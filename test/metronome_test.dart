import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:music_sheets/features/metronome/metronome.dart';

/// Sample indices where a click starts (silence before, sound after).
List<int> _onsets(Uint8List wav) {
  final data = ByteData.sublistView(wav, 44);
  final n = data.lengthInBytes ~/ 2;
  final onsets = <int>[];
  var quiet = 1 << 30;
  for (var i = 0; i < n; i++) {
    final loud = data.getInt16(i * 2, Endian.little).abs() > 200;
    if (loud && quiet > 400) onsets.add(i);
    quiet = loud ? 0 : quiet + 1;
  }
  return onsets;
}

void main() {
  test('one bar is exactly beats × 60/bpm long, with a WAV header', () {
    final wav = buildBarWav(const MetronomeSettings(bpm: 120, beats: 3).copyWith());
    expect(String.fromCharCodes(wav.sublist(0, 4)), 'RIFF');
    expect(String.fromCharCodes(wav.sublist(8, 12)), 'WAVE');
    final samples = (wav.length - 44) ~/ 2;
    expect(samples, 44100 * 3 * 60 ~/ 120);
  });

  test('clicks land on every beat and subdivision', () {
    final s = const MetronomeSettings(bpm: 60, beats: 2).copyWith(subdivision: Subdivision.triplets);
    final onsets = _onsets(buildBarWav(s));
    final expected = [for (var k = 0; k < 6; k++) (k * 44100 / 3).round()];
    expect(onsets.length, expected.length);
    for (var i = 0; i < expected.length; i++) {
      expect((onsets[i] - expected[i]).abs(), lessThan(3), reason: 'click $i');
    }
  });

  test('muted beats are silent', () {
    final s = const MetronomeSettings(bpm: 60, beats: 4)
        .copyWith(accents: [BeatAccent.accent, BeatAccent.mute, BeatAccent.normal, BeatAccent.mute]);
    final onsets = _onsets(buildBarWav(s));
    expect(onsets.length, 2);
    expect(onsets[0], lessThan(3));
    expect((onsets[1] - 2 * 44100).abs(), lessThan(3));
  });

  test('changing beats per bar keeps the accent pattern', () {
    final s = const MetronomeSettings().copyWith(
      accents: [BeatAccent.accent, BeatAccent.mute, BeatAccent.normal, BeatAccent.normal],
    );
    expect(s.copyWith(beats: 6).accents, [
      BeatAccent.accent,
      BeatAccent.mute,
      BeatAccent.normal,
      BeatAccent.normal,
      BeatAccent.normal,
      BeatAccent.normal,
    ]);
    expect(s.copyWith(beats: 2).accents, [BeatAccent.accent, BeatAccent.mute]);
    expect(s.copyWith(bpm: 999).bpm, maxBpm);
  });

  test('settings survive a JSON round-trip', () {
    final s = const MetronomeSettings().copyWith(
      bpm: 87,
      beats: 7,
      subdivision: Subdivision.sixteenths,
      sound: ClickSound.wood,
      volume: 0.4,
      flash: false,
    );
    expect(MetronomeSettings.fromJson(s.toJson()).toJson(), s.toJson());
  });

  test('tap tempo averages taps and resets after a pause', () {
    final t = TapTempo();
    final start = DateTime(2026);
    expect(t.tap(start), isNull);
    expect(t.tap(start.add(const Duration(milliseconds: 500))), 120);
    expect(t.tap(start.add(const Duration(milliseconds: 1000))), 120);
    // A long pause starts over.
    expect(t.tap(start.add(const Duration(seconds: 10))), isNull);
    expect(t.tap(start.add(const Duration(seconds: 10, milliseconds: 750))), 80);
  });

  test('tempo markings', () {
    expect(tempoMarking(50), 'Largo');
    expect(tempoMarking(100), 'Andante');
    expect(tempoMarking(132), 'Allegro');
  });
}
