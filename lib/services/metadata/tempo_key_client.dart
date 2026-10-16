import 'dart:convert';

import 'package:http/http.dart' as http;

import 'matcher.dart';
import 'musicbrainz_client.dart';

class KeyAndTempo {
  const KeyAndTempo({this.key, this.tempo});
  final String? key;
  final int? tempo;
  bool get isEmpty => key == null && tempo == null;
}

/// Key and tempo without any account or API key.
///
/// 1. AcousticBrainz, by MusicBrainz recording id: BPM and key from audio analysis. The project stopped
///    collecting data in 2022, so newer recordings have no entry.
/// 2. Deezer, by title and artist: BPM only. Fills the tempo when AcousticBrainz has nothing.
class TempoKeyClient {
  TempoKeyClient(this.client, {this.acousticBrainz = 'https://acousticbrainz.org/api/v1', this.deezer = 'https://api.deezer.com'});

  final http.Client client;
  final String acousticBrainz;
  final String deezer;

  /// Below this the analysis is a guess, and a wrong key is worse than none.
  static const minKeyStrength = 0.3;

  Future<KeyAndTempo> lookup(String recordingId, String title, String artist) async {
    final ab = await _fromAcousticBrainz(recordingId);
    if (ab.tempo != null) return ab;
    final tempo = await _tempoFromDeezer(title, artist);
    return KeyAndTempo(key: ab.key, tempo: tempo);
  }

  Future<Map<String, dynamic>?> _json(Uri url) async {
    final res = await guardedGet(client, url, {'User-Agent': userAgent, 'Accept': 'application/json'});
    if (res.statusCode != 200) return null;
    final body = jsonDecode(utf8.decode(res.bodyBytes));
    return body is Map<String, dynamic> ? body : null;
  }

  Future<KeyAndTempo> _fromAcousticBrainz(String recordingId) async {
    final json = await _json(Uri.parse('$acousticBrainz/low-level').replace(queryParameters: {
      'recording_ids': recordingId,
      'features': 'rhythm.bpm;tonal.key_key;tonal.key_scale;tonal.key_strength',
    }));
    return parseAcousticBrainz(json, recordingId);
  }

  static KeyAndTempo parseAcousticBrainz(Map<String, dynamic>? json, String recordingId) {
    final entry = json?[recordingId];
    final first = entry is Map<String, dynamic> ? entry['0'] : null;
    if (first is! Map<String, dynamic>) return const KeyAndTempo();
    final bpm = ((first['rhythm'] as Map?)?['bpm'] as num?)?.round();
    final tonal = first['tonal'] as Map?;
    final strength = (tonal?['key_strength'] as num?)?.toDouble() ?? 0;
    return KeyAndTempo(
      tempo: bpm != null && bpm > 0 ? bpm : null,
      key: strength >= minKeyStrength ? formatKey(tonal?['key_key'] as String?, tonal?['key_scale'] as String?) : null,
    );
  }

  /// "F" + "minor" -> "Fm", "C#" + "major" -> "C#": the shorthand musicians write on a sheet.
  static String? formatKey(String? root, String? scale) {
    if (root == null || root.isEmpty) return null;
    return scale == 'minor' ? '${root}m' : root;
  }

  Future<int?> _tempoFromDeezer(String title, String artist) async {
    final found = await _json(Uri.parse('$deezer/search').replace(queryParameters: {'q': '$artist $title', 'limit': '10'}));
    for (final r in (found?['data'] as List?) ?? const []) {
      if (r is! Map<String, dynamic>) continue;
      // "(Live ...)" and similar suffixes lower the similarity, so only the studio track passes.
      if (similarity(title, r['title'] as String? ?? '') < closeTitle) continue;
      final rArtist = (r['artist'] as Map?)?['name'] as String? ?? '';
      if (!artistMatches(artist, rArtist)) continue;
      final track = await _json(Uri.parse('$deezer/track/${r['id']}'));
      final bpm = (track?['bpm'] as num?)?.round();
      if (bpm != null && bpm > 0) return bpm;
    }
    return null;
  }
}
