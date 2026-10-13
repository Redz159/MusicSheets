import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_sheets/data/db.dart';
import 'package:music_sheets/features/annotate/annotation_model.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<int> addSong(String title) => db.insertSong(SongsCompanion.insert(
        title: title,
        fileName: '$title.pdf',
        fileHash: title,
        pageCount: const Value(3),
        createdAt: DateTime.now(),
      ));

  test('setlist keeps insertion order and moves items', () async {
    final a = await addSong('A'), b = await addSong('B'), c = await addSong('C');
    final list = await db.createSetlist('Gig');
    await db.addSongsToSetlist(list, [a, b, c]);
    var entries = await db.watchSetlistEntries(list).first;
    expect(entries.map((e) => e.song.title), ['A', 'B', 'C']);

    await db.moveSetlistItem(list, entries[2].item.id, 0.5); // C to the top
    entries = await db.watchSetlistEntries(list).first;
    expect(entries.map((e) => e.song.title), ['C', 'A', 'B']);

    // The same song may appear twice in a setlist (e.g. reprise).
    await db.addSongsToSetlist(list, [a]);
    expect((await db.watchSetlistEntries(list).first).length, 4);
  });

  test('deleting a song cascades to folders, setlists, tags and annotations', () async {
    final a = await addSong('A');
    final folder = await db.createFolder('Band', 0xFF000000);
    await db.addSongsToFolder(folder, [a, a]); // duplicate insert is ignored
    final tag = await db.createTag('Live', 0xFF00FF00);
    await db.addTagToSongs(tag, [a]);
    final list = await db.createSetlist('Gig');
    await db.addSongsToSetlist(list, [a]);
    await db.saveAnnotation(a, 0, const PageAnnotations([
      TextItem(color: 0xFF000000, text: 'x', pos: Offset.zero, size: 0.03),
    ]).encode());

    expect((await db.watchFolderCounts().first)[folder], 1);
    expect((await db.watchSongTags().first)[a]!.single.name, 'Live');
    expect(await db.songsWithAnnotations(), {a});

    await db.deleteSongs([a]);
    expect(await db.watchFolderCounts().first, isEmpty);
    expect(await db.watchSongTags().first, isEmpty);
    expect(await db.watchSetlistEntries(list).first, isEmpty);
    expect(await db.songsWithAnnotations(), isEmpty);
  });

  test('saving empty annotations deletes the row', () async {
    final a = await addSong('A');
    await db.saveAnnotation(a, 1, '{"v":1,"items":[]}');
    expect((await db.annotationsForSong(a)).keys, [1]);
    await db.saveAnnotation(a, 1, null);
    expect(await db.annotationsForSong(a), isEmpty);
  });

  test('duplicate detection by hash', () async {
    await addSong('A');
    expect(await db.songByHash('A'), isNotNull);
    expect(await db.songByHash('nope'), isNull);
  });
}
