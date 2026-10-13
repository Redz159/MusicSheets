import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import '../core/settings.dart';

/// Opens PDF documents on demand and keeps them open until [dispose].
class PdfDocCache {
  final _docs = <String, Future<PdfDocument>>{};

  Future<PdfDocument> open(String path) => _docs.putIfAbsent(path, () => PdfDocument.openFile(path));

  /// Synchronously returns an already-opened document, if any.
  PdfDocument? peek(String path) => _ready[path];
  final _ready = <String, PdfDocument>{};

  Future<PdfDocument> load(String path) async {
    final d = await open(path);
    _ready[path] = d;
    return d;
  }

  Future<void> dispose() async {
    final docs = _docs.values.toList();
    _docs.clear();
    _ready.clear();
    for (final f in docs) {
      try {
        (await f).dispose();
      } catch (_) {}
    }
  }
}

/// LRU cache of rendered page images shared by the whole app.
///
/// Widgets take a [ui.Image.clone] of the cached image and dispose their own
/// handle, so evicting from the cache never pulls an image out from under a widget.
class PageImageCache {
  PageImageCache._();
  static final instance = PageImageCache._();

  static const _maxBytes = 220 * 1024 * 1024;
  final _images = <String, ui.Image>{};
  final _pending = <String, Future<ui.Image?>>{};
  int _bytes = 0;

  static String key(String docKey, int page, int width) => '$docKey#$page@$width';

  ui.Image? peek(String key) {
    final img = _images.remove(key);
    if (img == null) return null;
    _images[key] = img; // mark as recently used
    return img.clone();
  }

  /// Returns a clone the caller must dispose.
  Future<ui.Image?> get(PdfDocument doc, String docKey, int page, int width) async {
    final k = key(docKey, page, width);
    final hit = peek(k);
    if (hit != null) return hit;
    final img = await _pending.putIfAbsent(k, () => _render(doc, page, width, k));
    return img?.clone();
  }

  Future<ui.Image?> _render(PdfDocument doc, int page, int width, String k) async {
    try {
      final p = doc.pages[page];
      final height = (width * p.height / p.width).round();
      final raw = await p.render(
        fullWidth: width.toDouble(),
        fullHeight: height.toDouble(),
        width: width,
        height: height,
        backgroundColor: 0xFFFFFFFF,
        annotationRenderingMode: PdfAnnotationRenderingMode.annotationAndForms,
      );
      if (raw == null) return null;
      final img = await raw.createImage();
      raw.dispose();
      _images[k] = img;
      _bytes += img.width * img.height * 4;
      while (_bytes > _maxBytes && _images.length > 1) {
        final oldest = _images.keys.first;
        final old = _images.remove(oldest)!;
        _bytes -= old.width * old.height * 4;
        old.dispose();
      }
      return img;
    } catch (e) {
      debugPrint('render failed: $e');
      return null;
    } finally {
      unawaited(Future.microtask(() => _pending.remove(k)));
    }
  }

  void evictDoc(String docKey) {
    final keys = _images.keys.where((k) => k.startsWith('$docKey#')).toList();
    for (final k in keys) {
      final img = _images.remove(k)!;
      _bytes -= img.width * img.height * 4;
      img.dispose();
    }
  }
}

/// Rounds a pixel width up to a bucket so small layout changes reuse the cached render.
int renderWidthFor(double logicalWidth, double dpr, {double quality = 1.5, double maxPx = 3200}) {
  final px = (logicalWidth * dpr * quality).clamp(64, maxPx).toDouble();
  return ((px / 128).ceil() * 128).toInt();
}

ColorFilter? tintFilter(PageTint tint) => switch (tint) {
      PageTint.none => null,
      PageTint.sepia => const ColorFilter.matrix([
          0.97, 0, 0, 0, 0, //
          0, 0.92, 0, 0, 0,
          0, 0, 0.80, 0, 0,
          0, 0, 0, 1, 0,
        ]),
      PageTint.night => const ColorFilter.matrix([
          -0.9, 0, 0, 0, 235, //
          0, -0.9, 0, 0, 235,
          0, 0, -0.9, 0, 235,
          0, 0, 0, 1, 0,
        ]),
    };

/// Shows one rendered PDF page filling its (already correctly proportioned) box.
class PdfPageImage extends StatefulWidget {
  const PdfPageImage({
    super.key,
    required this.doc,
    required this.docKey,
    required this.page,
    this.quality = 1.5,
    this.zoom = 1,
  });

  final PdfDocument doc;
  final String docKey;
  final int page;
  final double quality;

  /// Current zoom of the page, so it is rendered sharp enough when zoomed in.
  final double zoom;

  @override
  State<PdfPageImage> createState() => _PdfPageImageState();
}

class _PdfPageImageState extends State<PdfPageImage> {
  ui.Image? _image;
  int? _width;

  @override
  void dispose() {
    _image?.dispose();
    super.dispose();
  }

  void _request(int width) {
    if (_width == width) return;
    _width = width;
    final key = PageImageCache.key(widget.docKey, widget.page, width);
    final cached = PageImageCache.instance.peek(key);
    if (cached != null) {
      _image?.dispose();
      _image = cached;
      return;
    }
    PageImageCache.instance.get(widget.doc, widget.docKey, widget.page, width).then((img) {
      if (!mounted || _width != width || img == null) {
        img?.dispose();
        return;
      }
      setState(() {
        _image?.dispose();
        _image = img;
      });
    });
  }

  @override
  void didUpdateWidget(PdfPageImage old) {
    super.didUpdateWidget(old);
    if (old.docKey != widget.docKey || old.page != widget.page) {
      _width = null;
      _image?.dispose();
      _image = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      if (c.maxWidth.isFinite && c.maxWidth > 0) {
        final dpr = MediaQuery.devicePixelRatioOf(context);
        _request(widget.zoom > 1
            ? renderWidthFor(c.maxWidth * widget.zoom, dpr, quality: widget.quality, maxPx: 4096)
            : renderWidthFor(c.maxWidth, dpr, quality: widget.quality));
      }
      final img = _image;
      return ColoredBox(
        color: Colors.white,
        child: img == null
            ? const SizedBox.expand()
            : RawImage(image: img, fit: BoxFit.fill, filterQuality: FilterQuality.medium),
      );
    });
  }
}

/// Renders the first page of a PDF to a small PNG (cached on disk).
class ThumbnailService {
  ThumbnailService(this.thumbDir);

  final String thumbDir;
  final _inFlight = <String, Future<File?>>{};
  static Future<void> _queue = Future.value();

  Future<File?> thumbnail(String pdfPath, String hash, {int page = 0, int width = 320}) {
    final file = File('$thumbDir/${hash}_${page}_$width.png');
    if (file.existsSync()) return Future.value(file);
    return _inFlight.putIfAbsent(file.path, () {
      // Render one thumbnail at a time to keep scrolling smooth.
      final c = Completer<File?>();
      _queue = _queue.then((_) async {
        try {
          final doc = await PdfDocument.openFile(pdfPath);
          try {
            final p = doc.pages[page];
            final h = (width * p.height / p.width).round();
            final raw = await p.render(
                fullWidth: width.toDouble(),
                fullHeight: h.toDouble(),
                width: width,
                height: h,
                backgroundColor: 0xFFFFFFFF);
            if (raw == null) return c.complete(null);
            final img = await raw.createImage();
            raw.dispose();
            final png = await img.toByteData(format: ui.ImageByteFormat.png);
            img.dispose();
            await file.writeAsBytes(png!.buffer.asUint8List());
            c.complete(file);
          } finally {
            doc.dispose();
          }
        } catch (e) {
          c.complete(null);
        }
      });
      return c.future.whenComplete(() => _inFlight.remove(file.path));
    });
  }
}
