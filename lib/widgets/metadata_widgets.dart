import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/settings.dart';
import '../data/db.dart';
import '../data/providers.dart';
import '../services/metadata/models.dart';
import '../services/services.dart';
import 'dialogs.dart';

/// Small "Review" pill on songs whose online match needs a decision. Hidden when lookups are off.
class ReviewBadge extends ConsumerWidget {
  const ReviewBadge({super.key, required this.song});
  final Song song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (song.lookupStatus != 'needsReview' || !ref.watch(settingsProvider.select((s) => s.fetchMetadata))) {
      return const SizedBox.shrink();
    }
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => chooseMatch(context, ref, song),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: scheme.tertiaryContainer, borderRadius: BorderRadius.circular(20)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.help_outline, size: 14, color: scheme.onTertiaryContainer),
            const SizedBox(width: 4),
            Text('Review', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: scheme.onTertiaryContainer)),
          ]),
        ),
      ),
    );
  }
}

/// The downloaded cover of a song, or null when there is none.
File? coverFileOf(AppPaths paths, Song song) {
  final name = song.coverFileName;
  if (name == null) return null;
  final f = File(paths.pdf(name));
  return f.existsSync() ? f : null;
}

class CoverImage extends ConsumerWidget {
  const CoverImage({super.key, required this.song, this.size = 48, this.radius = 6});
  final Song song;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = coverFileOf(ref.watch(appPathsProvider), song);
    if (f == null) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.file(f, width: size, height: size, fit: BoxFit.cover, cacheWidth: (size * 3).round()),
    );
  }
}

/// Opens the candidate picker for a song that is waiting for review.
Future<void> chooseMatch(BuildContext context, WidgetRef ref, Song song) async {
  final candidates = Candidate.decodeList(song.lookupCandidates);
  final choice = await showModalBottomSheet<_Choice>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _CandidateSheet(song: song, candidates: candidates),
  );
  if (choice == null || !context.mounted) return;
  final service = ref.read(lookupServiceProvider);
  if (choice.candidate == null) {
    await service.markNotFound(song.id);
    return;
  }
  try {
    await withProgress(context, 'Fetching details…', () => service.applyCandidate(song.id, choice.candidate!));
  } catch (e) {
    if (context.mounted) showSnack(context, 'Could not fetch details: $e');
  }
}

class _Choice {
  const _Choice(this.candidate);
  final Candidate? candidate;
}

class _CandidateSheet extends StatelessWidget {
  const _CandidateSheet({required this.song, required this.candidates});
  final Song song;
  final List<Candidate> candidates;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        ListTile(
          title: Text('Which "${song.title}"?', style: t.textTheme.titleLarge),
          subtitle: const Text('Pick the recording to take composer, year, key and cover from.'),
        ),
        const Divider(height: 1),
        Flexible(
          child: ListView(shrinkWrap: true, children: [
            for (final c in candidates)
              ListTile(
                leading: _CandidateCover(candidate: c),
                title: Text(c.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text([c.artist, if (c.year != null) '${c.year}', if (c.album != null) c.album!].join('  ·  '),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                onTap: () => Navigator.pop(context, _Choice(c)),
              ),
            ListTile(
              leading: const SizedBox(width: 48, child: Icon(Icons.block)),
              title: const Text('None of these'),
              onTap: () => Navigator.pop(context, const _Choice(null)),
            ),
          ]),
        ),
      ]),
    );
  }
}

class _CandidateCover extends StatelessWidget {
  const _CandidateCover({required this.candidate});
  final Candidate candidate;

  @override
  Widget build(BuildContext context) {
    const placeholder = SizedBox(width: 48, height: 48, child: Icon(Icons.album_outlined));
    final id = candidate.releaseGroupId;
    if (id == null) return placeholder;
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.network(
        'https://coverartarchive.org/release-group/$id/front-250',
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder,
      ),
    );
  }
}

/// Online lookups are opt-in: asks once what may be sent and switches them on if the user agrees.
/// Returns whether lookups are enabled afterwards.
Future<bool> enableMetadataLookup(BuildContext context, WidgetRef ref) async {
  if (ref.read(settingsProvider).fetchMetadata) return true;
  final ok = await confirm(
    context,
    title: 'Look up song metadata online?',
    message: 'Song titles, and artists printed on the sheets, are sent to MusicBrainz, AcousticBrainz and Deezer '
        'to find composer, key, tempo, year, genre, album and cover art. This applies to your whole library, '
        'including songs that are already in it. Nothing is sent while this is off.',
    action: 'Turn on',
    destructive: false,
  );
  if (!ok) return false;
  ref.read(settingsProvider.notifier).set((s) => s.copyWith(fetchMetadata: true));
  return true;
}

/// Puts songs back in the lookup queue and tells the user.
Future<void> fetchMetadataFor(BuildContext context, WidgetRef ref, List<int> ids) async {
  if (!await enableMetadataLookup(context, ref)) return;
  await ref.read(databaseProvider).requeueSongs(ids);
  if (context.mounted) {
    showSnack(context, ids.length == 1 ? 'Looking up this song…' : 'Looking up ${ids.length} songs…');
  }
}
