import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/settings.dart';
import '../../core/sorting.dart';
import '../../data/db.dart';
import '../../data/providers.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/song_actions.dart';
import '../../widgets/song_grid.dart';
import '../../widgets/song_list.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final _search = TextEditingController();
  String _query = '';
  final _tagFilter = <int>{};
  final _selected = <int>{};
  bool _searching = false;

  void _toggleSelect(Song s) => setState(() => _selected.contains(s.id) ? _selected.remove(s.id) : _selected.add(s.id));

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final songsAsync = ref.watch(songsProvider);
    final songTags = ref.watch(songTagsProvider).value ?? const {};
    final tags = ref.watch(tagsProvider).value ?? const [];
    final all = songsAsync.value ?? const <Song>[];
    final lastOpened = all.where((s) => s.lastOpenedAt != null).fold<Song?>(
        null, (best, s) => best == null || s.lastOpenedAt!.isAfter(best.lastOpenedAt!) ? s : best);

    List<String> tagNames(Song s) => [for (final t in songTags[s.id] ?? const <Tag>[]) t.name];
    final visible = sortSongs(
      all.where((s) =>
          matchesQuery(s, _query, tagNames(s)) &&
          (_tagFilter.isEmpty || (songTags[s.id] ?? const []).any((t) => _tagFilter.contains(t.id)))),
      settings.librarySort,
    );
    final selecting = _selected.isNotEmpty;

    return PopScope(
      canPop: !selecting && !_searching,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        setState(() {
          _selected.clear();
          _searching = false;
          _query = '';
          _search.clear();
        });
      },
      child: Scaffold(
        appBar: selecting ? _selectionBar(all) : _normalBar(settings, all.isNotEmpty),
        floatingActionButton: selecting
            ? null
            : FloatingActionButton.extended(
                onPressed: () => importFlow(context, ref),
                icon: const Icon(Icons.file_upload_outlined),
                label: const Text('Import PDFs'),
              ),
        body: Column(children: [
          if (tags.isNotEmpty && all.isNotEmpty)
            SizedBox(
              height: 52,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  for (final t in tags)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(t.name),
                        avatar: CircleAvatar(backgroundColor: Color(t.color), radius: 6),
                        showCheckmark: false,
                        selected: _tagFilter.contains(t.id),
                        onSelected: (on) => setState(() => on ? _tagFilter.add(t.id) : _tagFilter.remove(t.id)),
                      ),
                    ),
                ],
              ),
            ),
          Expanded(child: _body(songsAsync, all, visible, settings, songTags, lastOpened)),
        ]),
      ),
    );
  }

  Widget _body(AsyncValue<List<Song>> async, List<Song> all, List<Song> visible, AppSettings settings,
      Map<int, List<Tag>> songTags, Song? lastOpened) {
    if (async.isLoading && all.isEmpty) return const Center(child: CircularProgressIndicator());
    if (all.isEmpty) {
      return EmptyState(
        icon: Icons.library_music_outlined,
        title: 'Your library is empty',
        message: 'Import your sheet music as PDF files. You can select many files at once.',
        action: FilledButton.icon(
          onPressed: () => importFlow(context, ref),
          icon: const Icon(Icons.file_upload_outlined),
          label: const Text('Import PDFs'),
        ),
      );
    }
    if (visible.isEmpty) {
      return const EmptyState(icon: Icons.search_off, title: 'No matches', message: 'Try a different search or filter.');
    }
    void onTap(Song s) => _selected.isNotEmpty ? _toggleSelect(s) : openSongs(context, visible, visible.indexOf(s));
    if (settings.libraryGrid) {
      return SongGrid(songs: visible, selected: _selected, onTap: onTap, onLongPress: _toggleSelect);
    }
    return SongList(
      songs: visible,
      sort: settings.librarySort,
      selected: _selected,
      highlightId: lastOpened?.id,
      tagsOf: (s) => songTags[s.id] ?? const [],
      onTap: onTap,
      onLongPress: _toggleSelect,
      trailingBuilder: _selected.isNotEmpty
          ? null
          : (s) => IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => showSongMenu(context, ref, s),
              ),
    );
  }

  PreferredSizeWidget _normalBar(AppSettings settings, bool hasSongs) {
    final notifier = ref.read(settingsProvider.notifier);
    return AppBar(
      title: _searching
          ? TextField(
              controller: _search,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search title, composer, tags…',
                filled: false,
                border: InputBorder.none,
              ),
              onChanged: (v) => setState(() => _query = v),
            )
          : const Text('Library'),
      actions: [
        IconButton(
          tooltip: _searching ? 'Close search' : 'Search',
          icon: Icon(_searching ? Icons.close : Icons.search),
          onPressed: () => setState(() {
            _searching = !_searching;
            if (!_searching) {
              _query = '';
              _search.clear();
            }
          }),
        ),
        if (hasSongs) ...[
          PopupMenuButton<SongSort>(
            tooltip: 'Sort',
            icon: const Icon(Icons.sort),
            initialValue: settings.librarySort,
            onSelected: (s) => notifier.set((x) => x.copyWith(librarySort: s)),
            itemBuilder: (_) => [
              for (final s in SongSort.values)
                CheckedPopupMenuItem(value: s, checked: s == settings.librarySort, child: Text(s.label)),
            ],
          ),
          IconButton(
            tooltip: settings.libraryGrid ? 'List view' : 'Grid view',
            icon: Icon(settings.libraryGrid ? Icons.view_list_outlined : Icons.grid_view_outlined),
            onPressed: () => notifier.set((x) => x.copyWith(libraryGrid: !x.libraryGrid)),
          ),
          IconButton(
            tooltip: 'Select',
            icon: const Icon(Icons.checklist),
            onPressed: () {
              final first = ref.read(songsProvider).value?.firstOrNull;
              if (first != null) _toggleSelect(first);
            },
          ),
        ],
        const SizedBox(width: 8),
      ],
    );
  }

  PreferredSizeWidget _selectionBar(List<Song> all) {
    final ids = _selected.toList();
    final songs = [for (final s in all) if (_selected.contains(s.id)) s];
    return AppBar(
      leading: IconButton(icon: const Icon(Icons.close), onPressed: () => setState(_selected.clear)),
      title: Text('${_selected.length} selected'),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      actions: [
        IconButton(
          tooltip: 'Select all',
          icon: const Icon(Icons.select_all),
          onPressed: () => setState(() => _selected.addAll(all.map((s) => s.id))),
        ),
        IconButton(
          tooltip: 'Add to folder',
          icon: const Icon(Icons.create_new_folder_outlined),
          onPressed: () async {
            await addToFolder(context, ref, ids);
            setState(_selected.clear);
          },
        ),
        IconButton(
          tooltip: 'Add to setlist',
          icon: const Icon(Icons.playlist_add),
          onPressed: () async {
            await addToSetlist(context, ref, ids);
            setState(_selected.clear);
          },
        ),
        IconButton(
          tooltip: 'Tag',
          icon: const Icon(Icons.label_outline),
          onPressed: () async {
            await tagSongs(context, ref, ids);
            setState(_selected.clear);
          },
        ),
        IconButton(
          tooltip: 'Delete',
          icon: const Icon(Icons.delete_outline),
          onPressed: () async {
            if (await deleteSongs(context, ref, songs)) setState(_selected.clear);
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
