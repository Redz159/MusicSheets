import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' show Value;
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';
import 'package:uuid/uuid.dart';

import '../data/db.dart';
import '../data/providers.dart';

class ImportResult {
  final imported = <int>[];
  final duplicates = <String>[];
  final failed = <String>[];
}

/// Something that can provide a file name and its bytes (a picked file, a path...).
class ImportSource {
  ImportSource(this.name, this.read);
  final String name;
  final Future<Uint8List> Function() read;

  factory ImportSource.file(File f) => ImportSource(p.basename(f.path), f.readAsBytes);
}

class ImportService {
  ImportService(this.db, this.paths);

  final AppDatabase db;
  final AppPaths paths;

  static Future<List<ImportSource>> pick() async {
    final files = await FilePicker.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    return [for (final f in files) ImportSource(f.name, f.readAsBytes)];
  }

  /// Turns "my_song-name.pdf" into "my song-name".
  static String titleFromFileName(String name) {
    var t = p.basenameWithoutExtension(name).replaceAll('_', ' ');
    t = t.replaceAll(RegExp(r'\s+'), ' ').trim();
    return t.isEmpty ? 'Untitled' : t;
  }

  Future<ImportResult> import(List<ImportSource> sources, {void Function(int done, int total)? onProgress}) async {
    final result = ImportResult();
    for (var i = 0; i < sources.length; i++) {
      onProgress?.call(i, sources.length);
      final src = sources[i];
      try {
        final bytes = await src.read();
        final hash = sha256.convert(bytes).toString();
        if (await db.songByHash(hash) != null) {
          result.duplicates.add(src.name);
          continue;
        }
        final fileName = '${const Uuid().v4()}.pdf';
        final file = File(paths.pdf(fileName));
        await file.writeAsBytes(bytes, flush: true);
        int pageCount;
        try {
          final doc = await PdfDocument.openFile(file.path);
          pageCount = doc.pages.length;
          doc.dispose();
        } catch (_) {
          await file.delete();
          result.failed.add(src.name);
          continue;
        }
        final title = titleFromFileName(src.name);
        final id = await db.insertSong(SongsCompanion.insert(
          title: title,
          importTitle: Value(title),
          fileName: fileName,
          fileHash: hash,
          pageCount: Value(pageCount),
          createdAt: DateTime.now(),
        ));
        result.imported.add(id);
      } catch (_) {
        result.failed.add(src.name);
      }
    }
    onProgress?.call(sources.length, sources.length);
    return result;
  }

  Future<void> deleteSongs(List<Song> songs) async {
    final ids = [for (final s in songs) s.id];
    final clips = await db.audioClipsForSongs(ids);
    await db.deleteSongs(ids); // clip rows go with them (cascade)
    for (final name in [
      for (final s in songs) s.fileName,
      for (final s in songs) ?s.coverFileName,
      for (final c in clips) c.fileName,
    ]) {
      final f = File(paths.pdf(name));
      if (f.existsSync()) await f.delete();
    }
  }
}
