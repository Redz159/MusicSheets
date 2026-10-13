import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:perfect_freehand/perfect_freehand.dart';

/// All annotation coordinates are normalised to the page: x/width, y/height in 0..1.
/// Stroke widths and font sizes are relative to the page width. This keeps them
/// independent of zoom, screen size and the resolution used when exporting.
sealed class AnnoItem {
  const AnnoItem(this.color);

  final int color;

  Map<String, dynamic> toJson();

  /// Whether a point (in page pixels) lies within [radius] of this item.
  bool hit(Offset p, Size page, double radius);

  static AnnoItem fromJson(Map<String, dynamic> j) => switch (j['t']) {
        'ink' => InkItem.fromJson(j),
        'text' => TextItem.fromJson(j),
        _ => ShapeItem.fromJson(j),
      };
}

class InkItem extends AnnoItem {
  const InkItem({required int color, required this.width, required this.points, this.highlighter = false})
      : super(color);

  final double width;
  final bool highlighter;

  /// Flat list x0, y0, pressure0, x1, y1, pressure1...
  final List<double> points;

  int get length => points.length ~/ 3;

  Offset pointAt(int i, Size page) => Offset(points[i * 3] * page.width, points[i * 3 + 1] * page.height);

  @override
  Map<String, dynamic> toJson() => {
        't': 'ink',
        'c': color,
        'w': width,
        if (highlighter) 'hl': true,
        'p': [for (final v in points) double.parse(v.toStringAsFixed(5))],
      };

  factory InkItem.fromJson(Map<String, dynamic> j) => InkItem(
        color: j['c'] as int,
        width: (j['w'] as num).toDouble(),
        highlighter: j['hl'] == true,
        points: [for (final v in j['p'] as List) (v as num).toDouble()],
      );

  StrokeOptions options(double pageWidth, {bool complete = true}) => highlighter
      ? StrokeOptions(
          size: width * pageWidth,
          thinning: 0,
          smoothing: 0.5,
          streamline: 0.5,
          simulatePressure: false,
          isComplete: complete,
        )
      : StrokeOptions(
          size: width * pageWidth,
          thinning: 0.45,
          smoothing: 0.55,
          streamline: 0.4,
          simulatePressure: !_hasRealPressure,
          isComplete: complete,
        );

  bool get _hasRealPressure {
    for (var i = 2; i < points.length; i += 3) {
      if (points[i] != 0.5) return true;
    }
    return false;
  }

  /// Outline polygon in page pixel coordinates.
  List<Offset> outline(Size page, {bool complete = true}) {
    final pts = <PointVector>[
      for (var i = 0; i < length; i++)
        PointVector(points[i * 3] * page.width, points[i * 3 + 1] * page.height, points[i * 3 + 2]),
    ];
    return getStroke(pts, options: options(page.width, complete: complete));
  }

  @override
  bool hit(Offset p, Size page, double radius) {
    final r = radius + width * page.width / 2;
    if (length == 1) return (pointAt(0, page) - p).distance <= r;
    for (var i = 0; i < length - 1; i++) {
      if (_segDist(p, pointAt(i, page), pointAt(i + 1, page)) <= r) return true;
    }
    return false;
  }
}

enum ShapeKind { line, rect, oval }

class ShapeItem extends AnnoItem {
  const ShapeItem({required int color, required this.kind, required this.width, required this.a, required this.b})
      : super(color);

  final ShapeKind kind;
  final double width;
  final Offset a;
  final Offset b;

  Offset _scale(Offset o, Size page) => Offset(o.dx * page.width, o.dy * page.height);

  Rect rect(Size page) => Rect.fromPoints(_scale(a, page), _scale(b, page));

  @override
  Map<String, dynamic> toJson() => {
        't': kind.name,
        'c': color,
        'w': width,
        'a': [a.dx, a.dy, b.dx, b.dy],
      };

  factory ShapeItem.fromJson(Map<String, dynamic> j) {
    final v = [for (final x in j['a'] as List) (x as num).toDouble()];
    return ShapeItem(
      color: j['c'] as int,
      kind: ShapeKind.values.byName(j['t'] as String),
      width: (j['w'] as num).toDouble(),
      a: Offset(v[0], v[1]),
      b: Offset(v[2], v[3]),
    );
  }

  @override
  bool hit(Offset p, Size page, double radius) {
    final r = radius + width * page.width / 2;
    final pa = _scale(a, page), pb = _scale(b, page);
    switch (kind) {
      case ShapeKind.line:
        return _segDist(p, pa, pb) <= r;
      case ShapeKind.rect:
        final rc = rect(page);
        final corners = [rc.topLeft, rc.topRight, rc.bottomRight, rc.bottomLeft];
        for (var i = 0; i < 4; i++) {
          if (_segDist(p, corners[i], corners[(i + 1) % 4]) <= r) return true;
        }
        return false;
      case ShapeKind.oval:
        final rc = rect(page);
        final rx = math.max(rc.width / 2, 1.0), ry = math.max(rc.height / 2, 1.0);
        final d = p - rc.center;
        final norm = math.sqrt(math.pow(d.dx / rx, 2) + math.pow(d.dy / ry, 2));
        return (norm - 1).abs() * math.min(rx, ry) <= r;
    }
  }
}

class TextItem extends AnnoItem {
  const TextItem({
    required int color,
    required this.text,
    required this.pos,
    required this.size,
    this.stamp = false,
  }) : super(color);

  final String text;

  /// Top-left corner, normalised.
  final Offset pos;

  /// Font size relative to page width.
  final double size;

  /// Stamps (dynamics, fingerings) are drawn bold italic serif.
  final bool stamp;

  TextItem copyWith({String? text, Offset? pos, double? size, int? color}) => TextItem(
        color: color ?? this.color,
        text: text ?? this.text,
        pos: pos ?? this.pos,
        size: size ?? this.size,
        stamp: stamp,
      );

  TextPainter layout(Size page) => TextPainter(
        text: TextSpan(text: text, style: textStyle(page)),
        textDirection: TextDirection.ltr,
      )..layout();

  TextStyle textStyle(Size page) => TextStyle(
        color: Color(color),
        fontSize: size * page.width,
        height: 1.15,
        fontFamily: stamp ? 'serif' : null,
        fontStyle: stamp ? FontStyle.italic : FontStyle.normal,
        fontWeight: stamp ? FontWeight.bold : FontWeight.w500,
      );

  Rect bounds(Size page) {
    final tp = layout(page);
    return Offset(pos.dx * page.width, pos.dy * page.height) & tp.size;
  }

  @override
  Map<String, dynamic> toJson() => {
        't': 'text',
        'c': color,
        'v': text,
        'x': pos.dx,
        'y': pos.dy,
        's': size,
        if (stamp) 'st': true,
      };

  factory TextItem.fromJson(Map<String, dynamic> j) => TextItem(
        color: j['c'] as int,
        text: j['v'] as String,
        pos: Offset((j['x'] as num).toDouble(), (j['y'] as num).toDouble()),
        size: (j['s'] as num).toDouble(),
        stamp: j['st'] == true,
      );

  @override
  bool hit(Offset p, Size page, double radius) => bounds(page).inflate(radius).contains(p);
}

double _segDist(Offset p, Offset a, Offset b) {
  final ab = b - a;
  final len2 = ab.dx * ab.dx + ab.dy * ab.dy;
  if (len2 == 0) return (p - a).distance;
  final t = (((p.dx - a.dx) * ab.dx + (p.dy - a.dy) * ab.dy) / len2).clamp(0.0, 1.0);
  return (p - (a + ab * t)).distance;
}

/// The annotations of one page.
class PageAnnotations {
  const PageAnnotations(this.items);

  static const empty = PageAnnotations([]);

  final List<AnnoItem> items;

  bool get isEmpty => items.isEmpty;

  String? encode() => items.isEmpty ? null : jsonEncode({'v': 1, 'items': [for (final i in items) i.toJson()]});

  static PageAnnotations decode(String? data) {
    if (data == null || data.isEmpty) return empty;
    final j = jsonDecode(data) as Map<String, dynamic>;
    return PageAnnotations([
      for (final i in j['items'] as List) AnnoItem.fromJson((i as Map).cast<String, dynamic>()),
    ]);
  }
}

/// Paints [items] onto a canvas whose size is the page size in pixels.
void paintAnnotations(Canvas canvas, Size page, List<AnnoItem> items) {
  for (final item in items) {
    paintItem(canvas, page, item);
  }
}

void paintItem(Canvas canvas, Size page, AnnoItem item, {bool complete = true}) {
  switch (item) {
    case InkItem():
      final outline = item.outline(page, complete: complete);
      if (outline.isEmpty) return;
      final path = Path()..addPolygon(outline, true);
      final paint = Paint()
        ..color = Color(item.color)
        ..isAntiAlias = true;
      if (item.highlighter) paint.blendMode = BlendMode.multiply;
      canvas.drawPath(path, paint);
    case ShapeItem():
      final paint = Paint()
        ..color = Color(item.color)
        ..style = PaintingStyle.stroke
        ..strokeWidth = item.width * page.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      final rect = item.rect(page);
      switch (item.kind) {
        case ShapeKind.line:
          canvas.drawLine(
              Offset(item.a.dx * page.width, item.a.dy * page.height),
              Offset(item.b.dx * page.width, item.b.dy * page.height),
              paint);
        case ShapeKind.rect:
          canvas.drawRect(rect, paint);
        case ShapeKind.oval:
          canvas.drawOval(rect, paint);
      }
    case TextItem():
      item.layout(page).paint(canvas, Offset(item.pos.dx * page.width, item.pos.dy * page.height));
  }
}
