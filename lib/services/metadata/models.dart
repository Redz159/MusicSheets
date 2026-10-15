import 'dart:convert';

enum LookupStatus { pending, matched, needsReview, notFound, failed }

LookupStatus lookupStatusOf(String name) =>
    LookupStatus.values.firstWhere((s) => s.name == name, orElse: () => LookupStatus.pending);

/// A MusicBrainz recording that might be the song on the sheet.
class Candidate {
  const Candidate({
    required this.recordingId,
    required this.title,
    required this.artist,
    required this.score,
    this.year,
    this.album,
    this.releaseGroupId,
    this.genres = const [],
    this.official = true,
  });

  final String recordingId;
  final String title;
  final String artist;

  /// MusicBrainz search score, 0..100.
  final int score;
  final int? year;
  final String? album;
  final String? releaseGroupId;
  final List<String> genres;

  /// False for live, compilation, karaoke and similar releases.
  final bool official;

  Map<String, dynamic> toJson() => {
        'id': recordingId,
        'title': title,
        'artist': artist,
        'score': score,
        'year': year,
        'album': album,
        'rg': releaseGroupId,
        'genres': genres,
        'official': official,
      };

  factory Candidate.fromJson(Map<String, dynamic> j) => Candidate(
        recordingId: j['id'] as String,
        title: j['title'] as String,
        artist: j['artist'] as String,
        score: j['score'] as int,
        year: j['year'] as int?,
        album: j['album'] as String?,
        releaseGroupId: j['rg'] as String?,
        genres: [for (final g in (j['genres'] as List? ?? const [])) g as String],
        official: j['official'] as bool? ?? true,
      );

  static String encodeList(List<Candidate> list) => jsonEncode([for (final c in list) c.toJson()]);

  static List<Candidate> decodeList(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      return [for (final j in jsonDecode(raw) as List) Candidate.fromJson(j as Map<String, dynamic>)];
    } catch (_) {
      return const [];
    }
  }
}

/// Thrown for errors worth retrying later: timeouts, 429/503, no connection.
class TemporaryLookupError implements Exception {
  TemporaryLookupError(this.message);
  final String message;

  @override
  String toString() => 'TemporaryLookupError: $message';
}
