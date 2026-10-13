import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

part 'db.g.dart';

class Songs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get composer => text().withDefault(const Constant(''))();
  TextColumn get instrument => text().withDefault(const Constant(''))();
  TextColumn get musicalKey => text().withDefault(const Constant(''))();
  IntColumn get tempo => integer().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();

  /// File name relative to the library directory.
  TextColumn get fileName => text()();
  TextColumn get fileHash => text()();
  IntColumn get pageCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastOpenedAt => dateTime().nullable()();
  IntColumn get openCount => integer().withDefault(const Constant(0))();
  IntColumn get lastPage => integer().withDefault(const Constant(0))();
}

class Folders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get color => integer().withDefault(const Constant(0xFF5C6BC0))();
  TextColumn get sortMode => text().withDefault(const Constant('title'))();
  DateTimeColumn get createdAt => dateTime()();
}

class FolderSongs extends Table {
  IntColumn get folderId => integer().references(Folders, #id, onDelete: KeyAction.cascade)();
  IntColumn get songId => integer().references(Songs, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {folderId, songId};
}

class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  IntColumn get color => integer().withDefault(const Constant(0xFF26A69A))();
}

class SongTags extends Table {
  IntColumn get songId => integer().references(Songs, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId => integer().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {songId, tagId};
}

class Setlists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class SetlistItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get setlistId => integer().references(Setlists, #id, onDelete: KeyAction.cascade)();
  IntColumn get songId => integer().references(Songs, #id, onDelete: KeyAction.cascade)();
  RealColumn get position => real()();
}

/// One row per annotated page. [data] is the JSON of a PageAnnotations object.
class Annotations extends Table {
  IntColumn get songId => integer().references(Songs, #id, onDelete: KeyAction.cascade)();
  IntColumn get page => integer()();
  TextColumn get data => text()();

  @override
  Set<Column> get primaryKey => {songId, page};
}

/// A recording attached to a song: either the whole song, or a part marked by a
/// rectangle on one page (normalized 0..1 page coordinates).
class AudioClips extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get songId => integer().references(Songs, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();

  /// File name relative to the library directory.
  TextColumn get fileName => text()();

  /// Null when the clip is for the whole song.
  IntColumn get page => integer().nullable()();
  RealColumn get left => real().nullable()();
  RealColumn get top => real().nullable()();
  RealColumn get right => real().nullable()();
  RealColumn get bottom => real().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

class SetlistEntry {
  SetlistEntry(this.item, this.song);
  final SetlistItem item;
  final Song song;
}

@DriftDatabase(tables: [Songs, Folders, FolderSongs, Tags, SongTags, Setlists, SetlistItems, Annotations, AudioClips])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  static AppDatabase open(String dbPath) => AppDatabase(NativeDatabase.createInBackground(File(dbPath)));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) await m.createTable(audioClips);
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  // ---------------------------------------------------------------- Songs

  Stream<List<Song>> watchSongs() => select(songs).watch();

  Future<Song?> songById(int id) => (select(songs)..where((s) => s.id.equals(id))).getSingleOrNull();

  Future<List<Song>> songsByIds(List<int> ids) async {
    final rows = await (select(songs)..where((s) => s.id.isIn(ids))).get();
    final byId = {for (final s in rows) s.id: s};
    return [for (final id in ids) ?byId[id]];
  }

  Future<Song?> songByHash(String hash) =>
      (select(songs)..where((s) => s.fileHash.equals(hash))..limit(1)).getSingleOrNull();

  Future<int> insertSong(SongsCompanion song) => into(songs).insert(song);

  Future<void> updateSong(int id, SongsCompanion changes) =>
      (update(songs)..where((s) => s.id.equals(id))).write(changes);

  Future<void> markOpened(int id) => customUpdate(
        'UPDATE songs SET open_count = open_count + 1, last_opened_at = ? WHERE id = ?',
        variables: [Variable(DateTime.now()), Variable(id)],
        updates: {songs},
      );

  Future<void> saveLastPage(int id, int page) =>
      (update(songs)..where((s) => s.id.equals(id))).write(SongsCompanion(lastPage: Value(page)));

  Future<void> deleteSongs(List<int> ids) => (delete(songs)..where((s) => s.id.isIn(ids))).go();

  // ---------------------------------------------------------------- Tags

  Stream<List<Tag>> watchTags() => (select(tags)..orderBy([(t) => OrderingTerm.asc(t.name)])).watch();

  /// songId -> tags of that song.
  Stream<Map<int, List<Tag>>> watchSongTags() {
    final q = select(songTags).join([innerJoin(tags, tags.id.equalsExp(songTags.tagId))]);
    return q.watch().map((rows) {
      final map = <int, List<Tag>>{};
      for (final r in rows) {
        map.putIfAbsent(r.readTable(songTags).songId, () => []).add(r.readTable(tags));
      }
      for (final list in map.values) {
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      }
      return map;
    });
  }

  Future<int> createTag(String name, int color) async {
    final existing = await (select(tags)..where((t) => t.name.equals(name))).getSingleOrNull();
    if (existing != null) return existing.id;
    return into(tags).insert(TagsCompanion.insert(name: name, color: Value(color)));
  }

  Future<void> updateTag(int id, {String? name, int? color}) => (update(tags)..where((t) => t.id.equals(id)))
      .write(TagsCompanion(name: Value.absentIfNull(name), color: Value.absentIfNull(color)));

  Future<void> deleteTag(int id) => (delete(tags)..where((t) => t.id.equals(id))).go();

  Future<void> setSongTags(int songId, Set<int> tagIds) => transaction(() async {
        await (delete(songTags)..where((t) => t.songId.equals(songId))).go();
        await batch((b) => b.insertAll(
            songTags, [for (final t in tagIds) SongTagsCompanion.insert(songId: songId, tagId: t)]));
      });

  Future<void> addTagToSongs(int tagId, List<int> songIds) => batch((b) => b.insertAll(
      songTags, [for (final s in songIds) SongTagsCompanion.insert(songId: s, tagId: tagId)],
      mode: InsertMode.insertOrIgnore));

  // ---------------------------------------------------------------- Folders

  Stream<List<Folder>> watchFolders() =>
      (select(folders)..orderBy([(f) => OrderingTerm.asc(f.name.collate(Collate.noCase))])).watch();

  /// folderId -> number of songs.
  Stream<Map<int, int>> watchFolderCounts() {
    final count = folderSongs.songId.count();
    final q = selectOnly(folderSongs)
      ..addColumns([folderSongs.folderId, count])
      ..groupBy([folderSongs.folderId]);
    return q.watch().map((rows) => {for (final r in rows) r.read(folderSongs.folderId)!: r.read(count)!});
  }

  Stream<Folder?> watchFolder(int id) => (select(folders)..where((f) => f.id.equals(id))).watchSingleOrNull();

  Stream<List<Song>> watchFolderSongs(int folderId) {
    final q = select(songs).join([innerJoin(folderSongs, folderSongs.songId.equalsExp(songs.id))])
      ..where(folderSongs.folderId.equals(folderId));
    return q.watch().map((rows) => [for (final r in rows) r.readTable(songs)]);
  }

  Future<int> createFolder(String name, int color) =>
      into(folders).insert(FoldersCompanion.insert(name: name, color: Value(color), createdAt: DateTime.now()));

  Future<void> updateFolder(int id, {String? name, int? color, String? sortMode}) =>
      (update(folders)..where((f) => f.id.equals(id))).write(FoldersCompanion(
        name: Value.absentIfNull(name),
        color: Value.absentIfNull(color),
        sortMode: Value.absentIfNull(sortMode),
      ));

  Future<void> deleteFolder(int id) => (delete(folders)..where((f) => f.id.equals(id))).go();

  Future<void> addSongsToFolder(int folderId, List<int> songIds) => batch((b) => b.insertAll(
      folderSongs, [for (final s in songIds) FolderSongsCompanion.insert(folderId: folderId, songId: s)],
      mode: InsertMode.insertOrIgnore));

  Future<void> removeSongsFromFolder(int folderId, List<int> songIds) =>
      (delete(folderSongs)..where((f) => f.folderId.equals(folderId) & f.songId.isIn(songIds))).go();

  // ---------------------------------------------------------------- Setlists

  Stream<List<Setlist>> watchSetlists() =>
      (select(setlists)..orderBy([(s) => OrderingTerm.desc(s.updatedAt)])).watch();

  Stream<Map<int, int>> watchSetlistCounts() {
    final count = setlistItems.id.count();
    final q = selectOnly(setlistItems)
      ..addColumns([setlistItems.setlistId, count])
      ..groupBy([setlistItems.setlistId]);
    return q.watch().map((rows) => {for (final r in rows) r.read(setlistItems.setlistId)!: r.read(count)!});
  }

  Stream<Setlist?> watchSetlist(int id) => (select(setlists)..where((s) => s.id.equals(id))).watchSingleOrNull();

  Stream<List<SetlistEntry>> watchSetlistEntries(int setlistId) {
    final q = select(setlistItems).join([innerJoin(songs, songs.id.equalsExp(setlistItems.songId))])
      ..where(setlistItems.setlistId.equals(setlistId))
      ..orderBy([OrderingTerm.asc(setlistItems.position)]);
    return q.watch().map((rows) => [for (final r in rows) SetlistEntry(r.readTable(setlistItems), r.readTable(songs))]);
  }

  Future<int> createSetlist(String name) {
    final now = DateTime.now();
    return into(setlists).insert(SetlistsCompanion.insert(name: name, createdAt: now, updatedAt: now));
  }

  Future<void> renameSetlist(int id, String name) => (update(setlists)..where((s) => s.id.equals(id)))
      .write(SetlistsCompanion(name: Value(name), updatedAt: Value(DateTime.now())));

  Future<void> deleteSetlist(int id) => (delete(setlists)..where((s) => s.id.equals(id))).go();

  Future<void> _touchSetlist(int id) => (update(setlists)..where((s) => s.id.equals(id)))
      .write(SetlistsCompanion(updatedAt: Value(DateTime.now())));

  Future<void> addSongsToSetlist(int setlistId, List<int> songIds) => transaction(() async {
        final maxPos = setlistItems.position.max();
        final row = await (selectOnly(setlistItems)
              ..addColumns([maxPos])
              ..where(setlistItems.setlistId.equals(setlistId)))
            .getSingle();
        var pos = (row.read(maxPos) ?? 0) + 1;
        await batch((b) => b.insertAll(setlistItems, [
              for (final s in songIds) SetlistItemsCompanion.insert(setlistId: setlistId, songId: s, position: pos++),
            ]));
        await _touchSetlist(setlistId);
      });

  Future<void> removeSetlistItem(int itemId) => (delete(setlistItems)..where((i) => i.id.equals(itemId))).go();

  Future<void> moveSetlistItem(int setlistId, int itemId, double newPosition) => transaction(() async {
        await (update(setlistItems)..where((i) => i.id.equals(itemId)))
            .write(SetlistItemsCompanion(position: Value(newPosition)));
        await _touchSetlist(setlistId);
      });

  /// Rewrites positions as 1, 2, 3... (used when fractional positions get too close).
  Future<void> normalizeSetlist(int setlistId, List<int> orderedItemIds) => batch((b) {
        for (var i = 0; i < orderedItemIds.length; i++) {
          b.update(setlistItems, SetlistItemsCompanion(position: Value(i + 1.0)),
              where: (t) => t.id.equals(orderedItemIds[i]));
        }
      });

  // ---------------------------------------------------------------- Annotations

  Future<Map<int, String>> annotationsForSong(int songId) async {
    final rows = await (select(annotations)..where((a) => a.songId.equals(songId))).get();
    return {for (final r in rows) r.page: r.data};
  }

  Future<void> saveAnnotation(int songId, int page, String? data) async {
    if (data == null) {
      await (delete(annotations)..where((a) => a.songId.equals(songId) & a.page.equals(page))).go();
    } else {
      await into(annotations).insertOnConflictUpdate(AnnotationsCompanion.insert(songId: songId, page: page, data: data));
    }
  }

  Future<Set<int>> songsWithAnnotations() async {
    final q = selectOnly(annotations, distinct: true)..addColumns([annotations.songId]);
    return {for (final r in await q.get()) r.read(annotations.songId)!};
  }

  // ---------------------------------------------------------------- Audio clips

  /// Clips of the given songs, whole-song clips first, then by page and position.
  Stream<List<AudioClip>> watchAudioClips(List<int> songIds) => (select(audioClips)
        ..where((c) => c.songId.isIn(songIds))
        ..orderBy([
          (c) => OrderingTerm(expression: c.page, nulls: NullsOrder.first),
          (c) => OrderingTerm(expression: c.top),
          (c) => OrderingTerm(expression: c.createdAt),
        ]))
      .watch();

  Future<List<AudioClip>> audioClipsForSongs(List<int> songIds) =>
      (select(audioClips)..where((c) => c.songId.isIn(songIds))).get();

  Future<int> insertAudioClip(AudioClipsCompanion clip) => into(audioClips).insert(clip);

  Future<void> updateAudioClip(int id, AudioClipsCompanion changes) =>
      (update(audioClips)..where((c) => c.id.equals(id))).write(changes);

  Future<void> deleteAudioClip(int id) => (delete(audioClips)..where((c) => c.id.equals(id))).go();

  /// Writes a consistent copy of the database to [path] (used for backups).
  Future<void> exportTo(String path) async {
    final f = File(path);
    if (f.existsSync()) f.deleteSync();
    await customStatement('VACUUM INTO ?', [path]);
  }
}

String dbFileName = 'library.sqlite';

String libraryPdfPath(String libraryDir, String fileName) => p.join(libraryDir, fileName);
