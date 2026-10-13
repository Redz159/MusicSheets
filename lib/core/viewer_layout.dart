/// One page of the sequence shown in the viewer: [song] indexes the viewer's song list.
class PageRef {
  const PageRef(this.song, this.page);
  final int song;
  final int page;
}

/// All pages of all songs, one after another (a setlist is "one long document").
List<PageRef> flattenPages(List<int> pageCounts) => [
      for (var s = 0; s < pageCounts.length; s++)
        for (var p = 0; p < pageCounts[s]; p++) PageRef(s, p),
    ];

/// Index of the first flat page of each song.
List<int> songOffsets(List<int> pageCounts) {
  final out = <int>[];
  var acc = 0;
  for (final c in pageCounts) {
    out.add(acc);
    acc += c;
  }
  return out;
}

/// Groups flat page indices into what is shown at once. With [spread], pages are
/// paired within each song (a song never shares a spread with the next one).
List<List<int>> buildUnits(List<PageRef> flat, {required bool spread}) {
  if (!spread) return [for (var i = 0; i < flat.length; i++) [i]];
  final units = <List<int>>[];
  var i = 0;
  while (i < flat.length) {
    if (i + 1 < flat.length && flat[i + 1].song == flat[i].song) {
      units.add([i, i + 1]);
      i += 2;
    } else {
      units.add([i]);
      i += 1;
    }
  }
  return units;
}

int unitOf(List<List<int>> units, int flatIndex) {
  for (var u = 0; u < units.length; u++) {
    if (units[u].contains(flatIndex)) return u;
  }
  return 0;
}
