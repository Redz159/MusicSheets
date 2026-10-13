import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_sheets/core/sorting.dart';
import 'package:music_sheets/widgets/song_list.dart';

import 'helpers.dart';

void main() {
  testWidgets('A–Z list shows section bars, rows and a rail that jumps', (tester) async {
    tester.view.physicalSize = const Size(1600, 1900);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    final titles = [
      'Alle hassen Nazis - Gitarre',
      'Cocaine - Gitarre',
      'Comatose - Gitarre',
      'Dance Macabre - Gitarre',
      'Keine Angst - Gitarre',
      for (var i = 0; i < 30; i++) 'Zebra $i',
    ];
    final songs = sortSongs([for (var i = 0; i < titles.length; i++) song(i + 1, titles[i])], SongSort.title);
    String? tapped;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: SongList(songs: songs, sort: SongSort.title, onTap: (s) => tapped = s.title)),
    ));

    expect(find.text('Alle hassen Nazis - Gitarre'), findsOneWidget);
    expect(find.text('-'), findsWidgets); // empty composer shows a dash like the screenshot
    final rail = find.byType(LetterRail);
    expect(rail, findsOneWidget);
    for (final l in ['A', 'C', 'D', 'K', 'Z']) {
      expect(find.descendant(of: rail, matching: find.text(l)), findsOneWidget);
    }

    await tester.tap(find.text('Cocaine - Gitarre'));
    expect(tapped, 'Cocaine - Gitarre');

    // Jump to Z via the rail.
    expect(find.text('Zebra 29'), findsNothing);
    await tester.tap(find.descendant(of: rail, matching: find.text('Z')));
    await tester.pumpAndSettle();
    expect(find.text('Zebra 0'), findsOneWidget);
    expect(find.text('Alle hassen Nazis - Gitarre'), findsNothing);
  });
}
