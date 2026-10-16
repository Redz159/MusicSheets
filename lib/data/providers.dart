import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'db.dart';

/// Directories used by the app. Resolved once in main() before runApp.
class AppPaths {
  AppPaths({required this.root, required this.cache});

  final String root;
  final String cache;

  String get libraryDir => p.join(root, 'library');
  String get dbPath => p.join(root, dbFileName);
  String get thumbDir => p.join(cache, 'thumbs');
  String pdf(String fileName) => p.join(libraryDir, fileName);

  /// Cover images live next to the PDFs but are not part of backups.
  static bool isCover(String fileName) => fileName.endsWith(coverSuffix);
  static const coverSuffix = '-cover.jpg';

  static Future<AppPaths> resolve() async {
    final docs = await getApplicationDocumentsDirectory();
    final cache = await getApplicationCacheDirectory();
    final paths = AppPaths(root: p.join(docs.path, 'MusicSheets'), cache: cache.path);
    Directory(paths.libraryDir).createSync(recursive: true);
    Directory(paths.thumbDir).createSync(recursive: true);
    return paths;
  }
}

final appPathsProvider = Provider<AppPaths>((ref) => throw UnimplementedError('overridden in main'));

/// Bumped after a backup restore so the database is reopened from the new file.
final libraryEpochProvider = NotifierProvider<LibraryEpoch, int>(LibraryEpoch.new);

class LibraryEpoch extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state++;
}

final databaseProvider = Provider<AppDatabase>((ref) {
  ref.watch(libraryEpochProvider);
  final db = AppDatabase.open(ref.watch(appPathsProvider).dbPath);
  ref.onDispose(() async {
    try {
      await db.close();
    } catch (_) {
      // Already closed by a restore.
    }
  });
  return db;
});

final songsProvider = StreamProvider<List<Song>>((ref) => ref.watch(databaseProvider).watchSongs());

final songByIdProvider = Provider<Map<int, Song>>((ref) {
  final songs = ref.watch(songsProvider).value ?? const [];
  return {for (final s in songs) s.id: s};
});

final tagsProvider = StreamProvider<List<Tag>>((ref) => ref.watch(databaseProvider).watchTags());

final songTagsProvider =
    StreamProvider<Map<int, List<Tag>>>((ref) => ref.watch(databaseProvider).watchSongTags());

final foldersProvider = StreamProvider<List<Folder>>((ref) => ref.watch(databaseProvider).watchFolders());

final folderCountsProvider =
    StreamProvider<Map<int, int>>((ref) => ref.watch(databaseProvider).watchFolderCounts());

final folderProvider =
    StreamProvider.family<Folder?, int>((ref, id) => ref.watch(databaseProvider).watchFolder(id));

final folderSongsProvider =
    StreamProvider.family<List<Song>, int>((ref, id) => ref.watch(databaseProvider).watchFolderSongs(id));

final setlistsProvider = StreamProvider<List<Setlist>>((ref) => ref.watch(databaseProvider).watchSetlists());

final setlistCountsProvider =
    StreamProvider<Map<int, int>>((ref) => ref.watch(databaseProvider).watchSetlistCounts());

final setlistProvider =
    StreamProvider.family<Setlist?, int>((ref, id) => ref.watch(databaseProvider).watchSetlist(id));

final setlistEntriesProvider = StreamProvider.family<List<SetlistEntry>, int>(
    (ref, id) => ref.watch(databaseProvider).watchSetlistEntries(id));
