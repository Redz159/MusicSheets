// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $SongsTable extends Songs with TableInfo<$SongsTable, Song> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _composerMeta = const VerificationMeta(
    'composer',
  );
  @override
  late final GeneratedColumn<String> composer = GeneratedColumn<String>(
    'composer',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _instrumentMeta = const VerificationMeta(
    'instrument',
  );
  @override
  late final GeneratedColumn<String> instrument = GeneratedColumn<String>(
    'instrument',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _musicalKeyMeta = const VerificationMeta(
    'musicalKey',
  );
  @override
  late final GeneratedColumn<String> musicalKey = GeneratedColumn<String>(
    'musical_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tempoMeta = const VerificationMeta('tempo');
  @override
  late final GeneratedColumn<int> tempo = GeneratedColumn<int>(
    'tempo',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileHashMeta = const VerificationMeta(
    'fileHash',
  );
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
    'file_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageCountMeta = const VerificationMeta(
    'pageCount',
  );
  @override
  late final GeneratedColumn<int> pageCount = GeneratedColumn<int>(
    'page_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastOpenedAtMeta = const VerificationMeta(
    'lastOpenedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastOpenedAt = GeneratedColumn<DateTime>(
    'last_opened_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _openCountMeta = const VerificationMeta(
    'openCount',
  );
  @override
  late final GeneratedColumn<int> openCount = GeneratedColumn<int>(
    'open_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastPageMeta = const VerificationMeta(
    'lastPage',
  );
  @override
  late final GeneratedColumn<int> lastPage = GeneratedColumn<int>(
    'last_page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _artistMeta = const VerificationMeta('artist');
  @override
  late final GeneratedColumn<String> artist = GeneratedColumn<String>(
    'artist',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genreMeta = const VerificationMeta('genre');
  @override
  late final GeneratedColumn<String> genre = GeneratedColumn<String>(
    'genre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _albumMeta = const VerificationMeta('album');
  @override
  late final GeneratedColumn<String> album = GeneratedColumn<String>(
    'album',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _coverFileNameMeta = const VerificationMeta(
    'coverFileName',
  );
  @override
  late final GeneratedColumn<String> coverFileName = GeneratedColumn<String>(
    'cover_file_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _importTitleMeta = const VerificationMeta(
    'importTitle',
  );
  @override
  late final GeneratedColumn<String> importTitle = GeneratedColumn<String>(
    'import_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mbRecordingIdMeta = const VerificationMeta(
    'mbRecordingId',
  );
  @override
  late final GeneratedColumn<String> mbRecordingId = GeneratedColumn<String>(
    'mb_recording_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mbWorkIdMeta = const VerificationMeta(
    'mbWorkId',
  );
  @override
  late final GeneratedColumn<String> mbWorkId = GeneratedColumn<String>(
    'mb_work_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mbReleaseGroupIdMeta = const VerificationMeta(
    'mbReleaseGroupId',
  );
  @override
  late final GeneratedColumn<String> mbReleaseGroupId = GeneratedColumn<String>(
    'mb_release_group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lookupStatusMeta = const VerificationMeta(
    'lookupStatus',
  );
  @override
  late final GeneratedColumn<String> lookupStatus = GeneratedColumn<String>(
    'lookup_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _lookupAttemptsMeta = const VerificationMeta(
    'lookupAttempts',
  );
  @override
  late final GeneratedColumn<int> lookupAttempts = GeneratedColumn<int>(
    'lookup_attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextAttemptAtMeta = const VerificationMeta(
    'nextAttemptAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextAttemptAt =
      GeneratedColumn<DateTime>(
        'next_attempt_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lookupCandidatesMeta = const VerificationMeta(
    'lookupCandidates',
  );
  @override
  late final GeneratedColumn<String> lookupCandidates = GeneratedColumn<String>(
    'lookup_candidates',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    composer,
    instrument,
    musicalKey,
    tempo,
    notes,
    fileName,
    fileHash,
    pageCount,
    createdAt,
    lastOpenedAt,
    openCount,
    lastPage,
    artist,
    year,
    genre,
    album,
    coverFileName,
    importTitle,
    mbRecordingId,
    mbWorkId,
    mbReleaseGroupId,
    lookupStatus,
    lookupAttempts,
    nextAttemptAt,
    lookupCandidates,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'songs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Song> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('composer')) {
      context.handle(
        _composerMeta,
        composer.isAcceptableOrUnknown(data['composer']!, _composerMeta),
      );
    }
    if (data.containsKey('instrument')) {
      context.handle(
        _instrumentMeta,
        instrument.isAcceptableOrUnknown(data['instrument']!, _instrumentMeta),
      );
    }
    if (data.containsKey('musical_key')) {
      context.handle(
        _musicalKeyMeta,
        musicalKey.isAcceptableOrUnknown(data['musical_key']!, _musicalKeyMeta),
      );
    }
    if (data.containsKey('tempo')) {
      context.handle(
        _tempoMeta,
        tempo.isAcceptableOrUnknown(data['tempo']!, _tempoMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_hash')) {
      context.handle(
        _fileHashMeta,
        fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta),
      );
    } else if (isInserting) {
      context.missing(_fileHashMeta);
    }
    if (data.containsKey('page_count')) {
      context.handle(
        _pageCountMeta,
        pageCount.isAcceptableOrUnknown(data['page_count']!, _pageCountMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_opened_at')) {
      context.handle(
        _lastOpenedAtMeta,
        lastOpenedAt.isAcceptableOrUnknown(
          data['last_opened_at']!,
          _lastOpenedAtMeta,
        ),
      );
    }
    if (data.containsKey('open_count')) {
      context.handle(
        _openCountMeta,
        openCount.isAcceptableOrUnknown(data['open_count']!, _openCountMeta),
      );
    }
    if (data.containsKey('last_page')) {
      context.handle(
        _lastPageMeta,
        lastPage.isAcceptableOrUnknown(data['last_page']!, _lastPageMeta),
      );
    }
    if (data.containsKey('artist')) {
      context.handle(
        _artistMeta,
        artist.isAcceptableOrUnknown(data['artist']!, _artistMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('genre')) {
      context.handle(
        _genreMeta,
        genre.isAcceptableOrUnknown(data['genre']!, _genreMeta),
      );
    }
    if (data.containsKey('album')) {
      context.handle(
        _albumMeta,
        album.isAcceptableOrUnknown(data['album']!, _albumMeta),
      );
    }
    if (data.containsKey('cover_file_name')) {
      context.handle(
        _coverFileNameMeta,
        coverFileName.isAcceptableOrUnknown(
          data['cover_file_name']!,
          _coverFileNameMeta,
        ),
      );
    }
    if (data.containsKey('import_title')) {
      context.handle(
        _importTitleMeta,
        importTitle.isAcceptableOrUnknown(
          data['import_title']!,
          _importTitleMeta,
        ),
      );
    }
    if (data.containsKey('mb_recording_id')) {
      context.handle(
        _mbRecordingIdMeta,
        mbRecordingId.isAcceptableOrUnknown(
          data['mb_recording_id']!,
          _mbRecordingIdMeta,
        ),
      );
    }
    if (data.containsKey('mb_work_id')) {
      context.handle(
        _mbWorkIdMeta,
        mbWorkId.isAcceptableOrUnknown(data['mb_work_id']!, _mbWorkIdMeta),
      );
    }
    if (data.containsKey('mb_release_group_id')) {
      context.handle(
        _mbReleaseGroupIdMeta,
        mbReleaseGroupId.isAcceptableOrUnknown(
          data['mb_release_group_id']!,
          _mbReleaseGroupIdMeta,
        ),
      );
    }
    if (data.containsKey('lookup_status')) {
      context.handle(
        _lookupStatusMeta,
        lookupStatus.isAcceptableOrUnknown(
          data['lookup_status']!,
          _lookupStatusMeta,
        ),
      );
    }
    if (data.containsKey('lookup_attempts')) {
      context.handle(
        _lookupAttemptsMeta,
        lookupAttempts.isAcceptableOrUnknown(
          data['lookup_attempts']!,
          _lookupAttemptsMeta,
        ),
      );
    }
    if (data.containsKey('next_attempt_at')) {
      context.handle(
        _nextAttemptAtMeta,
        nextAttemptAt.isAcceptableOrUnknown(
          data['next_attempt_at']!,
          _nextAttemptAtMeta,
        ),
      );
    }
    if (data.containsKey('lookup_candidates')) {
      context.handle(
        _lookupCandidatesMeta,
        lookupCandidates.isAcceptableOrUnknown(
          data['lookup_candidates']!,
          _lookupCandidatesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Song map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Song(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      composer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}composer'],
      )!,
      instrument: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instrument'],
      )!,
      musicalKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}musical_key'],
      )!,
      tempo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tempo'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      fileHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_hash'],
      )!,
      pageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_count'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastOpenedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_opened_at'],
      ),
      openCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}open_count'],
      )!,
      lastPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_page'],
      )!,
      artist: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}artist'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      genre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}genre'],
      )!,
      album: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}album'],
      )!,
      coverFileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_file_name'],
      ),
      importTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}import_title'],
      ),
      mbRecordingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mb_recording_id'],
      ),
      mbWorkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mb_work_id'],
      ),
      mbReleaseGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mb_release_group_id'],
      ),
      lookupStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lookup_status'],
      )!,
      lookupAttempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lookup_attempts'],
      )!,
      nextAttemptAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_attempt_at'],
      ),
      lookupCandidates: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lookup_candidates'],
      ),
    );
  }

  @override
  $SongsTable createAlias(String alias) {
    return $SongsTable(attachedDatabase, alias);
  }
}

class Song extends DataClass implements Insertable<Song> {
  final int id;
  final String title;
  final String composer;
  final String instrument;
  final String musicalKey;
  final int? tempo;
  final String notes;

  /// File name relative to the library directory.
  final String fileName;
  final String fileHash;
  final int pageCount;
  final DateTime createdAt;
  final DateTime? lastOpenedAt;
  final int openCount;
  final int lastPage;
  final String artist;
  final int? year;
  final String genre;
  final String album;

  /// Cover image file name relative to the library directory. Not part of backups.
  final String? coverFileName;

  /// The title as generated at import. Null for songs imported before lookups existed;
  /// those are never renamed by a lookup.
  final String? importTitle;
  final String? mbRecordingId;
  final String? mbWorkId;
  final String? mbReleaseGroupId;

  /// One of [LookupStatus.name].
  final String lookupStatus;
  final int lookupAttempts;
  final DateTime? nextAttemptAt;

  /// JSON list of candidates while the status is needsReview.
  final String? lookupCandidates;
  const Song({
    required this.id,
    required this.title,
    required this.composer,
    required this.instrument,
    required this.musicalKey,
    this.tempo,
    required this.notes,
    required this.fileName,
    required this.fileHash,
    required this.pageCount,
    required this.createdAt,
    this.lastOpenedAt,
    required this.openCount,
    required this.lastPage,
    required this.artist,
    this.year,
    required this.genre,
    required this.album,
    this.coverFileName,
    this.importTitle,
    this.mbRecordingId,
    this.mbWorkId,
    this.mbReleaseGroupId,
    required this.lookupStatus,
    required this.lookupAttempts,
    this.nextAttemptAt,
    this.lookupCandidates,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['composer'] = Variable<String>(composer);
    map['instrument'] = Variable<String>(instrument);
    map['musical_key'] = Variable<String>(musicalKey);
    if (!nullToAbsent || tempo != null) {
      map['tempo'] = Variable<int>(tempo);
    }
    map['notes'] = Variable<String>(notes);
    map['file_name'] = Variable<String>(fileName);
    map['file_hash'] = Variable<String>(fileHash);
    map['page_count'] = Variable<int>(pageCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastOpenedAt != null) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt);
    }
    map['open_count'] = Variable<int>(openCount);
    map['last_page'] = Variable<int>(lastPage);
    map['artist'] = Variable<String>(artist);
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    map['genre'] = Variable<String>(genre);
    map['album'] = Variable<String>(album);
    if (!nullToAbsent || coverFileName != null) {
      map['cover_file_name'] = Variable<String>(coverFileName);
    }
    if (!nullToAbsent || importTitle != null) {
      map['import_title'] = Variable<String>(importTitle);
    }
    if (!nullToAbsent || mbRecordingId != null) {
      map['mb_recording_id'] = Variable<String>(mbRecordingId);
    }
    if (!nullToAbsent || mbWorkId != null) {
      map['mb_work_id'] = Variable<String>(mbWorkId);
    }
    if (!nullToAbsent || mbReleaseGroupId != null) {
      map['mb_release_group_id'] = Variable<String>(mbReleaseGroupId);
    }
    map['lookup_status'] = Variable<String>(lookupStatus);
    map['lookup_attempts'] = Variable<int>(lookupAttempts);
    if (!nullToAbsent || nextAttemptAt != null) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt);
    }
    if (!nullToAbsent || lookupCandidates != null) {
      map['lookup_candidates'] = Variable<String>(lookupCandidates);
    }
    return map;
  }

  SongsCompanion toCompanion(bool nullToAbsent) {
    return SongsCompanion(
      id: Value(id),
      title: Value(title),
      composer: Value(composer),
      instrument: Value(instrument),
      musicalKey: Value(musicalKey),
      tempo: tempo == null && nullToAbsent
          ? const Value.absent()
          : Value(tempo),
      notes: Value(notes),
      fileName: Value(fileName),
      fileHash: Value(fileHash),
      pageCount: Value(pageCount),
      createdAt: Value(createdAt),
      lastOpenedAt: lastOpenedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastOpenedAt),
      openCount: Value(openCount),
      lastPage: Value(lastPage),
      artist: Value(artist),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      genre: Value(genre),
      album: Value(album),
      coverFileName: coverFileName == null && nullToAbsent
          ? const Value.absent()
          : Value(coverFileName),
      importTitle: importTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(importTitle),
      mbRecordingId: mbRecordingId == null && nullToAbsent
          ? const Value.absent()
          : Value(mbRecordingId),
      mbWorkId: mbWorkId == null && nullToAbsent
          ? const Value.absent()
          : Value(mbWorkId),
      mbReleaseGroupId: mbReleaseGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(mbReleaseGroupId),
      lookupStatus: Value(lookupStatus),
      lookupAttempts: Value(lookupAttempts),
      nextAttemptAt: nextAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextAttemptAt),
      lookupCandidates: lookupCandidates == null && nullToAbsent
          ? const Value.absent()
          : Value(lookupCandidates),
    );
  }

  factory Song.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Song(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      composer: serializer.fromJson<String>(json['composer']),
      instrument: serializer.fromJson<String>(json['instrument']),
      musicalKey: serializer.fromJson<String>(json['musicalKey']),
      tempo: serializer.fromJson<int?>(json['tempo']),
      notes: serializer.fromJson<String>(json['notes']),
      fileName: serializer.fromJson<String>(json['fileName']),
      fileHash: serializer.fromJson<String>(json['fileHash']),
      pageCount: serializer.fromJson<int>(json['pageCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastOpenedAt: serializer.fromJson<DateTime?>(json['lastOpenedAt']),
      openCount: serializer.fromJson<int>(json['openCount']),
      lastPage: serializer.fromJson<int>(json['lastPage']),
      artist: serializer.fromJson<String>(json['artist']),
      year: serializer.fromJson<int?>(json['year']),
      genre: serializer.fromJson<String>(json['genre']),
      album: serializer.fromJson<String>(json['album']),
      coverFileName: serializer.fromJson<String?>(json['coverFileName']),
      importTitle: serializer.fromJson<String?>(json['importTitle']),
      mbRecordingId: serializer.fromJson<String?>(json['mbRecordingId']),
      mbWorkId: serializer.fromJson<String?>(json['mbWorkId']),
      mbReleaseGroupId: serializer.fromJson<String?>(json['mbReleaseGroupId']),
      lookupStatus: serializer.fromJson<String>(json['lookupStatus']),
      lookupAttempts: serializer.fromJson<int>(json['lookupAttempts']),
      nextAttemptAt: serializer.fromJson<DateTime?>(json['nextAttemptAt']),
      lookupCandidates: serializer.fromJson<String?>(json['lookupCandidates']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'composer': serializer.toJson<String>(composer),
      'instrument': serializer.toJson<String>(instrument),
      'musicalKey': serializer.toJson<String>(musicalKey),
      'tempo': serializer.toJson<int?>(tempo),
      'notes': serializer.toJson<String>(notes),
      'fileName': serializer.toJson<String>(fileName),
      'fileHash': serializer.toJson<String>(fileHash),
      'pageCount': serializer.toJson<int>(pageCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastOpenedAt': serializer.toJson<DateTime?>(lastOpenedAt),
      'openCount': serializer.toJson<int>(openCount),
      'lastPage': serializer.toJson<int>(lastPage),
      'artist': serializer.toJson<String>(artist),
      'year': serializer.toJson<int?>(year),
      'genre': serializer.toJson<String>(genre),
      'album': serializer.toJson<String>(album),
      'coverFileName': serializer.toJson<String?>(coverFileName),
      'importTitle': serializer.toJson<String?>(importTitle),
      'mbRecordingId': serializer.toJson<String?>(mbRecordingId),
      'mbWorkId': serializer.toJson<String?>(mbWorkId),
      'mbReleaseGroupId': serializer.toJson<String?>(mbReleaseGroupId),
      'lookupStatus': serializer.toJson<String>(lookupStatus),
      'lookupAttempts': serializer.toJson<int>(lookupAttempts),
      'nextAttemptAt': serializer.toJson<DateTime?>(nextAttemptAt),
      'lookupCandidates': serializer.toJson<String?>(lookupCandidates),
    };
  }

  Song copyWith({
    int? id,
    String? title,
    String? composer,
    String? instrument,
    String? musicalKey,
    Value<int?> tempo = const Value.absent(),
    String? notes,
    String? fileName,
    String? fileHash,
    int? pageCount,
    DateTime? createdAt,
    Value<DateTime?> lastOpenedAt = const Value.absent(),
    int? openCount,
    int? lastPage,
    String? artist,
    Value<int?> year = const Value.absent(),
    String? genre,
    String? album,
    Value<String?> coverFileName = const Value.absent(),
    Value<String?> importTitle = const Value.absent(),
    Value<String?> mbRecordingId = const Value.absent(),
    Value<String?> mbWorkId = const Value.absent(),
    Value<String?> mbReleaseGroupId = const Value.absent(),
    String? lookupStatus,
    int? lookupAttempts,
    Value<DateTime?> nextAttemptAt = const Value.absent(),
    Value<String?> lookupCandidates = const Value.absent(),
  }) => Song(
    id: id ?? this.id,
    title: title ?? this.title,
    composer: composer ?? this.composer,
    instrument: instrument ?? this.instrument,
    musicalKey: musicalKey ?? this.musicalKey,
    tempo: tempo.present ? tempo.value : this.tempo,
    notes: notes ?? this.notes,
    fileName: fileName ?? this.fileName,
    fileHash: fileHash ?? this.fileHash,
    pageCount: pageCount ?? this.pageCount,
    createdAt: createdAt ?? this.createdAt,
    lastOpenedAt: lastOpenedAt.present ? lastOpenedAt.value : this.lastOpenedAt,
    openCount: openCount ?? this.openCount,
    lastPage: lastPage ?? this.lastPage,
    artist: artist ?? this.artist,
    year: year.present ? year.value : this.year,
    genre: genre ?? this.genre,
    album: album ?? this.album,
    coverFileName: coverFileName.present
        ? coverFileName.value
        : this.coverFileName,
    importTitle: importTitle.present ? importTitle.value : this.importTitle,
    mbRecordingId: mbRecordingId.present
        ? mbRecordingId.value
        : this.mbRecordingId,
    mbWorkId: mbWorkId.present ? mbWorkId.value : this.mbWorkId,
    mbReleaseGroupId: mbReleaseGroupId.present
        ? mbReleaseGroupId.value
        : this.mbReleaseGroupId,
    lookupStatus: lookupStatus ?? this.lookupStatus,
    lookupAttempts: lookupAttempts ?? this.lookupAttempts,
    nextAttemptAt: nextAttemptAt.present
        ? nextAttemptAt.value
        : this.nextAttemptAt,
    lookupCandidates: lookupCandidates.present
        ? lookupCandidates.value
        : this.lookupCandidates,
  );
  Song copyWithCompanion(SongsCompanion data) {
    return Song(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      composer: data.composer.present ? data.composer.value : this.composer,
      instrument: data.instrument.present
          ? data.instrument.value
          : this.instrument,
      musicalKey: data.musicalKey.present
          ? data.musicalKey.value
          : this.musicalKey,
      tempo: data.tempo.present ? data.tempo.value : this.tempo,
      notes: data.notes.present ? data.notes.value : this.notes,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      pageCount: data.pageCount.present ? data.pageCount.value : this.pageCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastOpenedAt: data.lastOpenedAt.present
          ? data.lastOpenedAt.value
          : this.lastOpenedAt,
      openCount: data.openCount.present ? data.openCount.value : this.openCount,
      lastPage: data.lastPage.present ? data.lastPage.value : this.lastPage,
      artist: data.artist.present ? data.artist.value : this.artist,
      year: data.year.present ? data.year.value : this.year,
      genre: data.genre.present ? data.genre.value : this.genre,
      album: data.album.present ? data.album.value : this.album,
      coverFileName: data.coverFileName.present
          ? data.coverFileName.value
          : this.coverFileName,
      importTitle: data.importTitle.present
          ? data.importTitle.value
          : this.importTitle,
      mbRecordingId: data.mbRecordingId.present
          ? data.mbRecordingId.value
          : this.mbRecordingId,
      mbWorkId: data.mbWorkId.present ? data.mbWorkId.value : this.mbWorkId,
      mbReleaseGroupId: data.mbReleaseGroupId.present
          ? data.mbReleaseGroupId.value
          : this.mbReleaseGroupId,
      lookupStatus: data.lookupStatus.present
          ? data.lookupStatus.value
          : this.lookupStatus,
      lookupAttempts: data.lookupAttempts.present
          ? data.lookupAttempts.value
          : this.lookupAttempts,
      nextAttemptAt: data.nextAttemptAt.present
          ? data.nextAttemptAt.value
          : this.nextAttemptAt,
      lookupCandidates: data.lookupCandidates.present
          ? data.lookupCandidates.value
          : this.lookupCandidates,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Song(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('composer: $composer, ')
          ..write('instrument: $instrument, ')
          ..write('musicalKey: $musicalKey, ')
          ..write('tempo: $tempo, ')
          ..write('notes: $notes, ')
          ..write('fileName: $fileName, ')
          ..write('fileHash: $fileHash, ')
          ..write('pageCount: $pageCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastOpenedAt: $lastOpenedAt, ')
          ..write('openCount: $openCount, ')
          ..write('lastPage: $lastPage, ')
          ..write('artist: $artist, ')
          ..write('year: $year, ')
          ..write('genre: $genre, ')
          ..write('album: $album, ')
          ..write('coverFileName: $coverFileName, ')
          ..write('importTitle: $importTitle, ')
          ..write('mbRecordingId: $mbRecordingId, ')
          ..write('mbWorkId: $mbWorkId, ')
          ..write('mbReleaseGroupId: $mbReleaseGroupId, ')
          ..write('lookupStatus: $lookupStatus, ')
          ..write('lookupAttempts: $lookupAttempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lookupCandidates: $lookupCandidates')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    title,
    composer,
    instrument,
    musicalKey,
    tempo,
    notes,
    fileName,
    fileHash,
    pageCount,
    createdAt,
    lastOpenedAt,
    openCount,
    lastPage,
    artist,
    year,
    genre,
    album,
    coverFileName,
    importTitle,
    mbRecordingId,
    mbWorkId,
    mbReleaseGroupId,
    lookupStatus,
    lookupAttempts,
    nextAttemptAt,
    lookupCandidates,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Song &&
          other.id == this.id &&
          other.title == this.title &&
          other.composer == this.composer &&
          other.instrument == this.instrument &&
          other.musicalKey == this.musicalKey &&
          other.tempo == this.tempo &&
          other.notes == this.notes &&
          other.fileName == this.fileName &&
          other.fileHash == this.fileHash &&
          other.pageCount == this.pageCount &&
          other.createdAt == this.createdAt &&
          other.lastOpenedAt == this.lastOpenedAt &&
          other.openCount == this.openCount &&
          other.lastPage == this.lastPage &&
          other.artist == this.artist &&
          other.year == this.year &&
          other.genre == this.genre &&
          other.album == this.album &&
          other.coverFileName == this.coverFileName &&
          other.importTitle == this.importTitle &&
          other.mbRecordingId == this.mbRecordingId &&
          other.mbWorkId == this.mbWorkId &&
          other.mbReleaseGroupId == this.mbReleaseGroupId &&
          other.lookupStatus == this.lookupStatus &&
          other.lookupAttempts == this.lookupAttempts &&
          other.nextAttemptAt == this.nextAttemptAt &&
          other.lookupCandidates == this.lookupCandidates);
}

class SongsCompanion extends UpdateCompanion<Song> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> composer;
  final Value<String> instrument;
  final Value<String> musicalKey;
  final Value<int?> tempo;
  final Value<String> notes;
  final Value<String> fileName;
  final Value<String> fileHash;
  final Value<int> pageCount;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastOpenedAt;
  final Value<int> openCount;
  final Value<int> lastPage;
  final Value<String> artist;
  final Value<int?> year;
  final Value<String> genre;
  final Value<String> album;
  final Value<String?> coverFileName;
  final Value<String?> importTitle;
  final Value<String?> mbRecordingId;
  final Value<String?> mbWorkId;
  final Value<String?> mbReleaseGroupId;
  final Value<String> lookupStatus;
  final Value<int> lookupAttempts;
  final Value<DateTime?> nextAttemptAt;
  final Value<String?> lookupCandidates;
  const SongsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.composer = const Value.absent(),
    this.instrument = const Value.absent(),
    this.musicalKey = const Value.absent(),
    this.tempo = const Value.absent(),
    this.notes = const Value.absent(),
    this.fileName = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
    this.openCount = const Value.absent(),
    this.lastPage = const Value.absent(),
    this.artist = const Value.absent(),
    this.year = const Value.absent(),
    this.genre = const Value.absent(),
    this.album = const Value.absent(),
    this.coverFileName = const Value.absent(),
    this.importTitle = const Value.absent(),
    this.mbRecordingId = const Value.absent(),
    this.mbWorkId = const Value.absent(),
    this.mbReleaseGroupId = const Value.absent(),
    this.lookupStatus = const Value.absent(),
    this.lookupAttempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lookupCandidates = const Value.absent(),
  });
  SongsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.composer = const Value.absent(),
    this.instrument = const Value.absent(),
    this.musicalKey = const Value.absent(),
    this.tempo = const Value.absent(),
    this.notes = const Value.absent(),
    required String fileName,
    required String fileHash,
    this.pageCount = const Value.absent(),
    required DateTime createdAt,
    this.lastOpenedAt = const Value.absent(),
    this.openCount = const Value.absent(),
    this.lastPage = const Value.absent(),
    this.artist = const Value.absent(),
    this.year = const Value.absent(),
    this.genre = const Value.absent(),
    this.album = const Value.absent(),
    this.coverFileName = const Value.absent(),
    this.importTitle = const Value.absent(),
    this.mbRecordingId = const Value.absent(),
    this.mbWorkId = const Value.absent(),
    this.mbReleaseGroupId = const Value.absent(),
    this.lookupStatus = const Value.absent(),
    this.lookupAttempts = const Value.absent(),
    this.nextAttemptAt = const Value.absent(),
    this.lookupCandidates = const Value.absent(),
  }) : title = Value(title),
       fileName = Value(fileName),
       fileHash = Value(fileHash),
       createdAt = Value(createdAt);
  static Insertable<Song> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? composer,
    Expression<String>? instrument,
    Expression<String>? musicalKey,
    Expression<int>? tempo,
    Expression<String>? notes,
    Expression<String>? fileName,
    Expression<String>? fileHash,
    Expression<int>? pageCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastOpenedAt,
    Expression<int>? openCount,
    Expression<int>? lastPage,
    Expression<String>? artist,
    Expression<int>? year,
    Expression<String>? genre,
    Expression<String>? album,
    Expression<String>? coverFileName,
    Expression<String>? importTitle,
    Expression<String>? mbRecordingId,
    Expression<String>? mbWorkId,
    Expression<String>? mbReleaseGroupId,
    Expression<String>? lookupStatus,
    Expression<int>? lookupAttempts,
    Expression<DateTime>? nextAttemptAt,
    Expression<String>? lookupCandidates,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (composer != null) 'composer': composer,
      if (instrument != null) 'instrument': instrument,
      if (musicalKey != null) 'musical_key': musicalKey,
      if (tempo != null) 'tempo': tempo,
      if (notes != null) 'notes': notes,
      if (fileName != null) 'file_name': fileName,
      if (fileHash != null) 'file_hash': fileHash,
      if (pageCount != null) 'page_count': pageCount,
      if (createdAt != null) 'created_at': createdAt,
      if (lastOpenedAt != null) 'last_opened_at': lastOpenedAt,
      if (openCount != null) 'open_count': openCount,
      if (lastPage != null) 'last_page': lastPage,
      if (artist != null) 'artist': artist,
      if (year != null) 'year': year,
      if (genre != null) 'genre': genre,
      if (album != null) 'album': album,
      if (coverFileName != null) 'cover_file_name': coverFileName,
      if (importTitle != null) 'import_title': importTitle,
      if (mbRecordingId != null) 'mb_recording_id': mbRecordingId,
      if (mbWorkId != null) 'mb_work_id': mbWorkId,
      if (mbReleaseGroupId != null) 'mb_release_group_id': mbReleaseGroupId,
      if (lookupStatus != null) 'lookup_status': lookupStatus,
      if (lookupAttempts != null) 'lookup_attempts': lookupAttempts,
      if (nextAttemptAt != null) 'next_attempt_at': nextAttemptAt,
      if (lookupCandidates != null) 'lookup_candidates': lookupCandidates,
    });
  }

  SongsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? composer,
    Value<String>? instrument,
    Value<String>? musicalKey,
    Value<int?>? tempo,
    Value<String>? notes,
    Value<String>? fileName,
    Value<String>? fileHash,
    Value<int>? pageCount,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastOpenedAt,
    Value<int>? openCount,
    Value<int>? lastPage,
    Value<String>? artist,
    Value<int?>? year,
    Value<String>? genre,
    Value<String>? album,
    Value<String?>? coverFileName,
    Value<String?>? importTitle,
    Value<String?>? mbRecordingId,
    Value<String?>? mbWorkId,
    Value<String?>? mbReleaseGroupId,
    Value<String>? lookupStatus,
    Value<int>? lookupAttempts,
    Value<DateTime?>? nextAttemptAt,
    Value<String?>? lookupCandidates,
  }) {
    return SongsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      composer: composer ?? this.composer,
      instrument: instrument ?? this.instrument,
      musicalKey: musicalKey ?? this.musicalKey,
      tempo: tempo ?? this.tempo,
      notes: notes ?? this.notes,
      fileName: fileName ?? this.fileName,
      fileHash: fileHash ?? this.fileHash,
      pageCount: pageCount ?? this.pageCount,
      createdAt: createdAt ?? this.createdAt,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
      openCount: openCount ?? this.openCount,
      lastPage: lastPage ?? this.lastPage,
      artist: artist ?? this.artist,
      year: year ?? this.year,
      genre: genre ?? this.genre,
      album: album ?? this.album,
      coverFileName: coverFileName ?? this.coverFileName,
      importTitle: importTitle ?? this.importTitle,
      mbRecordingId: mbRecordingId ?? this.mbRecordingId,
      mbWorkId: mbWorkId ?? this.mbWorkId,
      mbReleaseGroupId: mbReleaseGroupId ?? this.mbReleaseGroupId,
      lookupStatus: lookupStatus ?? this.lookupStatus,
      lookupAttempts: lookupAttempts ?? this.lookupAttempts,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      lookupCandidates: lookupCandidates ?? this.lookupCandidates,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (composer.present) {
      map['composer'] = Variable<String>(composer.value);
    }
    if (instrument.present) {
      map['instrument'] = Variable<String>(instrument.value);
    }
    if (musicalKey.present) {
      map['musical_key'] = Variable<String>(musicalKey.value);
    }
    if (tempo.present) {
      map['tempo'] = Variable<int>(tempo.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (pageCount.present) {
      map['page_count'] = Variable<int>(pageCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastOpenedAt.present) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt.value);
    }
    if (openCount.present) {
      map['open_count'] = Variable<int>(openCount.value);
    }
    if (lastPage.present) {
      map['last_page'] = Variable<int>(lastPage.value);
    }
    if (artist.present) {
      map['artist'] = Variable<String>(artist.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (genre.present) {
      map['genre'] = Variable<String>(genre.value);
    }
    if (album.present) {
      map['album'] = Variable<String>(album.value);
    }
    if (coverFileName.present) {
      map['cover_file_name'] = Variable<String>(coverFileName.value);
    }
    if (importTitle.present) {
      map['import_title'] = Variable<String>(importTitle.value);
    }
    if (mbRecordingId.present) {
      map['mb_recording_id'] = Variable<String>(mbRecordingId.value);
    }
    if (mbWorkId.present) {
      map['mb_work_id'] = Variable<String>(mbWorkId.value);
    }
    if (mbReleaseGroupId.present) {
      map['mb_release_group_id'] = Variable<String>(mbReleaseGroupId.value);
    }
    if (lookupStatus.present) {
      map['lookup_status'] = Variable<String>(lookupStatus.value);
    }
    if (lookupAttempts.present) {
      map['lookup_attempts'] = Variable<int>(lookupAttempts.value);
    }
    if (nextAttemptAt.present) {
      map['next_attempt_at'] = Variable<DateTime>(nextAttemptAt.value);
    }
    if (lookupCandidates.present) {
      map['lookup_candidates'] = Variable<String>(lookupCandidates.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('composer: $composer, ')
          ..write('instrument: $instrument, ')
          ..write('musicalKey: $musicalKey, ')
          ..write('tempo: $tempo, ')
          ..write('notes: $notes, ')
          ..write('fileName: $fileName, ')
          ..write('fileHash: $fileHash, ')
          ..write('pageCount: $pageCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastOpenedAt: $lastOpenedAt, ')
          ..write('openCount: $openCount, ')
          ..write('lastPage: $lastPage, ')
          ..write('artist: $artist, ')
          ..write('year: $year, ')
          ..write('genre: $genre, ')
          ..write('album: $album, ')
          ..write('coverFileName: $coverFileName, ')
          ..write('importTitle: $importTitle, ')
          ..write('mbRecordingId: $mbRecordingId, ')
          ..write('mbWorkId: $mbWorkId, ')
          ..write('mbReleaseGroupId: $mbReleaseGroupId, ')
          ..write('lookupStatus: $lookupStatus, ')
          ..write('lookupAttempts: $lookupAttempts, ')
          ..write('nextAttemptAt: $nextAttemptAt, ')
          ..write('lookupCandidates: $lookupCandidates')
          ..write(')'))
        .toString();
  }
}

class $FoldersTable extends Folders with TableInfo<$FoldersTable, Folder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoldersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF5C6BC0),
  );
  static const VerificationMeta _sortModeMeta = const VerificationMeta(
    'sortMode',
  );
  @override
  late final GeneratedColumn<String> sortMode = GeneratedColumn<String>(
    'sort_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('title'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, color, sortMode, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'folders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Folder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('sort_mode')) {
      context.handle(
        _sortModeMeta,
        sortMode.isAcceptableOrUnknown(data['sort_mode']!, _sortModeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Folder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Folder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      sortMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_mode'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FoldersTable createAlias(String alias) {
    return $FoldersTable(attachedDatabase, alias);
  }
}

class Folder extends DataClass implements Insertable<Folder> {
  final int id;
  final String name;
  final int color;
  final String sortMode;
  final DateTime createdAt;
  const Folder({
    required this.id,
    required this.name,
    required this.color,
    required this.sortMode,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    map['sort_mode'] = Variable<String>(sortMode);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      sortMode: Value(sortMode),
      createdAt: Value(createdAt),
    );
  }

  factory Folder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Folder(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      sortMode: serializer.fromJson<String>(json['sortMode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'sortMode': serializer.toJson<String>(sortMode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Folder copyWith({
    int? id,
    String? name,
    int? color,
    String? sortMode,
    DateTime? createdAt,
  }) => Folder(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color ?? this.color,
    sortMode: sortMode ?? this.sortMode,
    createdAt: createdAt ?? this.createdAt,
  );
  Folder copyWithCompanion(FoldersCompanion data) {
    return Folder(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      sortMode: data.sortMode.present ? data.sortMode.value : this.sortMode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Folder(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('sortMode: $sortMode, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color, sortMode, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Folder &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.sortMode == this.sortMode &&
          other.createdAt == this.createdAt);
}

class FoldersCompanion extends UpdateCompanion<Folder> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> color;
  final Value<String> sortMode;
  final Value<DateTime> createdAt;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.sortMode = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FoldersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    this.sortMode = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Folder> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? color,
    Expression<String>? sortMode,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (sortMode != null) 'sort_mode': sortMode,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FoldersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? color,
    Value<String>? sortMode,
    Value<DateTime>? createdAt,
  }) {
    return FoldersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      sortMode: sortMode ?? this.sortMode,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (sortMode.present) {
      map['sort_mode'] = Variable<String>(sortMode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('sortMode: $sortMode, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FolderSongsTable extends FolderSongs
    with TableInfo<$FolderSongsTable, FolderSong> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FolderSongsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _folderIdMeta = const VerificationMeta(
    'folderId',
  );
  @override
  late final GeneratedColumn<int> folderId = GeneratedColumn<int>(
    'folder_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES folders (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<int> songId = GeneratedColumn<int>(
    'song_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES songs (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [folderId, songId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'folder_songs';
  @override
  VerificationContext validateIntegrity(
    Insertable<FolderSong> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_folderIdMeta);
    }
    if (data.containsKey('song_id')) {
      context.handle(
        _songIdMeta,
        songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta),
      );
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {folderId, songId};
  @override
  FolderSong map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FolderSong(
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}folder_id'],
      )!,
      songId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}song_id'],
      )!,
    );
  }

  @override
  $FolderSongsTable createAlias(String alias) {
    return $FolderSongsTable(attachedDatabase, alias);
  }
}

class FolderSong extends DataClass implements Insertable<FolderSong> {
  final int folderId;
  final int songId;
  const FolderSong({required this.folderId, required this.songId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['folder_id'] = Variable<int>(folderId);
    map['song_id'] = Variable<int>(songId);
    return map;
  }

  FolderSongsCompanion toCompanion(bool nullToAbsent) {
    return FolderSongsCompanion(
      folderId: Value(folderId),
      songId: Value(songId),
    );
  }

  factory FolderSong.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FolderSong(
      folderId: serializer.fromJson<int>(json['folderId']),
      songId: serializer.fromJson<int>(json['songId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'folderId': serializer.toJson<int>(folderId),
      'songId': serializer.toJson<int>(songId),
    };
  }

  FolderSong copyWith({int? folderId, int? songId}) => FolderSong(
    folderId: folderId ?? this.folderId,
    songId: songId ?? this.songId,
  );
  FolderSong copyWithCompanion(FolderSongsCompanion data) {
    return FolderSong(
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      songId: data.songId.present ? data.songId.value : this.songId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FolderSong(')
          ..write('folderId: $folderId, ')
          ..write('songId: $songId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(folderId, songId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FolderSong &&
          other.folderId == this.folderId &&
          other.songId == this.songId);
}

class FolderSongsCompanion extends UpdateCompanion<FolderSong> {
  final Value<int> folderId;
  final Value<int> songId;
  final Value<int> rowid;
  const FolderSongsCompanion({
    this.folderId = const Value.absent(),
    this.songId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FolderSongsCompanion.insert({
    required int folderId,
    required int songId,
    this.rowid = const Value.absent(),
  }) : folderId = Value(folderId),
       songId = Value(songId);
  static Insertable<FolderSong> custom({
    Expression<int>? folderId,
    Expression<int>? songId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (folderId != null) 'folder_id': folderId,
      if (songId != null) 'song_id': songId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FolderSongsCompanion copyWith({
    Value<int>? folderId,
    Value<int>? songId,
    Value<int>? rowid,
  }) {
    return FolderSongsCompanion(
      folderId: folderId ?? this.folderId,
      songId: songId ?? this.songId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (folderId.present) {
      map['folder_id'] = Variable<int>(folderId.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<int>(songId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FolderSongsCompanion(')
          ..write('folderId: $folderId, ')
          ..write('songId: $songId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF26A69A),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final int id;
  final String name;
  final int color;
  const Tag({required this.id, required this.name, required this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(id: Value(id), name: Value(name), color: Value(color));
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
    };
  }

  Tag copyWith({int? id, String? name, int? color}) => Tag(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color ?? this.color,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> color;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Tag> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? color,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
    });
  }

  TagsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? color,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }
}

class $SongTagsTable extends SongTags with TableInfo<$SongTagsTable, SongTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SongTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<int> songId = GeneratedColumn<int>(
    'song_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES songs (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [songId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'song_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<SongTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('song_id')) {
      context.handle(
        _songIdMeta,
        songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta),
      );
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {songId, tagId};
  @override
  SongTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SongTag(
      songId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}song_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $SongTagsTable createAlias(String alias) {
    return $SongTagsTable(attachedDatabase, alias);
  }
}

class SongTag extends DataClass implements Insertable<SongTag> {
  final int songId;
  final int tagId;
  const SongTag({required this.songId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['song_id'] = Variable<int>(songId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  SongTagsCompanion toCompanion(bool nullToAbsent) {
    return SongTagsCompanion(songId: Value(songId), tagId: Value(tagId));
  }

  factory SongTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SongTag(
      songId: serializer.fromJson<int>(json['songId']),
      tagId: serializer.fromJson<int>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'songId': serializer.toJson<int>(songId),
      'tagId': serializer.toJson<int>(tagId),
    };
  }

  SongTag copyWith({int? songId, int? tagId}) =>
      SongTag(songId: songId ?? this.songId, tagId: tagId ?? this.tagId);
  SongTag copyWithCompanion(SongTagsCompanion data) {
    return SongTag(
      songId: data.songId.present ? data.songId.value : this.songId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SongTag(')
          ..write('songId: $songId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(songId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SongTag &&
          other.songId == this.songId &&
          other.tagId == this.tagId);
}

class SongTagsCompanion extends UpdateCompanion<SongTag> {
  final Value<int> songId;
  final Value<int> tagId;
  final Value<int> rowid;
  const SongTagsCompanion({
    this.songId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SongTagsCompanion.insert({
    required int songId,
    required int tagId,
    this.rowid = const Value.absent(),
  }) : songId = Value(songId),
       tagId = Value(tagId);
  static Insertable<SongTag> custom({
    Expression<int>? songId,
    Expression<int>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (songId != null) 'song_id': songId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SongTagsCompanion copyWith({
    Value<int>? songId,
    Value<int>? tagId,
    Value<int>? rowid,
  }) {
    return SongTagsCompanion(
      songId: songId ?? this.songId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (songId.present) {
      map['song_id'] = Variable<int>(songId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SongTagsCompanion(')
          ..write('songId: $songId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SetlistsTable extends Setlists with TableInfo<$SetlistsTable, Setlist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetlistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, notes, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'setlists';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setlist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setlist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setlist(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SetlistsTable createAlias(String alias) {
    return $SetlistsTable(attachedDatabase, alias);
  }
}

class Setlist extends DataClass implements Insertable<Setlist> {
  final int id;
  final String name;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Setlist({
    required this.id,
    required this.name,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SetlistsCompanion toCompanion(bool nullToAbsent) {
    return SetlistsCompanion(
      id: Value(id),
      name: Value(name),
      notes: Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Setlist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setlist(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      notes: serializer.fromJson<String>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Setlist copyWith({
    int? id,
    String? name,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Setlist(
    id: id ?? this.id,
    name: name ?? this.name,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Setlist copyWithCompanion(SetlistsCompanion data) {
    return Setlist(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setlist(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, notes, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setlist &&
          other.id == this.id &&
          other.name == this.name &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SetlistsCompanion extends UpdateCompanion<Setlist> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const SetlistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SetlistsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Setlist> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SetlistsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return SetlistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetlistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SetlistItemsTable extends SetlistItems
    with TableInfo<$SetlistItemsTable, SetlistItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetlistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _setlistIdMeta = const VerificationMeta(
    'setlistId',
  );
  @override
  late final GeneratedColumn<int> setlistId = GeneratedColumn<int>(
    'setlist_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES setlists (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<int> songId = GeneratedColumn<int>(
    'song_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES songs (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<double> position = GeneratedColumn<double>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, setlistId, songId, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'setlist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SetlistItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('setlist_id')) {
      context.handle(
        _setlistIdMeta,
        setlistId.isAcceptableOrUnknown(data['setlist_id']!, _setlistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_setlistIdMeta);
    }
    if (data.containsKey('song_id')) {
      context.handle(
        _songIdMeta,
        songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta),
      );
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetlistItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetlistItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      setlistId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}setlist_id'],
      )!,
      songId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}song_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $SetlistItemsTable createAlias(String alias) {
    return $SetlistItemsTable(attachedDatabase, alias);
  }
}

class SetlistItem extends DataClass implements Insertable<SetlistItem> {
  final int id;
  final int setlistId;
  final int songId;
  final double position;
  const SetlistItem({
    required this.id,
    required this.setlistId,
    required this.songId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['setlist_id'] = Variable<int>(setlistId);
    map['song_id'] = Variable<int>(songId);
    map['position'] = Variable<double>(position);
    return map;
  }

  SetlistItemsCompanion toCompanion(bool nullToAbsent) {
    return SetlistItemsCompanion(
      id: Value(id),
      setlistId: Value(setlistId),
      songId: Value(songId),
      position: Value(position),
    );
  }

  factory SetlistItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetlistItem(
      id: serializer.fromJson<int>(json['id']),
      setlistId: serializer.fromJson<int>(json['setlistId']),
      songId: serializer.fromJson<int>(json['songId']),
      position: serializer.fromJson<double>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'setlistId': serializer.toJson<int>(setlistId),
      'songId': serializer.toJson<int>(songId),
      'position': serializer.toJson<double>(position),
    };
  }

  SetlistItem copyWith({
    int? id,
    int? setlistId,
    int? songId,
    double? position,
  }) => SetlistItem(
    id: id ?? this.id,
    setlistId: setlistId ?? this.setlistId,
    songId: songId ?? this.songId,
    position: position ?? this.position,
  );
  SetlistItem copyWithCompanion(SetlistItemsCompanion data) {
    return SetlistItem(
      id: data.id.present ? data.id.value : this.id,
      setlistId: data.setlistId.present ? data.setlistId.value : this.setlistId,
      songId: data.songId.present ? data.songId.value : this.songId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetlistItem(')
          ..write('id: $id, ')
          ..write('setlistId: $setlistId, ')
          ..write('songId: $songId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, setlistId, songId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetlistItem &&
          other.id == this.id &&
          other.setlistId == this.setlistId &&
          other.songId == this.songId &&
          other.position == this.position);
}

class SetlistItemsCompanion extends UpdateCompanion<SetlistItem> {
  final Value<int> id;
  final Value<int> setlistId;
  final Value<int> songId;
  final Value<double> position;
  const SetlistItemsCompanion({
    this.id = const Value.absent(),
    this.setlistId = const Value.absent(),
    this.songId = const Value.absent(),
    this.position = const Value.absent(),
  });
  SetlistItemsCompanion.insert({
    this.id = const Value.absent(),
    required int setlistId,
    required int songId,
    required double position,
  }) : setlistId = Value(setlistId),
       songId = Value(songId),
       position = Value(position);
  static Insertable<SetlistItem> custom({
    Expression<int>? id,
    Expression<int>? setlistId,
    Expression<int>? songId,
    Expression<double>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (setlistId != null) 'setlist_id': setlistId,
      if (songId != null) 'song_id': songId,
      if (position != null) 'position': position,
    });
  }

  SetlistItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? setlistId,
    Value<int>? songId,
    Value<double>? position,
  }) {
    return SetlistItemsCompanion(
      id: id ?? this.id,
      setlistId: setlistId ?? this.setlistId,
      songId: songId ?? this.songId,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (setlistId.present) {
      map['setlist_id'] = Variable<int>(setlistId.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<int>(songId.value);
    }
    if (position.present) {
      map['position'] = Variable<double>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetlistItemsCompanion(')
          ..write('id: $id, ')
          ..write('setlistId: $setlistId, ')
          ..write('songId: $songId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $AnnotationsTable extends Annotations
    with TableInfo<$AnnotationsTable, Annotation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnnotationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<int> songId = GeneratedColumn<int>(
    'song_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES songs (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
    'page',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [songId, page, data];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'annotations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Annotation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('song_id')) {
      context.handle(
        _songIdMeta,
        songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta),
      );
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('page')) {
      context.handle(
        _pageMeta,
        page.isAcceptableOrUnknown(data['page']!, _pageMeta),
      );
    } else if (isInserting) {
      context.missing(_pageMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {songId, page};
  @override
  Annotation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Annotation(
      songId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}song_id'],
      )!,
      page: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
    );
  }

  @override
  $AnnotationsTable createAlias(String alias) {
    return $AnnotationsTable(attachedDatabase, alias);
  }
}

class Annotation extends DataClass implements Insertable<Annotation> {
  final int songId;
  final int page;
  final String data;
  const Annotation({
    required this.songId,
    required this.page,
    required this.data,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['song_id'] = Variable<int>(songId);
    map['page'] = Variable<int>(page);
    map['data'] = Variable<String>(data);
    return map;
  }

  AnnotationsCompanion toCompanion(bool nullToAbsent) {
    return AnnotationsCompanion(
      songId: Value(songId),
      page: Value(page),
      data: Value(data),
    );
  }

  factory Annotation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Annotation(
      songId: serializer.fromJson<int>(json['songId']),
      page: serializer.fromJson<int>(json['page']),
      data: serializer.fromJson<String>(json['data']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'songId': serializer.toJson<int>(songId),
      'page': serializer.toJson<int>(page),
      'data': serializer.toJson<String>(data),
    };
  }

  Annotation copyWith({int? songId, int? page, String? data}) => Annotation(
    songId: songId ?? this.songId,
    page: page ?? this.page,
    data: data ?? this.data,
  );
  Annotation copyWithCompanion(AnnotationsCompanion data) {
    return Annotation(
      songId: data.songId.present ? data.songId.value : this.songId,
      page: data.page.present ? data.page.value : this.page,
      data: data.data.present ? data.data.value : this.data,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Annotation(')
          ..write('songId: $songId, ')
          ..write('page: $page, ')
          ..write('data: $data')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(songId, page, data);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Annotation &&
          other.songId == this.songId &&
          other.page == this.page &&
          other.data == this.data);
}

class AnnotationsCompanion extends UpdateCompanion<Annotation> {
  final Value<int> songId;
  final Value<int> page;
  final Value<String> data;
  final Value<int> rowid;
  const AnnotationsCompanion({
    this.songId = const Value.absent(),
    this.page = const Value.absent(),
    this.data = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnnotationsCompanion.insert({
    required int songId,
    required int page,
    required String data,
    this.rowid = const Value.absent(),
  }) : songId = Value(songId),
       page = Value(page),
       data = Value(data);
  static Insertable<Annotation> custom({
    Expression<int>? songId,
    Expression<int>? page,
    Expression<String>? data,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (songId != null) 'song_id': songId,
      if (page != null) 'page': page,
      if (data != null) 'data': data,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnnotationsCompanion copyWith({
    Value<int>? songId,
    Value<int>? page,
    Value<String>? data,
    Value<int>? rowid,
  }) {
    return AnnotationsCompanion(
      songId: songId ?? this.songId,
      page: page ?? this.page,
      data: data ?? this.data,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (songId.present) {
      map['song_id'] = Variable<int>(songId.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnnotationsCompanion(')
          ..write('songId: $songId, ')
          ..write('page: $page, ')
          ..write('data: $data, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AudioClipsTable extends AudioClips
    with TableInfo<$AudioClipsTable, AudioClip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AudioClipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _songIdMeta = const VerificationMeta('songId');
  @override
  late final GeneratedColumn<int> songId = GeneratedColumn<int>(
    'song_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES songs (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pageMeta = const VerificationMeta('page');
  @override
  late final GeneratedColumn<int> page = GeneratedColumn<int>(
    'page',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leftMeta = const VerificationMeta('left');
  @override
  late final GeneratedColumn<double> left = GeneratedColumn<double>(
    'left',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _topMeta = const VerificationMeta('top');
  @override
  late final GeneratedColumn<double> top = GeneratedColumn<double>(
    'top',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rightMeta = const VerificationMeta('right');
  @override
  late final GeneratedColumn<double> right = GeneratedColumn<double>(
    'right',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bottomMeta = const VerificationMeta('bottom');
  @override
  late final GeneratedColumn<double> bottom = GeneratedColumn<double>(
    'bottom',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    songId,
    title,
    fileName,
    page,
    left,
    top,
    right,
    bottom,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'audio_clips';
  @override
  VerificationContext validateIntegrity(
    Insertable<AudioClip> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('song_id')) {
      context.handle(
        _songIdMeta,
        songId.isAcceptableOrUnknown(data['song_id']!, _songIdMeta),
      );
    } else if (isInserting) {
      context.missing(_songIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('page')) {
      context.handle(
        _pageMeta,
        page.isAcceptableOrUnknown(data['page']!, _pageMeta),
      );
    }
    if (data.containsKey('left')) {
      context.handle(
        _leftMeta,
        left.isAcceptableOrUnknown(data['left']!, _leftMeta),
      );
    }
    if (data.containsKey('top')) {
      context.handle(
        _topMeta,
        top.isAcceptableOrUnknown(data['top']!, _topMeta),
      );
    }
    if (data.containsKey('right')) {
      context.handle(
        _rightMeta,
        right.isAcceptableOrUnknown(data['right']!, _rightMeta),
      );
    }
    if (data.containsKey('bottom')) {
      context.handle(
        _bottomMeta,
        bottom.isAcceptableOrUnknown(data['bottom']!, _bottomMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AudioClip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AudioClip(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      songId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}song_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      page: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page'],
      ),
      left: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}left'],
      ),
      top: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}top'],
      ),
      right: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}right'],
      ),
      bottom: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bottom'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AudioClipsTable createAlias(String alias) {
    return $AudioClipsTable(attachedDatabase, alias);
  }
}

class AudioClip extends DataClass implements Insertable<AudioClip> {
  final int id;
  final int songId;
  final String title;

  /// File name relative to the library directory.
  final String fileName;

  /// Null when the clip is for the whole song.
  final int? page;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final DateTime createdAt;
  const AudioClip({
    required this.id,
    required this.songId,
    required this.title,
    required this.fileName,
    this.page,
    this.left,
    this.top,
    this.right,
    this.bottom,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['song_id'] = Variable<int>(songId);
    map['title'] = Variable<String>(title);
    map['file_name'] = Variable<String>(fileName);
    if (!nullToAbsent || page != null) {
      map['page'] = Variable<int>(page);
    }
    if (!nullToAbsent || left != null) {
      map['left'] = Variable<double>(left);
    }
    if (!nullToAbsent || top != null) {
      map['top'] = Variable<double>(top);
    }
    if (!nullToAbsent || right != null) {
      map['right'] = Variable<double>(right);
    }
    if (!nullToAbsent || bottom != null) {
      map['bottom'] = Variable<double>(bottom);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AudioClipsCompanion toCompanion(bool nullToAbsent) {
    return AudioClipsCompanion(
      id: Value(id),
      songId: Value(songId),
      title: Value(title),
      fileName: Value(fileName),
      page: page == null && nullToAbsent ? const Value.absent() : Value(page),
      left: left == null && nullToAbsent ? const Value.absent() : Value(left),
      top: top == null && nullToAbsent ? const Value.absent() : Value(top),
      right: right == null && nullToAbsent
          ? const Value.absent()
          : Value(right),
      bottom: bottom == null && nullToAbsent
          ? const Value.absent()
          : Value(bottom),
      createdAt: Value(createdAt),
    );
  }

  factory AudioClip.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AudioClip(
      id: serializer.fromJson<int>(json['id']),
      songId: serializer.fromJson<int>(json['songId']),
      title: serializer.fromJson<String>(json['title']),
      fileName: serializer.fromJson<String>(json['fileName']),
      page: serializer.fromJson<int?>(json['page']),
      left: serializer.fromJson<double?>(json['left']),
      top: serializer.fromJson<double?>(json['top']),
      right: serializer.fromJson<double?>(json['right']),
      bottom: serializer.fromJson<double?>(json['bottom']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'songId': serializer.toJson<int>(songId),
      'title': serializer.toJson<String>(title),
      'fileName': serializer.toJson<String>(fileName),
      'page': serializer.toJson<int?>(page),
      'left': serializer.toJson<double?>(left),
      'top': serializer.toJson<double?>(top),
      'right': serializer.toJson<double?>(right),
      'bottom': serializer.toJson<double?>(bottom),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AudioClip copyWith({
    int? id,
    int? songId,
    String? title,
    String? fileName,
    Value<int?> page = const Value.absent(),
    Value<double?> left = const Value.absent(),
    Value<double?> top = const Value.absent(),
    Value<double?> right = const Value.absent(),
    Value<double?> bottom = const Value.absent(),
    DateTime? createdAt,
  }) => AudioClip(
    id: id ?? this.id,
    songId: songId ?? this.songId,
    title: title ?? this.title,
    fileName: fileName ?? this.fileName,
    page: page.present ? page.value : this.page,
    left: left.present ? left.value : this.left,
    top: top.present ? top.value : this.top,
    right: right.present ? right.value : this.right,
    bottom: bottom.present ? bottom.value : this.bottom,
    createdAt: createdAt ?? this.createdAt,
  );
  AudioClip copyWithCompanion(AudioClipsCompanion data) {
    return AudioClip(
      id: data.id.present ? data.id.value : this.id,
      songId: data.songId.present ? data.songId.value : this.songId,
      title: data.title.present ? data.title.value : this.title,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      page: data.page.present ? data.page.value : this.page,
      left: data.left.present ? data.left.value : this.left,
      top: data.top.present ? data.top.value : this.top,
      right: data.right.present ? data.right.value : this.right,
      bottom: data.bottom.present ? data.bottom.value : this.bottom,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AudioClip(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('title: $title, ')
          ..write('fileName: $fileName, ')
          ..write('page: $page, ')
          ..write('left: $left, ')
          ..write('top: $top, ')
          ..write('right: $right, ')
          ..write('bottom: $bottom, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    songId,
    title,
    fileName,
    page,
    left,
    top,
    right,
    bottom,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudioClip &&
          other.id == this.id &&
          other.songId == this.songId &&
          other.title == this.title &&
          other.fileName == this.fileName &&
          other.page == this.page &&
          other.left == this.left &&
          other.top == this.top &&
          other.right == this.right &&
          other.bottom == this.bottom &&
          other.createdAt == this.createdAt);
}

class AudioClipsCompanion extends UpdateCompanion<AudioClip> {
  final Value<int> id;
  final Value<int> songId;
  final Value<String> title;
  final Value<String> fileName;
  final Value<int?> page;
  final Value<double?> left;
  final Value<double?> top;
  final Value<double?> right;
  final Value<double?> bottom;
  final Value<DateTime> createdAt;
  const AudioClipsCompanion({
    this.id = const Value.absent(),
    this.songId = const Value.absent(),
    this.title = const Value.absent(),
    this.fileName = const Value.absent(),
    this.page = const Value.absent(),
    this.left = const Value.absent(),
    this.top = const Value.absent(),
    this.right = const Value.absent(),
    this.bottom = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AudioClipsCompanion.insert({
    this.id = const Value.absent(),
    required int songId,
    required String title,
    required String fileName,
    this.page = const Value.absent(),
    this.left = const Value.absent(),
    this.top = const Value.absent(),
    this.right = const Value.absent(),
    this.bottom = const Value.absent(),
    required DateTime createdAt,
  }) : songId = Value(songId),
       title = Value(title),
       fileName = Value(fileName),
       createdAt = Value(createdAt);
  static Insertable<AudioClip> custom({
    Expression<int>? id,
    Expression<int>? songId,
    Expression<String>? title,
    Expression<String>? fileName,
    Expression<int>? page,
    Expression<double>? left,
    Expression<double>? top,
    Expression<double>? right,
    Expression<double>? bottom,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (songId != null) 'song_id': songId,
      if (title != null) 'title': title,
      if (fileName != null) 'file_name': fileName,
      if (page != null) 'page': page,
      if (left != null) 'left': left,
      if (top != null) 'top': top,
      if (right != null) 'right': right,
      if (bottom != null) 'bottom': bottom,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AudioClipsCompanion copyWith({
    Value<int>? id,
    Value<int>? songId,
    Value<String>? title,
    Value<String>? fileName,
    Value<int?>? page,
    Value<double?>? left,
    Value<double?>? top,
    Value<double?>? right,
    Value<double?>? bottom,
    Value<DateTime>? createdAt,
  }) {
    return AudioClipsCompanion(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      title: title ?? this.title,
      fileName: fileName ?? this.fileName,
      page: page ?? this.page,
      left: left ?? this.left,
      top: top ?? this.top,
      right: right ?? this.right,
      bottom: bottom ?? this.bottom,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (songId.present) {
      map['song_id'] = Variable<int>(songId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (page.present) {
      map['page'] = Variable<int>(page.value);
    }
    if (left.present) {
      map['left'] = Variable<double>(left.value);
    }
    if (top.present) {
      map['top'] = Variable<double>(top.value);
    }
    if (right.present) {
      map['right'] = Variable<double>(right.value);
    }
    if (bottom.present) {
      map['bottom'] = Variable<double>(bottom.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AudioClipsCompanion(')
          ..write('id: $id, ')
          ..write('songId: $songId, ')
          ..write('title: $title, ')
          ..write('fileName: $fileName, ')
          ..write('page: $page, ')
          ..write('left: $left, ')
          ..write('top: $top, ')
          ..write('right: $right, ')
          ..write('bottom: $bottom, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SongsTable songs = $SongsTable(this);
  late final $FoldersTable folders = $FoldersTable(this);
  late final $FolderSongsTable folderSongs = $FolderSongsTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $SongTagsTable songTags = $SongTagsTable(this);
  late final $SetlistsTable setlists = $SetlistsTable(this);
  late final $SetlistItemsTable setlistItems = $SetlistItemsTable(this);
  late final $AnnotationsTable annotations = $AnnotationsTable(this);
  late final $AudioClipsTable audioClips = $AudioClipsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    songs,
    folders,
    folderSongs,
    tags,
    songTags,
    setlists,
    setlistItems,
    annotations,
    audioClips,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'folders',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('folder_songs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'songs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('folder_songs', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'songs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('song_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('song_tags', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'setlists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('setlist_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'songs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('setlist_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'songs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('annotations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'songs',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('audio_clips', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SongsTableCreateCompanionBuilder =
    SongsCompanion Function({
      Value<int> id,
      required String title,
      Value<String> composer,
      Value<String> instrument,
      Value<String> musicalKey,
      Value<int?> tempo,
      Value<String> notes,
      required String fileName,
      required String fileHash,
      Value<int> pageCount,
      required DateTime createdAt,
      Value<DateTime?> lastOpenedAt,
      Value<int> openCount,
      Value<int> lastPage,
      Value<String> artist,
      Value<int?> year,
      Value<String> genre,
      Value<String> album,
      Value<String?> coverFileName,
      Value<String?> importTitle,
      Value<String?> mbRecordingId,
      Value<String?> mbWorkId,
      Value<String?> mbReleaseGroupId,
      Value<String> lookupStatus,
      Value<int> lookupAttempts,
      Value<DateTime?> nextAttemptAt,
      Value<String?> lookupCandidates,
    });
typedef $$SongsTableUpdateCompanionBuilder =
    SongsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> composer,
      Value<String> instrument,
      Value<String> musicalKey,
      Value<int?> tempo,
      Value<String> notes,
      Value<String> fileName,
      Value<String> fileHash,
      Value<int> pageCount,
      Value<DateTime> createdAt,
      Value<DateTime?> lastOpenedAt,
      Value<int> openCount,
      Value<int> lastPage,
      Value<String> artist,
      Value<int?> year,
      Value<String> genre,
      Value<String> album,
      Value<String?> coverFileName,
      Value<String?> importTitle,
      Value<String?> mbRecordingId,
      Value<String?> mbWorkId,
      Value<String?> mbReleaseGroupId,
      Value<String> lookupStatus,
      Value<int> lookupAttempts,
      Value<DateTime?> nextAttemptAt,
      Value<String?> lookupCandidates,
    });

final class $$SongsTableReferences
    extends BaseReferences<_$AppDatabase, $SongsTable, Song> {
  $$SongsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FolderSongsTable, List<FolderSong>>
  _folderSongsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.folderSongs,
    aliasName: $_aliasNameGenerator(db.songs.id, db.folderSongs.songId),
  );

  $$FolderSongsTableProcessedTableManager get folderSongsRefs {
    final manager = $$FolderSongsTableTableManager(
      $_db,
      $_db.folderSongs,
    ).filter((f) => f.songId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_folderSongsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SongTagsTable, List<SongTag>> _songTagsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.songTags,
    aliasName: $_aliasNameGenerator(db.songs.id, db.songTags.songId),
  );

  $$SongTagsTableProcessedTableManager get songTagsRefs {
    final manager = $$SongTagsTableTableManager(
      $_db,
      $_db.songTags,
    ).filter((f) => f.songId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_songTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SetlistItemsTable, List<SetlistItem>>
  _setlistItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.setlistItems,
    aliasName: $_aliasNameGenerator(db.songs.id, db.setlistItems.songId),
  );

  $$SetlistItemsTableProcessedTableManager get setlistItemsRefs {
    final manager = $$SetlistItemsTableTableManager(
      $_db,
      $_db.setlistItems,
    ).filter((f) => f.songId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_setlistItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AnnotationsTable, List<Annotation>>
  _annotationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.annotations,
    aliasName: $_aliasNameGenerator(db.songs.id, db.annotations.songId),
  );

  $$AnnotationsTableProcessedTableManager get annotationsRefs {
    final manager = $$AnnotationsTableTableManager(
      $_db,
      $_db.annotations,
    ).filter((f) => f.songId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_annotationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AudioClipsTable, List<AudioClip>>
  _audioClipsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.audioClips,
    aliasName: $_aliasNameGenerator(db.songs.id, db.audioClips.songId),
  );

  $$AudioClipsTableProcessedTableManager get audioClipsRefs {
    final manager = $$AudioClipsTableTableManager(
      $_db,
      $_db.audioClips,
    ).filter((f) => f.songId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_audioClipsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SongsTableFilterComposer extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get composer => $composableBuilder(
    column: $table.composer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instrument => $composableBuilder(
    column: $table.instrument,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get musicalKey => $composableBuilder(
    column: $table.musicalKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tempo => $composableBuilder(
    column: $table.tempo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openCount => $composableBuilder(
    column: $table.openCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPage => $composableBuilder(
    column: $table.lastPage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get album => $composableBuilder(
    column: $table.album,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverFileName => $composableBuilder(
    column: $table.coverFileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get importTitle => $composableBuilder(
    column: $table.importTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mbRecordingId => $composableBuilder(
    column: $table.mbRecordingId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mbWorkId => $composableBuilder(
    column: $table.mbWorkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mbReleaseGroupId => $composableBuilder(
    column: $table.mbReleaseGroupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lookupStatus => $composableBuilder(
    column: $table.lookupStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lookupAttempts => $composableBuilder(
    column: $table.lookupAttempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lookupCandidates => $composableBuilder(
    column: $table.lookupCandidates,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> folderSongsRefs(
    Expression<bool> Function($$FolderSongsTableFilterComposer f) f,
  ) {
    final $$FolderSongsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.folderSongs,
      getReferencedColumn: (t) => t.songId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FolderSongsTableFilterComposer(
            $db: $db,
            $table: $db.folderSongs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> songTagsRefs(
    Expression<bool> Function($$SongTagsTableFilterComposer f) f,
  ) {
    final $$SongTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.songTags,
      getReferencedColumn: (t) => t.songId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongTagsTableFilterComposer(
            $db: $db,
            $table: $db.songTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> setlistItemsRefs(
    Expression<bool> Function($$SetlistItemsTableFilterComposer f) f,
  ) {
    final $$SetlistItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setlistItems,
      getReferencedColumn: (t) => t.songId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetlistItemsTableFilterComposer(
            $db: $db,
            $table: $db.setlistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> annotationsRefs(
    Expression<bool> Function($$AnnotationsTableFilterComposer f) f,
  ) {
    final $$AnnotationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.annotations,
      getReferencedColumn: (t) => t.songId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnnotationsTableFilterComposer(
            $db: $db,
            $table: $db.annotations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> audioClipsRefs(
    Expression<bool> Function($$AudioClipsTableFilterComposer f) f,
  ) {
    final $$AudioClipsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.audioClips,
      getReferencedColumn: (t) => t.songId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioClipsTableFilterComposer(
            $db: $db,
            $table: $db.audioClips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SongsTableOrderingComposer
    extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get composer => $composableBuilder(
    column: $table.composer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instrument => $composableBuilder(
    column: $table.instrument,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get musicalKey => $composableBuilder(
    column: $table.musicalKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tempo => $composableBuilder(
    column: $table.tempo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileHash => $composableBuilder(
    column: $table.fileHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openCount => $composableBuilder(
    column: $table.openCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPage => $composableBuilder(
    column: $table.lastPage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get artist => $composableBuilder(
    column: $table.artist,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genre => $composableBuilder(
    column: $table.genre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get album => $composableBuilder(
    column: $table.album,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverFileName => $composableBuilder(
    column: $table.coverFileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get importTitle => $composableBuilder(
    column: $table.importTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mbRecordingId => $composableBuilder(
    column: $table.mbRecordingId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mbWorkId => $composableBuilder(
    column: $table.mbWorkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mbReleaseGroupId => $composableBuilder(
    column: $table.mbReleaseGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lookupStatus => $composableBuilder(
    column: $table.lookupStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lookupAttempts => $composableBuilder(
    column: $table.lookupAttempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lookupCandidates => $composableBuilder(
    column: $table.lookupCandidates,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SongsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SongsTable> {
  $$SongsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get composer =>
      $composableBuilder(column: $table.composer, builder: (column) => column);

  GeneratedColumn<String> get instrument => $composableBuilder(
    column: $table.instrument,
    builder: (column) => column,
  );

  GeneratedColumn<String> get musicalKey => $composableBuilder(
    column: $table.musicalKey,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tempo =>
      $composableBuilder(column: $table.tempo, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<int> get pageCount =>
      $composableBuilder(column: $table.pageCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get openCount =>
      $composableBuilder(column: $table.openCount, builder: (column) => column);

  GeneratedColumn<int> get lastPage =>
      $composableBuilder(column: $table.lastPage, builder: (column) => column);

  GeneratedColumn<String> get artist =>
      $composableBuilder(column: $table.artist, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get genre =>
      $composableBuilder(column: $table.genre, builder: (column) => column);

  GeneratedColumn<String> get album =>
      $composableBuilder(column: $table.album, builder: (column) => column);

  GeneratedColumn<String> get coverFileName => $composableBuilder(
    column: $table.coverFileName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get importTitle => $composableBuilder(
    column: $table.importTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mbRecordingId => $composableBuilder(
    column: $table.mbRecordingId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mbWorkId =>
      $composableBuilder(column: $table.mbWorkId, builder: (column) => column);

  GeneratedColumn<String> get mbReleaseGroupId => $composableBuilder(
    column: $table.mbReleaseGroupId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lookupStatus => $composableBuilder(
    column: $table.lookupStatus,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lookupAttempts => $composableBuilder(
    column: $table.lookupAttempts,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextAttemptAt => $composableBuilder(
    column: $table.nextAttemptAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lookupCandidates => $composableBuilder(
    column: $table.lookupCandidates,
    builder: (column) => column,
  );

  Expression<T> folderSongsRefs<T extends Object>(
    Expression<T> Function($$FolderSongsTableAnnotationComposer a) f,
  ) {
    final $$FolderSongsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.folderSongs,
      getReferencedColumn: (t) => t.songId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FolderSongsTableAnnotationComposer(
            $db: $db,
            $table: $db.folderSongs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> songTagsRefs<T extends Object>(
    Expression<T> Function($$SongTagsTableAnnotationComposer a) f,
  ) {
    final $$SongTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.songTags,
      getReferencedColumn: (t) => t.songId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.songTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> setlistItemsRefs<T extends Object>(
    Expression<T> Function($$SetlistItemsTableAnnotationComposer a) f,
  ) {
    final $$SetlistItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setlistItems,
      getReferencedColumn: (t) => t.songId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetlistItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.setlistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> annotationsRefs<T extends Object>(
    Expression<T> Function($$AnnotationsTableAnnotationComposer a) f,
  ) {
    final $$AnnotationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.annotations,
      getReferencedColumn: (t) => t.songId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnnotationsTableAnnotationComposer(
            $db: $db,
            $table: $db.annotations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> audioClipsRefs<T extends Object>(
    Expression<T> Function($$AudioClipsTableAnnotationComposer a) f,
  ) {
    final $$AudioClipsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.audioClips,
      getReferencedColumn: (t) => t.songId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AudioClipsTableAnnotationComposer(
            $db: $db,
            $table: $db.audioClips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SongsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SongsTable,
          Song,
          $$SongsTableFilterComposer,
          $$SongsTableOrderingComposer,
          $$SongsTableAnnotationComposer,
          $$SongsTableCreateCompanionBuilder,
          $$SongsTableUpdateCompanionBuilder,
          (Song, $$SongsTableReferences),
          Song,
          PrefetchHooks Function({
            bool folderSongsRefs,
            bool songTagsRefs,
            bool setlistItemsRefs,
            bool annotationsRefs,
            bool audioClipsRefs,
          })
        > {
  $$SongsTableTableManager(_$AppDatabase db, $SongsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SongsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SongsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SongsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> composer = const Value.absent(),
                Value<String> instrument = const Value.absent(),
                Value<String> musicalKey = const Value.absent(),
                Value<int?> tempo = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> fileHash = const Value.absent(),
                Value<int> pageCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastOpenedAt = const Value.absent(),
                Value<int> openCount = const Value.absent(),
                Value<int> lastPage = const Value.absent(),
                Value<String> artist = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String> genre = const Value.absent(),
                Value<String> album = const Value.absent(),
                Value<String?> coverFileName = const Value.absent(),
                Value<String?> importTitle = const Value.absent(),
                Value<String?> mbRecordingId = const Value.absent(),
                Value<String?> mbWorkId = const Value.absent(),
                Value<String?> mbReleaseGroupId = const Value.absent(),
                Value<String> lookupStatus = const Value.absent(),
                Value<int> lookupAttempts = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> lookupCandidates = const Value.absent(),
              }) => SongsCompanion(
                id: id,
                title: title,
                composer: composer,
                instrument: instrument,
                musicalKey: musicalKey,
                tempo: tempo,
                notes: notes,
                fileName: fileName,
                fileHash: fileHash,
                pageCount: pageCount,
                createdAt: createdAt,
                lastOpenedAt: lastOpenedAt,
                openCount: openCount,
                lastPage: lastPage,
                artist: artist,
                year: year,
                genre: genre,
                album: album,
                coverFileName: coverFileName,
                importTitle: importTitle,
                mbRecordingId: mbRecordingId,
                mbWorkId: mbWorkId,
                mbReleaseGroupId: mbReleaseGroupId,
                lookupStatus: lookupStatus,
                lookupAttempts: lookupAttempts,
                nextAttemptAt: nextAttemptAt,
                lookupCandidates: lookupCandidates,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String> composer = const Value.absent(),
                Value<String> instrument = const Value.absent(),
                Value<String> musicalKey = const Value.absent(),
                Value<int?> tempo = const Value.absent(),
                Value<String> notes = const Value.absent(),
                required String fileName,
                required String fileHash,
                Value<int> pageCount = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> lastOpenedAt = const Value.absent(),
                Value<int> openCount = const Value.absent(),
                Value<int> lastPage = const Value.absent(),
                Value<String> artist = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String> genre = const Value.absent(),
                Value<String> album = const Value.absent(),
                Value<String?> coverFileName = const Value.absent(),
                Value<String?> importTitle = const Value.absent(),
                Value<String?> mbRecordingId = const Value.absent(),
                Value<String?> mbWorkId = const Value.absent(),
                Value<String?> mbReleaseGroupId = const Value.absent(),
                Value<String> lookupStatus = const Value.absent(),
                Value<int> lookupAttempts = const Value.absent(),
                Value<DateTime?> nextAttemptAt = const Value.absent(),
                Value<String?> lookupCandidates = const Value.absent(),
              }) => SongsCompanion.insert(
                id: id,
                title: title,
                composer: composer,
                instrument: instrument,
                musicalKey: musicalKey,
                tempo: tempo,
                notes: notes,
                fileName: fileName,
                fileHash: fileHash,
                pageCount: pageCount,
                createdAt: createdAt,
                lastOpenedAt: lastOpenedAt,
                openCount: openCount,
                lastPage: lastPage,
                artist: artist,
                year: year,
                genre: genre,
                album: album,
                coverFileName: coverFileName,
                importTitle: importTitle,
                mbRecordingId: mbRecordingId,
                mbWorkId: mbWorkId,
                mbReleaseGroupId: mbReleaseGroupId,
                lookupStatus: lookupStatus,
                lookupAttempts: lookupAttempts,
                nextAttemptAt: nextAttemptAt,
                lookupCandidates: lookupCandidates,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SongsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                folderSongsRefs = false,
                songTagsRefs = false,
                setlistItemsRefs = false,
                annotationsRefs = false,
                audioClipsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (folderSongsRefs) db.folderSongs,
                    if (songTagsRefs) db.songTags,
                    if (setlistItemsRefs) db.setlistItems,
                    if (annotationsRefs) db.annotations,
                    if (audioClipsRefs) db.audioClips,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (folderSongsRefs)
                        await $_getPrefetchedData<
                          Song,
                          $SongsTable,
                          FolderSong
                        >(
                          currentTable: table,
                          referencedTable: $$SongsTableReferences
                              ._folderSongsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SongsTableReferences(
                                db,
                                table,
                                p0,
                              ).folderSongsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.songId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (songTagsRefs)
                        await $_getPrefetchedData<Song, $SongsTable, SongTag>(
                          currentTable: table,
                          referencedTable: $$SongsTableReferences
                              ._songTagsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SongsTableReferences(
                                db,
                                table,
                                p0,
                              ).songTagsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.songId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (setlistItemsRefs)
                        await $_getPrefetchedData<
                          Song,
                          $SongsTable,
                          SetlistItem
                        >(
                          currentTable: table,
                          referencedTable: $$SongsTableReferences
                              ._setlistItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SongsTableReferences(
                                db,
                                table,
                                p0,
                              ).setlistItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.songId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (annotationsRefs)
                        await $_getPrefetchedData<
                          Song,
                          $SongsTable,
                          Annotation
                        >(
                          currentTable: table,
                          referencedTable: $$SongsTableReferences
                              ._annotationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SongsTableReferences(
                                db,
                                table,
                                p0,
                              ).annotationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.songId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (audioClipsRefs)
                        await $_getPrefetchedData<Song, $SongsTable, AudioClip>(
                          currentTable: table,
                          referencedTable: $$SongsTableReferences
                              ._audioClipsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SongsTableReferences(
                                db,
                                table,
                                p0,
                              ).audioClipsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.songId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SongsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SongsTable,
      Song,
      $$SongsTableFilterComposer,
      $$SongsTableOrderingComposer,
      $$SongsTableAnnotationComposer,
      $$SongsTableCreateCompanionBuilder,
      $$SongsTableUpdateCompanionBuilder,
      (Song, $$SongsTableReferences),
      Song,
      PrefetchHooks Function({
        bool folderSongsRefs,
        bool songTagsRefs,
        bool setlistItemsRefs,
        bool annotationsRefs,
        bool audioClipsRefs,
      })
    >;
typedef $$FoldersTableCreateCompanionBuilder =
    FoldersCompanion Function({
      Value<int> id,
      required String name,
      Value<int> color,
      Value<String> sortMode,
      required DateTime createdAt,
    });
typedef $$FoldersTableUpdateCompanionBuilder =
    FoldersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> color,
      Value<String> sortMode,
      Value<DateTime> createdAt,
    });

final class $$FoldersTableReferences
    extends BaseReferences<_$AppDatabase, $FoldersTable, Folder> {
  $$FoldersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FolderSongsTable, List<FolderSong>>
  _folderSongsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.folderSongs,
    aliasName: $_aliasNameGenerator(db.folders.id, db.folderSongs.folderId),
  );

  $$FolderSongsTableProcessedTableManager get folderSongsRefs {
    final manager = $$FolderSongsTableTableManager(
      $_db,
      $_db.folderSongs,
    ).filter((f) => f.folderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_folderSongsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FoldersTableFilterComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortMode => $composableBuilder(
    column: $table.sortMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> folderSongsRefs(
    Expression<bool> Function($$FolderSongsTableFilterComposer f) f,
  ) {
    final $$FolderSongsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.folderSongs,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FolderSongsTableFilterComposer(
            $db: $db,
            $table: $db.folderSongs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoldersTableOrderingComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortMode => $composableBuilder(
    column: $table.sortMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoldersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoldersTable> {
  $$FoldersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get sortMode =>
      $composableBuilder(column: $table.sortMode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> folderSongsRefs<T extends Object>(
    Expression<T> Function($$FolderSongsTableAnnotationComposer a) f,
  ) {
    final $$FolderSongsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.folderSongs,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FolderSongsTableAnnotationComposer(
            $db: $db,
            $table: $db.folderSongs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoldersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoldersTable,
          Folder,
          $$FoldersTableFilterComposer,
          $$FoldersTableOrderingComposer,
          $$FoldersTableAnnotationComposer,
          $$FoldersTableCreateCompanionBuilder,
          $$FoldersTableUpdateCompanionBuilder,
          (Folder, $$FoldersTableReferences),
          Folder,
          PrefetchHooks Function({bool folderSongsRefs})
        > {
  $$FoldersTableTableManager(_$AppDatabase db, $FoldersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoldersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoldersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<String> sortMode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FoldersCompanion(
                id: id,
                name: name,
                color: color,
                sortMode: sortMode,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> color = const Value.absent(),
                Value<String> sortMode = const Value.absent(),
                required DateTime createdAt,
              }) => FoldersCompanion.insert(
                id: id,
                name: name,
                color: color,
                sortMode: sortMode,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FoldersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({folderSongsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (folderSongsRefs) db.folderSongs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (folderSongsRefs)
                    await $_getPrefetchedData<
                      Folder,
                      $FoldersTable,
                      FolderSong
                    >(
                      currentTable: table,
                      referencedTable: $$FoldersTableReferences
                          ._folderSongsRefsTable(db),
                      managerFromTypedResult: (p0) => $$FoldersTableReferences(
                        db,
                        table,
                        p0,
                      ).folderSongsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.folderId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FoldersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoldersTable,
      Folder,
      $$FoldersTableFilterComposer,
      $$FoldersTableOrderingComposer,
      $$FoldersTableAnnotationComposer,
      $$FoldersTableCreateCompanionBuilder,
      $$FoldersTableUpdateCompanionBuilder,
      (Folder, $$FoldersTableReferences),
      Folder,
      PrefetchHooks Function({bool folderSongsRefs})
    >;
typedef $$FolderSongsTableCreateCompanionBuilder =
    FolderSongsCompanion Function({
      required int folderId,
      required int songId,
      Value<int> rowid,
    });
typedef $$FolderSongsTableUpdateCompanionBuilder =
    FolderSongsCompanion Function({
      Value<int> folderId,
      Value<int> songId,
      Value<int> rowid,
    });

final class $$FolderSongsTableReferences
    extends BaseReferences<_$AppDatabase, $FolderSongsTable, FolderSong> {
  $$FolderSongsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FoldersTable _folderIdTable(_$AppDatabase db) =>
      db.folders.createAlias(
        $_aliasNameGenerator(db.folderSongs.folderId, db.folders.id),
      );

  $$FoldersTableProcessedTableManager get folderId {
    final $_column = $_itemColumn<int>('folder_id')!;

    final manager = $$FoldersTableTableManager(
      $_db,
      $_db.folders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SongsTable _songIdTable(_$AppDatabase db) => db.songs.createAlias(
    $_aliasNameGenerator(db.folderSongs.songId, db.songs.id),
  );

  $$SongsTableProcessedTableManager get songId {
    final $_column = $_itemColumn<int>('song_id')!;

    final manager = $$SongsTableTableManager(
      $_db,
      $_db.songs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_songIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FolderSongsTableFilterComposer
    extends Composer<_$AppDatabase, $FolderSongsTable> {
  $$FolderSongsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$FoldersTableFilterComposer get folderId {
    final $$FoldersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoldersTableFilterComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SongsTableFilterComposer get songId {
    final $$SongsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableFilterComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FolderSongsTableOrderingComposer
    extends Composer<_$AppDatabase, $FolderSongsTable> {
  $$FolderSongsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$FoldersTableOrderingComposer get folderId {
    final $$FoldersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoldersTableOrderingComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SongsTableOrderingComposer get songId {
    final $$SongsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableOrderingComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FolderSongsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FolderSongsTable> {
  $$FolderSongsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$FoldersTableAnnotationComposer get folderId {
    final $$FoldersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.folders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoldersTableAnnotationComposer(
            $db: $db,
            $table: $db.folders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SongsTableAnnotationComposer get songId {
    final $$SongsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableAnnotationComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FolderSongsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FolderSongsTable,
          FolderSong,
          $$FolderSongsTableFilterComposer,
          $$FolderSongsTableOrderingComposer,
          $$FolderSongsTableAnnotationComposer,
          $$FolderSongsTableCreateCompanionBuilder,
          $$FolderSongsTableUpdateCompanionBuilder,
          (FolderSong, $$FolderSongsTableReferences),
          FolderSong,
          PrefetchHooks Function({bool folderId, bool songId})
        > {
  $$FolderSongsTableTableManager(_$AppDatabase db, $FolderSongsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FolderSongsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FolderSongsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FolderSongsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> folderId = const Value.absent(),
                Value<int> songId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FolderSongsCompanion(
                folderId: folderId,
                songId: songId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int folderId,
                required int songId,
                Value<int> rowid = const Value.absent(),
              }) => FolderSongsCompanion.insert(
                folderId: folderId,
                songId: songId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FolderSongsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({folderId = false, songId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (folderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.folderId,
                                referencedTable: $$FolderSongsTableReferences
                                    ._folderIdTable(db),
                                referencedColumn: $$FolderSongsTableReferences
                                    ._folderIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (songId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.songId,
                                referencedTable: $$FolderSongsTableReferences
                                    ._songIdTable(db),
                                referencedColumn: $$FolderSongsTableReferences
                                    ._songIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FolderSongsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FolderSongsTable,
      FolderSong,
      $$FolderSongsTableFilterComposer,
      $$FolderSongsTableOrderingComposer,
      $$FolderSongsTableAnnotationComposer,
      $$FolderSongsTableCreateCompanionBuilder,
      $$FolderSongsTableUpdateCompanionBuilder,
      (FolderSong, $$FolderSongsTableReferences),
      FolderSong,
      PrefetchHooks Function({bool folderId, bool songId})
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      Value<int> id,
      required String name,
      Value<int> color,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> color,
    });

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, Tag> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SongTagsTable, List<SongTag>> _songTagsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.songTags,
    aliasName: $_aliasNameGenerator(db.tags.id, db.songTags.tagId),
  );

  $$SongTagsTableProcessedTableManager get songTagsRefs {
    final manager = $$SongTagsTableTableManager(
      $_db,
      $_db.songTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_songTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> songTagsRefs(
    Expression<bool> Function($$SongTagsTableFilterComposer f) f,
  ) {
    final $$SongTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.songTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongTagsTableFilterComposer(
            $db: $db,
            $table: $db.songTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  Expression<T> songTagsRefs<T extends Object>(
    Expression<T> Function($$SongTagsTableAnnotationComposer a) f,
  ) {
    final $$SongTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.songTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.songTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, $$TagsTableReferences),
          Tag,
          PrefetchHooks Function({bool songTagsRefs})
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> color = const Value.absent(),
              }) => TagsCompanion(id: id, name: name, color: color),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> color = const Value.absent(),
              }) => TagsCompanion.insert(id: id, name: name, color: color),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TagsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({songTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (songTagsRefs) db.songTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (songTagsRefs)
                    await $_getPrefetchedData<Tag, $TagsTable, SongTag>(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences._songTagsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$TagsTableReferences(db, table, p0).songTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, $$TagsTableReferences),
      Tag,
      PrefetchHooks Function({bool songTagsRefs})
    >;
typedef $$SongTagsTableCreateCompanionBuilder =
    SongTagsCompanion Function({
      required int songId,
      required int tagId,
      Value<int> rowid,
    });
typedef $$SongTagsTableUpdateCompanionBuilder =
    SongTagsCompanion Function({
      Value<int> songId,
      Value<int> tagId,
      Value<int> rowid,
    });

final class $$SongTagsTableReferences
    extends BaseReferences<_$AppDatabase, $SongTagsTable, SongTag> {
  $$SongTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SongsTable _songIdTable(_$AppDatabase db) => db.songs.createAlias(
    $_aliasNameGenerator(db.songTags.songId, db.songs.id),
  );

  $$SongsTableProcessedTableManager get songId {
    final $_column = $_itemColumn<int>('song_id')!;

    final manager = $$SongsTableTableManager(
      $_db,
      $_db.songs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_songIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) =>
      db.tags.createAlias($_aliasNameGenerator(db.songTags.tagId, db.tags.id));

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SongTagsTableFilterComposer
    extends Composer<_$AppDatabase, $SongTagsTable> {
  $$SongTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$SongsTableFilterComposer get songId {
    final $$SongsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableFilterComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SongTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $SongTagsTable> {
  $$SongTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$SongsTableOrderingComposer get songId {
    final $$SongsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableOrderingComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SongTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SongTagsTable> {
  $$SongTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$SongsTableAnnotationComposer get songId {
    final $$SongsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableAnnotationComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SongTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SongTagsTable,
          SongTag,
          $$SongTagsTableFilterComposer,
          $$SongTagsTableOrderingComposer,
          $$SongTagsTableAnnotationComposer,
          $$SongTagsTableCreateCompanionBuilder,
          $$SongTagsTableUpdateCompanionBuilder,
          (SongTag, $$SongTagsTableReferences),
          SongTag,
          PrefetchHooks Function({bool songId, bool tagId})
        > {
  $$SongTagsTableTableManager(_$AppDatabase db, $SongTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SongTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SongTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SongTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> songId = const Value.absent(),
                Value<int> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  SongTagsCompanion(songId: songId, tagId: tagId, rowid: rowid),
          createCompanionCallback:
              ({
                required int songId,
                required int tagId,
                Value<int> rowid = const Value.absent(),
              }) => SongTagsCompanion.insert(
                songId: songId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SongTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({songId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (songId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.songId,
                                referencedTable: $$SongTagsTableReferences
                                    ._songIdTable(db),
                                referencedColumn: $$SongTagsTableReferences
                                    ._songIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable: $$SongTagsTableReferences
                                    ._tagIdTable(db),
                                referencedColumn: $$SongTagsTableReferences
                                    ._tagIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SongTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SongTagsTable,
      SongTag,
      $$SongTagsTableFilterComposer,
      $$SongTagsTableOrderingComposer,
      $$SongTagsTableAnnotationComposer,
      $$SongTagsTableCreateCompanionBuilder,
      $$SongTagsTableUpdateCompanionBuilder,
      (SongTag, $$SongTagsTableReferences),
      SongTag,
      PrefetchHooks Function({bool songId, bool tagId})
    >;
typedef $$SetlistsTableCreateCompanionBuilder =
    SetlistsCompanion Function({
      Value<int> id,
      required String name,
      Value<String> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$SetlistsTableUpdateCompanionBuilder =
    SetlistsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$SetlistsTableReferences
    extends BaseReferences<_$AppDatabase, $SetlistsTable, Setlist> {
  $$SetlistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SetlistItemsTable, List<SetlistItem>>
  _setlistItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.setlistItems,
    aliasName: $_aliasNameGenerator(db.setlists.id, db.setlistItems.setlistId),
  );

  $$SetlistItemsTableProcessedTableManager get setlistItemsRefs {
    final manager = $$SetlistItemsTableTableManager(
      $_db,
      $_db.setlistItems,
    ).filter((f) => f.setlistId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_setlistItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SetlistsTableFilterComposer
    extends Composer<_$AppDatabase, $SetlistsTable> {
  $$SetlistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> setlistItemsRefs(
    Expression<bool> Function($$SetlistItemsTableFilterComposer f) f,
  ) {
    final $$SetlistItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setlistItems,
      getReferencedColumn: (t) => t.setlistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetlistItemsTableFilterComposer(
            $db: $db,
            $table: $db.setlistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SetlistsTableOrderingComposer
    extends Composer<_$AppDatabase, $SetlistsTable> {
  $$SetlistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SetlistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetlistsTable> {
  $$SetlistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> setlistItemsRefs<T extends Object>(
    Expression<T> Function($$SetlistItemsTableAnnotationComposer a) f,
  ) {
    final $$SetlistItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.setlistItems,
      getReferencedColumn: (t) => t.setlistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetlistItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.setlistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SetlistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SetlistsTable,
          Setlist,
          $$SetlistsTableFilterComposer,
          $$SetlistsTableOrderingComposer,
          $$SetlistsTableAnnotationComposer,
          $$SetlistsTableCreateCompanionBuilder,
          $$SetlistsTableUpdateCompanionBuilder,
          (Setlist, $$SetlistsTableReferences),
          Setlist,
          PrefetchHooks Function({bool setlistItemsRefs})
        > {
  $$SetlistsTableTableManager(_$AppDatabase db, $SetlistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetlistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetlistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetlistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => SetlistsCompanion(
                id: id,
                name: name,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => SetlistsCompanion.insert(
                id: id,
                name: name,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SetlistsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({setlistItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (setlistItemsRefs) db.setlistItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (setlistItemsRefs)
                    await $_getPrefetchedData<
                      Setlist,
                      $SetlistsTable,
                      SetlistItem
                    >(
                      currentTable: table,
                      referencedTable: $$SetlistsTableReferences
                          ._setlistItemsRefsTable(db),
                      managerFromTypedResult: (p0) => $$SetlistsTableReferences(
                        db,
                        table,
                        p0,
                      ).setlistItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.setlistId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SetlistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SetlistsTable,
      Setlist,
      $$SetlistsTableFilterComposer,
      $$SetlistsTableOrderingComposer,
      $$SetlistsTableAnnotationComposer,
      $$SetlistsTableCreateCompanionBuilder,
      $$SetlistsTableUpdateCompanionBuilder,
      (Setlist, $$SetlistsTableReferences),
      Setlist,
      PrefetchHooks Function({bool setlistItemsRefs})
    >;
typedef $$SetlistItemsTableCreateCompanionBuilder =
    SetlistItemsCompanion Function({
      Value<int> id,
      required int setlistId,
      required int songId,
      required double position,
    });
typedef $$SetlistItemsTableUpdateCompanionBuilder =
    SetlistItemsCompanion Function({
      Value<int> id,
      Value<int> setlistId,
      Value<int> songId,
      Value<double> position,
    });

final class $$SetlistItemsTableReferences
    extends BaseReferences<_$AppDatabase, $SetlistItemsTable, SetlistItem> {
  $$SetlistItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SetlistsTable _setlistIdTable(_$AppDatabase db) =>
      db.setlists.createAlias(
        $_aliasNameGenerator(db.setlistItems.setlistId, db.setlists.id),
      );

  $$SetlistsTableProcessedTableManager get setlistId {
    final $_column = $_itemColumn<int>('setlist_id')!;

    final manager = $$SetlistsTableTableManager(
      $_db,
      $_db.setlists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_setlistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SongsTable _songIdTable(_$AppDatabase db) => db.songs.createAlias(
    $_aliasNameGenerator(db.setlistItems.songId, db.songs.id),
  );

  $$SongsTableProcessedTableManager get songId {
    final $_column = $_itemColumn<int>('song_id')!;

    final manager = $$SongsTableTableManager(
      $_db,
      $_db.songs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_songIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SetlistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SetlistItemsTable> {
  $$SetlistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  $$SetlistsTableFilterComposer get setlistId {
    final $$SetlistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.setlistId,
      referencedTable: $db.setlists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetlistsTableFilterComposer(
            $db: $db,
            $table: $db.setlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SongsTableFilterComposer get songId {
    final $$SongsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableFilterComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetlistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SetlistItemsTable> {
  $$SetlistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  $$SetlistsTableOrderingComposer get setlistId {
    final $$SetlistsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.setlistId,
      referencedTable: $db.setlists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetlistsTableOrderingComposer(
            $db: $db,
            $table: $db.setlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SongsTableOrderingComposer get songId {
    final $$SongsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableOrderingComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetlistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetlistItemsTable> {
  $$SetlistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  $$SetlistsTableAnnotationComposer get setlistId {
    final $$SetlistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.setlistId,
      referencedTable: $db.setlists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SetlistsTableAnnotationComposer(
            $db: $db,
            $table: $db.setlists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SongsTableAnnotationComposer get songId {
    final $$SongsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableAnnotationComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SetlistItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SetlistItemsTable,
          SetlistItem,
          $$SetlistItemsTableFilterComposer,
          $$SetlistItemsTableOrderingComposer,
          $$SetlistItemsTableAnnotationComposer,
          $$SetlistItemsTableCreateCompanionBuilder,
          $$SetlistItemsTableUpdateCompanionBuilder,
          (SetlistItem, $$SetlistItemsTableReferences),
          SetlistItem,
          PrefetchHooks Function({bool setlistId, bool songId})
        > {
  $$SetlistItemsTableTableManager(_$AppDatabase db, $SetlistItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetlistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetlistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetlistItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> setlistId = const Value.absent(),
                Value<int> songId = const Value.absent(),
                Value<double> position = const Value.absent(),
              }) => SetlistItemsCompanion(
                id: id,
                setlistId: setlistId,
                songId: songId,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int setlistId,
                required int songId,
                required double position,
              }) => SetlistItemsCompanion.insert(
                id: id,
                setlistId: setlistId,
                songId: songId,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SetlistItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({setlistId = false, songId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (setlistId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.setlistId,
                                referencedTable: $$SetlistItemsTableReferences
                                    ._setlistIdTable(db),
                                referencedColumn: $$SetlistItemsTableReferences
                                    ._setlistIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (songId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.songId,
                                referencedTable: $$SetlistItemsTableReferences
                                    ._songIdTable(db),
                                referencedColumn: $$SetlistItemsTableReferences
                                    ._songIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SetlistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SetlistItemsTable,
      SetlistItem,
      $$SetlistItemsTableFilterComposer,
      $$SetlistItemsTableOrderingComposer,
      $$SetlistItemsTableAnnotationComposer,
      $$SetlistItemsTableCreateCompanionBuilder,
      $$SetlistItemsTableUpdateCompanionBuilder,
      (SetlistItem, $$SetlistItemsTableReferences),
      SetlistItem,
      PrefetchHooks Function({bool setlistId, bool songId})
    >;
typedef $$AnnotationsTableCreateCompanionBuilder =
    AnnotationsCompanion Function({
      required int songId,
      required int page,
      required String data,
      Value<int> rowid,
    });
typedef $$AnnotationsTableUpdateCompanionBuilder =
    AnnotationsCompanion Function({
      Value<int> songId,
      Value<int> page,
      Value<String> data,
      Value<int> rowid,
    });

final class $$AnnotationsTableReferences
    extends BaseReferences<_$AppDatabase, $AnnotationsTable, Annotation> {
  $$AnnotationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SongsTable _songIdTable(_$AppDatabase db) => db.songs.createAlias(
    $_aliasNameGenerator(db.annotations.songId, db.songs.id),
  );

  $$SongsTableProcessedTableManager get songId {
    final $_column = $_itemColumn<int>('song_id')!;

    final manager = $$SongsTableTableManager(
      $_db,
      $_db.songs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_songIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnnotationsTableFilterComposer
    extends Composer<_$AppDatabase, $AnnotationsTable> {
  $$AnnotationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  $$SongsTableFilterComposer get songId {
    final $$SongsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableFilterComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnotationsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnnotationsTable> {
  $$AnnotationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  $$SongsTableOrderingComposer get songId {
    final $$SongsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableOrderingComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnotationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnnotationsTable> {
  $$AnnotationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  $$SongsTableAnnotationComposer get songId {
    final $$SongsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableAnnotationComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnnotationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnnotationsTable,
          Annotation,
          $$AnnotationsTableFilterComposer,
          $$AnnotationsTableOrderingComposer,
          $$AnnotationsTableAnnotationComposer,
          $$AnnotationsTableCreateCompanionBuilder,
          $$AnnotationsTableUpdateCompanionBuilder,
          (Annotation, $$AnnotationsTableReferences),
          Annotation,
          PrefetchHooks Function({bool songId})
        > {
  $$AnnotationsTableTableManager(_$AppDatabase db, $AnnotationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnnotationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnnotationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnnotationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> songId = const Value.absent(),
                Value<int> page = const Value.absent(),
                Value<String> data = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnnotationsCompanion(
                songId: songId,
                page: page,
                data: data,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int songId,
                required int page,
                required String data,
                Value<int> rowid = const Value.absent(),
              }) => AnnotationsCompanion.insert(
                songId: songId,
                page: page,
                data: data,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AnnotationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({songId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (songId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.songId,
                                referencedTable: $$AnnotationsTableReferences
                                    ._songIdTable(db),
                                referencedColumn: $$AnnotationsTableReferences
                                    ._songIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AnnotationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnnotationsTable,
      Annotation,
      $$AnnotationsTableFilterComposer,
      $$AnnotationsTableOrderingComposer,
      $$AnnotationsTableAnnotationComposer,
      $$AnnotationsTableCreateCompanionBuilder,
      $$AnnotationsTableUpdateCompanionBuilder,
      (Annotation, $$AnnotationsTableReferences),
      Annotation,
      PrefetchHooks Function({bool songId})
    >;
typedef $$AudioClipsTableCreateCompanionBuilder =
    AudioClipsCompanion Function({
      Value<int> id,
      required int songId,
      required String title,
      required String fileName,
      Value<int?> page,
      Value<double?> left,
      Value<double?> top,
      Value<double?> right,
      Value<double?> bottom,
      required DateTime createdAt,
    });
typedef $$AudioClipsTableUpdateCompanionBuilder =
    AudioClipsCompanion Function({
      Value<int> id,
      Value<int> songId,
      Value<String> title,
      Value<String> fileName,
      Value<int?> page,
      Value<double?> left,
      Value<double?> top,
      Value<double?> right,
      Value<double?> bottom,
      Value<DateTime> createdAt,
    });

final class $$AudioClipsTableReferences
    extends BaseReferences<_$AppDatabase, $AudioClipsTable, AudioClip> {
  $$AudioClipsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SongsTable _songIdTable(_$AppDatabase db) => db.songs.createAlias(
    $_aliasNameGenerator(db.audioClips.songId, db.songs.id),
  );

  $$SongsTableProcessedTableManager get songId {
    final $_column = $_itemColumn<int>('song_id')!;

    final manager = $$SongsTableTableManager(
      $_db,
      $_db.songs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_songIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AudioClipsTableFilterComposer
    extends Composer<_$AppDatabase, $AudioClipsTable> {
  $$AudioClipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get left => $composableBuilder(
    column: $table.left,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get top => $composableBuilder(
    column: $table.top,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get right => $composableBuilder(
    column: $table.right,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bottom => $composableBuilder(
    column: $table.bottom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SongsTableFilterComposer get songId {
    final $$SongsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableFilterComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AudioClipsTableOrderingComposer
    extends Composer<_$AppDatabase, $AudioClipsTable> {
  $$AudioClipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get page => $composableBuilder(
    column: $table.page,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get left => $composableBuilder(
    column: $table.left,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get top => $composableBuilder(
    column: $table.top,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get right => $composableBuilder(
    column: $table.right,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bottom => $composableBuilder(
    column: $table.bottom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SongsTableOrderingComposer get songId {
    final $$SongsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableOrderingComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AudioClipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AudioClipsTable> {
  $$AudioClipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<int> get page =>
      $composableBuilder(column: $table.page, builder: (column) => column);

  GeneratedColumn<double> get left =>
      $composableBuilder(column: $table.left, builder: (column) => column);

  GeneratedColumn<double> get top =>
      $composableBuilder(column: $table.top, builder: (column) => column);

  GeneratedColumn<double> get right =>
      $composableBuilder(column: $table.right, builder: (column) => column);

  GeneratedColumn<double> get bottom =>
      $composableBuilder(column: $table.bottom, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SongsTableAnnotationComposer get songId {
    final $$SongsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.songId,
      referencedTable: $db.songs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SongsTableAnnotationComposer(
            $db: $db,
            $table: $db.songs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AudioClipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AudioClipsTable,
          AudioClip,
          $$AudioClipsTableFilterComposer,
          $$AudioClipsTableOrderingComposer,
          $$AudioClipsTableAnnotationComposer,
          $$AudioClipsTableCreateCompanionBuilder,
          $$AudioClipsTableUpdateCompanionBuilder,
          (AudioClip, $$AudioClipsTableReferences),
          AudioClip,
          PrefetchHooks Function({bool songId})
        > {
  $$AudioClipsTableTableManager(_$AppDatabase db, $AudioClipsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AudioClipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AudioClipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AudioClipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> songId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<int?> page = const Value.absent(),
                Value<double?> left = const Value.absent(),
                Value<double?> top = const Value.absent(),
                Value<double?> right = const Value.absent(),
                Value<double?> bottom = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AudioClipsCompanion(
                id: id,
                songId: songId,
                title: title,
                fileName: fileName,
                page: page,
                left: left,
                top: top,
                right: right,
                bottom: bottom,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int songId,
                required String title,
                required String fileName,
                Value<int?> page = const Value.absent(),
                Value<double?> left = const Value.absent(),
                Value<double?> top = const Value.absent(),
                Value<double?> right = const Value.absent(),
                Value<double?> bottom = const Value.absent(),
                required DateTime createdAt,
              }) => AudioClipsCompanion.insert(
                id: id,
                songId: songId,
                title: title,
                fileName: fileName,
                page: page,
                left: left,
                top: top,
                right: right,
                bottom: bottom,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AudioClipsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({songId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (songId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.songId,
                                referencedTable: $$AudioClipsTableReferences
                                    ._songIdTable(db),
                                referencedColumn: $$AudioClipsTableReferences
                                    ._songIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AudioClipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AudioClipsTable,
      AudioClip,
      $$AudioClipsTableFilterComposer,
      $$AudioClipsTableOrderingComposer,
      $$AudioClipsTableAnnotationComposer,
      $$AudioClipsTableCreateCompanionBuilder,
      $$AudioClipsTableUpdateCompanionBuilder,
      (AudioClip, $$AudioClipsTableReferences),
      AudioClip,
      PrefetchHooks Function({bool songId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SongsTableTableManager get songs =>
      $$SongsTableTableManager(_db, _db.songs);
  $$FoldersTableTableManager get folders =>
      $$FoldersTableTableManager(_db, _db.folders);
  $$FolderSongsTableTableManager get folderSongs =>
      $$FolderSongsTableTableManager(_db, _db.folderSongs);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$SongTagsTableTableManager get songTags =>
      $$SongTagsTableTableManager(_db, _db.songTags);
  $$SetlistsTableTableManager get setlists =>
      $$SetlistsTableTableManager(_db, _db.setlists);
  $$SetlistItemsTableTableManager get setlistItems =>
      $$SetlistItemsTableTableManager(_db, _db.setlistItems);
  $$AnnotationsTableTableManager get annotations =>
      $$AnnotationsTableTableManager(_db, _db.annotations);
  $$AudioClipsTableTableManager get audioClips =>
      $$AudioClipsTableTableManager(_db, _db.audioClips);
}
