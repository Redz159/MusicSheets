import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'models.dart';
import 'query_builder.dart';
import 'rate_limiter.dart';

const userAgent = 'MusicSheets/1.0 ( https://github.com/Redz159/MusicSheets )';
const _secondaryExcluded = {'live', 'compilation', 'karaoke', 'dj-mix', 'mixtape/street', 'demo', 'remix'};
const _primaryAllowed = {'album', 'single', 'ep'};

/// Maps HTTP trouble to [TemporaryLookupError] so the queue can retry later.
Future<http.Response> guardedGet(http.Client client, Uri url, Map<String, String> headers) async {
  final http.Response res;
  try {
    res = await client.get(url, headers: headers).timeout(const Duration(seconds: 20));
  } on TimeoutException {
    throw TemporaryLookupError('timeout');
  } on SocketException catch (e) {
    throw TemporaryLookupError('no connection: ${e.message}');
  } on http.ClientException catch (e) {
    throw TemporaryLookupError('network: ${e.message}');
  }
  if (res.statusCode == 429 || res.statusCode >= 500) throw TemporaryLookupError('HTTP ${res.statusCode}');
  return res;
}

class RecordingDetails {
  const RecordingDetails({this.workId, this.composer, this.genres = const []});
  final String? workId;
  final String? composer;
  final List<String> genres;
}

class MusicBrainzClient {
  MusicBrainzClient(this.client, {RateLimiter? limiter, this.base = 'https://musicbrainz.org/ws/2'})
      : limiter = limiter ?? RateLimiter(const Duration(milliseconds: 1100));

  final http.Client client;
  final RateLimiter limiter;
  final String base;

  Future<Map<String, dynamic>?> _json(String path, Map<String, String> params) async {
    await limiter.wait();
    final res = await guardedGet(
        client, Uri.parse('$base/$path').replace(queryParameters: {...params, 'fmt': 'json'}), {
      'User-Agent': userAgent,
      'Accept': 'application/json',
    });
    if (res.statusCode == 404) return null;
    if (res.statusCode != 200) throw TemporaryLookupError('HTTP ${res.statusCode}');
    return jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
  }

  static String _escape(String s) => s.replaceAll(RegExp(r'[+\-&|!(){}\[\]^"~*?:\\/]'), ' ').trim();

  Future<List<Candidate>> searchRecordings(SearchQuery q) async {
    final parts = ['recording:"${_escape(q.title)}"'];
    if (q.artist != null) parts.add('artist:"${_escape(q.artist!)}"');
    final json = await _json('recording', {'query': parts.join(' AND '), 'limit': '25'});
    return parseRecordings(json);
  }

  /// Work link, composer and genres of a recording: 2 requests (recording, then work).
  Future<RecordingDetails> details(String recordingId) async {
    final rec = await _json('recording/$recordingId', {'inc': 'work-rels+genres'});
    final genres = [
      for (final g in (rec?['genres'] as List?) ?? const []) (g as Map<String, dynamic>),
    ]..sort((a, b) => ((b['count'] as int?) ?? 0).compareTo((a['count'] as int?) ?? 0));
    final genreNames = [for (final g in genres) g['name'] as String];

    String? workId;
    for (final r in (rec?['relations'] as List?) ?? const []) {
      final work = (r as Map<String, dynamic>)['work'];
      if (work is Map<String, dynamic>) {
        workId = work['id'] as String?;
        break;
      }
    }
    if (workId == null) return RecordingDetails(genres: genreNames);
    final work = await _json('work/$workId', {'inc': 'artist-rels'});
    final names = <String>[];
    for (final r in (work?['relations'] as List?) ?? const []) {
      final m = r as Map<String, dynamic>;
      if (m['type'] == 'composer' && m['artist'] is Map) {
        final name = (m['artist'] as Map)['name'] as String?;
        if (name != null && !names.contains(name)) names.add(name);
      }
    }
    return RecordingDetails(workId: workId, composer: names.isEmpty ? null : names.join(', '), genres: genreNames);
  }

  static List<Candidate> parseRecordings(Map<String, dynamic>? json) {
    final out = <Candidate>[];
    for (final r in (json?['recordings'] as List?) ?? const []) {
      final m = r as Map<String, dynamic>;
      final credit = [
        for (final a in (m['artist-credit'] as List?) ?? const [])
          '${(a as Map<String, dynamic>)['name'] ?? (a['artist'] as Map?)?['name'] ?? ''}${a['joinphrase'] ?? ''}',
      ].join().trim();
      if (credit.isEmpty) continue;

      int? bestYear;
      String? album, groupId;
      var official = false;
      for (final rel in (m['releases'] as List?) ?? const []) {
        final rm = rel as Map<String, dynamic>;
        if (rm['status'] != 'Official') continue;
        final group = (rm['release-group'] as Map<String, dynamic>?) ?? const {};
        final primary = (group['primary-type'] as String?)?.toLowerCase();
        final secondary = [for (final s in (group['secondary-types'] as List?) ?? const []) (s as String).toLowerCase()];
        if (primary == null || !_primaryAllowed.contains(primary)) continue;
        if (secondary.any(_secondaryExcluded.contains)) continue;
        official = true;
        final year = int.tryParse(((rm['date'] as String?) ?? '').split('-').first);
        if (year != null && (bestYear == null || year < bestYear)) {
          bestYear = year;
          album = rm['title'] as String?;
          groupId = group['id'] as String?;
        } else if (album == null) {
          album = rm['title'] as String?;
          groupId = group['id'] as String?;
        }
      }
      bestYear ??= int.tryParse(((m['first-release-date'] as String?) ?? '').split('-').first);
      out.add(Candidate(
        recordingId: m['id'] as String,
        title: m['title'] as String,
        artist: credit,
        score: int.tryParse('${m['score']}') ?? 0,
        year: bestYear,
        album: album,
        releaseGroupId: groupId,
        official: official,
      ));
    }
    return out;
  }
}
