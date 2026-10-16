import '../data/db.dart';

enum SongSort {
  title('Title A–Z'),
  composer('Composer'),
  recentlyAdded('Recently added'),
  recentlyOpened('Recently opened'),
  mostPlayed('Most played');

  const SongSort(this.label);
  final String label;

  /// Whether this sort is shown as an indexed (A–Z sectioned) list.
  bool get indexed => this == title || this == composer;

  static SongSort parse(String? name) =>
      SongSort.values.firstWhere((s) => s.name == name, orElse: () => SongSort.title);
}

/// Letter used for everything that doesn't start with A–Z.
const otherSection = '?';

const _foldMap = {
  'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a', 'æ': 'ae', //
  'ç': 'c', 'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e', 'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
  'ñ': 'n', 'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', 'ø': 'o', 'œ': 'oe',
  'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u', 'ý': 'y', 'ÿ': 'y', 'ß': 'ss',
};

/// Lowercases and strips diacritics so "Ärger" sorts with "a" and "Élan" with "e".
String foldText(String s) {
  final lower = s.toLowerCase().trim();
  final buf = StringBuffer();
  for (final rune in lower.runes) {
    final ch = String.fromCharCode(rune);
    buf.write(_foldMap[ch] ?? ch);
  }
  return buf.toString();
}

String sectionLetter(String s) {
  final folded = foldText(s);
  if (folded.isEmpty) return otherSection;
  final c = folded.codeUnitAt(0);
  if (c >= 0x61 && c <= 0x7a) return String.fromCharCode(c - 32);
  return otherSection;
}

/// Compares with "?" entries first (like the index rail), then alphabetically.
int compareForIndex(String a, String b) {
  final sa = sectionLetter(a), sb = sectionLetter(b);
  if (sa != sb) {
    if (sa == otherSection) return -1;
    if (sb == otherSection) return 1;
    return sa.compareTo(sb);
  }
  return foldText(a).compareTo(foldText(b));
}

String sortKeyFor(Song s, SongSort sort) => switch (sort) {
      SongSort.composer => s.composer.trim().isEmpty ? '' : s.composer,
      _ => s.title,
    };

List<Song> sortSongs(Iterable<Song> songs, SongSort sort) {
  final list = songs.toList();
  int byTitle(Song a, Song b) => compareForIndex(a.title, b.title);
  switch (sort) {
    case SongSort.title:
      list.sort(byTitle);
    case SongSort.composer:
      list.sort((a, b) {
        final c = compareForIndex(a.composer, b.composer);
        return c != 0 ? c : byTitle(a, b);
      });
    case SongSort.recentlyAdded:
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    case SongSort.recentlyOpened:
      list.sort((a, b) {
        final ao = a.lastOpenedAt, bo = b.lastOpenedAt;
        if (ao == null && bo == null) return byTitle(a, b);
        if (ao == null) return 1;
        if (bo == null) return -1;
        return bo.compareTo(ao);
      });
    case SongSort.mostPlayed:
      list.sort((a, b) {
        final c = b.openCount.compareTo(a.openCount);
        return c != 0 ? c : byTitle(a, b);
      });
  }
  return list;
}

/// A flattened list entry for sectioned lists: either a header or a song.
sealed class IndexEntry {
  const IndexEntry();
}

class HeaderEntry extends IndexEntry {
  const HeaderEntry(this.letter);
  final String letter;
}

class SongEntry extends IndexEntry {
  const SongEntry(this.song);
  final Song song;
}

class IndexedSongs {
  IndexedSongs(this.entries, this.sectionStart);

  final List<IndexEntry> entries;

  /// Section letter -> index of its header in [entries], in display order.
  final Map<String, int> sectionStart;

  /// Builds the sectioned list from songs that are already sorted with [sortSongs].
  factory IndexedSongs.build(List<Song> sorted, SongSort sort) {
    final entries = <IndexEntry>[];
    final starts = <String, int>{};
    for (final s in sorted) {
      final letter = sectionLetter(sortKeyFor(s, sort));
      if (!starts.containsKey(letter)) {
        starts[letter] = entries.length;
        entries.add(HeaderEntry(letter));
      }
      entries.add(SongEntry(s));
    }
    return IndexedSongs(entries, starts);
  }
}

/// Simple multi-term search over title, composer, artist, album, genre, instrument, key, notes and tags.
bool matchesQuery(Song s, String query, List<String> tagNames) {
  final q = foldText(query);
  if (q.isEmpty) return true;
  final hay = foldText([s.title, s.composer, s.artist, s.album, s.genre, s.instrument, s.musicalKey, s.notes, ...tagNames].join(' '));
  return q.split(RegExp(r'\s+')).every(hay.contains);
}
