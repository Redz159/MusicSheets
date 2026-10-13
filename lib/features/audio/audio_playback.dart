import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../data/db.dart';
import '../../data/providers.dart';
import '../../services/import_service.dart';

extension AudioClipArea on AudioClip {
  /// Null for a whole-song clip.
  ({int page, double left, double top, double right, double bottom})? get area {
    final pg = page, l = left, t = top, r = right, b = bottom;
    if (pg == null || l == null || t == null || r == null || b == null) return null;
    return (page: pg, left: l, top: t, right: r, bottom: b);
  }
}

/// Copies a picked audio file into the library and attaches it to [songId] as a whole-song clip.
Future<AudioClip?> pickAndAddAudio(AppDatabase db, AppPaths paths, int songId) async {
  final files = await FilePicker.pickFiles(type: FileType.audio);
  if (files.isEmpty) return null;
  final f = files.first;
  final ext = p.extension(f.name).toLowerCase();
  final fileName = '${const Uuid().v4()}${ext.isEmpty ? '.m4a' : ext}';
  final target = File(paths.pdf(fileName));
  final src = f.path;
  if (src != null && File(src).existsSync()) {
    await File(src).copy(target.path);
  } else {
    await target.writeAsBytes(await f.readAsBytes(), flush: true);
  }
  final id = await db.insertAudioClip(
    AudioClipsCompanion.insert(
      songId: songId,
      title: ImportService.titleFromFileName(f.name),
      fileName: fileName,
      createdAt: DateTime.now(),
    ),
  );
  return (await db.audioClipsForSongs([songId])).firstWhere((c) => c.id == id);
}

Future<void> deleteAudioClip(AppDatabase db, AppPaths paths, AudioClip clip) async {
  await db.deleteAudioClip(clip.id);
  final f = File(paths.pdf(clip.fileName));
  if (f.existsSync()) await f.delete();
}

Future<void> setClipArea(AppDatabase db, AudioClip clip, int? page, {double? l, double? t, double? r, double? b}) =>
    db.updateAudioClip(
      clip.id,
      AudioClipsCompanion(page: Value(page), left: Value(l), top: Value(t), right: Value(r), bottom: Value(b)),
    );

/// Plays one clip at a time, with speed and loop for practising.
class AudioPlayback extends ChangeNotifier {
  AudioPlayback() {
    _sub = _player.playerStateStream.listen((s) {
      if (s.processingState == ProcessingState.completed && !_loop) {
        // Back to the start, ready to play again; the clip stays selected.
        _player.pause();
        _player.seek(Duration.zero);
      }
      notifyListeners();
    });
  }

  final _player = AudioPlayer();
  late final StreamSubscription<PlayerState> _sub;

  AudioClip? _clip;

  /// The loaded clip (playing or paused); its area is marked on the sheet.
  AudioClip? get clip => _clip;
  bool get playing => _player.playing && _player.processingState != ProcessingState.completed;

  Stream<Duration> get positionStream => _player.positionStream;
  Duration get position => _player.position;
  Duration? get duration => _player.duration;

  double _speed = 1;
  double get speed => _speed;
  bool _loop = false;
  bool get loop => _loop;

  /// Plays [clip], or toggles pause if it is already loaded.
  Future<void> play(AudioClip clip, String path) async {
    if (_clip?.id == clip.id) {
      toggle();
      return;
    }
    _clip = clip;
    notifyListeners();
    try {
      await _player.setFilePath(path);
      unawaited(_player.play());
    } catch (e) {
      _clip = null;
      notifyListeners();
      rethrow;
    }
  }

  void toggle() => playing ? _player.pause() : _player.play();

  Future<void> stop() async {
    await _player.stop();
    _clip = null;
    notifyListeners();
  }

  void seek(Duration to) => _player.seek(to);

  void skip(Duration by) {
    final d = duration ?? Duration.zero;
    var to = position + by;
    if (to < Duration.zero) to = Duration.zero;
    if (to > d) to = d;
    _player.seek(to);
  }

  void setSpeed(double s) {
    _speed = s;
    _player.setSpeed(s);
    notifyListeners();
  }

  void setLoop(bool on) {
    _loop = on;
    _player.setLoopMode(on ? LoopMode.one : LoopMode.off);
    notifyListeners();
  }

  /// Keeps the loaded clip in sync with database edits (rename, new area, delete).
  void refresh(List<AudioClip> clips) {
    final c = _clip;
    if (c == null) return;
    final now = clips.where((x) => x.id == c.id).firstOrNull;
    if (now == null) {
      stop();
    } else if (now != c) {
      _clip = now;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sub.cancel();
    _player.dispose();
    super.dispose();
  }
}
