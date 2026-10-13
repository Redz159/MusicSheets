import 'package:flutter/material.dart';

enum AnnoTool {
  pen(Icons.edit, 'Pen'),
  highlighter(Icons.border_color, 'Highlighter'),
  line(Icons.horizontal_rule, 'Line'),
  rect(Icons.crop_square, 'Rectangle'),
  oval(Icons.circle_outlined, 'Circle'),
  text(Icons.title, 'Text'),
  stamp(Icons.music_note, 'Symbols'),
  eraser(Icons.cleaning_services_outlined, 'Eraser');

  const AnnoTool(this.icon, this.label);
  final IconData icon;
  final String label;

  bool get isShape => this == line || this == rect || this == oval;
}

const penColors = [0xFF111111, 0xFFD32F2F, 0xFF1565C0, 0xFF2E7D32, 0xFFEF6C00, 0xFF7B1FA2];
const highlightColors = [0x66FFEB3B, 0x6676FF03, 0x66FF4081, 0x6640C4FF, 0x66FFAB40];

/// Relative to page width.
const penWidths = [0.0022, 0.0038, 0.0065];
const highlightWidths = [0.012, 0.02, 0.032];
const textSizes = [0.022, 0.03, 0.042];

const stamps = ['pp', 'p', 'mp', 'mf', 'f', 'ff', 'sfz', 'cresc.', 'dim.', 'rit.', 'a tempo', '1', '2', '3', '4', '5', 'V', '>'];

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
