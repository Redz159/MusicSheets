import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/db.dart';
import 'annotation_model.dart';

typedef PageKey = (int songId, int page);

class _Change {
  _Change(this.key, this.before, this.after);
  final PageKey key;
  final PageAnnotations before;
  final PageAnnotations after;
}

/// Holds the annotations of the songs open in the viewer, with undo/redo and
/// debounced saving to the database.
class AnnotationStore extends ChangeNotifier {
  AnnotationStore(this.db);

  final AppDatabase db;
  final _pages = <PageKey, PageAnnotations>{};
  final _dirty = <PageKey>{};
  final _undo = <_Change>[];
  final _redo = <_Change>[];
  Timer? _saveTimer;

  Future<void> load(Iterable<int> songIds) async {
    for (final id in songIds.toSet()) {
      final rows = await db.annotationsForSong(id);
      rows.forEach((page, data) {
        try {
          _pages[(id, page)] = PageAnnotations.decode(data);
        } catch (e) {
          debugPrint('Could not read annotations of song $id page $page: $e');
        }
      });
    }
    notifyListeners();
  }

  PageAnnotations get(int songId, int page) => _pages[(songId, page)] ?? PageAnnotations.empty;

  bool get canUndo => _undo.isNotEmpty;
  bool get canRedo => _redo.isNotEmpty;

  /// Replaces a page's annotations as one undoable step.
  void commit(int songId, int page, PageAnnotations after, {PageAnnotations? before}) {
    final key = (songId, page);
    final prev = before ?? get(songId, page);
    _undo.add(_Change(key, prev, after));
    if (_undo.length > 200) _undo.removeAt(0);
    _redo.clear();
    _put(key, after);
  }

  /// Updates without recording undo (used while a gesture is still in progress).
  void preview(int songId, int page, PageAnnotations value) {
    _pages[(songId, page)] = value;
    notifyListeners();
  }

  void add(int songId, int page, AnnoItem item) =>
      commit(songId, page, PageAnnotations([...get(songId, page).items, item]));

  void clearPage(int songId, int page) {
    if (get(songId, page).isEmpty) return;
    commit(songId, page, PageAnnotations.empty);
  }

  PageKey? undo() {
    if (_undo.isEmpty) return null;
    final c = _undo.removeLast();
    _redo.add(c);
    _put(c.key, c.before);
    return c.key;
  }

  PageKey? redo() {
    if (_redo.isEmpty) return null;
    final c = _redo.removeLast();
    _undo.add(c);
    _put(c.key, c.after);
    return c.key;
  }

  void _put(PageKey key, PageAnnotations value) {
    _pages[key] = value;
    _dirty.add(key);
    notifyListeners();
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 600), flush);
  }

  Future<void> flush() async {
    _saveTimer?.cancel();
    final keys = _dirty.toList();
    _dirty.clear();
    for (final k in keys) {
      await db.saveAnnotation(k.$1, k.$2, get(k.$1, k.$2).encode());
    }
  }

  @override
  void dispose() {
    flush();
    super.dispose();
  }
}
