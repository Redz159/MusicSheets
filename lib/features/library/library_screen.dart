import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/settings.dart';
import '../../core/sorting.dart';
import '../../data/db.dart';
import '../../data/providers.dart';
import '../../services/services.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/metadata_widgets.dart';
import '../../widgets/platform_widgets.dart';
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
  bool _reviewOnly = false;

  void _toggleSelect(Song s) => setState(
    () =>
        _selected.contains(s.id) ? _selected.remove(s.id) : _selected.add(s.id),
  );

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final songsAsync = ref.watch(songsProvider);
    final songTags = ref.watch(songTagsProvider).value ?? const {};
    final tags = ref.watch(tagsProvider).value ?? const [];
    final all = songsAsync.value ?? const <Song>[];
    final lastOpened = all
        .where((s) => s.lastOpenedAt != null)
        .fold<Song?>(
          null,
          (best, s) =>
              best == null || s.lastOpenedAt!.isAfter(best.lastOpenedAt!)
              ? s
              : best,
        );

    List<String> tagNames(Song s) => [
      for (final t in songTags[s.id] ?? const <Tag>[]) t.name,
    ];
    final reviewCount = ref.watch(reviewSongsProvider).length;
    if (_reviewOnly && reviewCount == 0) _reviewOnly = false;
    final visible = sortSongs(
      all.where(
        (s) =>
            (!_reviewOnly || s.lookupStatus == 'needsReview') &&
            matchesQuery(s, _query, tagNames(s)) &&
            (_tagFilter.isEmpty ||
                (songTags[s.id] ?? const []).any(
                  (t) => _tagFilter.contains(t.id),
                )),
      ),
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
      child: PlatformScaffold(
        appBar: selecting
            ? _selectionBar(all)
            : _normalBar(settings, all.isNotEmpty),
        floatingActionButton: selecting
            ? null
            : PlatformActionButton(
                onPressed: () => importFlow(context, ref),
                icon: const Icon(Icons.file_upload_outlined),
                label: const Text('Import PDFs'),
              ),
        body: Column(
          children: [
            if (reviewCount > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: usesCupertinoPresentation
                      ? _iosFilterPill(
                          context,
                          label: 'Needs review ($reviewCount)',
                          selected: _reviewOnly,
                          icon: CupertinoIcons.question_circle,
                          onPressed: () =>
                              setState(() => _reviewOnly = !_reviewOnly),
                        )
                      : FilterChip(
                          avatar: const Icon(Icons.help_outline, size: 18),
                          label: Text('Needs review ($reviewCount)'),
                          selected: _reviewOnly,
                          onSelected: (on) => setState(() => _reviewOnly = on),
                        ),
                ),
              ),
            if (tags.isNotEmpty && all.isNotEmpty)
              SizedBox(
                height: 52,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  children: [
                    for (final t in tags)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: usesCupertinoPresentation
                            ? _iosFilterPill(
                                context,
                                label: t.name,
                                selected: _tagFilter.contains(t.id),
                                color: Color(t.color),
                                onPressed: () => setState(
                                  () => _tagFilter.contains(t.id)
                                      ? _tagFilter.remove(t.id)
                                      : _tagFilter.add(t.id),
                                ),
                              )
                            : FilterChip(
                                label: Text(t.name),
                                avatar: CircleAvatar(
                                  backgroundColor: Color(t.color),
                                  radius: 6,
                                ),
                                showCheckmark: false,
                                selected: _tagFilter.contains(t.id),
                                onSelected: (on) => setState(
                                  () => on
                                      ? _tagFilter.add(t.id)
                                      : _tagFilter.remove(t.id),
                                ),
                              ),
                      ),
                  ],
                ),
              ),
            Expanded(
              child: _body(
                songsAsync,
                all,
                visible,
                settings,
                songTags,
                lastOpened,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iosFilterPill(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onPressed,
    IconData? icon,
    Color? color,
  }) {
    final foreground = selected
        ? CupertinoColors.white
        : CupertinoColors.label.resolveFrom(context);
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      borderRadius: BorderRadius.circular(18),
      color: selected
          ? CupertinoTheme.of(context).primaryColor
          : CupertinoColors.tertiarySystemFill.resolveFrom(context),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (color != null)
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            )
          else if (icon != null)
            Icon(icon, size: 16, color: foreground),
          if (color != null || icon != null) const SizedBox(width: 6),
          Text(label, style: TextStyle(color: foreground)),
        ],
      ),
    );
  }

  Widget _body(
    AsyncValue<List<Song>> async,
    List<Song> all,
    List<Song> visible,
    AppSettings settings,
    Map<int, List<Tag>> songTags,
    Song? lastOpened,
  ) {
    if (async.isLoading && all.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    if (all.isEmpty) {
      return EmptyState(
        icon: Icons.library_music_outlined,
        title: 'Your library is empty',
        message: 'Import your sheet music as PDF files. You can select many files at once.',
        action: PlatformPrimaryButton(
          onPressed: () => importFlow(context, ref),
          icon: const Icon(Icons.file_upload_outlined),
          label: const Text('Import PDFs'),
        ),
      );
    }
    if (visible.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off,
        title: 'No matches',
        message: 'Try a different search or filter.',
      );
    }
    void onTap(Song s) => _selected.isNotEmpty
        ? _toggleSelect(s)
        : openSongs(context, visible, visible.indexOf(s));
    if (settings.libraryGrid) {
      return SongGrid(
        songs: visible,
        selected: _selected,
        onTap: onTap,
        onLongPress: _toggleSelect,
      );
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
              tooltip: 'Song actions',
              icon: const Icon(Icons.more_vert),
              onPressed: () => showSongMenu(context, ref, s),
            ),
    );
  }

  PreferredSizeWidget _normalBar(AppSettings settings, bool hasSongs) {
    final notifier = ref.read(settingsProvider.notifier);
    return AppBar(
      title: _searching
          ? platformTextField(
              controller: _search,
              autofocus: true,
              hint: 'Search title, composer, artist, tags…',
              decoration: const InputDecoration(
                hintText: 'Search title, composer, artist, tags…',
                filled: false,
                border: InputBorder.none,
              ),
              onChanged: (v) => setState(() => _query = v),
            )
          : const Text('Library'),
      actions: [
        IconButton(
          tooltip: _searching ? 'Close search' : 'Search',
          icon: Icon(
            usesCupertinoPresentation
                ? (_searching ? CupertinoIcons.xmark : CupertinoIcons.search)
                : (_searching ? Icons.close : Icons.search),
          ),
          onPressed: () => setState(() {
            _searching = !_searching;
            if (!_searching) {
              _query = '';
              _search.clear();
            }
          }),
        ),
        if (hasSongs) ...[
          PlatformMenuButton<SongSort>(
            tooltip: 'Sort',
            icon: const Icon(Icons.sort),
            cupertinoIcon: CupertinoIcons.sort_down,
            onSelected: (s) => notifier.set((x) => x.copyWith(librarySort: s)),
            actions: [
              for (final s in SongSort.values)
                PlatformMenuAction(
                  value: s,
                  title: s.label,
                  selected: s == settings.librarySort,
                ),
            ],
          ),
          IconButton(
            tooltip: settings.libraryGrid ? 'List view' : 'Grid view',
            icon: Icon(
              usesCupertinoPresentation
                  ? (settings.libraryGrid
                        ? CupertinoIcons.list_bullet
                        : CupertinoIcons.square_grid_2x2)
                  : (settings.libraryGrid
                        ? Icons.view_list_outlined
                        : Icons.grid_view_outlined),
            ),
            onPressed: () =>
                notifier.set((x) => x.copyWith(libraryGrid: !x.libraryGrid)),
          ),
          IconButton(
            tooltip: 'Select',
            icon: Icon(
              usesCupertinoPresentation
                  ? CupertinoIcons.checkmark_circle
                  : Icons.checklist,
            ),
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
    final songs = [
      for (final s in all)
        if (_selected.contains(s.id)) s,
    ];
    if (usesCupertinoPresentation) {
      return AppBar(
        leading: IconButton(
          tooltip: 'Cancel selection',
          icon: const Icon(CupertinoIcons.xmark),
          onPressed: () => setState(_selected.clear),
        ),
        title: Text('${_selected.length} selected'),
        actions: [
          PlatformMenuButton<String>(
            tooltip: 'Selection actions',
            icon: const Icon(Icons.more_vert),
            cupertinoIcon: CupertinoIcons.ellipsis,
            onSelected: (action) async {
              switch (action) {
                case 'all':
                  setState(() => _selected.addAll(all.map((s) => s.id)));
                case 'folder':
                  await addToFolder(context, ref, ids);
                  if (mounted) setState(_selected.clear);
                case 'setlist':
                  await addToSetlist(context, ref, ids);
                  if (mounted) setState(_selected.clear);
                case 'tag':
                  await tagSongs(context, ref, ids);
                  if (mounted) setState(_selected.clear);
                case 'metadata':
                  await fetchMetadataFor(context, ref, ids);
                  if (mounted) setState(_selected.clear);
                case 'delete':
                  if (await deleteSongs(context, ref, songs) && mounted) {
                    setState(_selected.clear);
                  }
              }
            },
            actions: const [
              PlatformMenuAction(
                value: 'all',
                title: 'Select all',
                cupertinoIcon: CupertinoIcons.check_mark_circled,
              ),
              PlatformMenuAction(
                value: 'folder',
                title: 'Add to folder',
                cupertinoIcon: CupertinoIcons.folder_badge_plus,
              ),
              PlatformMenuAction(
                value: 'setlist',
                title: 'Add to setlist',
                cupertinoIcon: CupertinoIcons.music_note_list,
              ),
              PlatformMenuAction(
                value: 'tag',
                title: 'Tag',
                cupertinoIcon: CupertinoIcons.tag,
              ),
              PlatformMenuAction(
                value: 'metadata',
                title: 'Fetch metadata',
                cupertinoIcon: CupertinoIcons.cloud_download,
              ),
              PlatformMenuAction(
                value: 'delete',
                title: 'Delete',
                cupertinoIcon: CupertinoIcons.delete,
                destructive: true,
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      );
    }
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => setState(_selected.clear),
      ),
      title: Text('${_selected.length} selected'),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      actions: [
        IconButton(
          tooltip: 'Select all',
          icon: const Icon(Icons.select_all),
          onPressed: () =>
              setState(() => _selected.addAll(all.map((s) => s.id))),
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
          tooltip: 'Fetch metadata',
          icon: const Icon(Icons.cloud_download_outlined),
          onPressed: () async {
            await fetchMetadataFor(context, ref, ids);
            setState(_selected.clear);
          },
        ),
        IconButton(
          tooltip: 'Delete',
          icon: const Icon(Icons.delete_outline),
          onPressed: () async {
            if (await deleteSongs(context, ref, songs)) {
              setState(_selected.clear);
            }
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
