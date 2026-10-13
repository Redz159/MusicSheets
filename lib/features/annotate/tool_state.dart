import 'package:flutter/material.dart';

enum AnnoTool {
  pen(Icons.edit, 'Pen'),
  highlighter(Icons.border_color, 'Highlighter'),
  eraser(null, 'Eraser'),
  line(Icons.horizontal_rule, 'Line'),
  rect(Icons.crop_square, 'Rectangle'),
  oval(Icons.circle_outlined, 'Circle'),
  text(Icons.title, 'Text'),
  stamp(Icons.music_note, 'Symbols');

  const AnnoTool(this.icon, this.label);

  /// Null for the eraser: Material Icons has no eraser glyph, so [EraserIcon] draws one.
  final IconData? icon;
  final String label;

  Widget buildIcon(Color color, {double size = 24}) {
    final i = icon;
    return i == null ? EraserIcon(color: color, size: size) : Icon(i, color: color, size: size);
  }

  bool get isShape => this == line || this == rect || this == oval;
}

/// The classic eraser glyph: a tilted block with a filled tip, resting on a line.
class EraserIcon extends StatelessWidget {
  const EraserIcon({super.key, required this.color, this.size = 24});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(size: Size.square(size), painter: _EraserPainter(color));
}

class _EraserPainter extends CustomPainter {
  _EraserPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.9
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..color = color;

    canvas.save();
    canvas.translate(12.5, 10.5);
    canvas.rotate(-0.785398); // -45°: tip points to the bottom left
    final body = RRect.fromRectAndRadius(const Rect.fromLTWH(-9, -4.5, 18, 9), const Radius.circular(2));
    canvas.save();
    canvas.clipRect(const Rect.fromLTWH(-10, -6, 7.5, 12));
    canvas.drawRRect(body, fill);
    canvas.restore();
    canvas.drawRRect(body, stroke);
    canvas.restore();

    canvas.drawLine(const Offset(9.5, 21), const Offset(21, 21), stroke);
  }

  @override
  bool shouldRepaint(_EraserPainter old) => old.color != color;
}

const penColors = [0xFF111111, 0xFFD32F2F, 0xFF1565C0, 0xFF2E7D32, 0xFFEF6C00, 0xFF7B1FA2];
const highlightColors = [0x66FFEB3B, 0x6676FF03, 0x66FF4081, 0x6640C4FF, 0x66FFAB40];

/// Relative to page width.
const penWidths = [0.0022, 0.0038, 0.0065];
const highlightWidths = [0.012, 0.02, 0.032];
const textSizes = [0.022, 0.03, 0.042];

const stamps = [
  'pp',
  'p',
  'mp',
  'mf',
  'f',
  'ff',
  'sfz',
  'cresc.',
  'dim.',
  'rit.',
  'a tempo',
  '1',
  '2',
  '3',
  '4',
  '5',
  'V',
  '>',
];

class ToolState extends ChangeNotifier {
  AnnoTool _tool = AnnoTool.pen;
  int _penColor = penColors.first;
  int _highlightColor = highlightColors.first;
  int _penWidth = 1;
  int _highlightWidth = 1;
  int _textSize = 1;
  String _stamp = 'mf';

  AnnoTool get tool => _tool;
  set tool(AnnoTool t) => _set(() => _tool = t);

  bool get usesHighlightPalette => _tool == AnnoTool.highlighter;

  int get color => usesHighlightPalette ? _highlightColor : _penColor;
  set color(int c) => _set(() => usesHighlightPalette ? _highlightColor = c : _penColor = c);

  /// Width index 0..2 of the current tool.
  int get widthIndex => switch (_tool) {
    AnnoTool.highlighter => _highlightWidth,
    AnnoTool.text || AnnoTool.stamp => _textSize,
    _ => _penWidth,
  };
  set widthIndex(int i) => _set(() {
    switch (_tool) {
      case AnnoTool.highlighter:
        _highlightWidth = i;
      case AnnoTool.text || AnnoTool.stamp:
        _textSize = i;
      default:
        _penWidth = i;
    }
  });

  double get strokeWidth => usesHighlightPalette ? highlightWidths[_highlightWidth] : penWidths[_penWidth];
  double get textSize => textSizes[_textSize];
  int get penColor => _penColor;

  String get stamp => _stamp;
  set stamp(String s) => _set(() {
    _stamp = s;
    _tool = AnnoTool.stamp;
  });

  void _set(VoidCallback f) {
    f();
    notifyListeners();
  }
}
