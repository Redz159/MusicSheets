import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_sheets/data/db.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('a v2 library upgrades to v3 with every song pending and no import title', () async {
    final dir = Directory.systemTemp.createTempSync('mig');
    addTearDown(() => dir.deleteSync(recursive: true));
    final path = '${dir.path}/old.sqlite';
    final old = sqlite3.open(path);
    old.execute('''
      CREATE TABLE songs (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, composer TEXT NOT NULL DEFAULT '',
        instrument TEXT NOT NULL DEFAULT '', musical_key TEXT NOT NULL DEFAULT '', tempo INTEGER, notes TEXT NOT NULL DEFAULT '',
        file_name TEXT NOT NULL, file_hash TEXT NOT NULL, page_count INTEGER NOT NULL DEFAULT 0, created_at INTEGER NOT NULL,
        last_opened_at INTEGER, open_count INTEGER NOT NULL DEFAULT 0, last_page INTEGER NOT NULL DEFAULT 0);
      INSERT INTO songs (title, composer, file_name, file_hash, created_at) VALUES ('My Song', 'Me', 'a.pdf', 'h', 1760000000);
      PRAGMA user_version = 2;
    ''');
    old.dispose();

    final db = AppDatabase(NativeDatabase(File(path)));
    addTearDown(db.close);
    final s = (await db.select(db.songs).get()).single;
    expect((s.title, s.composer), ('My Song', 'Me'));
    expect(s.lookupStatus, 'pending');
    expect(s.importTitle, isNull);
    expect(s.artist, '');
    expect((await db.nextDueSong(DateTime.now()))?.id, s.id);
  });
}
