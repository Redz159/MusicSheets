import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'annotation_model.dart';
import 'annotation_store.dart';
import 'tool_state.dart';

/// Paints a page's annotations and, when [editable], turns pointer input into edits.
class AnnotationLayer extends StatefulWidget {
  const AnnotationLayer({
    super.key,
    required this.songId,
    required this.page,
    required this.store,
    required this.tools,
    required this.editable,
    this.pinching,
    this.stylusOnly = false,
    this.onFingerTap,
    this.onFingerSwipe,
  });

  final int songId;
  final int page;
  final AnnotationStore store;
  final ToolState tools;
  final bool editable;
  final bool stylusOnly;

  /// True while two fingers zoom/pan the page; finger input is not drawn then.
  final ValueListenable<bool>? pinching;

  /// In stylus-only mode, finger taps (global position) and horizontal swipes (+1 next, -1 previous).
  final ValueChanged<Offset>? onFingerTap;
  final ValueChanged<int>? onFingerSwipe;

  @override
  State<AnnotationLayer> createState() => _AnnotationLayerState();
}

class _AnnotationLayerState extends State<AnnotationLayer> {
  final _draft = ValueNotifier<AnnoItem?>(null);
  Size _size = Size.zero;

  int? _pointer;
  bool _pointerIsTouch = false;
  AnnoTool? _gestureTool;
  List<double>? _points;
  Offset? _shapeStart;
  PageAnnotations? _before;
  int? _dragIndex;
  Offset? _dragOrigin;
  Offset? _downLocal;
  bool _moved = false;

  int? _fingerPointer;
  Offset? _fingerStart;

  PageAnnotations get _current => widget.store.get(widget.songId, widget.page);

  Offset _norm(Offset local) => Offset(local.dx / _size.width, local.dy / _size.height);

  static double _pressure(PointerEvent e) {
    if (e.kind != PointerDeviceKind.stylus && e.kind != PointerDeviceKind.invertedStylus) return 0.5;
    final range = e.pressureMax - e.pressureMin;
    if (range <= 0) return 0.5;
    return ((e.pressure - e.pressureMin) / range).clamp(0.05, 1.0);
  }

  bool get _isPinching => widget.pinching?.value ?? false;

  @override
  void initState() {
    super.initState();
    widget.pinching?.addListener(_onPinch);
  }

  @override
  void didUpdateWidget(AnnotationLayer old) {
    super.didUpdateWidget(old);
    if (old.pinching != widget.pinching) {
      old.pinching?.removeListener(_onPinch);
      widget.pinching?.addListener(_onPinch);
    }
  }

  @override
  void dispose() {
    widget.pinching?.removeListener(_onPinch);
    _draft.dispose();
    super.dispose();
  }

  /// A second finger turned the gesture into zoom/pan: drop what that finger started.
  void _onPinch() {
    if (!_isPinching) return;
    _fingerPointer = null;
    if (_pointer == null || !_pointerIsTouch) return;
    if (_before != null && !identical(_before!.items, _current.items)) {
      widget.store.preview(widget.songId, widget.page, _before!);
    }
    _reset();
  }

  void _onDown(PointerDownEvent e) {
    final isStylus = e.kind == PointerDeviceKind.stylus || e.kind == PointerDeviceKind.invertedStylus;
    if (!isStylus && _isPinching) return;
    if (widget.stylusOnly && !isStylus) {
      _fingerPointer ??= e.pointer;
      _fingerStart = e.localPosition;
      return;
    }
    if (_pointer != null) return; // ignore extra fingers while drawing
    _pointer = e.pointer;
    _pointerIsTouch = !isStylus;
    _moved = false;
    _downLocal = e.localPosition;
    final tool = e.kind == PointerDeviceKind.invertedStylus ? AnnoTool.eraser : widget.tools.tool;
    _gestureTool = tool;
    final n = _norm(e.localPosition);
    switch (tool) {
      case AnnoTool.pen || AnnoTool.highlighter:
        _points = [n.dx, n.dy, _pressure(e)];
        _draft.value = _ink();
      case AnnoTool.line || AnnoTool.rect || AnnoTool.oval:
        _shapeStart = n;
      case AnnoTool.eraser:
        _before = _current;
        _eraseAt(e.localPosition);
      case AnnoTool.text:
        _before = _current;
        final items = _current.items;
        for (var i = items.length - 1; i >= 0; i--) {
          final it = items[i];
          if (it is TextItem && it.hit(e.localPosition, _size, 8)) {
            _dragIndex = i;
            _dragOrigin = it.pos;
            break;
          }
        }
      case AnnoTool.stamp:
        break;
    }
  }

  InkItem _ink() => InkItem(
        color: widget.tools.color,
        width: widget.tools.strokeWidth,
        highlighter: _gestureTool == AnnoTool.highlighter,
        points: _points!,
      );

  ShapeItem _shape(Offset end) => ShapeItem(
        color: widget.tools.penColor,
        kind: switch (_gestureTool) {
          AnnoTool.rect => ShapeKind.rect,
          AnnoTool.oval => ShapeKind.oval,
          _ => ShapeKind.line,
        },
        width: widget.tools.strokeWidth,
        a: _shapeStart!,
        b: end,
      );

  void _onMove(PointerMoveEvent e) {
    if (e.pointer != _pointer) return;
    if (_downLocal != null && (e.localPosition - _downLocal!).distance > 4) _moved = true;
    final n = _norm(e.localPosition);
    switch (_gestureTool) {
      case AnnoTool.pen || AnnoTool.highlighter:
        final pts = _points!;
        final lx = pts[pts.length - 3] * _size.width, ly = pts[pts.length - 2] * _size.height;
        if ((Offset(lx, ly) - e.localPosition).distance < 0.8) return;
        pts.addAll([n.dx, n.dy, _pressure(e)]);
        _draft.value = _ink();
      case AnnoTool.line || AnnoTool.rect || AnnoTool.oval:
        _draft.value = _shape(n);
      case AnnoTool.eraser:
        _eraseAt(e.localPosition);
      case AnnoTool.text:
        if (_dragIndex != null && _moved) {
          final delta = _norm(e.localPosition) - _norm(_downLocal!);
          final items = [..._current.items];
          items[_dragIndex!] = (items[_dragIndex!] as TextItem).copyWith(pos: _dragOrigin! + delta);
          widget.store.preview(widget.songId, widget.page, PageAnnotations(items));
        }
      default:
        break;
    }
  }

  void _eraseAt(Offset local) {
    final radius = 10.0;
    final items = _current.items;
    final kept = [for (final it in items) if (!it.hit(local, _size, radius)) it];
    if (kept.length != items.length) widget.store.preview(widget.songId, widget.page, PageAnnotations(kept));
  }

  Future<void> _onUp(PointerEvent e) async {
    if (e.pointer == _fingerPointer) {
      final start = _fingerStart!;
      _fingerPointer = null;
      final d = e.localPosition - start;
      if (d.dx.abs() > 60 && d.dx.abs() > d.dy.abs() * 1.5) {
        widget.onFingerSwipe?.call(d.dx < 0 ? 1 : -1);
      } else if (d.distance < 12) {
        widget.onFingerTap?.call(e.position);
      }
      return;
    }
    if (e.pointer != _pointer) return;
    final tool = _gestureTool;
    final local = e.localPosition;
    final store = widget.store;
    final sid = widget.songId, page = widget.page;
    switch (tool) {
      case AnnoTool.pen || AnnoTool.highlighter:
        if (_points != null && _points!.isNotEmpty) store.add(sid, page, _ink());
      case AnnoTool.line || AnnoTool.rect || AnnoTool.oval:
        final end = _norm(local);
        if ((local - _downLocal!).distance > 6) store.add(sid, page, _shape(end));
      case AnnoTool.eraser:
        if (_before != null && !identical(_before!.items, _current.items)) {
          store.commit(sid, page, _current, before: _before);
        }
      case AnnoTool.text:
        if (_dragIndex != null && _moved) {
          store.commit(sid, page, _current, before: _before);
        } else if (_dragIndex != null) {
          await _editText(_dragIndex!);
        } else if (!_moved) {
          await _newText(_norm(local));
        }
      case AnnoTool.stamp:
        if (!_moved) {
          final item = TextItem(
              color: widget.tools.penColor, text: widget.tools.stamp, pos: Offset.zero, size: widget.tools.textSize, stamp: true);
          final tp = item.layout(_size);
          final pos = _norm(local - Offset(tp.width / 2, tp.height / 2));
          store.add(sid, page, item.copyWith(pos: pos));
        }
      default:
        break;
    }
    _reset();
  }

  void _onCancel(PointerCancelEvent e) {
    if (e.pointer == _fingerPointer) _fingerPointer = null;
    if (e.pointer != _pointer) return;
    if (_before != null && !identical(_before!.items, _current.items)) {
      widget.store.commit(widget.songId, widget.page, _current, before: _before);
    }
    _reset();
  }

  void _reset() {
    _pointer = null;
    _gestureTool = null;
    _points = null;
    _shapeStart = null;
    _before = null;
    _dragIndex = null;
    _dragOrigin = null;
    _downLocal = null;
    _draft.value = null;
  }

  Future<void> _newText(Offset pos) async {
    final sid = widget.songId, page = widget.page;
    final text = await _textDialog(context, initial: '');
    if (text == null || text.$1.isEmpty) return;
    widget.store.add(sid, page, TextItem(color: widget.tools.penColor, text: text.$1, pos: pos, size: widget.tools.textSize));
  }

  Future<void> _editText(int index) async {
    final sid = widget.songId, page = widget.page;
    final item = _current.items[index] as TextItem;
    final result = await _textDialog(context, initial: item.text, editing: true);
    if (result == null) return;
    final items = [...widget.store.get(sid, page).items];
    final at = items.indexOf(item);
    if (at < 0) return;
    if (result.$2 || result.$1.isEmpty) {
      items.removeAt(at);
    } else {
      items[at] = item.copyWith(text: result.$1);
    }
    widget.store.commit(sid, page, PageAnnotations(items));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      _size = c.biggest;
      final painted = ListenableBuilder(
        listenable: widget.store,
        builder: (context, _) => RepaintBoundary(
          child: CustomPaint(size: _size, painter: _ItemsPainter(_current.items)),
        ),
      );
      final draft = IgnorePointer(
        child: CustomPaint(size: _size, painter: _DraftPainter(_draft)),
      );
      if (!widget.editable) return Stack(children: [painted]);
      return Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _onDown,
        onPointerMove: _onMove,
        onPointerUp: _onUp,
        onPointerCancel: _onCancel,
        child: Stack(children: [painted, draft]),
      );
    });
  }
}

class _ItemsPainter extends CustomPainter {
  _ItemsPainter(this.items);
  final List<AnnoItem> items;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
    paintAnnotations(canvas, size, items);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ItemsPainter old) => !identical(old.items, items);
}

class _DraftPainter extends CustomPainter {
  _DraftPainter(this.draft) : super(repaint: draft);
  final ValueNotifier<AnnoItem?> draft;

  @override
  void paint(Canvas canvas, Size size) {
    final d = draft.value;
    if (d != null) paintItem(canvas, size, d, complete: false);
  }

  @override
  bool shouldRepaint(_DraftPainter old) => old.draft != draft;
}

/// Returns (text, delete?) or null when cancelled.
Future<(String, bool)?> _textDialog(BuildContext context, {required String initial, bool editing = false}) {
  final controller = TextEditingController(text: initial);
  return showDialog<(String, bool)>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(editing ? 'Edit text' : 'Add text'),
      content: TextField(
        controller: controller,
        autofocus: true,
        minLines: 1,
        maxLines: 4,
        decoration: const InputDecoration(hintText: 'Text'),
      ),
      actions: [
        if (editing)
          TextButton(
            onPressed: () => Navigator.pop(context, ('', true)),
            child: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, (controller.text.trim(), false)), child: const Text('Done')),
      ],
    ),
  );
}
