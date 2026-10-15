import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/settings.dart';
import '../../data/db.dart';
import '../../data/providers.dart';
import '../../services/backup_service.dart';
import '../../services/services.dart';
import '../../widgets/dialogs.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(settingsProvider);
    final n = ref.read(settingsProvider.notifier);
    final songs = ref.watch(songsProvider).value ?? const [];
    final pages = songs.fold<int>(0, (a, s) => a + s.pageCount);
    final tags = ref.watch(tagsProvider).value ?? const [];
    final t = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(padding: const EdgeInsets.only(bottom: 32), children: [
            const _Header('Appearance'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.brightness_auto), label: Text('System')),
                  ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode), label: Text('Light')),
                  ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode), label: Text('Dark')),
                ],
                selected: {s.themeMode},
                onSelectionChanged: (v) => n.set((x) => x.copyWith(themeMode: v.first)),
              ),
            ),
            const _Header('Reading'),
            SwitchListTile(
              title: const Text('Two pages side by side in landscape'),
              subtitle: const Text('On tablets'),
              value: s.twoPageLandscape,
              onChanged: (v) => n.set((x) => x.copyWith(twoPageLandscape: v)),
            ),
            SwitchListTile(
              title: const Text('Half-page turns'),
              subtitle: const Text('First show the top half of the next page, so you can read ahead'),
              value: s.halfPageTurn,
              onChanged: (v) => n.set((x) => x.copyWith(halfPageTurn: v)),
            ),
            ListTile(
              title: const Text('Page colour'),
              trailing: SegmentedButton<PageTint>(
                showSelectedIcon: false,
                segments: [for (final p in PageTint.values) ButtonSegment(value: p, label: Text(p.label))],
                selected: {s.pageTint},
                onSelectionChanged: (v) => n.set((x) => x.copyWith(pageTint: v.first)),
              ),
            ),
            ListTile(
              title: const Text('Tap zone width'),
              subtitle: Text('Tap the left/right ${(s.tapZoneFraction * 100).round()} % of the screen to turn pages'),
            ),
            Slider(
              value: s.tapZoneFraction,
              min: 0.15,
              max: 0.45,
              divisions: 6,
              label: '${(s.tapZoneFraction * 100).round()} %',
              onChanged: (v) => n.set((x) => x.copyWith(tapZoneFraction: v)),
            ),
            SwitchListTile(
              title: const Text('Keep screen on while reading'),
              value: s.keepScreenOn,
              onChanged: (v) => n.set((x) => x.copyWith(keepScreenOn: v)),
            ),
            const _Header('Page-turn pedal'),
            const ListTile(
              leading: Icon(Icons.bluetooth),
              title: Text('Bluetooth pedals work automatically'),
              subtitle: Text('Pair the pedal in your system settings. Arrow keys, Page Up/Down and Space turn pages.'),
            ),
            SwitchListTile(
              title: const Text('Swap pedal direction'),
              value: s.swapPedal,
              onChanged: (v) => n.set((x) => x.copyWith(swapPedal: v)),
            ),
            const _Header('Annotations'),
            SwitchListTile(
              title: const Text('Draw with stylus only'),
              subtitle: const Text('Fingers keep turning pages while annotating (palm rejection)'),
              value: s.stylusOnly,
              onChanged: (v) => n.set((x) => x.copyWith(stylusOnly: v)),
            ),
            const _Header('Tags'),
            if (tags.isEmpty)
              const ListTile(subtitle: Text('No tags yet. Add tags when editing a song.'))
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final tag in tags)
                    InputChip(
                      avatar: CircleAvatar(backgroundColor: Color(tag.color), radius: 6),
                      label: Text(tag.name),
                      onPressed: () async {
                        final r = await promptNameAndColor(context, title: 'Edit tag', initial: tag.name, color: tag.color);
                        if (r != null) await ref.read(databaseProvider).updateTag(tag.id, name: r.$1, color: r.$2);
                      },
                      onDeleted: () async {
                        if (await confirm(context, title: 'Delete tag "${tag.name}"?', message: 'Songs keep everything else.')) {
                          await ref.read(databaseProvider).deleteTag(tag.id);
                        }
                      },
                    ),
                ]),
              ),
            const _Header('Song metadata'),
            SwitchListTile(
              title: const Text('Fetch song metadata online'),
              subtitle: const Text(
                  'Looks up composer, key, tempo, artist, year, genre, album and cover art. Song titles are sent to '
                  'MusicBrainz, AcousticBrainz and Deezer, also for your existing library.'),
              value: s.fetchMetadata,
              onChanged: (v) => n.set((x) => x.copyWith(fetchMetadata: v)),
            ),
            SwitchListTile(
              title: const Text('Wi-Fi only'),
              subtitle: const Text('Wait for Wi-Fi so mobile data is not used'),
              value: s.metadataWifiOnly,
              onChanged: s.fetchMetadata ? (v) => n.set((x) => x.copyWith(metadataWifiOnly: v)) : null,
            ),
            if (s.fetchMetadata) _MetadataProgress(songs: songs),
            const ListTile(
              dense: true,
              title: Text('Data from MusicBrainz and the Cover Art Archive. Key and tempo from AcousticBrainz and Deezer.'),
            ),
            const _Header('Backup'),
            ListTile(
              leading: const Icon(Icons.backup_outlined),
              title: const Text('Create backup'),
              subtitle: const Text('All PDFs, annotations, folders, tags and setlists in one .zip file'),
              onTap: () => _backup(context, ref),
            ),
            ListTile(
              leading: const Icon(Icons.restore),
              title: const Text('Restore backup'),
              subtitle: const Text('Replaces the current library'),
              onTap: () => _restore(context, ref),
            ),
            const _Header('Library'),
            ListTile(
              leading: const Icon(Icons.library_music_outlined),
              title: Text('${songs.length} songs · $pages pages'),
              subtitle: Text('Stored on this device', style: t.textTheme.bodySmall),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> _backup(BuildContext context, WidgetRef ref) async {
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null ? null : box.localToGlobal(Offset.zero) & box.size;
    try {
      final file = await withProgress(
          context, 'Creating backup…', () => ref.read(backupServiceProvider).createBackup(ref.read(databaseProvider)));
      await ref.read(exportServiceProvider).share(file, origin: origin);
    } catch (e) {
      if (context.mounted) showSnack(context, 'Backup failed: $e');
    }
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final path = await BackupService.pickBackup();
    if (path == null || !context.mounted) return;
    final ok = await confirm(
      context,
      title: 'Restore backup?',
      message: 'Your current library on this device will be replaced by the backup.',
      action: 'Restore',
    );
    if (!ok || !context.mounted) return;
    final backup = ref.read(backupServiceProvider);
    try {
      await withProgress(context, 'Restoring…', () async {
        final dir = await backup.extract(path);
        await ref.read(databaseProvider).close();
        await backup.install(dir);
        ref.read(libraryEpochProvider.notifier).bump();
      });
      // Covers are not in backups: songs without their cover file go back into the lookup queue.
      final paths = ref.read(appPathsProvider);
      await ref.read(databaseProvider).requeueSongsWithMissingCovers((n) => File(paths.pdf(n)).existsSync());
      if (context.mounted) showSnack(context, 'Backup restored');
    } catch (e) {
      ref.read(libraryEpochProvider.notifier).bump();
      if (context.mounted) showSnack(context, 'Restore failed: $e');
    }
  }
}

class _MetadataProgress extends StatelessWidget {
  const _MetadataProgress({required this.songs});
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    int count(String status) => songs.where((s) => s.lookupStatus == status).length;
    final pending = count('pending'), review = count('needsReview'), failed = count('failed');
    if (pending + review + failed == 0) return const SizedBox.shrink();
    return ListTile(
      leading: const Icon(Icons.cloud_sync_outlined),
      title: Text([
        if (pending > 0) '$pending waiting for lookup',
        if (review > 0) '$review need review',
        if (failed > 0) '$failed failed',
      ].join(' · ')),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
        child: Text(text,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w700)),
      );
}
