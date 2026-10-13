import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/db.dart';
import '../../data/providers.dart';
import '../../widgets/dialogs.dart';

class SetlistsScreen extends ConsumerWidget {
  const SetlistsScreen({super.key});

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final name = await promptText(context, title: 'New setlist', hint: 'e.g. Concert 12 May', action: 'Create');
    if (name == null) return;
    final id = await ref.read(databaseProvider).createSetlist(name);
    if (context.mounted) context.go('/setlists/$id');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(setlistsProvider);
    final counts = ref.watch(setlistCountsProvider).value ?? const {};
    final list = async.value ?? const <Setlist>[];
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Setlists')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _create(context, ref),
        icon: const Icon(Icons.playlist_add),
        label: const Text('New setlist'),
      ),
      body: async.isLoading && list.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : list.isEmpty
              ? EmptyState(
                  icon: Icons.queue_music_outlined,
                  title: 'No setlists yet',
                  message: 'Put songs in the order you play them, then swipe through all of them in one go.',
                  action: FilledButton.icon(
                    onPressed: () => _create(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Create setlist'),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  itemCount: list.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final s = list[i];
                    final n = counts[s.id] ?? 0;
                    return Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        leading: CircleAvatar(
                          backgroundColor: t.colorScheme.secondaryContainer,
                          child: Icon(Icons.queue_music, color: t.colorScheme.onSecondaryContainer),
                        ),
                        title: Text(s.name, style: t.textTheme.titleMedium),
                        subtitle: Text('${n == 1 ? '1 song' : '$n songs'} · edited ${_ago(s.updatedAt)}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.go('/setlists/${s.id}'),
                      ),
                    );
                  },
                ),
    );
  }
}

String _ago(DateTime d) {
  final diff = DateTime.now().difference(d);
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inHours < 1) return '${diff.inMinutes} min ago';
  if (diff.inDays < 1) return '${diff.inHours} h ago';
  if (diff.inDays < 7) return '${diff.inDays} d ago';
  return '${d.day}.${d.month}.${d.year}';
}
