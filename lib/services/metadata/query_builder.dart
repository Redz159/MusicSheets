/// Turns a file-name-derived title into search queries.
class SearchQuery {
  const SearchQuery(this.title, {this.artist});
  final String title;
  final String? artist;

  @override
  bool operator ==(Object other) => other is SearchQuery && other.title == title && other.artist == artist;

  @override
  int get hashCode => Object.hash(title, artist);

  @override
  String toString() => artist == null ? title : '$artist - $title';
}

final _brackets = RegExp(r'[\(\[\{][^\)\]\}]*[\)\]\}]');
final _noise = RegExp(
  r'\b(final|v\d+|ver\d*|version|copy|scan(ned)?|score|sheet|sheets|real\s*book|fake\s*book|lead\s*sheet|'
  r'chords?|tabs?|arrangement|'
  // Instruments and parts, English and German.
  r'piano|klavier|guitar|gitarre|git|violin|geige|violine|vocals?|gesang|bass|drums?|schlagzeug|flute|fl(ö|oe)te|'
  r'sax(ophone?)?|trumpet|trompete|cello|clarinet|klarinette|ukulele|keyboard|akkordeon|'
  r'noten|akkorde|stimme|part|partitur|tabulatur)\b',
  caseSensitive: false,
  unicode: true,
);
final _separator = RegExp(r'\s+[-–—]\s+');

String _tidy(String s) => s.replaceAll(RegExp(r'\s+'), ' ').trim().replaceAll(RegExp(r'^[-–—\s]+|[-–—\s]+$'), '');

/// Removes bracketed text and noise words such as "final", "v2" or "piano".
String cleanTitle(String raw) => _tidy(raw.replaceAll(_brackets, ' ').replaceAll(_noise, ' '));

/// Queries to try, best first. "Queen - Bohemian Rhapsody" yields both orders.
List<SearchQuery> queriesFromTitle(String raw) {
  final cleaned = cleanTitle(raw);
  if (cleaned.isEmpty) return const [];
  final out = <SearchQuery>[];
  final parts = cleaned.split(_separator).map(_tidy).where((p) => p.isNotEmpty).toList();
  if (parts.length == 2) {
    out
      ..add(SearchQuery(parts[1], artist: parts[0]))
      ..add(SearchQuery(parts[0], artist: parts[1]));
  }
  out.add(SearchQuery(cleaned));
  return out;
}
