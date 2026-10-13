import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/db.dart';
import '../../data/providers.dart';
import '../../widgets/dialogs.dart';

class FoldersScreen extends ConsumerWidget {
  const FoldersScreen({super.key});

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final r = await promptNameAndColor(context, title: 'New folder', action: 'Create');
    if (r != null) await ref.read(databaseProvider).createFolder(r.$1, r.$2);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folders = ref.watch(foldersProvider);
    final counts = ref.watch(folderCountsProvider).value ?? const {};
    final list = folders.value ?? const <Folder>[];
    return Scaffold(
      appBar: AppBar(title: const Text('Folders')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _create(context, ref),
        icon: const Icon(Icons.create_new_folder_outlined),
        label: const Text('New folder'),
      ),
      body: folders.isLoading && list.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : list.isEmpty
              ? EmptyState(
                  icon: Icons.folder_outlined,
                  title: 'No folders yet',
                  message: 'Folders group songs, for example by band, instrument or genre. A song can be in several folders.',
                  action: FilledButton.icon(
                    onPressed: () => _create(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Create folder'),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 260,
                    mainAxisExtent: 132,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, i) => _FolderCard(folder: list[i], count: counts[list[i].id] ?? 0),
                ),
    );
  }
}

class _FolderCard extends ConsumerWidget {
  const _FolderCard({required this.folder, required this.count});
  final Folder folder;
  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Color(folder.color);
    final t = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: () => context.go('/folders/${folder.id}'),
        onLongPress: () => showFolderMenu(context, ref, folder),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(14)),
                child: Icon(Icons.folder_rounded, color: color, size: 28),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () => showFolderMenu(context, ref, folder),
              ),
            ]),
            const Spacer(),
            Text(folder.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.textTheme.titleMedium),
            Text(count == 1 ? '1 song' : '$count songs',
                style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant)),
          ]),
        ),
      ),
    );
  }
}

Future<void> showFolderMenu(BuildContext context, WidgetRef ref, Folder folder, {bool popOnDelete = false}) {
  final db = ref.read(databaseProvider);
  return showModalBottomSheet<void>(
    context: context,
    builder: (sheet) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(title: Text(folder.name, style: Theme.of(context).textTheme.titleLarge)),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.edit_outlined),
          title: const Text('Rename & colour'),
          onTap: () async {
            Navigator.pop(sheet);
            final r = await promptNameAndColor(context, title: 'Edit folder', initial: folder.name, color: folder.color);
            if (r != null) await db.updateFolder(folder.id, name: r.$1, color: r.$2);
          },
        ),
        ListTile(
          leading: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
          title: Text('Delete folder', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          subtitle: const Text('Songs stay in your library'),
          onTap: () async {
            Navigator.pop(sheet);
            if (await confirm(context, title: 'Delete "${folder.name}"?', message: 'The songs stay in your library.')) {
              await db.deleteFolder(folder.id);
              if (popOnDelete && context.mounted) context.go('/folders');
            }
          },
        ),
      ]),
    ),
  );
}
