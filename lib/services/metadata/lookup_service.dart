import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import '../../data/db.dart';
import '../../data/providers.dart';
import 'cover_art.dart';
import 'matcher.dart';
import 'models.dart';
import 'musicbrainz_client.dart';
import 'pdf_header.dart';
import 'tempo_key_client.dart';
import 'query_builder.dart';
import '../../core/sorting.dart' show foldText;

const maxAttempts = 5;
const _backoff = [Duration(minutes: 1), Duration(minutes: 10), Duration(hours: 1), Duration(hours: 6)];

/// Delay before attempt number [attempts] + 1, or null when the song should be parked as failed.
Duration? backoffFor(int attempts) => attempts >= maxAttempts ? null : _backoff[(attempts - 1).clamp(0, _backoff.length - 1)];

/// Reads title and artist from the top of page 1; null when the sheet has no text layer.
typedef PdfHeaderReader = Future<PdfHeader?> Function(String pdfPath);

/// What a lookup writes to a song. Only empty fields are filled (see [applyMatch]).
class MatchResult {
  const MatchResult({required this.candidate, this.composer, this.workId, this.genre, this.keyAndTempo = const KeyAndTempo()});
  final Candidate candidate;
  final String? composer;
  final String? workId;
  final String? genre;
  final KeyAndTempo keyAndTempo;
}

/// Builds the update for [song]: fills empty fields only, never overwrites a value, and renames
/// the song only when its title is still the generated import title.
SongsCompanion applyMatch(Song song, MatchResult m, {required bool strong}) {
  final c = m.candidate;
  final renamable = strong && song.importTitle != null && song.title == song.importTitle;
  return SongsCompanion(
    title: renamable && c.title.trim().isNotEmpty ? Value(c.title.trim()) : const Value.absent(),
    composer: song.composer.isEmpty && (m.composer ?? '').isNotEmpty ? Value(m.composer!) : const Value.absent(),
    artist: song.artist.isEmpty ? Value(c.artist) : const Value.absent(),
    year: song.year == null && c.year != null ? Value(c.year) : const Value.absent(),
    genre: song.genre.isEmpty && (m.genre ?? '').isNotEmpty ? Value(m.genre!) : const Value.absent(),
    album: song.album.isEmpty && (c.album ?? '').isNotEmpty ? Value(c.album!) : const Value.absent(),
    musicalKey: song.musicalKey.isEmpty && m.keyAndTempo.key != null ? Value(m.keyAndTempo.key!) : const Value.absent(),
    tempo: song.tempo == null && m.keyAndTempo.tempo != null ? Value(m.keyAndTempo.tempo) : const Value.absent(),
    mbRecordingId: Value(c.recordingId),
    mbWorkId: Value(m.workId),
    mbReleaseGroupId: Value(c.releaseGroupId),
  );
}

enum StepOutcome { idle, processed, waiting }

class LookupService {
  LookupService(
    this.db,
    this.paths, {
    required this.musicBrainz,
    required this.tempoKey,
    required this.covers,
    PdfHeaderReader? readHeader,
    DateTime Function()? now,
  })  : readHeader = readHeader ?? readPdfHeader,
        now = now ?? DateTime.now;

  factory LookupService.create(AppDatabase db, AppPaths paths, {http.Client? client}) {
    final c = client ?? http.Client();
    return LookupService(db, paths,
        musicBrainz: MusicBrainzClient(c), tempoKey: TempoKeyClient(c), covers: CoverArtService(c));
  }

  final AppDatabase db;
  final AppPaths paths;
  final MusicBrainzClient musicBrainz;
  final TempoKeyClient tempoKey;
  final CoverArtService covers;
  final PdfHeaderReader readHeader;
  final DateTime Function() now;

  /// Handles the next due song. Returns [StepOutcome.waiting] when only backed-off songs remain.
  Future<StepOutcome> processNext() async {
    final song = await db.claimNextDue(now());
    if (song == null) return await db.earliestRetry() == null ? StepOutcome.idle : StepOutcome.waiting;
    await processSong(song);
    return StepOutcome.processed;
  }

  Future<void> processSong(Song song) async {
    try {
      await _lookup(song);
    } on TemporaryLookupError catch (e) {
      debugPrint('lookup "${song.title}": temporary failure, will retry: ${e.message}');
      final attempts = song.lookupAttempts + 1;
      final delay = backoffFor(attempts);
      await db.updateSong(
        song.id,
        SongsCompanion(
          lookupAttempts: Value(attempts),
          lookupStatus: Value(delay == null ? LookupStatus.failed.name : LookupStatus.pending.name),
          nextAttemptAt: Value(delay == null ? null : now().add(delay)),
        ),
      );
    } catch (e, st) {
      debugPrint('lookup "${song.title}": failed: $e\n$st');
      // Unexpected trouble with one song must not block the queue.
      await db.updateSong(song.id, SongsCompanion(lookupStatus: Value(LookupStatus.failed.name)));
    }
  }

  /// Queries to try, most specific first. A name in the file ("Queen - Song") beats the artist printed
  /// on the sheet, which beats a bare title. The printed artist is paired with the file-name title too,
  /// because the title on the sheet may contain a typo.
  static List<SearchQuery> buildQueries(String fileTitle, PdfHeader? header) {
    final fromName = queriesFromTitle(fileTitle);
    final plainName = [for (final q in fromName) if (q.artist == null && !q.title.contains(RegExp(r'\s[-–—]\s'))) q];
    final out = <SearchQuery>[
      for (final q in fromName) if (q.artist != null) q,
      if (header?.artist != null) ...[
        for (final q in plainName) SearchQuery(q.title, artist: header!.artist),
        SearchQuery(header!.title, artist: header.artist),
      ],
      for (final q in fromName) if (q.artist == null) q,
      if (header != null) SearchQuery(header.title),
    ];
    final seen = <String>{};
    return [
      for (final q in out)
        if (seen.add('${foldText(q.title)}|${foldText(q.artist ?? '')}')) q,
    ];
  }

  Future<void> _lookup(Song song) async {
    final header = await readHeader(paths.pdf(song.fileName));
    final queries = buildQueries(song.importTitle ?? song.title, header);
    final decision = await _search(queries);
    if (decision.isEmpty) {
      await _finish(song.id, LookupStatus.notFound);
    } else if (decision.isStrong) {
      await _complete(song, decision.best!, strong: true);
    } else {
      await db.updateSong(
        song.id,
        SongsCompanion(
          lookupStatus: Value(LookupStatus.needsReview.name),
          lookupCandidates: Value(Candidate.encodeList(decision.review)),
          nextAttemptAt: const Value(null),
        ),
      );
    }
  }

  Future<MatchDecision> _search(List<SearchQuery> queries) async {
    // Candidates from a search that named an artist are only a fallback: when the artist did not
    // match, those hits are unrelated recordings.
    MatchDecision? plain, withArtist;
    for (final q in queries) {
      final decision = decide(q, await musicBrainz.searchRecordings(q));
      if (decision.isStrong) return decision;
      if (decision.isEmpty) continue;
      if (q.artist == null) {
        plain ??= decision;
      } else {
        withArtist ??= decision;
      }
    }
    return plain ?? withArtist ?? const MatchDecision.none();
  }

  /// Applies a chosen candidate, from a strong match or from the review picker.
  Future<void> applyCandidate(int songId, Candidate candidate) async {
    final song = await db.songById(songId);
    if (song == null) return;
    try {
      await _complete(song, candidate, strong: false);
    } on TemporaryLookupError {
      await db.requeueSongs([songId]);
    }
  }

  Future<void> _complete(Song song, Candidate c, {required bool strong}) async {
    final details = await musicBrainz.details(c.recordingId);
    final kt = await tempoKey.lookup(c.recordingId, c.title, c.artist);
    final fresh = await db.songById(song.id) ?? song; // the user may have edited it in the meantime
    final result = MatchResult(
      candidate: c,
      composer: details.composer,
      workId: details.workId,
      genre: details.genres.isEmpty ? null : details.genres.first,
      keyAndTempo: kt,
    );
    await db.updateSong(
      song.id,
      applyMatch(fresh, result, strong: strong).copyWith(
        lookupStatus: Value(LookupStatus.matched.name),
        lookupCandidates: const Value(null),
        lookupAttempts: const Value(0),
        nextAttemptAt: const Value(null),
      ),
    );
    await _fetchCover(fresh, c.releaseGroupId);
  }

  /// After a restore (covers are not in backups): downloads the missing covers again from the stored
  /// release group. The lookup state of the songs stays as it was, so hand-picked matches survive.
  Future<void> restoreMissingCovers() async {
    var offline = false;
    for (final song in await db.songsWithCover()) {
      final name = song.coverFileName!;
      if (await File(paths.pdf(name)).exists()) continue;
      final group = song.mbReleaseGroupId;
      var ok = false;
      if (group != null && !offline) {
        try {
          ok = await covers.download(group, File(paths.pdf(name)));
        } on TemporaryLookupError {
          offline = true; // stop asking; the remaining songs only lose the dangling reference
        }
      }
      // Without the reference a later "Fetch metadata" can fetch the cover again.
      if (!ok) await db.updateSong(song.id, const SongsCompanion(coverFileName: Value(null)));
    }
  }

  Future<void> _fetchCover(Song song, String? releaseGroupId) async {
    if (releaseGroupId == null || song.coverFileName != null) return;
    try {
      final name = '${p.basenameWithoutExtension(song.fileName)}${AppPaths.coverSuffix}';
      if (await covers.download(releaseGroupId, File(paths.pdf(name)))) {
        await db.updateSong(song.id, SongsCompanion(coverFileName: Value(name)));
      }
    } on TemporaryLookupError {
      // The metadata is already stored; a missing cover is not worth a retry.
    }
  }

  Future<void> _finish(int id, LookupStatus status) => db.updateSong(
        id,
        SongsCompanion(lookupStatus: Value(status.name), nextAttemptAt: const Value(null), lookupCandidates: const Value(null)),
      );

  /// The user rejected every candidate.
  Future<void> markNotFound(int songId) => _finish(songId, LookupStatus.notFound);
}
