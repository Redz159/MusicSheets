import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/settings.dart';
import '../../data/db.dart';
import '../../data/providers.dart';
import '../../services/backup_service.dart';
import '../../services/services.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/metadata_widgets.dart';
import '../../widgets/platform_widgets.dart';

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

    return PlatformScaffold(
      appBar: AppBar(title: const Text('Settings')),
      largeTitle: 'Settings',
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: EdgeInsets.only(
              left: usesCupertinoPresentation ? 8 : 0,
              right: usesCupertinoPresentation ? 8 : 0,
              bottom: 32,
            ),
            children: [
              PlatformSettingsSection(
                title: 'Appearance',
                children: [
                  if (defaultTargetPlatform == TargetPlatform.iOS)
                    PlatformListTile(
                      title: const Text('Theme'),
                      trailing: Builder(
                        builder: (context) {
                          final labelStyle = TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            decoration: TextDecoration.none,
                          );
                          return CupertinoSlidingSegmentedControl<ThemeMode>(
                            groupValue: s.themeMode,
                            children: {
                              ThemeMode.system: Text('Auto', style: labelStyle),
                              ThemeMode.light: Text('Light', style: labelStyle),
                              ThemeMode.dark: Text('Dark', style: labelStyle),
                            },
                            onValueChanged: (v) =>
                                n.set((x) => x.copyWith(themeMode: v)),
                          );
                        },
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment(
                            value: ThemeMode.system,
                            icon: Icon(Icons.brightness_auto),
                            label: Text('System'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.light,
                            icon: Icon(Icons.light_mode),
                            label: Text('Light'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            icon: Icon(Icons.dark_mode),
                            label: Text('Dark'),
                          ),
                        ],
                        selected: {s.themeMode},
                        onSelectionChanged: (v) =>
                            n.set((x) => x.copyWith(themeMode: v.first)),
                      ),
                    ),
                ],
              ),
              PlatformSettingsSection(
                title: 'Reading',
                children: [
                  PlatformSwitchTile(
                    title: const Text('Two pages side by side in landscape'),
                    subtitle: const Text('On tablets'),
                    value: s.twoPageLandscape,
                    onChanged: (v) =>
                        n.set((x) => x.copyWith(twoPageLandscape: v)),
                  ),
                  PlatformSwitchTile(
                    title: const Text('Half-page turns'),
                    subtitle: const Text(
                      'First show the top half of the next page, so you can read ahead',
                    ),
                    value: s.halfPageTurn,
                    onChanged: (v) => n.set((x) => x.copyWith(halfPageTurn: v)),
                  ),
                  PlatformListTile(
                    title: const Text('Page colour'),
                    trailing: defaultTargetPlatform == TargetPlatform.iOS
                        ? Builder(
                            builder: (context) {
                              final labelStyle = TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                decoration: TextDecoration.none,
                              );
                              return CupertinoSlidingSegmentedControl<PageTint>(
                                groupValue: s.pageTint,
                                children: {
                                  for (final p in PageTint.values)
                                    p: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(p.label, style: labelStyle),
                                    ),
                                },
                                onValueChanged: (v) =>
                                    n.set((x) => x.copyWith(pageTint: v)),
                              );
                            },
                          )
                        : SegmentedButton<PageTint>(
                            showSelectedIcon: false,
                            segments: [
                              for (final p in PageTint.values)
                                ButtonSegment(value: p, label: Text(p.label)),
                            ],
                            selected: {s.pageTint},
                            onSelectionChanged: (v) =>
                                n.set((x) => x.copyWith(pageTint: v.first)),
                          ),
                  ),
                  PlatformListTile(
                    title: const Text('Page-turn tap zone'),
                    trailing: PlatformSlider(
                      value: s.tapZoneFraction,
                      min: 0.15,
                      max: 0.45,
                      divisions: 6,
                      label: '${(s.tapZoneFraction * 100).round()} %',
                      onChanged: (v) =>
                          n.set((x) => x.copyWith(tapZoneFraction: v)),
                    ),
                  ),
                  PlatformSwitchTile(
                    title: const Text('Keep screen on while reading'),
                    value: s.keepScreenOn,
                    onChanged: (v) => n.set((x) => x.copyWith(keepScreenOn: v)),
                  ),
                ],
              ),
              PlatformSettingsSection(
                title: 'Page-turn pedal',
                children: [
                  const PlatformListTile(
                    leading: Icon(CupertinoIcons.bluetooth),
                    title: Text('Bluetooth pedals work automatically'),
                    subtitle: Text(
                      'Pair the pedal in system settings. Arrow keys, Page Up/Down and Space turn pages.',
                    ),
                  ),
                  PlatformSwitchTile(
                    title: const Text('Swap pedal direction'),
                    value: s.swapPedal,
                    onChanged: (v) => n.set((x) => x.copyWith(swapPedal: v)),
                  ),
                ],
              ),
              PlatformSettingsSection(
                title: 'Annotations',
                children: [
                  PlatformSwitchTile(
                    title: const Text('Draw with stylus only'),
                    subtitle: const Text(
                      'Fingers keep turning pages while annotating (palm rejection)',
                    ),
                    value: s.stylusOnly,
                    onChanged: (v) => n.set((x) => x.copyWith(stylusOnly: v)),
                  ),
                ],
              ),
              PlatformSettingsSection(
                title: 'Tags',
                children: [
                  if (tags.isEmpty)
                    const PlatformListTile(
                      title: Text('No tags yet'),
                      subtitle: Text('Add tags when editing a song.'),
                    )
                  else if (usesCupertinoPresentation)
                    for (final tag in tags)
                      PlatformListTile(
                        leading: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Color(tag.color),
                            shape: BoxShape.circle,
                          ),
                        ),
                        title: Text(tag.name),
                        trailing: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => _deleteTag(context, ref, tag),
                          child: const Icon(
                            CupertinoIcons.delete,
                            color: CupertinoColors.destructiveRed,
                          ),
                        ),
                        onTap: () => _editTag(context, ref, tag),
                      )
                  else
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final tag in tags)
                            InputChip(
                              avatar: CircleAvatar(
                                backgroundColor: Color(tag.color),
                                radius: 6,
                              ),
                              label: Text(tag.name),
                              onPressed: () => _editTag(context, ref, tag),
                              onDeleted: () => _deleteTag(context, ref, tag),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
              PlatformSettingsSection(
                title: 'Song metadata',
                footer: const Text(
                  'Data from MusicBrainz and the Cover Art Archive. Key and tempo from AcousticBrainz and Deezer.',
                ),
                children: [
                  PlatformSwitchTile(
                    title: const Text('Fetch song metadata online'),
                    subtitle: const Text(
                      'Looks up composer, key, tempo, artist, year, genre, album and cover art. Song titles are sent to '
                      'MusicBrainz, AcousticBrainz and Deezer, also for your existing library.',
                    ),
                    value: s.fetchMetadata,
                    onChanged: (v) => v
                        ? enableMetadataLookup(context, ref)
                        : n.set((x) => x.copyWith(fetchMetadata: false)),
                  ),
                  PlatformSwitchTile(
                    title: const Text('Wi-Fi only'),
                    subtitle: const Text(
                      'Wait for Wi-Fi so mobile data is not used',
                    ),
                    value: s.metadataWifiOnly,
                    onChanged: s.fetchMetadata
                        ? (v) => n.set((x) => x.copyWith(metadataWifiOnly: v))
                        : null,
                  ),
                  if (s.fetchMetadata) _MetadataProgress(songs: songs),
                ],
              ),
              PlatformSettingsSection(
                title: 'Backup',
                children: [
                  PlatformListTile(
                    leading: Icon(
                      usesCupertinoPresentation
                          ? CupertinoIcons.cloud_upload
                          : Icons.backup_outlined,
                    ),
                    title: const Text('Create backup'),
                    subtitle: const Text(
                      'All PDFs, annotations, folders, tags and setlists in one .zip file',
                    ),
                    onTap: () => _backup(context, ref),
                  ),
                  PlatformListTile(
                    leading: Icon(
                      usesCupertinoPresentation
                          ? CupertinoIcons.refresh
                          : Icons.restore,
                    ),
                    title: const Text('Restore backup'),
                    subtitle: const Text('Replaces the current library'),
                    onTap: () => _restore(context, ref),
                  ),
                ],
              ),
              PlatformSettingsSection(
                title: 'Library',
                children: [
                  PlatformListTile(
                    leading: Icon(
                      usesCupertinoPresentation
                          ? CupertinoIcons.music_note_list
                          : Icons.library_music_outlined,
                    ),
                    title: Text('${songs.length} songs · $pages pages'),
                    subtitle: Text(
                      'Stored on this device',
                      style: t.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              PlatformSettingsSection(
                title: 'About',
                children: [
                  PlatformListTile(
                    leading: Icon(
                      usesCupertinoPresentation
                          ? CupertinoIcons.doc_text
                          : Icons.description_outlined,
                    ),
                    title: const Text('Open-source licenses'),
                    subtitle: const Text(
                      'MusicSheets is MIT-licensed. PDF export uses Syncfusion under its Community License.',
                    ),
                    onTap: () => _showLicenses(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editTag(BuildContext context, WidgetRef ref, Tag tag) async {
    final result = await promptNameAndColor(
      context,
      title: 'Edit tag',
      initial: tag.name,
      color: tag.color,
    );
    if (result == null) return;
    await ref
        .read(databaseProvider)
        .updateTag(tag.id, name: result.$1, color: result.$2);
  }

  Future<void> _deleteTag(BuildContext context, WidgetRef ref, Tag tag) async {
    if (!await confirm(
      context,
      title: 'Delete tag "${tag.name}"?',
      message: 'Songs keep everything else.',
    )) {
      return;
    }
    await ref.read(databaseProvider).deleteTag(tag.id);
  }

  void _showLicenses(BuildContext context) {
    if (usesCupertinoPresentation) {
      Navigator.of(context).push(
        CupertinoPageRoute<void>(builder: (_) => const _IosLicensesPage()),
      );
      return;
    }
    showLicensePage(context: context, applicationName: 'MusicSheets');
  }

  Future<void> _backup(BuildContext context, WidgetRef ref) async {
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    try {
      final file = await withProgress(
        context,
        'Creating backup…',
        () => ref
            .read(backupServiceProvider)
            .createBackup(ref.read(databaseProvider)),
      );
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
      message:
          'Your current library on this device will be replaced by the backup.',
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
      // Covers are not in backups: download them again for songs that were already matched.
      if (ref.read(settingsProvider).fetchMetadata) {
        unawaited(ref.read(lookupServiceProvider).restoreMissingCovers());
      }
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
    int count(String status) =>
        songs.where((s) => s.lookupStatus == status).length;
    final pending = count('pending'),
        review = count('needsReview'),
        failed = count('failed');
    if (pending + review + failed == 0) return const SizedBox.shrink();
    return PlatformListTile(
      leading: const Icon(Icons.cloud_sync_outlined),
      title: Text(
        [
          if (pending > 0) '$pending waiting for lookup',
          if (review > 0) '$review need review',
          if (failed > 0) '$failed failed',
        ].join(' · '),
      ),
    );
  }
}

class _IosLicensesPage extends StatefulWidget {
  const _IosLicensesPage();

  @override
  State<_IosLicensesPage> createState() => _IosLicensesPageState();
}

class _IosLicensesPageState extends State<_IosLicensesPage> {
  late final Future<List<LicenseEntry>> _licenses = LicenseRegistry.licenses
      .toList();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Open-source licenses'),
      ),
      child: SafeArea(
        child: FutureBuilder<List<LicenseEntry>>(
          future: _licenses,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Could not load licenses: ${snapshot.error}'),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CupertinoActivityIndicator());
            }
            return ListView(
              children: [
                CupertinoListSection.insetGrouped(
                  header: const Text('MUSICSHEETS'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Third-party software used by MusicSheets is listed below.',
                        style: CupertinoTheme.of(context).textTheme.textStyle,
                      ),
                    ),
                  ],
                ),
                for (final entry in snapshot.data!)
                  CupertinoListSection.insetGrouped(
                    header: Text(entry.packages.join(', ')),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SelectableText(
                          entry.paragraphs
                              .map((paragraph) {
                                final indent = List.filled(
                                  paragraph.indent * 2,
                                  ' ',
                                ).join();
                                return '$indent${paragraph.text}';
                              })
                              .join('\n\n'),
                          style: CupertinoTheme.of(context).textTheme.textStyle
                              .copyWith(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
