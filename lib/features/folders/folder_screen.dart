import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sorting.dart';
import '../../data/db.dart';
import '../../data/providers.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/platform_widgets.dart';
import '../../widgets/song_actions.dart';
import '../../widgets/song_list.dart';
import 'folders_screen.dart';

class FolderScreen extends ConsumerStatefulWidget {
  const FolderScreen({super.key, required this.folderId});
  final int folderId;

  @override
  ConsumerState<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends ConsumerState<FolderScreen> {
  final _selected = <int>{};

  void _toggle(Song s) => setState(
    () =>
        _selected.contains(s.id) ? _selected.remove(s.id) : _selected.add(s.id),
  );

  Future<void> _addSongs(List<Song> current) async {
    final ids = await pickSongs(
      context,
      title: 'Add to folder',
      exclude: {for (final s in current) s.id},
    );
    if (ids != null) {
      await ref.read(databaseProvider).addSongsToFolder(widget.folderId, ids);
    }
  }

  @override
  Widget build(BuildContext context) {
    final folder = ref.watch(folderProvider(widget.folderId)).value;
    final songsAsync = ref.watch(folderSongsProvider(widget.folderId));
    final songTags = ref.watch(songTagsProvider).value ?? const {};
    final db = ref.read(databaseProvider);
    if (folder == null) {
      return const PlatformScaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    final sort = SongSort.parse(folder.sortMode);
    final songs = sortSongs(songsAsync.value ?? const [], sort);
    final selecting = _selected.isNotEmpty;

    return PopScope(
      canPop: !selecting,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(_selected.clear);
      },
      child: PlatformScaffold(
        appBar: selecting
            ? AppBar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(_selected.clear),
                ),
                title: Text('${_selected.length} selected'),
                actions: [
                  IconButton(
                    tooltip: 'Add to setlist',
                    icon: const Icon(Icons.playlist_add),
                    onPressed: () async {
                      await addToSetlist(context, ref, _selected.toList());
                      setState(_selected.clear);
                    },
                  ),
                  IconButton(
                    tooltip: 'Remove from folder',
                    icon: const Icon(Icons.folder_off_outlined),
                    onPressed: () async {
                      await db.removeSongsFromFolder(
                        widget.folderId,
                        _selected.toList(),
                      );
                      setState(_selected.clear);
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              )
            : AppBar(
                title: Row(
                  children: [
                    Icon(Icons.folder_rounded, color: Color(folder.color)),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(folder.name, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                actions: [
                  PlatformMenuButton<SongSort>(
                    tooltip: 'Sort',
                    icon: const Icon(Icons.sort),
                    cupertinoIcon: CupertinoIcons.sort_down,
                    onSelected: (s) =>
                        db.updateFolder(folder.id, sortMode: s.name),
                    actions: [
                      for (final s in SongSort.values)
                        PlatformMenuAction(
                          value: s,
                          selected: s == sort,
                          title: s.label,
                        ),
                    ],
                  ),
                  IconButton(
                    tooltip: 'Import PDFs into this folder',
                    icon: const Icon(Icons.file_upload_outlined),
                    onPressed: () =>
                        importFlow(context, ref, folderId: folder.id),
                  ),
                  IconButton(
                    icon: Icon(
                      usesCupertinoPresentation
                          ? CupertinoIcons.ellipsis
                          : Icons.more_vert,
                    ),
                    onPressed: () =>
                        showFolderMenu(context, ref, folder, popOnDelete: true),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
        floatingActionButton: selecting
            ? null
            : PlatformActionButton(
                onPressed: () => _addSongs(songs),
                icon: const Icon(Icons.add),
                label: const Text('Add songs'),
              ),
        body: songs.isEmpty
            ? EmptyState(
                icon: Icons.folder_open_outlined,
                title: 'This folder is empty',
                message: 'Add songs from your library or import new PDFs straight into this folder.',
                action: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    PlatformPrimaryButton(
                      onPressed: () => _addSongs(songs),
                      icon: const Icon(Icons.add),
                      label: const Text('Add songs'),
                    ),
                    PlatformSecondaryButton(
                      onPressed: () =>
                          importFlow(context, ref, folderId: folder.id),
                      icon: const Icon(Icons.file_upload_outlined),
                      label: const Text('Import PDFs'),
                    ),
                  ],
                ),
              )
            : SongList(
                songs: songs,
                sort: sort,
                selected: _selected,
                tagsOf: (s) => songTags[s.id] ?? const [],
                onTap: (s) => selecting
                    ? _toggle(s)
                    : openSongs(context, songs, songs.indexOf(s)),
                onLongPress: _toggle,
                trailingBuilder: selecting
                    ? null
                    : (s) => IconButton(
                        tooltip: 'Song actions',
                        icon: const Icon(Icons.more_vert),
                        onPressed: () => showSongMenu(
                          context,
                          ref,
                          s,
                          extra: (sheet) => [
                            PlatformListTile(
                              leading: const Icon(Icons.folder_off_outlined),
                              title: const Text('Remove from this folder'),
                              onTap: () {
                                Navigator.pop(sheet);
                                db.removeSongsFromFolder(folder.id, [s.id]);
                              },
                            ),
                          ],
                        ),
                      ),
              ),
      ),
    );
  }
}
