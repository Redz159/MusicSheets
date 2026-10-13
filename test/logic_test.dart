import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_sheets/core/ordering.dart';
import 'package:music_sheets/core/sorting.dart';
import 'package:music_sheets/core/viewer_layout.dart';
import 'package:music_sheets/features/annotate/annotation_model.dart';
import 'package:music_sheets/services/import_service.dart';

import 'helpers.dart';

void main() {
  group('sorting', () {
    test('umlauts and accents sort with their base letter', () {
      expect(sectionLetter('Ärger'), 'A');
      expect(sectionLetter('élan'), 'E');
      expect(sectionLetter('Über den Wolken'), 'U');
      expect(foldText('Straße'), 'strasse');
    });

    test('digits and symbols go to the "?" section, which comes first', () {
      expect(sectionLetter('99 Luftballons'), otherSection);
      expect(sectionLetter('(I Can\'t Get No)'), otherSection);
      expect(sectionLetter(''), otherSection);
      final sorted = sortSongs([song(1, 'Cocaine'), song(2, '7 Nation Army'), song(3, 'Alle hassen Nazis')], SongSort.title);
      expect(sorted.map((s) => s.title), ['7 Nation Army', 'Alle hassen Nazis', 'Cocaine']);
    });

    test('indexed list matches the screenshot layout', () {
      final songs = sortSongs([
        song(1, 'Keine Angst - Gitarre'),
        song(2, 'Comatose - Gitarre'),
        song(3, 'Dance Macabre - Gitarre'),
        song(4, 'Alle hassen Nazis - Gitarre'),
        song(5, 'Cocaine - Gitarre'),
      ], SongSort.title);
      final idx = IndexedSongs.build(songs, SongSort.title);
      expect(idx.sectionStart.keys, ['A', 'C', 'D', 'K']);
      final rendered = [
        for (final e in idx.entries)
          switch (e) {
            HeaderEntry(:final letter) => '#$letter',
            SongEntry(:final song) => song.title.split(' - ').first,
          }
      ];
      expect(rendered, ['#A', 'Alle hassen Nazis', '#C', 'Cocaine', 'Comatose', '#D', 'Dance Macabre', '#K', 'Keine Angst']);
      expect(idx.sectionStart['C'], 2);
    });

    test('composer sort groups by composer, then title', () {
      final sorted = sortSongs([
        song(1, 'B', composer: 'Zappa'),
        song(2, 'A', composer: 'Zappa'),
        song(3, 'C', composer: 'Bach'),
      ], SongSort.composer);
      expect(sorted.map((s) => s.title), ['C', 'A', 'B']);
    });

    test('recently opened puts never-opened songs last', () {
      final sorted = sortSongs([
        song(1, 'Never'),
        song(2, 'Old', opened: DateTime(2026, 1, 1)),
        song(3, 'New', opened: DateTime(2026, 5, 1)),
      ], SongSort.recentlyOpened);
      expect(sorted.map((s) => s.title), ['New', 'Old', 'Never']);
    });

    test('search matches all terms across fields and tags', () {
      final s = song(1, 'Dance Macabre', composer: 'Ghost');
      expect(matchesQuery(s, 'ghost dance', []), isTrue);
      expect(matchesQuery(s, 'macabre live', ['Live']), isTrue);
      expect(matchesQuery(s, 'metallica', []), isFalse);
    });
  });

  group('setlist ordering', () {
    test('moving down and up computes positions between neighbours', () {
      final positions = [1.0, 2.0, 3.0, 4.0];
      final down = reorderPosition(positions, 0, 3); // A before D -> between C and D
      expect(down.index, 2);
      expect(down.position, 3.5);
      final up = reorderPosition(positions, 3, 0); // D to the top
      expect(up.index, 0);
      expect(up.position, 0.0);
      final end = reorderPosition(positions, 1, 4);
      expect(end.position, 5.0);
    });

    test('flags positions that got too close', () {
      final r = reorderPosition([1.0, 1.0 + 1e-8, 2.0], 2, 1);
      expect(r.needsNormalize, isTrue);
    });
  });

  group('viewer layout', () {
    final flat = flattenPages([3, 2]);

    test('flattens songs into one sequence', () {
      expect(flat.length, 5);
      expect(songOffsets([3, 2]), [0, 3]);
      expect(flat[3].song, 1);
      expect(flat[3].page, 0);
    });

    test('spreads never mix two songs', () {
      final units = buildUnits(flat, spread: true);
      expect(units, [
        [0, 1],
        [2],
        [3, 4],
      ]);
      expect(unitOf(units, 4), 2);
      expect(buildUnits(flat, spread: false).length, 5);
    });
  });

  group('annotations', () {
    const page = Size(1000, 1400);

    test('JSON round-trip keeps all item types', () {
      final anns = PageAnnotations([
        const InkItem(color: 0xFF111111, width: 0.004, points: [0.1, 0.2, 0.5, 0.3, 0.4, 0.7]),
        const InkItem(color: 0x66FFEB3B, width: 0.02, highlighter: true, points: [0.5, 0.5, 0.5]),
        const ShapeItem(color: 0xFFD32F2F, kind: ShapeKind.oval, width: 0.003, a: Offset(0.1, 0.1), b: Offset(0.3, 0.2)),
        const TextItem(color: 0xFF1565C0, text: 'Capo 2\nÜbergang', pos: Offset(0.6, 0.05), size: 0.03),
        const TextItem(color: 0xFF111111, text: 'mf', pos: Offset(0.2, 0.8), size: 0.03, stamp: true),
      ]);
      final back = PageAnnotations.decode(anns.encode());
      expect(back.encode(), anns.encode());
      expect(back.items[1], isA<InkItem>().having((i) => i.highlighter, 'highlighter', true));
      expect(back.items[2], isA<ShapeItem>().having((i) => i.kind, 'kind', ShapeKind.oval));
      expect((back.items[3] as TextItem).text, 'Capo 2\nÜbergang');
      expect((back.items[4] as TextItem).stamp, isTrue);
    });

    test('empty pages encode to null so the row is deleted', () {
      expect(PageAnnotations.empty.encode(), isNull);
      expect(PageAnnotations.decode(null).isEmpty, isTrue);
    });

    test('eraser hit test follows the stroke in page pixels', () {
      const ink = InkItem(color: 0xFF000000, width: 0.004, points: [0.1, 0.1, 0.5, 0.5, 0.1, 0.5]);
      expect(ink.hit(const Offset(300, 140), page, 5), isTrue); // on the segment
      expect(ink.hit(const Offset(300, 600), page, 5), isFalse);
      const line = ShapeItem(color: 0, kind: ShapeKind.rect, width: 0.002, a: Offset(0.1, 0.1), b: Offset(0.5, 0.5));
      expect(line.hit(const Offset(100, 400), page, 4), isTrue); // left edge
      expect(line.hit(const Offset(300, 400), page, 4), isFalse); // inside, not on edge
    });

    test('stroke outline scales with the page', () {
      const ink = InkItem(color: 0xFF000000, width: 0.004, points: [0.1, 0.1, 0.5, 0.5, 0.5, 0.5]);
      final small = ink.outline(const Size(500, 700));
      final big = ink.outline(const Size(1000, 1400));
      expect(small, isNotEmpty);
      final maxSmall = small.map((o) => o.dx).reduce((a, b) => a > b ? a : b);
      final maxBig = big.map((o) => o.dx).reduce((a, b) => a > b ? a : b);
      expect(maxBig / maxSmall, closeTo(2, 0.05));
    });
  });

  test('titles from file names', () {
    expect(ImportService.titleFromFileName('Cocaine - Gitarre.pdf'), 'Cocaine - Gitarre');
    expect(ImportService.titleFromFileName('dance_macabre__guitar.PDF'), 'dance macabre guitar');
    expect(ImportService.titleFromFileName('.pdf'), isNotEmpty);
  });
}
