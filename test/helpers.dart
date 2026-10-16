import 'package:music_sheets/data/db.dart';

Song song(int id, String title, {String composer = '', int pages = 1, DateTime? created, int opens = 0, DateTime? opened}) =>
    Song(
      id: id,
      title: title,
      composer: composer,
      instrument: '',
      musicalKey: '',
      notes: '',
      fileName: '$id.pdf',
      fileHash: 'h$id',
      pageCount: pages,
      createdAt: created ?? DateTime(2026, 1, id),
      lastOpenedAt: opened,
      openCount: opens,
      lastPage: 0,
      artist: '',
      genre: '',
      album: '',
      lookupStatus: 'pending',
      lookupAttempts: 0,
    );
