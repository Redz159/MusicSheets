import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../data/db.dart';
import '../data/providers.dart';

/// Full library backup: a zip with the database, all PDFs and a manifest.
class BackupService {
  BackupService(this.paths);

  final AppPaths paths;

  static const manifestName = 'musicsheets-backup.json';

  Future<File> createBackup(AppDatabase db) async {
    final tmp = await getTemporaryDirectory();
    final work = Directory(p.join(tmp.path, 'backup_work'));
    if (work.existsSync()) work.deleteSync(recursive: true);
    work.createSync(recursive: true);

    final dbCopy = p.join(work.path, dbFileName);
    await db.exportTo(dbCopy);
    final manifest = File(p.join(work.path, manifestName));
    await manifest.writeAsString(jsonEncode({'app': 'MusicSheets', 'format': 1, 'created': DateTime.now().toIso8601String()}));

    final now = DateTime.now();
    final stamp = '${now.year}-${_two(now.month)}-${_two(now.day)}';
    final zipPath = p.join(tmp.path, 'MusicSheets-Backup-$stamp.zip');
    final enc = ZipFileEncoder()..create(zipPath);
    await enc.addFile(manifest, manifestName);
    await enc.addFile(File(dbCopy), dbFileName);
    final lib = Directory(paths.libraryDir);
    for (final f in lib.listSync().whereType<File>()) {
      // PDFs are already compressed; storing them is much faster than deflating again.
      await enc.addFile(f, 'library/${p.basename(f.path)}', 0);
    }
    await enc.close();
    work.deleteSync(recursive: true);
    return File(zipPath);
  }

  static Future<String?> pickBackup() async {
    final files = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['zip']);
    if (files.isEmpty) return null;
    final f = files.first;
    if (f.path != null) return f.path;
    final tmp = await getTemporaryDirectory();
    final out = File(p.join(tmp.path, 'restore.zip'));
    await out.writeAsBytes(await f.readAsBytes());
    return out.path;
  }

  /// Extracts and validates a backup. Returns the directory with the extracted content.
  Future<Directory> extract(String zipPath) async {
    final tmp = await getTemporaryDirectory();
    final out = Directory(p.join(tmp.path, 'restore_work'));
    if (out.existsSync()) out.deleteSync(recursive: true);
    out.createSync(recursive: true);
    await extractFileToDisk(zipPath, out.path);
    if (!File(p.join(out.path, manifestName)).existsSync() || !File(p.join(out.path, dbFileName)).existsSync()) {
      out.deleteSync(recursive: true);
      throw const FormatException('This file is not a MusicSheets backup.');
    }
    return out;
  }

  /// Replaces the current library with an extracted backup. The database must be closed.
  Future<void> install(Directory extracted) async {
    final lib = Directory(paths.libraryDir);
    if (lib.existsSync()) lib.deleteSync(recursive: true);
    for (final suffix in ['', '-wal', '-shm']) {
      final f = File('${paths.dbPath}$suffix');
      if (f.existsSync()) f.deleteSync();
    }
    File(p.join(extracted.path, dbFileName)).copySync(paths.dbPath);
    final srcLib = Directory(p.join(extracted.path, 'library'));
    lib.createSync(recursive: true);
    if (srcLib.existsSync()) {
      for (final f in srcLib.listSync().whereType<File>()) {
        f.copySync(p.join(lib.path, p.basename(f.path)));
      }
    }
    extracted.deleteSync(recursive: true);
  }
}

String _two(int v) => v.toString().padLeft(2, '0');
