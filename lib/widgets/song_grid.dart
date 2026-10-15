import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db.dart';
import '../data/providers.dart';
import '../services/services.dart';
import 'metadata_widgets.dart';

class SongThumbnail extends ConsumerStatefulWidget {
  const SongThumbnail({super.key, required this.song});
  final Song song;

  @override
  ConsumerState<SongThumbnail> createState() => _SongThumbnailState();
}

class _SongThumbnailState extends ConsumerState<SongThumbnail> {
  Future<File?>? _future;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(SongThumbnail old) {
    super.didUpdateWidget(old);
    if (old.song.fileHash != widget.song.fileHash) _load();
  }

  void _load() {
    final paths = ref.read(appPathsProvider);
    _future = ref.read(thumbnailServiceProvider).thumbnail(paths.pdf(widget.song.fileName), widget.song.fileHash);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File?>(
      future: _future,
      builder: (context, snap) {
        final file = snap.data;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: file == null
              ? Container(
                  key: const ValueKey('placeholder'),
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Icon(Icons.music_note, color: Colors.grey.shade400, size: 36),
                )
              : Image.file(file, key: ValueKey(file.path), fit: BoxFit.cover, alignment: Alignment.topCenter),
        );
      },
    );
  }
}

class SongGrid extends StatelessWidget {
  const SongGrid({
    super.key,
    required this.songs,
    required this.onTap,
    this.onLongPress,
    this.selected = const {},
  });

  final List<Song> songs;
  final void Function(Song) onTap;
  final void Function(Song)? onLongPress;
  final Set<int> selected;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 190,
        childAspectRatio: 0.62,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
      ),
      itemCount: songs.length,
      itemBuilder: (context, i) {
        final s = songs[i];
        final isSelected = selected.contains(s.id);
        return GestureDetector(
          onTap: () => onTap(s),
          onLongPress: onLongPress == null ? null : () => onLongPress!(s),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? t.colorScheme.primary : t.colorScheme.outlineVariant,
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: const [BoxShadow(blurRadius: 6, offset: Offset(0, 2), color: Color(0x22000000))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Stack(fit: StackFit.expand, children: [
                    Hero(tag: 'song-${s.id}', child: SongThumbnail(song: s)),
                    if (s.coverFileName != null)
                      Positioned(left: 6, bottom: 6, child: CoverImage(song: s, size: 44)),
                    if (s.lookupStatus == 'needsReview') Positioned(left: 4, top: 4, child: ReviewBadge(song: s)),
                    if (isSelected)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: CircleAvatar(
                          radius: 13,
                          backgroundColor: t.colorScheme.primary,
                          child: Icon(Icons.check, size: 16, color: t.colorScheme.onPrimary),
                        ),
                      ),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(s.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.textTheme.titleSmall),
            Text(s.composer.isEmpty ? '${s.pageCount} pages' : s.composer,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: t.textTheme.bodySmall?.copyWith(color: t.colorScheme.onSurfaceVariant)),
          ]),
        );
      },
    );
  }
}
