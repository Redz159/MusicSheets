import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart' as rx;
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;

import '../data/db.dart';
import '../data/providers.dart';
import '../features/annotate/annotation_model.dart';

class ExportService {
  ExportService(this.db, this.paths);

  final AppDatabase db;
  final AppPaths paths;

  /// Builds one PDF from [songs] (merged in order) and optionally burns in the annotations.
  Future<File> buildPdf(List<Song> songs, {required bool withAnnotations, required String name}) async {
    Uint8List bytes;
    if (songs.length == 1) {
      bytes = await File(paths.pdf(songs.first.fileName)).readAsBytes();
    } else {
      bytes = await _merge(songs);
    }

    if (withAnnotations) {
      final pages = <int, PageAnnotations>{};
      var offset = 0;
      for (final s in songs) {
        final anns = await db.annotationsForSong(s.id);
        anns.forEach((page, data) => pages[offset + page] = PageAnnotations.decode(data));
        offset += s.pageCount;
      }
      if (pages.isNotEmpty) bytes = await burnIn(bytes, pages);
    }

    final dir = await getTemporaryDirectory();
    final out = File(p.join(dir.path, 'export', '${safeFileName(name)}.pdf'));
    await out.parent.create(recursive: true);
    await out.writeAsBytes(bytes, flush: true);
    return out;
  }

  Future<Uint8List> _merge(List<Song> songs) async {
    final docs = <rx.PdfDocument>[];
    try {
      for (final s in songs) {
        docs.add(await rx.PdfDocument.openFile(paths.pdf(s.fileName)));
      }
      final merged = await rx.PdfDocument.createNew(sourceName: 'setlist');
      try {
        merged.pages = [for (final d in docs) ...d.pages];
        return await merged.encodePdf();
      } finally {
        merged.dispose();
      }
    } finally {
      for (final d in docs) {
        d.dispose();
      }
    }
  }

  Future<void> share(File file, {Rect? origin}) async {
    await SharePlus.instance.share(ShareParams(
      files: [XFile(file.path, mimeType: 'application/pdf')],
      sharePositionOrigin: origin,
    ));
  }
}

String safeFileName(String s) {
  final cleaned = s.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_').trim();
  return cleaned.isEmpty ? 'export' : cleaned;
}

/// Draws annotations as vector graphics onto the given PDF pages (page index -> annotations).
Future<Uint8List> burnIn(Uint8List pdfBytes, Map<int, PageAnnotations> pages) async {
  final doc = sf.PdfDocument(inputBytes: pdfBytes);
  try {
    pages.forEach((index, anns) {
      if (index >= doc.pages.count || anns.isEmpty) return;
      final page = doc.pages[index];
      _drawPage(page, anns.items);
    });
    return Uint8List.fromList(await doc.save());
  } finally {
    doc.dispose();
  }
}

void _drawPage(sf.PdfPage page, List<AnnoItem> items) {
  final g = page.graphics;
  final w = page.size.width, h = page.size.height;
  final rotation = page.rotation;
  final swap = rotation == sf.PdfPageRotateAngle.rotateAngle90 || rotation == sf.PdfPageRotateAngle.rotateAngle270;
  // The size as displayed (annotations were made on the rotated page).
  final display = swap ? Size(h, w) : Size(w, h);

  // Maps a point on the displayed page to the unrotated page space.
  Offset map(Offset d) => switch (rotation) {
        sf.PdfPageRotateAngle.rotateAngle90 => Offset(d.dy, h - d.dx),
        sf.PdfPageRotateAngle.rotateAngle180 => Offset(w - d.dx, h - d.dy),
        sf.PdfPageRotateAngle.rotateAngle270 => Offset(w - d.dy, d.dx),
        _ => d,
      };
  final textAngle = switch (rotation) {
    sf.PdfPageRotateAngle.rotateAngle90 => -90.0,
    sf.PdfPageRotateAngle.rotateAngle180 => 180.0,
    sf.PdfPageRotateAngle.rotateAngle270 => 90.0,
    _ => 0.0,
  };

  for (final item in items) {
    final c = Color(item.color);
    final color = sf.PdfColor((c.r * 255).round(), (c.g * 255).round(), (c.b * 255).round());
    final state = g.save();
    final alpha = c.a;
    final highlighter = item is InkItem && item.highlighter;
    if (alpha < 0.999 || highlighter) {
      g.setTransparency(alpha, mode: highlighter ? sf.PdfBlendMode.multiply : sf.PdfBlendMode.normal);
    }
    switch (item) {
      case InkItem():
        final outline = item.outline(display);
        if (outline.length > 2) {
          g.drawPolygon([for (final o in outline) map(o)], brush: sf.PdfSolidBrush(color));
        }
      case ShapeItem():
        final pen = sf.PdfPen(color, width: item.width * display.width)
          ..lineCap = sf.PdfLineCap.round
          ..lineJoin = sf.PdfLineJoin.round;
        final a = map(Offset(item.a.dx * display.width, item.a.dy * display.height));
        final b = map(Offset(item.b.dx * display.width, item.b.dy * display.height));
        switch (item.kind) {
          case ShapeKind.line:
            g.drawLine(pen, a, b);
          case ShapeKind.rect:
            g.drawRectangle(pen: pen, bounds: Rect.fromPoints(a, b));
          case ShapeKind.oval:
            g.drawEllipse(Rect.fromPoints(a, b), pen: pen);
        }
      case TextItem():
        final size = item.size * display.width;
        final font = item.stamp
            ? sf.PdfStandardFont(sf.PdfFontFamily.timesRoman, size,
                multiStyle: [sf.PdfFontStyle.bold, sf.PdfFontStyle.italic])
            : sf.PdfStandardFont(sf.PdfFontFamily.helvetica, size);
        final origin = map(Offset(item.pos.dx * display.width, item.pos.dy * display.height));
        g.translateTransform(origin.dx, origin.dy);
        if (textAngle != 0) g.rotateTransform(textAngle);
        final lines = item.text.split('\n');
        for (var i = 0; i < lines.length; i++) {
          g.drawString(lines[i], font,
              brush: sf.PdfSolidBrush(color), bounds: Rect.fromLTWH(0, i * size * 1.15, 0, 0));
        }
    }
    g.restore(state);
  }
}
