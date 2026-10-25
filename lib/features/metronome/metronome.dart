import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:shared_preferences/shared_preferences.dart';

const minBpm = 20;
const maxBpm = 300;
const maxBeats = 12;

enum Subdivision {
  none(1, '1/4'),
  eighths(2, '1/8'),
  triplets(3, 'Triplet'),
  sixteenths(4, '1/16');

  const Subdivision(this.clicks, this.label);
  final int clicks;
  final String label;
}

enum BeatAccent {
  accent,
  normal,
  mute;

  BeatAccent get next =>
      BeatAccent.values[(index + 1) % BeatAccent.values.length];
}

enum ClickSound {
  click('Click'),
  wood('Wood'),
  beep('Beep');

  const ClickSound(this.label);
  final String label;
}

String tempoMarking(int bpm) => switch (bpm) {
  < 40 => 'Grave',
  < 60 => 'Largo',
  < 66 => 'Larghetto',
  < 76 => 'Adagio',
  < 108 => 'Andante',
  < 120 => 'Moderato',
  < 156 => 'Allegro',
  < 176 => 'Vivace',
  < 200 => 'Presto',
  _ => 'Prestissimo',
};

@immutable
class MetronomeSettings {
  const MetronomeSettings({
    this.bpm = 100,
    this.beats = 4,
    this.subdivision = Subdivision.none,
    this.accents = const [
      BeatAccent.accent,
      BeatAccent.normal,
      BeatAccent.normal,
      BeatAccent.normal,
    ],
    this.sound = ClickSound.click,
    this.volume = 0.8,
    this.flash = true,
  });

  final int bpm;
  final int beats;
  final Subdivision subdivision;

  /// One entry per beat of the bar.
  final List<BeatAccent> accents;
  final ClickSound sound;
  final double volume;

  /// Flash the screen edge on every beat.
  final bool flash;

  double get beatSeconds => 60 / bpm;
  double get barSeconds => beats * beatSeconds;

  MetronomeSettings copyWith({
    int? bpm,
    int? beats,
    Subdivision? subdivision,
    List<BeatAccent>? accents,
    ClickSound? sound,
    double? volume,
    bool? flash,
  }) {
    final b = (beats ?? this.beats).clamp(1, maxBeats);
    final source = accents ?? this.accents;
    // Keep the pattern when the bar gets longer or shorter; new beats are plain.
    final fitted = [
      for (var i = 0; i < b; i++)
        i < source.length
            ? source[i]
            : (i == 0 ? BeatAccent.accent : BeatAccent.normal),
    ];
    return MetronomeSettings(
      bpm: (bpm ?? this.bpm).clamp(minBpm, maxBpm),
      beats: b,
      subdivision: subdivision ?? this.subdivision,
      accents: List.unmodifiable(fitted),
      sound: sound ?? this.sound,
      volume: (volume ?? this.volume).clamp(0.0, 1.0),
      flash: flash ?? this.flash,
    );
  }

  Map<String, Object> toJson() => {
    'bpm': bpm,
    'beats': beats,
    'subdivision': subdivision.name,
    'accents': [for (final a in accents) a.name],
    'sound': sound.name,
    'volume': volume,
    'flash': flash,
  };

  factory MetronomeSettings.fromJson(Map<String, dynamic> j) {
    T pick<T extends Enum>(List<T> values, Object? name, T fallback) =>
        values.firstWhere((v) => v.name == name, orElse: () => fallback);
    const d = MetronomeSettings();
    return d.copyWith(
      bpm: (j['bpm'] as num?)?.toInt(),
      beats: (j['beats'] as num?)?.toInt(),
      subdivision: pick(Subdivision.values, j['subdivision'], d.subdivision),
      accents: [
        for (final a in (j['accents'] as List? ?? const []))
          pick(BeatAccent.values, a, BeatAccent.normal),
      ],
      sound: pick(ClickSound.values, j['sound'], d.sound),
      volume: (j['volume'] as num?)?.toDouble(),
      flash: j['flash'] as bool?,
    );
  }
}

const _sampleRate = 44100;

enum _Level { accent, normal, sub }

/// Synthesises one click (mono, -1..1).
Float32List _click(ClickSound sound, _Level level) {
  final n = (_sampleRate * 0.05).round();
  final out = Float32List(n);
  final (f, gain) = switch ((sound, level)) {
    (ClickSound.click, _Level.accent) => (2100.0, 1.0),
    (ClickSound.click, _Level.normal) => (1500.0, 0.8),
    (ClickSound.click, _Level.sub) => (1100.0, 0.45),
    (ClickSound.wood, _Level.accent) => (1300.0, 1.0),
    (ClickSound.wood, _Level.normal) => (950.0, 0.85),
    (ClickSound.wood, _Level.sub) => (750.0, 0.5),
    (ClickSound.beep, _Level.accent) => (1760.0, 0.75),
    (ClickSound.beep, _Level.normal) => (880.0, 0.6),
    (ClickSound.beep, _Level.sub) => (660.0, 0.35),
  };
  const tau = 2 * math.pi;
  for (var i = 0; i < n; i++) {
    final t = i / _sampleRate;
    final attack = math.min(1.0, t / 0.0005);
    final v = switch (sound) {
      ClickSound.click => math.sin(tau * f * t) * math.exp(-t / 0.006),
      ClickSound.wood =>
        (math.sin(tau * f * t) + 0.45 * math.sin(tau * f * 2.76 * t)) /
            1.45 *
            math.exp(-t / 0.011),
      ClickSound.beep =>
        math.sin(tau * f * t) *
            (t < 0.035 ? 1.0 : math.exp(-(t - 0.035) / 0.003)),
    };
    out[i] = (v * attack * gain).toDouble();
  }
  return out;
}

/// Renders one bar as a 16-bit mono WAV. Looping it gives a sample-exact beat.
Uint8List buildBarWav(MetronomeSettings s) {
  final length = (s.barSeconds * _sampleRate).round();
  final mix = Float32List(length);
  final clicks = {for (final l in _Level.values) l: _click(s.sound, l)};
  final perBeat = s.subdivision.clicks;
  for (var beat = 0; beat < s.beats; beat++) {
    for (var k = 0; k < perBeat; k++) {
      final level = k > 0
          ? _Level.sub
          : switch (s.accents[beat]) {
              BeatAccent.accent => _Level.accent,
              BeatAccent.normal => _Level.normal,
              BeatAccent.mute => null,
            };
      if (level == null) continue;
      final start = ((beat + k / perBeat) * s.beatSeconds * _sampleRate)
          .round();
      final c = clicks[level]!;
      // Wrap around so a click near the end of the bar continues into the loop.
      for (var i = 0; i < c.length; i++) {
        mix[(start + i) % length] += c[i];
      }
    }
  }

  final data = ByteData(44 + length * 2);
  void ascii(int at, String s) {
    for (var i = 0; i < s.length; i++) {
      data.setUint8(at + i, s.codeUnitAt(i));
    }
  }

  ascii(0, 'RIFF');
  data.setUint32(4, 36 + length * 2, Endian.little);
  ascii(8, 'WAVE');
  ascii(12, 'fmt ');
  data.setUint32(16, 16, Endian.little);
  data.setUint16(20, 1, Endian.little); // PCM
  data.setUint16(22, 1, Endian.little); // mono
  data.setUint32(24, _sampleRate, Endian.little);
  data.setUint32(28, _sampleRate * 2, Endian.little);
  data.setUint16(32, 2, Endian.little);
  data.setUint16(34, 16, Endian.little);
  ascii(36, 'data');
  data.setUint32(40, length * 2, Endian.little);
  for (var i = 0; i < length; i++) {
    data.setInt16(
      44 + i * 2,
      (mix[i].clamp(-1.0, 1.0) * 32000).round(),
      Endian.little,
    );
  }
  return data.buffer.asUint8List();
}

/// Where the metronome is in the bar right now.
typedef MetronomePulse = ({int beat, int sub, double sinceBeat});

/// Averages the last few taps into a tempo; returns null until there are two taps.
class TapTempo {
  final _taps = <DateTime>[];

  int? tap([DateTime? now]) {
    now ??= DateTime.now();
    if (_taps.isNotEmpty &&
        now.difference(_taps.last) > const Duration(seconds: 2))
      _taps.clear();
    _taps.add(now);
    if (_taps.length > 5) _taps.removeAt(0);
    if (_taps.length < 2) return null;
    final span =
        _taps.last.difference(_taps.first).inMicroseconds / (_taps.length - 1);
    return (60e6 / span).round().clamp(minBpm, maxBpm);
  }
}

class Metronome extends ChangeNotifier {
  Metronome(this._prefs) {
    final raw = _prefs.getString(_key);
    if (raw != null) {
      try {
        _settings = MetronomeSettings.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      } catch (_) {}
    }
  }

  static const _key = 'metronome';
  final SharedPreferences _prefs;
  final tapTempo = TapTempo();

  MetronomeSettings _settings = const MetronomeSettings();
  MetronomeSettings get settings => _settings;

  bool _running = false;
  bool get running => _running;

  AudioSource? _source;
  SoundHandle? _handle;
  int _generation = 0;
  Timer? _rebuild;
  bool _disposed = false;
  final Stopwatch _playbackClock = Stopwatch();

  void update(MetronomeSettings Function(MetronomeSettings s) change) {
    final next = change(_settings);
    final soundChanged =
        jsonEncode({...next.toJson(), 'volume': 0, 'flash': 0}) !=
        jsonEncode({..._settings.toJson(), 'volume': 0, 'flash': 0});
    _settings = next;
    _prefs.setString(_key, jsonEncode(next.toJson()));
    if (_running) {
      final h = _handle;
      if (h != null) SoLoud.instance.setVolume(h, next.volume);
      // While tapping the click stays silent; it resumes when the taps stop.
      if (soundChanged && !_tapping) {
        // Debounced so dragging the tempo slider doesn't rebuild on every frame.
        _rebuild?.cancel();
        _rebuild = Timer(const Duration(milliseconds: 120), _play);
      }
    }
    notifyListeners();
  }

  void setBpm(int bpm) => update((s) => s.copyWith(bpm: bpm));

  bool _tapping = false;
  Timer? _tapEnd;

  /// True while tap tempo has silenced a running metronome.
  bool get tapping => _tapping;

  /// Hearing clicks while tapping throws you off, so a running metronome goes quiet
  /// and comes back in on the tapped grid, two beats after the last tap.
  void tap() {
    final bpm = tapTempo.tap();
    if (_running) {
      if (!_tapping) {
        _tapping = true;
        _silence();
      }
      _tapEnd?.cancel();
      final beat = Duration(
        microseconds: (60e6 / (bpm ?? _settings.bpm)).round(),
      );
      _tapEnd = Timer(beat * 2, () {
        _tapping = false;
        if (_running) _play();
        notifyListeners();
      });
    }
    if (bpm != null) {
      setBpm(bpm);
    } else {
      notifyListeners();
    }
  }

  void _silence() {
    _rebuild?.cancel();
    _generation++; // drops a load that is still in flight
    final (handle, source) = (_handle, _source);
    _handle = null;
    _source = null;
    _release(handle, source);
  }

  Future<void> toggle() => _running ? stop() : start();

  Future<void> start() async {
    if (_running) return;
    _running = true;
    _playbackClock
      ..reset()
      ..start();
    notifyListeners();
    await _play();
  }

  Future<void> stop() async {
    _rebuild?.cancel();
    _tapEnd?.cancel();
    _tapping = false;
    _running = false;
    _playbackClock.stop();
    _generation++;
    if (!_disposed) notifyListeners();
    await _release(_handle, _source);
    _handle = null;
    _source = null;
  }

  Future<void> _play() async {
    final generation = ++_generation;
    final soloud = SoLoud.instance;
    try {
      if (!soloud.isInitialized) await soloud.init(bufferSize: 1024, channels: Channels.mono);
      final wav = buildBarWav(_settings);
      final source = await soloud.loadMem('metronome-$generation.wav', wav);
      if (generation != _generation || !_running) {
        await soloud.disposeSource(source);
        return;
      }
      final handle = await soloud.play(
        source,
        volume: _settings.volume,
        looping: true,
      );
      final (oldHandle, oldSource) = (_handle, _source);
      _handle = handle;
      _source = source;
      _playbackClock
        ..reset()
        ..start();
      await _release(oldHandle, oldSource);
    } catch (e) {
      debugPrint('Metronome failed: $e');
      _running = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> _release(SoundHandle? handle, AudioSource? source) async {
    final soloud = SoLoud.instance;
    if (!soloud.isInitialized) return;
    try {
      if (handle != null) await soloud.stop(handle);
      if (source != null) await soloud.disposeSource(source);
    } catch (_) {}
  }

  /// Uses a monotonic clock so visual beats do not depend on audio position updates.
  MetronomePulse? pulse() {
    if (!_running || _tapping) return null;
    final s = _settings;
    final t = (_playbackClock.elapsedMicroseconds / 1e6) % s.barSeconds;
    final beat = (t / s.beatSeconds).floor().clamp(0, s.beats - 1);
    final inBeat = t - beat * s.beatSeconds;
    final sub = (inBeat / (s.beatSeconds / s.subdivision.clicks)).floor();
    return (beat: beat, sub: sub, sinceBeat: inBeat);
  }

  @override
  void dispose() {
    _disposed = true;
    stop();
    super.dispose();
  }
}
