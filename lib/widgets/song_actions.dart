import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/sorting.dart';
import '../data/db.dart';
import '../data/providers.dart';
import '../features/viewer/viewer_screen.dart';
import '../services/import_service.dart';
import '../services/services.dart';
import 'dialogs.dart';
import 'song_list.dart';

void openSongs(BuildContext context, List<Song> songs, int index, {String? setlistName, bool resume = true}) {
  context.push('/viewer',
      extra: ViewerArgs(
        songIds: [for (final s in songs) s.id],
        startSong: index,
        setlistName: setlistName,
        resumeLastPage: resume,
      ));
}

/// Picks PDFs, imports them with a progress dialog and reports the result.
Future<List<int>> importFlow(BuildContext context, WidgetRef ref, {int? folderId}) async {
  final sources = await ImportService.pick();
  if (sources.isEmpty || !context.mounted) return const [];
  final progress = ValueNotifier<(int, int)>((0, sources.length));
  final nav = Navigator.of(context, rootNavigator: true);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: AlertDialog(
        title: const Text('Importing'),
        content: ValueListenableBuilder(
          valueListenable: progress,
          builder: (context, v, _) => Column(mainAxisSize: MainAxisSize.min, children: [
            LinearProgressIndicator(value: v.$2 == 0 ? null : v.$1 / v.$2, borderRadius: BorderRadius.circular(4)),
            const SizedBox(height: 12),
            Text('${v.$1} of ${v.$2} files'),
          ]),
        ),
      ),
    ),
  );
  final result = await ref
      .read(importServiceProvider)
      .import(sources, onProgress: (done, total) => progress.value = (done, total));
  nav.pop();
  if (folderId != null && result.imported.isNotEmpty) {
    await ref.read(databaseProvider).addSongsToFolder(folderId, result.imported);
  }
  if (!context.mounted) return result.imported;
  final parts = [
    'Imported ${result.imported.length}',
    if (result.duplicates.isNotEmpty) '${result.duplicates.length} already in library',
    if (result.failed.isNotEmpty) '${result.failed.length} could not be read',
  ];
  showSnack(
    context,
    parts.join(' · '),
    action: folderId == null && result.imported.isNotEmpty
        ? SnackBarAction(label: 'Add to folder', onPressed: () => addToFolder(context, ref, result.imported))
        : null,
  );
  return result.imported;
}

Future<void> addToFolder(BuildContext context, WidgetRef ref, List<int> songIds) async {
  final db = ref.read(databaseProvider);
  final folders = ref.read(foldersProvider).value ?? [];
  final picked = await showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _PickerSheet(
      title: 'Add to folder',
      newLabel: 'New folder',
      items: [for (final f in folders) (f.id, f.name, Icons.folder, Color(f.color))],
      onNew: () async {
        final r = await promptNameAndColor(context, title: 'New folder', action: 'Create');
        return r == null ? null : db.createFolder(r.$1, r.$2);
      },
    ),
  );
  if (picked == null) return;
  await db.addSongsToFolder(picked, songIds);
  if (context.mounted) showSnack(context, 'Added ${songIds.length} to folder');
}

Future<void> addToSetlist(BuildContext context, WidgetRef ref, List<int> songIds) async {
  final db = ref.read(databaseProvider);
  final setlists = ref.read(setlistsProvider).value ?? [];
  final picked = await showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _PickerSheet(
      title: 'Add to setlist',
      newLabel: 'New setlist',
      items: [for (final s in setlists) (s.id, s.name, Icons.queue_music, null)],
      onNew: () async {
        final name = await promptText(context, title: 'New setlist', hint: 'e.g. Concert 12 May', action: 'Create');
        return name == null ? null : db.createSetlist(name);
      },
    ),
  );
  if (picked == null) return;
  await db.addSongsToSetlist(picked, songIds);
  if (context.mounted) showSnack(context, 'Added ${songIds.length} to setlist');
}

class _PickerSheet extends StatelessWidget {
  const _PickerSheet({required this.title, required this.items, required this.newLabel, required this.onNew});

  final String title;
  final List<(int, String, IconData, Color?)> items;
  final String newLabel;
  final Future<int?> Function() onNew;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      maxChildSize: 0.9,
      builder: (context, scroll) => ListView(controller: scroll, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.add)),
          title: Text(newLabel),
          onTap: () async {
            final id = await onNew();
            if (id != null && context.mounted) Navigator.pop(context, id);
          },
        ),
        const Divider(),
        for (final i in items)
          ListTile(
            leading: Icon(i.$3, color: i.$4),
            title: Text(i.$2),
            onTap: () => Navigator.pop(context, i.$1),
          ),
      ]),
    );
  }
}

Future<void> tagSongs(BuildContext context, WidgetRef ref, List<int> songIds) async {
  final db = ref.read(databaseProvider);
  final tags = ref.read(tagsProvider).value ?? [];
  final picked = await showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _PickerSheet(
      title: 'Add tag',
      newLabel: 'New tag',
      items: [for (final t in tags) (t.id, t.name, Icons.label, Color(t.color))],
      onNew: () async {
        final r = await promptNameAndColor(context, title: 'New tag', action: 'Create', color: paletteColors[2]);
        return r == null ? null : db.createTag(r.$1, r.$2);
      },
    ),
  );
  if (picked == null) return;
  await db.addTagToSongs(picked, songIds);
}

Future<bool> deleteSongs(BuildContext context, WidgetRef ref, List<Song> songs) async {
  final ok = await confirm(
    context,
    title: songs.length == 1 ? 'Delete "${songs.first.title}"?' : 'Delete ${songs.length} songs?',
    message: 'The PDF and all annotations will be removed from the library. This cannot be undone.',
  );
  if (!ok) return false;
  await ref.read(importServiceProvider).deleteSongs(songs);
  return true;
}

/// Asks original vs. annotated, builds the PDF and opens the share sheet.
Future<void> exportSongs(BuildContext context, WidgetRef ref, List<Song> songs, String name) async {
  final box = context.findRenderObject() as RenderBox?;
  final origin = box == null ? null : box.localToGlobal(Offset.zero) & box.size;
  final annotated = await showModalBottomSheet<bool>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          child: Text('Share PDF', style: Theme.of(context).textTheme.titleLarge),
        ),
        ListTile(
          leading: const Icon(Icons.draw_outlined),
          title: const Text('With annotations'),
          subtitle: const Text('Your markings are drawn into the PDF'),
          onTap: () => Navigator.pop(context, true),
        ),
        ListTile(
          leading: const Icon(Icons.picture_as_pdf_outlined),
          title: const Text('Original'),
          subtitle: const Text('The PDF exactly as it was imported'),
          onTap: () => Navigator.pop(context, false),
        ),
        const SizedBox(height: 12),
      ]),
    ),
  );
  if (annotated == null || !context.mounted) return;
  final service = ref.read(exportServiceProvider);
  try {
    final file = await withProgress(
        context, 'Preparing PDF…', () => service.buildPdf(songs, withAnnotations: annotated, name: name));
    await service.share(file, origin: origin);
  } catch (e) {
    if (context.mounted) showSnack(context, 'Export failed: $e');
  }
}

/// Bottom sheet with the actions for a single song.
Future<void> showSongMenu(BuildContext context, WidgetRef ref, Song song, {List<Widget> extra = const []}) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (sheet) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          title: Text(song.title, style: Theme.of(context).textTheme.titleLarge),
          subtitle: Text('${song.composer.isEmpty ? '-' : song.composer} · ${song.pageCount} pages'),
        ),
        const Divider(),
        ...extra,
        ListTile(
          leading: const Icon(Icons.edit_outlined),
          title: const Text('Edit details'),
          onTap: () {
            Navigator.pop(sheet);
            editSong(context, ref, song);
          },
        ),
        ListTile(
          leading: const Icon(Icons.create_new_folder_outlined),
          title: const Text('Add to folder'),
          onTap: () {
            Navigator.pop(sheet);
            addToFolder(context, ref, [song.id]);
          },
        ),
        ListTile(
          leading: const Icon(Icons.playlist_add),
          title: const Text('Add to setlist'),
          onTap: () {
            Navigator.pop(sheet);
            addToSetlist(context, ref, [song.id]);
          },
        ),
        ListTile(
          leading: const Icon(Icons.ios_share),
          title: const Text('Share PDF'),
          onTap: () {
            Navigator.pop(sheet);
            exportSongs(context, ref, [song], song.title);
          },
        ),
        ListTile(
          leading: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
          title: Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          onTap: () {
            Navigator.pop(sheet);
            deleteSongs(context, ref, [song]);
          },
        ),
      ]),
    ),
  );
}

Future<void> editSong(BuildContext context, WidgetRef ref, Song song) => showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => SongEditSheet(song: song),
    );

class SongEditSheet extends ConsumerStatefulWidget {
  const SongEditSheet({super.key, required this.song});
  final Song song;

  @override
  ConsumerState<SongEditSheet> createState() => _SongEditSheetState();
}

class _SongEditSheetState extends ConsumerState<SongEditSheet> {
  late final _title = TextEditingController(text: widget.song.title);
  late final _composer = TextEditingController(text: widget.song.composer);
  late final _instrument = TextEditingController(text: widget.song.instrument);
  late final _key = TextEditingController(text: widget.song.musicalKey);
  late final _tempo = TextEditingController(text: widget.song.tempo?.toString() ?? '');
  late final _notes = TextEditingController(text: widget.song.notes);
  Set<int>? _tagIds;

  Future<void> _save() async {
    final db = ref.read(databaseProvider);
    await db.updateSong(
      widget.song.id,
      SongsCompanion(
        title: Value(_title.text.trim().isEmpty ? widget.song.title : _title.text.trim()),
        composer: Value(_composer.text.trim()),
        instrument: Value(_instrument.text.trim()),
        musicalKey: Value(_key.text.trim()),
        tempo: Value(int.tryParse(_tempo.text.trim())),
        notes: Value(_notes.text.trim()),
      ),
    );
    if (_tagIds != null) await db.setSongTags(widget.song.id, _tagIds!);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final allTags = ref.watch(tagsProvider).value ?? [];
    final current = ref.watch(songTagsProvider).value?[widget.song.id] ?? [];
    final tagIds = _tagIds ?? {for (final t in current) t.id};
    const gap = SizedBox(height: 12, width: 12);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            Expanded(child: Text('Edit details', style: Theme.of(context).textTheme.titleLarge)),
            FilledButton(onPressed: _save, child: const Text('Save')),
          ]),
          const SizedBox(height: 16),
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
          gap,
          TextField(controller: _composer, decoration: const InputDecoration(labelText: 'Composer / Artist')),
          gap,
          Row(children: [
            Expanded(child: TextField(controller: _instrument, decoration: const InputDecoration(labelText: 'Instrument / Part'))),
            gap,
            Expanded(child: TextField(controller: _key, decoration: const InputDecoration(labelText: 'Key'))),
            gap,
            SizedBox(
              width: 110,
              child: TextField(
                controller: _tempo,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'BPM'),
              ),
            ),
          ]),
          gap,
          TextField(controller: _notes, minLines: 2, maxLines: 5, decoration: const InputDecoration(labelText: 'Notes')),
          const SizedBox(height: 20),
          Text('Tags', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final t in allTags)
              FilterChip(
                label: Text(t.name),
                selected: tagIds.contains(t.id),
                avatar: CircleAvatar(backgroundColor: Color(t.color), radius: 6),
                showCheckmark: false,
                onSelected: (on) => setState(() {
                  final next = {...tagIds};
                  on ? next.add(t.id) : next.remove(t.id);
                  _tagIds = next;
                }),
              ),
            ActionChip(
              avatar: const Icon(Icons.add, size: 18),
              label: const Text('New tag'),
              onPressed: () async {
                final r = await promptNameAndColor(context, title: 'New tag', action: 'Create', color: paletteColors[2]);
                if (r == null) return;
                final id = await ref.read(databaseProvider).createTag(r.$1, r.$2);
                setState(() => _tagIds = {...tagIds, id});
              },
            ),
          ]),
        ]),
      ),
    );
  }
}

/// Full-screen multi-select song picker. Returns the chosen ids in tap order.
Future<List<int>?> pickSongs(BuildContext context, {String title = 'Add songs', Set<int> exclude = const {}}) {
  return Navigator.of(context).push<List<int>>(MaterialPageRoute(
    fullscreenDialog: true,
    builder: (_) => _SongPicker(title: title, exclude: exclude),
  ));
}

class _SongPicker extends ConsumerStatefulWidget {
  const _SongPicker({required this.title, required this.exclude});
  final String title;
  final Set<int> exclude;

  @override
  ConsumerState<_SongPicker> createState() => _SongPickerState();
}

class _SongPickerState extends ConsumerState<_SongPicker> {
  final _picked = <int>[];
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final songs = ref.watch(songsProvider).value ?? [];
    final tags = ref.watch(songTagsProvider).value ?? {};
    final visible = sortSongs(
      songs.where((s) => !widget.exclude.contains(s.id) &&
          matchesQuery(s, _query, [for (final t in tags[s.id] ?? const <Tag>[]) t.name])),
      SongSort.title,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(_picked.isEmpty ? widget.title : '${_picked.length} selected'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: _picked.isEmpty ? null : () => Navigator.pop(context, _picked),
              child: const Text('Add'),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: SearchBar(
              hintText: 'Search songs',
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),
      ),
      body: SongList(
        songs: visible,
        sort: SongSort.title,
        selected: _picked.toSet(),
        selectionMode: true,
        onTap: (s) => setState(() => _picked.contains(s.id) ? _picked.remove(s.id) : _picked.add(s.id)),
      ),
    );
  }
}
