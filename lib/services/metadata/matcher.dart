import '../../core/sorting.dart';
import 'models.dart';
import 'query_builder.dart';

final _tokenSplit = RegExp(r"[^a-z0-9]+");

Set<String> _tokens(String s) => foldText(s).split(_tokenSplit).where((t) => t.isNotEmpty).toSet();

/// 0..1 overlap of the words in two titles (1 = same words, ignoring case, accents and order).
double similarity(String a, String b) {
  final ta = _tokens(a), tb = _tokens(b);
  if (ta.isEmpty || tb.isEmpty) return 0;
  final shared = ta.intersection(tb).length;
  return shared / (ta.length > tb.length ? ta.length : tb.length);
}

const closeTitle = 0.85;

final _featuring = RegExp(r'\s+(feat\.?|ft\.?|featuring|with|vs\.?|&|and|x)\s+', caseSensitive: false);

/// True when [credited] is the [wanted] artist, also when the credit adds guests ("Skillet feat. X").
bool artistMatches(String wanted, String credited) =>
    similarity(wanted, credited) >= closeTitle || similarity(wanted, credited.split(_featuring).first) >= closeTitle;
const _minLeaderCount = 3;
const _leaderFactor = 3;

class MatchDecision {
  const MatchDecision.strong(Candidate this.best) : review = const [];
  const MatchDecision.review(this.review) : best = null;
  const MatchDecision.none()
      : best = null,
        review = const [];

  /// Set when the match is clear enough to apply without asking.
  final Candidate? best;

  /// Candidates for the picker when the match is ambiguous.
  final List<Candidate> review;

  bool get isStrong => best != null;
  bool get isEmpty => best == null && review.isEmpty;
}

/// Decides whether the candidates for [query] are a clear match.
///
/// Strong: the artist in the query matches, or only one artist has a close official
/// recording, or one artist clearly leads. Everything else is ambiguous.
MatchDecision decide(SearchQuery query, List<Candidate> candidates) {
  final close = [
    for (final c in candidates)
      if (c.official && similarity(query.title, c.title) >= closeTitle) c,
  ];
  if (close.isEmpty) return const MatchDecision.none();

  // Best (earliest dated, then highest score) candidate per artist.
  final byArtist = <String, List<Candidate>>{};
  for (final c in close) {
    byArtist.putIfAbsent(foldText(c.artist), () => []).add(c);
  }
  Candidate pickOf(List<Candidate> list) {
    final sorted = [...list]..sort((a, b) {
        final byScore = b.score.compareTo(a.score);
        if (byScore != 0) return byScore;
        return (a.year ?? 9999).compareTo(b.year ?? 9999);
      });
    final top = sorted.first.score;
    final nearTop = sorted.where((c) => c.score >= top - 5 && c.year != null).toList()
      ..sort((a, b) => a.year!.compareTo(b.year!));
    return nearTop.isNotEmpty ? nearTop.first : sorted.first;
  }

  final groups = byArtist.values.toList()..sort((a, b) => b.length.compareTo(a.length));
  final picks = [for (final g in groups) pickOf(g)];

  final wanted = query.artist;
  if (wanted != null) {
    for (var i = 0; i < groups.length; i++) {
      if (artistMatches(wanted, groups[i].first.artist)) return MatchDecision.strong(picks[i]);
    }
    return MatchDecision.review(picks.take(5).toList());
  }
  if (groups.length == 1) return MatchDecision.strong(picks.first);
  if (groups.first.length >= _minLeaderCount && groups.first.length >= _leaderFactor * groups[1].length) {
    return MatchDecision.strong(picks.first);
  }
  return MatchDecision.review(picks.take(5).toList());
}
