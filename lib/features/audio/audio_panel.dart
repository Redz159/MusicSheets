import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../data/db.dart';
import 'audio_playback.dart';

String _time(Duration d) {
  final s = d.inSeconds;
  return '${s ~/ 60}:${(s % 60).toString().padLeft(2, '0')}';
}

String clipSubtitle(AudioClip c) {
  final a = c.area;
  return a == null ? 'Whole song' : 'Part Â· page ${a.page + 1}';
}

/// Floating card listing the song's recordings, with the player on top.
class AudioPanel extends StatelessWidget {
  const AudioPanel({
    super.key,
    required this.playback,
    required this.clips,
    required this.onAdd,
    required this.onPlay,
    required this.onMarkPart,
    required this.onWholeSong,
    required this.onRename,
    required this.onDelete,
    required this.onClose,
  });

  final AudioPlayback playback;

  /// Recordings of the current song.
  final List<AudioClip> clips;
  final VoidCallback onAdd;
  final ValueChanged<AudioClip> onPlay;
  final ValueChanged<AudioClip> onMarkPart;
  final ValueChanged<AudioClip> onWholeSong;
  final ValueChanged<AudioClip> onRename;
  final ValueChanged<AudioClip> onDelete;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Material(
      elevation: 8,
      shadowColor: Colors.black54,
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: ListenableBuilder(
        listenable: playback,
        builder: (context, _) {
          final current = playback.clip;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(Icons.headphones_outlined, color: scheme.primary, size: 22),
                    const SizedBox(width: 10),
                    Expanded(child: Text('Recordings', style: theme.textTheme.titleMedium)),
                    IconButton(tooltip: 'Add audio file', icon: const Icon(Icons.upload_file), onPressed: onAdd),
                    IconButton(tooltip: 'Close', icon: const Icon(Icons.close), onPressed: onClose),
                  ],
                ),
                if (current != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _Player(playback: playback, clip: current),
                  ),
                  const Divider(height: 20),
                ],
                if (clips.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                    child: Column(
                      children: [
                        Text(
                          'No recordings for this song yet.\nAdd a file for the whole song or for a part of it.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: onAdd,
                          icon: const Icon(Icons.upload_file),
                          label: const Text('Add audio file'),
                        ),
                      ],
                    ),
                  )
                else
                  for (final c in clips)
                    ListTile(
                      contentPadding: const EdgeInsets.only(right: 0),
                      leading: IconButton.filledTonal(
                        isSelected: current?.id == c.id,
                        icon: Icon(current?.id == c.id && playback.playing ? Icons.pause : Icons.play_arrow),
                        onPressed: () => onPlay(c),
                      ),
                      title: Text(c.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Row(
                        children: [
                          Icon(
                            c.area == null ? Icons.queue_music : Icons.highlight_alt,
                            size: 14,
                            color: scheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(clipSubtitle(c)),
                        ],
                      ),
                      onTap: () => onPlay(c),
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) => switch (v) {
                          'mark' => onMarkPart(c),
                          'whole' => onWholeSong(c),
                          'rename' => onRename(c),
                          _ => onDelete(c),
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: 'mark',
                            child: ListTile(
                              leading: const Icon(Icons.highlight_alt),
                              title: Text(c.area == null ? 'Mark part on sheet' : 'Change marked part'),
                            ),
                          ),
                          if (c.area != null)
                            const PopupMenuItem(
                              value: 'whole',
                              child: ListTile(leading: Icon(Icons.queue_music), title: Text('Use for whole song')),
                            ),
                          const PopupMenuItem(
                            value: 'rename',
                            child: ListTile(leading: Icon(Icons.edit_outlined), title: Text('Rename')),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: ListTile(leading: Icon(Icons.delete_outline), title: Text('Delete')),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Player extends StatelessWidget {
  const _Player({required this.playback, required this.clip});
  final AudioPlayback playback;
  final AudioClip clip;

  static const speeds = [0.5, 0.75, 0.9, 1.0, 1.25];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(clip.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall),
        Text(clipSubtitle(clip), style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
        StreamBuilder<Duration>(
          stream: playback.positionStream,
          builder: (context, snap) {
            final total = playback.duration ?? Duration.zero;
            var pos = snap.data ?? Duration.zero;
            if (pos > total) pos = total;
            return Column(
              children: [
                Slider(
                  value: total.inMilliseconds == 0 ? 0 : pos.inMilliseconds / total.inMilliseconds,
                  onChanged: total.inMilliseconds == 0
                      ? null
                      : (v) => playback.seek(Duration(milliseconds: (v * total.inMilliseconds).round())),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_time(pos), style: theme.textTheme.labelSmall),
                      Text(_time(total), style: theme.textTheme.labelSmall),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: 'Loop',
              isSelected: playback.loop,
              icon: const Icon(Icons.repeat),
              selectedIcon: Icon(Icons.repeat_on, color: scheme.primary),
              onPressed: () => playback.setLoop(!playback.loop),
            ),
            IconButton(
              tooltip: 'Back 5 s',
              icon: const Icon(Icons.replay_5),
              onPressed: () => playback.skip(const Duration(seconds: -5)),
            ),
            IconButton.filled(
              iconSize: 34,
              tooltip: playback.playing ? 'Pause' : 'Play',
              icon: Icon(playback.playing ? Icons.pause : Icons.play_arrow),
              onPressed: playback.toggle,
            ),
            IconButton(
              tooltip: 'Forward 5 s',
              icon: const Icon(Icons.forward_5),
              onPressed: () => playback.skip(const Duration(seconds: 5)),
            ),
            IconButton(tooltip: 'Stop', icon: const Icon(Icons.stop), onPressed: playback.stop),
          ],
        ),
        const SizedBox(height: 4),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          children: [
            for (final s in speeds)
              ChoiceChip(
                label: Text('${s}x'.replaceAll('.0x', 'x')),
                selected: playback.speed == s,
                showCheckmark: false,
                visualDensity: VisualDensity.compact,
                onSelected: (_) => playback.setSpeed(s),
              ),
          ],
        ),
      ],
    );
  }
}

/// Small player shown while a recording is loaded and the panel is closed.
class AudioPill extends StatelessWidget {
  const AudioPill({super.key, required this.playback, required this.onOpen});
  final AudioPlayback playback;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final clip = playback.clip;
    if (clip == null) return const SizedBox.shrink();
    return Material(
      elevation: 6,
      shadowColor: Colors.black54,
      color: scheme.surfaceContainerHigh,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: playback.playing ? 'Pause' : 'Play',
                icon: Icon(playback.playing ? Icons.pause : Icons.play_arrow),
                onPressed: playback.toggle,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: Text(clip.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              IconButton(tooltip: 'Stop', icon: const Icon(Icons.close), onPressed: playback.stop),
            ],
          ),
        ),
      ),
    );
  }
}

/// Draws the marked parts of one page; each has a play button in its corner.
class ClipAreasLayer extends StatelessWidget {
  const ClipAreasLayer({
    super.key,
    required this.clips,
    required this.playback,
    required this.showAll,
    required this.onPlay,
  });

  /// Part clips on this page.
  final List<AudioClip> clips;
  final AudioPlayback playback;

  /// All areas (audio panel open) or only the one being played.
  final bool showAll;
  final ValueChanged<AudioClip> onPlay;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: playback,
      builder: (context, _) {
        final active = playback.clip?.id;
        final visible = [
          for (final c in clips)
            if (showAll || c.id == active) c,
        ];
        if (visible.isEmpty) return const SizedBox.shrink();
        return LayoutBuilder(
          builder: (context, box) => Stack(
            children: [
              for (final c in visible)
                _ClipArea(
                  clip: c,
                  size: box.biggest,
                  active: c.id == active,
                  playing: c.id == active && playback.playing,
                  showButton: showAll || c.id == active,
                  onPlay: () => onPlay(c),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ClipArea extends StatelessWidget {
  const _ClipArea({
    required this.clip,
    required this.size,
    required this.active,
    required this.playing,
    required this.showButton,
    required this.onPlay,
  });

  final AudioClip clip;
  final Size size;
  final bool active;
  final bool playing;
  final bool showButton;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final a = clip.area!;
    final rect = Rect.fromLTRB(a.left * size.width, a.top * size.height, a.right * size.width, a.bottom * size.height);
    final color = active ? scheme.primary : scheme.tertiary;
    return Positioned.fromRect(
      rect: rect,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: active ? 0.16 : 0.07),
                  border: Border.all(
                    color: color.withValues(alpha: active ? 0.9 : 0.6),
                    width: active ? 3 : 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          if (showButton)
            Positioned(
              left: 4,
              top: 4,
              child: Material(
                color: color,
                shape: const StadiumBorder(),
                elevation: 3,
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: onPlay,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(6, 4, 12, 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(playing ? Icons.pause : Icons.play_arrow, color: scheme.onPrimary, size: 22),
                        const SizedBox(width: 4),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: (rect.width - 48).clamp(0, 220)),
                          child: Text(
                            clip.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: scheme.onPrimary, fontWeight: FontWeight.w600, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum _Grab { create, move, left, right, top, bottom, topLeft, topRight, bottomLeft, bottomRight }

/// Drag over the page to mark which part a recording belongs to. An existing mark
/// can be adjusted: drag an edge (one direction), a corner (both) or the inside
/// (move it). The ✕ in the top-right corner removes it.
class AreaSelector extends StatefulWidget {
  const AreaSelector({super.key, required this.rect, required this.onChanged});

  /// Current selection on this page (normalized), if any.
  final Rect? rect;
  final ValueChanged<Rect?> onChanged;

  @override
  State<AreaSelector> createState() => _AreaSelectorState();
}

class _AreaSelectorState extends State<AreaSelector> {
  /// How close (logical px) a touch must be to an edge to grab it.
  static const _reach = 24.0;

  _Grab? _grab;
  Offset _down = Offset.zero;
  Rect? _startRect;

  _Grab _grabAt(Offset p, Rect r) {
    final nearL = (p.dx - r.left).abs() < _reach, nearR = (p.dx - r.right).abs() < _reach;
    final nearT = (p.dy - r.top).abs() < _reach, nearB = (p.dy - r.bottom).abs() < _reach;
    final inX = p.dx > r.left - _reach && p.dx < r.right + _reach;
    final inY = p.dy > r.top - _reach && p.dy < r.bottom + _reach;
    if (!inX || !inY) return _Grab.create;
    // On a small mark, prefer the nearer of two opposite edges.
    final left = nearL && (!nearR || (p.dx - r.left).abs() <= (p.dx - r.right).abs());
    final right = nearR && !left;
    final top = nearT && (!nearB || (p.dy - r.top).abs() <= (p.dy - r.bottom).abs());
    final bottom = nearB && !top;
    return switch ((left, right, top, bottom)) {
      (true, _, true, _) => _Grab.topLeft,
      (_, true, true, _) => _Grab.topRight,
      (true, _, _, true) => _Grab.bottomLeft,
      (_, true, _, true) => _Grab.bottomRight,
      (true, _, _, _) => _Grab.left,
      (_, true, _, _) => _Grab.right,
      (_, _, true, _) => _Grab.top,
      (_, _, _, true) => _Grab.bottom,
      _ => r.contains(p) ? _Grab.move : _Grab.create,
    };
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, box) {
        final size = box.biggest;
        Rect toPx(Rect n) =>
            Rect.fromLTRB(n.left * size.width, n.top * size.height, n.right * size.width, n.bottom * size.height);
        Rect toNorm(Rect px) =>
            Rect.fromLTRB(px.left / size.width, px.top / size.height, px.right / size.width, px.bottom / size.height);
        final page = Offset.zero & size;
        final r = widget.rect == null ? null : toPx(widget.rect!);

        void update(Offset p) {
          final s = _startRect;
          final g = _grab;
          if (g == null) return;
          final c = Offset(p.dx.clamp(0, size.width), p.dy.clamp(0, size.height));
          if (g == _Grab.create || s == null) {
            widget.onChanged(toNorm(Rect.fromPoints(_down, c)));
            return;
          }
          final d = p - _down;
          if (g == _Grab.move) {
            final dx = d.dx.clamp(-s.left, size.width - s.right);
            final dy = d.dy.clamp(-s.top, size.height - s.bottom);
            widget.onChanged(toNorm(s.shift(Offset(dx, dy))));
            return;
          }
          var (l, t, rr, b) = (s.left, s.top, s.right, s.bottom);
          if (g == _Grab.left || g == _Grab.topLeft || g == _Grab.bottomLeft) l = c.dx;
          if (g == _Grab.right || g == _Grab.topRight || g == _Grab.bottomRight) rr = c.dx;
          if (g == _Grab.top || g == _Grab.topLeft || g == _Grab.topRight) t = c.dy;
          if (g == _Grab.bottom || g == _Grab.bottomLeft || g == _Grab.bottomRight) b = c.dy;
          // Dragging an edge past the opposite one simply flips the mark.
          widget.onChanged(toNorm(Rect.fromPoints(Offset(l, t), Offset(rr, b))));
        }

        final children = <Widget>[
          Positioned.fill(
            child: ColoredBox(color: Colors.black.withValues(alpha: r == null ? 0.08 : 0)),
          ),
        ];
        if (r != null) {
          children.add(
            Positioned.fromRect(
              rect: r,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.15),
                    border: Border.all(color: scheme.primary, width: 3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          );
          // Handles: corners as dots, edge middles as short bars.
          Widget handle(Offset c, Size s) => Positioned(
            left: c.dx - s.width / 2,
            top: c.dy - s.height / 2,
            width: s.width,
            height: s.height,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  border: Border.all(color: scheme.primary, width: 2.5),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 3)],
                ),
              ),
            ),
          );
          const dot = Size(16, 16);
          children.addAll([
            handle(r.topLeft, dot),
            handle(r.bottomLeft, dot),
            handle(r.bottomRight, dot),
            handle(r.centerLeft, const Size(10, 28)),
            handle(r.centerRight, const Size(10, 28)),
            handle(r.topCenter, const Size(28, 10)),
            handle(r.bottomCenter, const Size(28, 10)),
          ]);
          // Remove button on the top-right corner, kept inside the page.
          const btn = 34.0;
          final cx = r.right.clamp(btn / 2, size.width - btn / 2);
          final cy = r.top.clamp(btn / 2, size.height - btn / 2);
          children.add(
            Positioned(
              left: cx - btn / 2,
              top: cy - btn / 2,
              width: btn,
              height: btn,
              child: Material(
                color: scheme.error,
                shape: CircleBorder(side: BorderSide(color: scheme.onError, width: 2)),
                elevation: 3,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => widget.onChanged(null),
                  child: Tooltip(
                    message: 'Remove marking',
                    child: Icon(Icons.close, size: 20, color: scheme.onError),
                  ),
                ),
              ),
            ),
          );
        }

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          // Grab what is under the finger, not where the drag slop was exceeded.
          dragStartBehavior: DragStartBehavior.down,
          onPanStart: (d) {
            _down = d.localPosition;
            _startRect = r;
            _grab = r == null ? _Grab.create : _grabAt(_down, r);
            if (_grab == _Grab.create && page.contains(_down)) {
              widget.onChanged(toNorm(Rect.fromPoints(_down, _down)));
            }
          },
          onPanUpdate: (d) => update(d.localPosition),
          onPanEnd: (_) => _grab = null,
          onPanCancel: () => _grab = null,
          child: Stack(clipBehavior: Clip.none, children: children),
        );
      },
    );
  }
}
