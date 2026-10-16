import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:image/image.dart' as img;
import 'package:music_sheets/data/db.dart';
import 'package:music_sheets/data/providers.dart';
import 'package:music_sheets/services/metadata/cover_art.dart';
import 'package:music_sheets/services/metadata/lookup_runner.dart';
import 'package:music_sheets/services/metadata/lookup_service.dart';
import 'package:music_sheets/services/metadata/matcher.dart';
import 'package:music_sheets/services/metadata/models.dart';
import 'package:music_sheets/services/metadata/musicbrainz_client.dart';
import 'package:music_sheets/services/metadata/pdf_header.dart';
import 'package:music_sheets/services/metadata/query_builder.dart';
import 'package:music_sheets/services/metadata/rate_limiter.dart';
import 'package:music_sheets/services/metadata/tempo_key_client.dart';

Candidate cand(String title, String artist, {int score = 100, int? year, bool official = true, String id = ''}) =>
    Candidate(recordingId: id.isEmpty ? '$artist-$title-$year' : id, title: title, artist: artist, score: score, year: year, official: official);

void main() {
  group('query builder', () {
    test('strips noise words and brackets', () {
      expect(cleanTitle('bohemian rhapsody final v2'), 'bohemian rhapsody');
      expect(cleanTitle('Autumn Leaves (Real Book) piano'), 'Autumn Leaves');
      expect(cleanTitle('Fly Me To The Moon [copy]'), 'Fly Me To The Moon');
    });

    test('strips German instrument words', () {
      expect(cleanTitle('Comatose - Gitarre'), 'Comatose');
      expect(cleanTitle('Still Waiting - Gitarre'), 'Still Waiting');
      expect(queriesFromTitle('Comatose - Gitarre'), [const SearchQuery('Comatose')]);
      expect(cleanTitle('Schlagzeug Noten Hallelujah'), 'Hallelujah');
    });

    test('keeps the plain title as the last query', () {
      expect(queriesFromTitle('Autumn Leaves'), [const SearchQuery('Autumn Leaves')]);
    });

    test('tries both orders for "A - B"', () {
      expect(queriesFromTitle('Queen - Bohemian Rhapsody'), [
        const SearchQuery('Bohemian Rhapsody', artist: 'Queen'),
        const SearchQuery('Queen', artist: 'Bohemian Rhapsody'),
        const SearchQuery('Queen - Bohemian Rhapsody'),
      ]);
    });

    test('nothing left after cleaning gives no query', () {
      expect(queriesFromTitle('final v2 (copy)'), isEmpty);
    });
  });

  group('pdf header', () {
    HeaderLine l(String t, double x, double y, double w, double h) => HeaderLine(t, x, y, w, h);

    // Layout measured from a real MuseScore export (A4, 595 x 842 pt).
    final museScore = [
      l('Gitarre', 36, 36, 31, 11),
      l('Still Wating', 246, 39, 96, 22),
      l('Sum 41', 525, 69, 34, 11),
      l('Str', 29, 198, 14, 11),
      l('Chorus', 19, 324, 34, 11),
    ];

    test('title is the tallest line, artist the right-aligned one below it', () {
      final h = parseHeader(museScore, pageWidth: 595, pageHeight: 842)!;
      expect(h.title, 'Still Wating');
      expect(h.artist, 'Sum 41');
    });

    test('part names and section labels are not mistaken for the artist', () {
      final h = parseHeader([
        l('Gitarre', 36, 36, 31, 11),
        l('Comatose', 249, 40, 96, 24),
        l('Str', 29, 198, 14, 11),
      ], pageWidth: 595, pageHeight: 842)!;
      expect(h.title, 'Comatose');
      expect(h.artist, isNull);
    });

    test('credit prefixes and arranger lines are handled', () {
      final h = parseHeader([
        l('Autumn Leaves', 230, 40, 130, 24),
        l('Arr. J. Smith', 500, 62, 60, 10),
        l('Music by Joseph Kosma', 440, 74, 120, 10),
      ], pageWidth: 595, pageHeight: 842)!;
      expect(h.artist, 'Joseph Kosma');
    });

    test('text in the body of the page is ignored, and nothing found gives null', () {
      expect(parseHeader([l('Some long text far below', 250, 500, 90, 24)], pageWidth: 595, pageHeight: 842), isNull);
      expect(parseHeader(const [], pageWidth: 595, pageHeight: 842), isNull);
    });
  });

  group('lookup queries', () {
    const header = PdfHeader(title: 'Still Wating', artist: 'Sum 41');

    test('printed artist is paired with the file-name title first, typo-proof', () {
      final q = LookupService.buildQueries('Still Waiting - Gitarre', header);
      expect(q.first, const SearchQuery('Still Waiting', artist: 'Sum 41'));
      expect(q, contains(const SearchQuery('Still Wating', artist: 'Sum 41')));
      expect(q.last, const SearchQuery('Still Wating'));
    });

    test('an artist in the file name wins over the printed one', () {
      final q = LookupService.buildQueries('Queen - Bohemian Rhapsody', header);
      expect(q.first, const SearchQuery('Bohemian Rhapsody', artist: 'Queen'));
    });

    test('without a header it is just the file name', () {
      expect(LookupService.buildQueries('Autumn Leaves', null), [const SearchQuery('Autumn Leaves')]);
    });
  });

  group('matcher', () {
    test('a guest credit still matches the artist', () {
      expect(artistMatches('Skillet', 'Skillet feat. Someone'), isTrue);
      expect(artistMatches('Skillet', 'Sum 41'), isFalse);
    });

    test('similarity ignores case, accents and word order', () {
      expect(similarity('Café Del Mar', 'cafe del mar'), 1);
      expect(similarity('Autumn Leaves', 'Leaves Autumn'), 1);
      expect(similarity('Autumn Leaves', 'Winter Leaves'), lessThan(closeTitle));
    });

    test('artist in the query that matches is strong', () {
      final d = decide(const SearchQuery('Bohemian Rhapsody', artist: 'Queen'),
          [cand('Bohemian Rhapsody', 'Queen', year: 1975), cand('Bohemian Rhapsody', 'Panic! at the Disco', year: 2016)]);
      expect(d.best?.artist, 'Queen');
    });

    test('a different artist in the query goes to review', () {
      final d = decide(const SearchQuery('Bohemian Rhapsody', artist: 'Abba'), [cand('Bohemian Rhapsody', 'Queen', year: 1975)]);
      expect(d.isStrong, isFalse);
      expect(d.review, hasLength(1));
    });

    test('one artist only is strong, earliest official release wins', () {
      final d = decide(const SearchQuery('Imagine'),
          [cand('Imagine', 'John Lennon', year: 1988, id: 'b'), cand('Imagine', 'John Lennon', year: 1971, id: 'a')]);
      expect(d.best?.recordingId, 'a');
    });

    test('many artists without a clear leader go to review', () {
      final d = decide(const SearchQuery('Autumn Leaves'), [
        cand('Autumn Leaves', 'Jacintha', year: 1999),
        cand('Autumn Leaves', 'Sonny Stitt', year: 1991),
        cand('Autumn Leaves', 'David Osborne'),
      ]);
      expect(d.isStrong, isFalse);
      expect(d.review.map((c) => c.artist), containsAll(['Jacintha', 'Sonny Stitt', 'David Osborne']));
    });

    test('an artist with clearly the most recordings leads', () {
      final d = decide(const SearchQuery('Yesterday'), [
        for (var i = 0; i < 6; i++) cand('Yesterday', 'The Beatles', year: 1965 + i, id: 'b$i'),
        cand('Yesterday', 'Boyz II Men', year: 1991),
      ]);
      expect(d.best?.artist, 'The Beatles');
    });

    test('live, karaoke and unrelated titles are ignored', () {
      expect(decide(const SearchQuery('Imagine'), [cand('Imagine', 'X', official: false)]).isEmpty, isTrue);
      expect(decide(const SearchQuery('Imagine'), [cand('Something else entirely', 'X')]).isEmpty, isTrue);
    });
  });

  group('musicbrainz parsing', () {
    final json = {
      'recordings': [
        {
          'id': 'r1',
          'score': '100',
          'title': 'Autumn Leaves',
          'artist-credit': [
            {'name': 'Sonny Stitt', 'joinphrase': ' & ', 'artist': {'name': 'Sonny Stitt'}},
            {'name': 'Zimbo Trio', 'artist': {'name': 'Zimbo Trio'}},
          ],
          'first-release-date': '1990',
          'releases': [
            {'title': 'Live in Paris', 'status': 'Official', 'date': '1980', 'release-group': {'id': 'g0', 'primary-type': 'Album', 'secondary-types': ['Live']}},
            {'title': 'Bootleg', 'status': 'Bootleg', 'date': '1970', 'release-group': {'id': 'gx', 'primary-type': 'Album'}},
            {'title': 'In Brasil', 'status': 'Official', 'date': '1991-05', 'release-group': {'id': 'g1', 'primary-type': 'Album'}},
            {'title': 'Greatest Hits', 'status': 'Official', 'date': '2005', 'release-group': {'id': 'g2', 'primary-type': 'Album', 'secondary-types': ['Compilation']}},
          ],
        },
        {'id': 'r2', 'score': '90', 'title': 'No artist', 'artist-credit': []},
      ],
    };

    test('picks the earliest official studio release and joins artists', () {
      final list = MusicBrainzClient.parseRecordings(json);
      expect(list, hasLength(1));
      expect(list.single.artist, 'Sonny Stitt & Zimbo Trio');
      expect(list.single.year, 1991);
      expect(list.single.album, 'In Brasil');
      expect(list.single.releaseGroupId, 'g1');
      expect(list.single.official, isTrue);
    });

    test('a recording only on live or compilation releases is not official', () {
      final live = {
        'recordings': [
          {
            'id': 'r',
            'score': '100',
            'title': 'T',
            'artist-credit': [{'name': 'A'}],
            'releases': [
              {'title': 'L', 'status': 'Official', 'date': '1999', 'release-group': {'id': 'g', 'primary-type': 'Album', 'secondary-types': ['Live']}},
            ],
          },
        ],
      };
      expect(MusicBrainzClient.parseRecordings(live).single.official, isFalse);
    });
  });

  group('tempo and key', () {
    const id = 'rec-1';
    Map<String, dynamic> ab({num bpm = 172.27, String key = 'F', String scale = 'minor', num strength = 0.45}) => {
          id: {'0': {'rhythm': {'bpm': bpm}, 'tonal': {'key_key': key, 'key_scale': scale, 'key_strength': strength}}},
        };

    test('AcousticBrainz gives a rounded tempo and a shorthand key', () {
      final kt = TempoKeyClient.parseAcousticBrainz(ab(), id);
      expect((kt.key, kt.tempo), ('Fm', 172));
      expect(TempoKeyClient.parseAcousticBrainz(ab(key: 'C#', scale: 'major'), id).key, 'C#');
    });

    test('a weak key estimate is dropped but the tempo stays', () {
      final kt = TempoKeyClient.parseAcousticBrainz(ab(strength: 0.1), id);
      expect((kt.key, kt.tempo), (null, 172));
    });

    test('no entry gives nothing', () {
      expect(TempoKeyClient.parseAcousticBrainz({}, id).isEmpty, isTrue);
      expect(TempoKeyClient.parseAcousticBrainz(null, id).isEmpty, isTrue);
    });

    Future<KeyAndTempo> run(Map<String, dynamic> abBody, {Map<String, dynamic>? deezerSearch, Map<String, dynamic>? deezerTrack}) {
      final client = TempoKeyClient(MockClient((r) async {
        if (r.url.host == 'acousticbrainz.org') return http.Response(jsonEncode(abBody), 200);
        if (r.url.path.endsWith('/search')) return http.Response(jsonEncode(deezerSearch ?? {'data': []}), 200);
        return http.Response(jsonEncode(deezerTrack ?? {}), 200);
      }));
      return client.lookup(id, 'Still Waiting', 'Sum 41');
    }

    Map<String, dynamic> hit(String title, String artist, int trackId) => {'id': trackId, 'title': title, 'artist': {'name': artist}};

    test('Deezer fills the tempo when AcousticBrainz has nothing, and the studio track wins over live', () async {
      final kt = await run({}, deezerSearch: {
        'data': [hit('Still Waiting (Live At The House Of Blues)', 'Sum 41', 1), hit('Still Waiting', 'Sum 41', 2)],
      }, deezerTrack: {'bpm': 95.9});
      expect(kt.tempo, 96);
      expect(kt.key, isNull);
    });

    test('Deezer ignores other artists and a zero tempo', () async {
      expect((await run({}, deezerSearch: {'data': [hit('Still Waiting', 'Cover Band', 1)]}, deezerTrack: {'bpm': 90})).tempo, isNull);
      expect((await run({}, deezerSearch: {'data': [hit('Still Waiting', 'Sum 41', 1)]}, deezerTrack: {'bpm': 0})).tempo, isNull);
    });

    test('Deezer is only asked when AcousticBrainz has no tempo', () async {
      var deezerCalled = false;
      final client = TempoKeyClient(MockClient((r) async {
        if (r.url.host == 'api.deezer.com') deezerCalled = true;
        return http.Response(jsonEncode(ab()), 200);
      }));
      expect((await client.lookup(id, 'T', 'A')).tempo, 172);
      expect(deezerCalled, isFalse);
    });

    test('server trouble is a temporary error', () async {
      final client = TempoKeyClient(MockClient((_) async => http.Response('busy', 503)));
      expect(client.lookup(id, 'T', 'A'), throwsA(isA<TemporaryLookupError>()));
    });
  });

  group('rate limiter', () {
    test('spaces calls by the gap', () async {
      var clock = DateTime(2026);
      final slept = <Duration>[];
      final limiter = RateLimiter(const Duration(seconds: 1), now: () => clock, sleep: (d) async {
        slept.add(d);
        clock = clock.add(d);
      });
      await limiter.wait();
      await limiter.wait();
      await limiter.wait();
      expect(slept, [const Duration(seconds: 1), const Duration(seconds: 1)]);
    });
  });

  group('backoff', () {
    test('grows and parks after five attempts', () {
      expect(backoffFor(1), const Duration(minutes: 1));
      expect(backoffFor(2), const Duration(minutes: 10));
      expect(backoffFor(3), const Duration(hours: 1));
      expect(backoffFor(4), const Duration(hours: 6));
      expect(backoffFor(5), isNull);
    });
  });

  group('applyMatch', () {
    Song base({String title = 'autumn leaves', String? importTitle = 'autumn leaves', String composer = '', String key = '', int? tempo}) => Song(
          id: 1,
          title: title,
          composer: composer,
          instrument: '',
          musicalKey: key,
          tempo: tempo,
          notes: '',
          fileName: 'a.pdf',
          fileHash: 'h',
          pageCount: 1,
          createdAt: DateTime(2026),
          openCount: 0,
          lastPage: 0,
          artist: '',
          genre: '',
          album: '',
          importTitle: importTitle,
          lookupStatus: 'pending',
          lookupAttempts: 0,
        );
    final match = MatchResult(
      candidate: cand('Autumn Leaves', 'Sonny Stitt', year: 1991),
      composer: 'Joseph Kosma',
      genre: 'jazz',
      keyAndTempo: const KeyAndTempo(key: 'Gm', tempo: 110),
    );

    test('fills empty fields and renames an untouched title on a strong match', () {
      final c = applyMatch(base(), match, strong: true);
      expect(c.title.value, 'Autumn Leaves');
      expect(c.composer.value, 'Joseph Kosma');
      expect(c.musicalKey.value, 'Gm');
      expect(c.tempo.value, 110);
      expect(c.year.value, 1991);
    });

    test('never overwrites what is already there', () {
      final c = applyMatch(base(composer: 'Me', key: 'C', tempo: 90), match, strong: true);
      expect(c.composer.present, isFalse);
      expect(c.musicalKey.present, isFalse);
      expect(c.tempo.present, isFalse);
    });

    test('keeps an edited title, a picked match, and pre-feature songs', () {
      expect(applyMatch(base(title: 'My own name'), match, strong: true).title.present, isFalse);
      expect(applyMatch(base(), match, strong: false).title.present, isFalse);
      expect(applyMatch(base(importTitle: null), match, strong: true).title.present, isFalse);
    });
  });

  group('lookup service', () {
    late AppDatabase db;
    late Directory dir;
    late AppPaths paths;
    final now = DateTime(2026, 10, 15, 12);

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      dir = Directory.systemTemp.createTempSync('lookup_test');
      paths = AppPaths(root: dir.path, cache: dir.path);
      Directory(paths.libraryDir).createSync(recursive: true);
    });
    tearDown(() async {
      await db.close();
      dir.deleteSync(recursive: true);
    });

    Future<int> addSong(String title, {bool withImportTitle = true}) => db.insertSong(SongsCompanion.insert(
          title: title,
          fileName: '$title.pdf',
          fileHash: title,
          createdAt: now,
          importTitle: Value(withImportTitle ? title : null),
        ));

    LookupService service(Future<http.Response> Function(http.Request) handler, {PdfHeader? header}) {
      final client = MockClient(handler);
      return LookupService(db, paths,
          musicBrainz: MusicBrainzClient(client, limiter: RateLimiter(Duration.zero)),
          tempoKey: TempoKeyClient(client),
          covers: CoverArtService(client),
          readHeader: (_) async => header,
          now: () => now);
    }

    http.Response json(Object body, [int status = 200]) => http.Response(jsonEncode(body), status, headers: {'content-type': 'application/json'});

    Map<String, dynamic> recording(String id, String title, String artist, {String date = '1975'}) => {
          'id': id,
          'score': '100',
          'title': title,
          'artist-credit': [{'name': artist}],
          'releases': [
            {'title': 'Album', 'status': 'Official', 'date': date, 'release-group': {'id': 'rg-$id', 'primary-type': 'Album'}},
          ],
        };

    Future<http.Response> happy(http.Request r) async {
      final path = r.url.path;
      if (path.endsWith('/recording') && r.url.host == 'musicbrainz.org') {
        return json({'recordings': [recording('r1', 'Bohemian Rhapsody', 'Queen')]});
      }
      if (path.contains('/recording/r1')) {
        return json({'genres': [{'name': 'rock', 'count': 3}], 'relations': [{'work': {'id': 'w1'}}]});
      }
      if (path.contains('/work/w1')) {
        return json({'relations': [{'type': 'composer', 'artist': {'name': 'Freddie Mercury'}}]});
      }
      if (r.url.host == 'acousticbrainz.org') {
        return json({'r1': {'0': {'rhythm': {'bpm': 71.6}, 'tonal': {'key_key': 'Bb', 'key_scale': 'major', 'key_strength': 0.6}}}});
      }
      if (r.url.host == 'coverartarchive.org') return http.Response('not an image', 404);
      return http.Response('unexpected ${r.url}', 500);
    }

    test('strong match fills fields and renames the song', () async {
      final id = await addSong('bohemian rhapsody final');
      await service(happy).processNext();
      final s = (await db.songById(id))!;
      expect(s.lookupStatus, 'matched');
      expect(s.title, 'Bohemian Rhapsody');
      expect(s.composer, 'Freddie Mercury');
      expect(s.artist, 'Queen');
      expect(s.year, 1975);
      expect(s.genre, 'rock');
      expect(s.musicalKey, 'Bb');
      expect(s.tempo, 72);
      expect(s.mbRecordingId, 'r1');
      expect(s.coverFileName, isNull); // no cover available
    });

    test('a backfilled song keeps its title but gets the fields', () async {
      final id = await addSong('bohemian rhapsody', withImportTitle: false);
      await service(happy).processNext();
      final s = (await db.songById(id))!;
      expect(s.title, 'bohemian rhapsody');
      expect(s.composer, 'Freddie Mercury');
    });

    test('ambiguous results wait for review with candidates', () async {
      final id = await addSong('Autumn Leaves');
      await service((r) async => json({
            'recordings': [
              recording('a', 'Autumn Leaves', 'Jacintha'),
              recording('b', 'Autumn Leaves', 'Sonny Stitt'),
            ],
          })).processNext();
      final s = (await db.songById(id))!;
      expect(s.lookupStatus, 'needsReview');
      expect(Candidate.decodeList(s.lookupCandidates).map((c) => c.artist), containsAll(['Jacintha', 'Sonny Stitt']));
    });

    test('nothing found is final', () async {
      final id = await addSong('Obscure Original');
      await service((r) async => json({'recordings': []})).processNext();
      expect((await db.songById(id))!.lookupStatus, 'notFound');
    });

    test('uses the artist printed on the sheet to settle an ambiguous title', () async {
      final id = await addSong('Bohemian');
      final seen = <String>[];
      await service((r) async {
        if (r.url.queryParameters.containsKey('query')) {
          final q = r.url.queryParameters['query']!;
          seen.add(q);
          if (q.contains('Queen')) return json({'recordings': [recording('r1', 'Bohemian Rhapsody', 'Queen')]});
          return json({'recordings': [recording('a', 'Bohemian Rhapsody', 'Panic'), recording('b', 'Bohemian Rhapsody', 'Other')]});
        }
        return happy(r);
      }, header: const PdfHeader(title: 'Bohemian Rhapsody', artist: 'Queen')).processNext();
      expect(seen.first, contains('Queen'));
      final s = (await db.songById(id))!;
      expect(s.lookupStatus, 'matched');
      expect(s.artist, 'Queen');
    });

    test('a wrong printed artist does not hide the plain candidates', () async {
      final id = await addSong('Autumn Leaves');
      await service((r) async {
        final q = r.url.queryParameters['query'] ?? '';
        if (q.contains('artist:')) return json({'recordings': [recording('x', 'Autumn Leaves', 'Somebody Else')]});
        return json({'recordings': [recording('a', 'Autumn Leaves', 'Jacintha'), recording('b', 'Autumn Leaves', 'Sonny Stitt')]});
      }, header: const PdfHeader(title: 'Autumn Leaves', artist: 'Nobody')).processNext();
      final s = (await db.songById(id))!;
      expect(s.lookupStatus, 'needsReview');
      expect(Candidate.decodeList(s.lookupCandidates).map((c) => c.artist), containsAll(['Jacintha', 'Sonny Stitt']));
    });

    test('server trouble backs off, then parks the song as failed', () async {
      final id = await addSong('Anything');
      final svc = service((r) async => http.Response('busy', 503));
      await svc.processNext();
      var s = (await db.songById(id))!;
      expect((s.lookupStatus, s.lookupAttempts), ('pending', 1));
      expect(s.nextAttemptAt, now.add(const Duration(minutes: 1)));
      expect(await svc.processNext(), StepOutcome.waiting); // not due yet

      await db.updateSong(id, const SongsCompanion(lookupAttempts: Value(4), nextAttemptAt: Value(null)));
      await svc.processNext();
      s = (await db.songById(id))!;
      expect(s.lookupStatus, 'failed');
    });

    test('picking a candidate applies it without renaming', () async {
      final id = await addSong('bohemian rhapsody');
      await service(happy).applyCandidate(id, cand('Bohemian Rhapsody', 'Queen', year: 1975, id: 'r1'));
      final s = (await db.songById(id))!;
      expect(s.lookupStatus, 'matched');
      expect(s.title, 'bohemian rhapsody');
      expect(s.artist, 'Queen');
    });

    test('idle when the queue is empty, requeue puts songs back', () async {
      final svc = service(happy);
      expect(await svc.processNext(), StepOutcome.idle);
      final id = await addSong('x');
      await db.updateSong(id, const SongsCompanion(lookupStatus: Value('notFound')));
      expect(await svc.processNext(), StepOutcome.idle);
      await db.requeueSongs([id]);
      expect((await db.songById(id))!.lookupStatus, 'pending');
    });
  });

  group('database', () {
    test('a claimed song is not handed out again until its lease runs out', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final now = DateTime(2026, 10, 15, 12);
      final id = await db.insertSong(SongsCompanion.insert(title: 'a', fileName: 'a.pdf', fileHash: 'a', createdAt: now));
      expect((await db.claimNextDue(now))?.id, id);
      expect(await db.claimNextDue(now), isNull); // e.g. the other isolate
      expect((await db.claimNextDue(now.add(const Duration(minutes: 11))))?.id, id); // crashed run: lease expired
    });
  });

  group('restore', () {
    late AppDatabase db;
    late Directory dir;
    late AppPaths paths;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      dir = Directory.systemTemp.createTempSync('restore_test');
      paths = AppPaths(root: dir.path, cache: dir.path);
      Directory(paths.libraryDir).createSync(recursive: true);
    });
    tearDown(() async {
      await db.close();
      dir.deleteSync(recursive: true);
    });

    LookupService service(http.Client client) => LookupService(db, paths,
        musicBrainz: MusicBrainzClient(client, limiter: RateLimiter(Duration.zero)),
        tempoKey: TempoKeyClient(client),
        covers: CoverArtService(client));

    Future<int> matched(String name, {String? group, bool coverOnDisk = false}) async {
      final id = await db.insertSong(SongsCompanion.insert(title: name, fileName: '$name.pdf', fileHash: name, createdAt: DateTime(2026)));
      await db.updateSong(id, SongsCompanion(
        lookupStatus: const Value('matched'),
        coverFileName: Value('$name-cover.jpg'),
        mbReleaseGroupId: Value(group),
      ));
      if (coverOnDisk) File(paths.pdf('$name-cover.jpg')).writeAsBytesSync([1]);
      return id;
    }

    test('missing covers are downloaded again; matches stay as they were', () async {
      final png = Uint8List.fromList(img.encodePng(img.Image(width: 4, height: 4)));
      final asked = <String>[];
      final svc = service(MockClient((r) async {
        asked.add(r.url.path);
        return http.Response.bytes(png, 200);
      }));
      final a = await matched('a', group: 'rg-a');
      final b = await matched('b', group: 'rg-b', coverOnDisk: true);
      await svc.restoreMissingCovers();
      expect(File(paths.pdf('a-cover.jpg')).existsSync(), isTrue);
      expect(asked, ['/release-group/rg-a/front-500']);
      for (final id in [a, b]) {
        final s = (await db.songById(id))!;
        expect(s.lookupStatus, 'matched');
        expect(s.coverFileName, isNotNull);
      }
    });

    test('a song without a release group, or when offline, only loses the dangling reference', () async {
      final svc = service(MockClient((r) async => throw const SocketException('offline')));
      final a = await matched('a'); // no release group
      final b = await matched('b', group: 'rg-b');
      await svc.restoreMissingCovers();
      for (final id in [a, b]) {
        final s = (await db.songById(id))!;
        expect(s.lookupStatus, 'matched');
        expect(s.coverFileName, isNull);
      }
    });
  });

  group('runner', () {
    test('resumes when the network comes back', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final dir = Directory.systemTemp.createTempSync('runner_test');
      addTearDown(() => dir.deleteSync(recursive: true));
      final client = MockClient((r) async => http.Response('{"recordings":[]}', 200));
      final svc = LookupService(db, AppPaths(root: dir.path, cache: dir.path),
          musicBrainz: MusicBrainzClient(client, limiter: RateLimiter(Duration.zero)),
          tempoKey: TempoKeyClient(client),
          covers: CoverArtService(client),
          readHeader: (_) async => null);
      final id = await db.insertSong(SongsCompanion.insert(title: 'x', fileName: 'x.pdf', fileHash: 'x', createdAt: DateTime(2026)));
      var online = false;
      final runner = LookupRunner(svc, enabled: () => true, wifiOnly: () => true, network: (_) async => online);
      final changes = StreamController<List<ConnectivityResult>>();
      runner.watchConnectivity(changes: changes.stream);
      addTearDown(() async {
        runner.dispose();
        await changes.close();
      });

      expect(await runner.run(), isFalse); // offline: gives up, song untouched
      expect((await db.songById(id))!.lookupStatus, 'pending');

      online = true;
      changes.add([ConnectivityResult.wifi]);
      for (var i = 0; i < 50 && (await db.songById(id))!.lookupStatus == 'pending'; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
      expect((await db.songById(id))!.lookupStatus, 'notFound');
    });
  });
}
