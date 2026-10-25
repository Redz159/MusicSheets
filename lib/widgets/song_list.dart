import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

import '../core/sorting.dart';
import '../data/db.dart';
import 'metadata_widgets.dart';

const _railWidth = 44.0;

/// Song list with themed section headers and a letter rail for indexed sorts.
class SongList extends StatefulWidget {
  const SongList({
    super.key,
    required this.songs,
    required this.sort,
    required this.onTap,
    this.onLongPress,
    this.selected = const {},
    this.selectionMode,
    this.highlightId,
    this.tagsOf,
    this.trailingBuilder,
    this.bottomPadding = 96,
  });

  /// Already sorted with [sortSongs].
  final List<Song> songs;
  final SongSort sort;
  final void Function(Song song) onTap;
  final void Function(Song song)? onLongPress;
  final Set<int> selected;

  /// Shows checkboxes. Defaults to "something is selected".
  final bool? selectionMode;
  final int? highlightId;
  final List<Tag> Function(Song song)? tagsOf;
  final Widget Function(Song song)? trailingBuilder;
  final double bottomPadding;

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  final _scroll = ScrollController();
  final _list = ListController();
  late IndexedSongs _indexed;

  @override
  void initState() {
    super.initState();
    _rebuild();
  }

  @override
  void didUpdateWidget(SongList old) {
    super.didUpdateWidget(old);
    if (old.songs != widget.songs || old.sort != widget.sort) _rebuild();
  }

  void _rebuild() {
    _indexed = widget.sort.indexed
        ? IndexedSongs.build(widget.songs, widget.sort)
        : IndexedSongs([for (final s in widget.songs) SongEntry(s)], const {});
  }

  @override
  void dispose() {
    _scroll.dispose();
    _list.dispose();
    super.dispose();
  }

  void _jumpTo(String letter) {
    final index = _indexed.sectionStart[letter];
    if (index == null || !_scroll.hasClients) return;
    _list.jumpToItem(index: index, scrollController: _scroll, alignment: 0);
  }

  @override
  Widget build(BuildContext context) {
    final entries = _indexed.entries;
    final showRail = widget.sort.indexed && _indexed.sectionStart.length > 1;
    final list = SuperListView.builder(
      controller: _scroll,
      listController: _list,
      padding: EdgeInsets.only(bottom: widget.bottomPadding),
      itemCount: entries.length,
      itemBuilder: (context, i) => switch (entries[i]) {
        HeaderEntry(:final letter) => _SectionHeader(letter),
        SongEntry(:final song) => _SongRow(
          song: song,
          subtitle: song.composer,
          selected: widget.selected.contains(song.id),
          selectionMode: widget.selectionMode ?? widget.selected.isNotEmpty,
          highlighted: song.id == widget.highlightId,
          tags: widget.tagsOf?.call(song) ?? const [],
          trailing: widget.trailingBuilder?.call(song),
          onTap: () => widget.onTap(song),
          onLongPress: widget.onLongPress == null
              ? null
              : () => widget.onLongPress!(song),
        ),
      },
    );
    if (!showRail) return Scrollbar(controller: _scroll, child: list);
    return Row(
      children: [
        Expanded(child: list),
        LetterRail(
          letters: _indexed.sectionStart.keys.toList(),
          onLetter: _jumpTo,
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.letter);
  final String letter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 30,
      color: theme.colorScheme.surfaceContainerHigh,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        letter,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _SongRow extends StatelessWidget {
  const _SongRow({
    required this.song,
    required this.subtitle,
    required this.selected,
    required this.selectionMode,
    required this.highlighted,
    required this.tags,
    required this.onTap,
    this.onLongPress,
    this.trailing,
  });

  final Song song;
  final String subtitle;
  final bool selected;
  final bool selectionMode;
  final bool highlighted;
  final List<Tag> tags;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final scheme = t.colorScheme;
    final bg = selected
        ? scheme.primaryContainer
        : highlighted
        ? scheme.surfaceContainerHighest
        : scheme.surface;
    return Material(
      color: bg,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          constraints: const BoxConstraints(minHeight: 72),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: scheme.outlineVariant, width: 0.6),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
          child: Row(
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 180),
                child: selectionMode
                    ? Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          selected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: selected ? scheme.primary : scheme.outline,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              if (song.coverFileName != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CoverImage(song: song, size: 52),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: t.textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            [
                              subtitle.trim().isEmpty ? '-' : subtitle,
                              if (song.instrument.isNotEmpty) song.instrument,
                              if (song.musicalKey.isNotEmpty) song.musicalKey,
                            ].join('  ·  '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        ReviewBadge(song: song),
                        for (final tag in tags.take(4)) ...[
                          const SizedBox(width: 8),
                          TagPill(tag),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}

class TagPill extends StatelessWidget {
  const TagPill(this.tag, {super.key});
  final Tag tag;

  @override
  Widget build(BuildContext context) {
    final c = Color(tag.color);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        tag.name,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: HSLColor.fromColor(c).withLightness(0.35).toColor(),
        ),
      ),
    );
  }
}

/// The black A–Z rail. Tap or drag to jump; a bubble shows the current letter.
class LetterRail extends StatefulWidget {
  const LetterRail({super.key, required this.letters, required this.onLetter});

  final List<String> letters;
  final ValueChanged<String> onLetter;

  @override
  State<LetterRail> createState() => _LetterRailState();
}

class _LetterRailState extends State<LetterRail> {
  String? _active;
  double _bubbleY = 0;

  void _handle(Offset local, double cellHeight) {
    final i = (local.dy / cellHeight).floor().clamp(
      0,
      widget.letters.length - 1,
    );
    final letter = widget.letters[i];
    _bubbleY = (i + 0.5) * cellHeight;
    if (letter != _active) {
      HapticFeedback.selectionClick();
      setState(() => _active = letter);
      widget.onLetter(letter);
    } else {
      setState(() {});
    }
  }

  void _end() => setState(() => _active = null);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, c) {
        final cell = (c.maxHeight / widget.letters.length).clamp(18.0, 52.0);
        final fontSize = (cell * 0.55).clamp(11.0, 26.0);
        return SizedBox(
          width: _railWidth,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: ColoredBox(color: scheme.surfaceContainerLow),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (d) => _handle(d.localPosition, cell),
                onTapUp: (_) => _end(),
                onVerticalDragStart: (d) => _handle(d.localPosition, cell),
                onVerticalDragUpdate: (d) => _handle(d.localPosition, cell),
                onVerticalDragEnd: (_) => _end(),
                onVerticalDragCancel: _end,
                child: SizedBox(
                  height: c.maxHeight,
                  child: Column(
                    children: [
                      for (final l in widget.letters)
                        Container(
                          height: cell,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: l == _active
                                ? scheme.secondaryContainer
                                : null,
                          ),
                          child: Text(
                            l,
                            style: TextStyle(
                              color: l == _active
                                  ? scheme.onSecondaryContainer
                                  : scheme.onSurfaceVariant,
                              fontSize: fontSize,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (_active != null)
                Positioned(
                  right: _railWidth + 12,
                  top: _bubbleY - 36,
                  child: IgnorePointer(
                    child: Container(
                      width: 72,
                      height: 72,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(blurRadius: 12, color: Colors.black26),
                        ],
                      ),
                      child: Text(
                        _active!,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onPrimary,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
