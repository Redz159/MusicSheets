import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/ordering.dart';
import '../../data/db.dart';
import '../../data/providers.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/song_actions.dart';

class SetlistScreen extends ConsumerStatefulWidget {
  const SetlistScreen({super.key, required this.setlistId});
  final int setlistId;

  @override
  ConsumerState<SetlistScreen> createState() => _SetlistScreenState();
}

class _SetlistScreenState extends ConsumerState<SetlistScreen> {
  /// Local copy so reorders show instantly, before the database round-trip.
  List<SetlistEntry>? _local;

  Future<void> _onReorder(List<SetlistEntry> entries, int oldIndex, int newIndex) async {
    final r = reorderPosition([for (final e in entries) e.item.position], oldIndex, newIndex);
    final moved = entries[oldIndex];
    final next = [...entries]..removeAt(oldIndex);
    next.insert(r.index, moved);
    setState(() => _local = next);
    final db = ref.read(databaseProvider);
    if (r.needsNormalize) {
      await db.normalizeSetlist(widget.setlistId, [for (final e in next) e.item.id]);
    } else {
      await db.moveSetlistItem(widget.setlistId, moved.item.id, r.position);
    }
  }

  Future<void> _add() async {
    final ids = await pickSongs(context, title: 'Add to setlist');
    if (ids != null && ids.isNotEmpty) await ref.read(databaseProvider).addSongsToSetlist(widget.setlistId, ids);
  }

  void _play(List<SetlistEntry> entries, Setlist setlist, int index) {
    openSongs(context, [for (final e in entries) e.song], index, setlistName: setlist.name, resume: false);
  }

  @override
  Widget build(BuildContext context) {
    final setlist = ref.watch(setlistProvider(widget.setlistId)).value;
    ref.listen(setlistEntriesProvider(widget.setlistId), (_, next) {
      if (next.hasValue) setState(() => _local = null);
    });
    final entries = _local ?? ref.watch(setlistEntriesProvider(widget.setlistId)).value ?? const [];
    final db = ref.read(databaseProvider);
    final t = Theme.of(context);
    if (setlist == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final totalPages = entries.fold<int>(0, (a, e) => a + e.song.pageCount);

    return Scaffold(
      appBar: AppBar(
        title: Text(setlist.name),
        actions: [
          IconButton(tooltip: 'Add songs', icon: const Icon(Icons.playlist_add), onPressed: _add),
          PopupMenuButton<String>(
            onSelected: (v) async {
              switch (v) {
                case 'rename':
                  final name = await promptText(context, title: 'Rename setlist', initial: setlist.name);
                  if (name != null) await db.renameSetlist(setlist.id, name);
                case 'export':
                  if (entries.isNotEmpty && context.mounted) {
                    await exportSongs(context, ref, [for (final e in entries) e.song], setlist.name);
                  }
                case 'delete':
                  if (await confirm(context, title: 'Delete "${setlist.name}"?', message: 'The songs stay in your library.')) {
                    await db.deleteSetlist(setlist.id);
                    if (context.mounted) context.go('/setlists');
                  }
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'rename', child: ListTile(leading: Icon(Icons.edit_outlined), title: Text('Rename'))),
              PopupMenuItem(
                  value: 'export', child: ListTile(leading: Icon(Icons.ios_share), title: Text('Export as one PDF'))),
              PopupMenuItem(
                  value: 'delete', child: ListTile(leading: Icon(Icons.delete_outline), title: Text('Delete setlist'))),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: entries.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _play(entries, setlist, 0),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Play'),
            ),
      body: entries.isEmpty
          ? EmptyState(
              icon: Icons.queue_music_outlined,
              title: 'No songs yet',
              message: 'Add songs, then drag them into the order you play them.',
              action: FilledButton.icon(onPressed: _add, icon: const Icon(Icons.add), label: const Text('Add songs')),
            )
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                child: Text(
                  '${entries.length} songs · $totalPages pages · drag to reorder, swipe to remove',
                  style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant),
                ),
              ),
              Expanded(
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.only(bottom: 96),
                  buildDefaultDragHandles: false,
                  itemCount: entries.length,
                  onReorder: (o, n) => _onReorder(entries, o, n),
                  proxyDecorator: (child, _, anim) => Material(
                    elevation: 6,
                    color: t.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                    child: child,
                  ),
                  itemBuilder: (context, i) {
                    final e = entries[i];
                    return Dismissible(
                      key: ValueKey(e.item.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: t.colorScheme.errorContainer,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        child: Icon(Icons.remove_circle_outline, color: t.colorScheme.onErrorContainer),
                      ),
                      onDismissed: (_) {
                        setState(() => _local = [...entries]..removeAt(i));
                        db.removeSetlistItem(e.item.id);
                        showSnack(context, 'Removed "${e.song.title}"',
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () => db.addSongsToSetlist(setlist.id, [e.song.id]).then((_) async {
                                // put it back where it was
                                final list = await db.watchSetlistEntries(setlist.id).first;
                                final re = list.last;
                                final positions = [for (final x in list) x.item.position];
                                final r = reorderPosition(positions, list.length - 1, i);
                                await db.moveSetlistItem(setlist.id, re.item.id, r.position);
                              }),
                            ));
                      },
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 12, right: 8),
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: t.colorScheme.primaryContainer,
                          child: Text('${i + 1}',
                              style: TextStyle(fontSize: 13, color: t.colorScheme.onPrimaryContainer)),
                        ),
                        title: Text(e.song.title, style: const TextStyle(fontSize: 17)),
                        subtitle: Text(
                            '${e.song.composer.isEmpty ? '-' : e.song.composer} · ${e.song.pageCount} p.'),
                        onTap: () => _play(entries, setlist, i),
                        trailing: ReorderableDragStartListener(
                          index: i,
                          child: const Padding(padding: EdgeInsets.all(12), child: Icon(Icons.drag_handle)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]),
    );
  }
}
