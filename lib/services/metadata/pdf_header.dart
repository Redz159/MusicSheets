import 'dart:io';
import 'dart:isolate';

import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;

import 'query_builder.dart';

/// One line of text on page 1 with its box, in PDF points measured from the top left.
class HeaderLine {
  const HeaderLine(this.text, this.left, this.top, this.width, this.height);
  final String text;
  final double left;
  final double top;
  final double width;
  final double height;

  double get centerX => left + width / 2;
}

/// What the top of a sheet says: the title, and the artist or composer if one is printed.
class PdfHeader {
  const PdfHeader({required this.title, this.artist});
  final String title;
  final String? artist;

  @override
  String toString() => artist == null ? title : '$title ($artist)';
}

final _letters = RegExp(r'\p{L}', unicode: true);
final _creditPrefix = RegExp(
  r'^(music|words|lyrics|composed|written|text|musik|komponist|von|by)\b[\s:]*(by\s+)?',
  caseSensitive: false,
);
final _arranger = RegExp(r'^(arr(\.|anged)?|transcri|bearb|satz|tab(s|ulatur)?\b)', caseSensitive: false);

/// Finds title and artist among the lines at the top of a sheet. Engraved sheets (MuseScore,
/// Sibelius, Guitar Pro exports) put a large centered title first, then smaller right-aligned
/// composer/artist lines, and a small left-aligned part name such as "Gitarre".
PdfHeader? parseHeader(List<HeaderLine> lines, {required double pageWidth, required double pageHeight}) {
  final header = <HeaderLine>[];
  for (final l in lines) {
    final text = l.text.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (l.top > pageHeight * 0.2 || text.length > 80) continue;
    if (_letters.allMatches(text).length < 2) continue;
    header.add(HeaderLine(text, l.left, l.top, l.width, l.height));
  }
  if (header.isEmpty) return null;

  // The title is the tallest line; ties go to the topmost.
  final byProminence = [...header]..sort((a, b) {
      final h = b.height.round().compareTo(a.height.round());
      return h != 0 ? h : a.top.compareTo(b.top);
    });
  final title = byProminence.first;
  final cleanedTitle = cleanTitle(title.text);
  if (cleanedTitle.isEmpty) return null;

  // Artist: another line below the title that is not pushed into the left margin.
  final below = [for (final l in header) if (!identical(l, title) && l.top >= title.top - 4 && l.centerX >= pageWidth * 0.4) l]
    ..sort((a, b) => a.top.compareTo(b.top));
  String? artist;
  for (final l in below) {
    if (_arranger.hasMatch(l.text)) continue;
    final name = l.text.replaceFirst(_creditPrefix, '').trim();
    if (_letters.allMatches(name).length >= 2) {
      artist = name;
      break;
    }
  }
  return PdfHeader(title: cleanedTitle, artist: artist);
}

const _maxPdfBytes = 40 * 1024 * 1024;

/// Reads title and artist from page 1. Null for scans without a text layer and for unreadable files.
Future<PdfHeader?> readPdfHeader(String pdfPath) async {
  try {
    final file = File(pdfPath);
    if (!file.existsSync() || file.lengthSync() > _maxPdfBytes) return null;
    // Parsing runs off the UI isolate. Only plain numbers and strings cross back.
    final raw = await Isolate.run(() => _extractLines(pdfPath));
    if (raw == null) return null;
    return parseHeader(
      [for (final r in raw.lines) HeaderLine(r.$1, r.$2, r.$3, r.$4, r.$5)],
      pageWidth: raw.width,
      pageHeight: raw.height,
    );
  } catch (_) {
    return null;
  }
}

({List<(String, double, double, double, double)> lines, double width, double height})? _extractLines(String path) {
  final doc = sf.PdfDocument(inputBytes: File(path).readAsBytesSync());
  try {
    if (doc.pages.count == 0) return null;
    final size = doc.pages[0].size;
    final lines = sf.PdfTextExtractor(doc).extractTextLines(startPageIndex: 0, endPageIndex: 0);
    return (
      lines: [for (final l in lines) (l.text, l.bounds.left, l.bounds.top, l.bounds.width, l.bounds.height)],
      width: size.width,
      height: size.height,
    );
  } finally {
    doc.dispose();
  }
}
