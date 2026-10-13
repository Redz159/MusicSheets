import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'metronome.dart';

/// Material Icons has no metronome, so this draws the classic one: a pyramid with a swinging arm.
class MetronomeIcon extends StatelessWidget {
  const MetronomeIcon({super.key, this.color, this.size});

  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final s = size ?? theme.size ?? 24;
    return CustomPaint(size: Size.square(s), painter: _MetronomePainter(color ?? theme.color ?? Colors.black));
  }
}

class _MetronomePainter extends CustomPainter {
  _MetronomePainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.9
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    final body = Path()
      ..moveTo(6, 21)
      ..lineTo(18, 21)
      ..lineTo(14.5, 3.5)
      ..lineTo(9.5, 3.5)
      ..close();
    canvas.drawPath(body, stroke);
    canvas.drawLine(const Offset(7.2, 16.5), const Offset(16.8, 16.5), stroke);
    canvas.drawLine(const Offset(12, 16.5), const Offset(18.5, 6), stroke);
    canvas.drawCircle(const Offset(16.4, 9.4), 1.7, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_MetronomePainter old) => old.color != color;
}

/// Rebuilds [builder] whenever the audible beat (or subdivision) changes.
class _PulseBuilder extends StatefulWidget {
  const _PulseBuilder({required this.metronome, required this.builder});

  final Metronome metronome;
  final Widget Function(BuildContext context, MetronomePulse? pulse) builder;

  @override
  State<_PulseBuilder> createState() => _PulseBuilderState();
}

class _PulseBuilderState extends State<_PulseBuilder> with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_tick);
  MetronomePulse? _pulse;

  @override
  void initState() {
    super.initState();
    widget.metronome.addListener(_sync);
    _sync();
  }

  void _sync() {
    if (widget.metronome.running) {
      if (!_ticker.isActive) _ticker.start();
    } else {
      if (_ticker.isActive) _ticker.stop();
      if (_pulse != null) setState(() => _pulse = null);
    }
  }

  void _tick(Duration _) {
    final p = widget.metronome.pulse();
    if (p?.beat != _pulse?.beat || p?.sub != _pulse?.sub) setState(() => _pulse = p);
  }

  @override
  void dispose() {
    widget.metronome.removeListener(_sync);
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _pulse);
}

/// The beat dots: tap one to cycle accent → normal → mute.
class _BeatDots extends StatelessWidget {
  const _BeatDots({required this.metronome, required this.size, this.editable = true});

  final Metronome metronome;
  final double size;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accents = metronome.settings.accents;
    return _PulseBuilder(
      metronome: metronome,
      builder: (context, pulse) => Wrap(
        alignment: WrapAlignment.center,
        spacing: size * 0.3,
        runSpacing: size * 0.3,
        children: [
          for (var i = 0; i < accents.length; i++)
            GestureDetector(
              onTap: editable
                  ? () => metronome.update((s) {
                      final next = [...s.accents];
                      next[i] = next[i].next;
                      return s.copyWith(accents: next);
                    })
                  : null,
              child: _dot(scheme, accents[i], active: pulse?.beat == i),
            ),
        ],
      ),
    );
  }

  Widget _dot(ColorScheme scheme, BeatAccent accent, {required bool active}) {
    final fill = switch (accent) {
      BeatAccent.accent => scheme.primary,
      BeatAccent.normal => scheme.secondaryContainer,
      BeatAccent.mute => Colors.transparent,
    };
    return AnimatedContainer(
      duration: const Duration(milliseconds: 60),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active && accent != BeatAccent.mute ? scheme.tertiary : fill,
        border: Border.all(
          color: active ? scheme.tertiary : scheme.outline,
          width: accent == BeatAccent.mute ? 1.5 : (active ? 2.5 : 1),
        ),
        boxShadow: active ? [BoxShadow(color: scheme.tertiary.withValues(alpha: 0.5), blurRadius: size * 0.4)] : null,
      ),
      child: accent == BeatAccent.accent && size >= 20
          ? Icon(Icons.keyboard_arrow_up, size: size * 0.7, color: active ? scheme.onTertiary : scheme.onPrimary)
          : null,
    );
  }
}

/// A button that repeats while held, speeding up (for ±1 BPM).
class _RepeatButton extends StatefulWidget {
  const _RepeatButton({required this.icon, required this.tooltip, required this.onStep});

  final IconData icon;
  final String tooltip;
  final VoidCallback onStep;

  @override
  State<_RepeatButton> createState() => _RepeatButtonState();
}

class _RepeatButtonState extends State<_RepeatButton> {
  Timer? _timer;

  void _start() {
    var delay = 400;
    void step() {
      widget.onStep();
      delay = (delay * 0.75).round().clamp(40, 400);
      _timer = Timer(Duration(milliseconds: delay), step);
    }

    _timer = Timer(const Duration(milliseconds: 400), step);
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _start(),
      onLongPressEnd: (_) => _stop(),
      onLongPressCancel: _stop,
      child: IconButton.filledTonal(
        iconSize: 28,
        tooltip: widget.tooltip,
        icon: Icon(widget.icon),
        onPressed: widget.onStep,
      ),
    );
  }
}

/// Floating metronome card shown over the sheet music.
class MetronomePanel extends StatelessWidget {
  const MetronomePanel({
    super.key,
    required this.metronome,
    required this.songTempo,
    required this.onSaveTempo,
    required this.onClose,
  });

  final Metronome metronome;

  /// The current song's stored tempo, if any.
  final int? songTempo;
  final ValueChanged<int> onSaveTempo;
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
        listenable: metronome,
        builder: (context, _) {
          final s = metronome.settings;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    MetronomeIcon(color: scheme.primary, size: 22),
                    const SizedBox(width: 10),
                    Expanded(child: Text('Metronome', style: theme.textTheme.titleMedium)),
                    IconButton(tooltip: 'Close', icon: const Icon(Icons.close), onPressed: onClose),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Tempo
                      Row(
                        children: [
                          _RepeatButton(
                            icon: Icons.remove,
                            tooltip: '−1 BPM',
                            onStep: () => metronome.setBpm(metronome.settings.bpm - 1),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '${s.bpm}',
                                  style: theme.textTheme.displayMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontFeatures: const [FontFeature.tabularFigures()],
                                  ),
                                ),
                                Text(
                                  'BPM · ${tempoMarking(s.bpm)}',
                                  style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                          _RepeatButton(
                            icon: Icons.add,
                            tooltip: '+1 BPM',
                            onStep: () => metronome.setBpm(metronome.settings.bpm + 1),
                          ),
                        ],
                      ),
                      Slider(
                        value: s.bpm.toDouble(),
                        min: minBpm.toDouble(),
                        max: maxBpm.toDouble(),
                        divisions: maxBpm - minBpm,
                        label: '${s.bpm}',
                        onChanged: (v) => metronome.setBpm(v.round()),
                      ),
                      if (songTempo != null && songTempo != s.bpm)
                        _SongTempoRow(
                          label: 'Song tempo: $songTempo BPM',
                          action: 'Use',
                          onPressed: () => metronome.setBpm(songTempo!),
                        ),
                      if (songTempo != s.bpm)
                        _SongTempoRow(
                          label: songTempo == null ? 'No tempo saved for this song' : 'Keep ${s.bpm} BPM?',
                          action: 'Save to song',
                          onPressed: () => onSaveTempo(s.bpm),
                        ),
                      const SizedBox(height: 8),

                      // Play / tap
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                              onPressed: () {
                                HapticFeedback.selectionClick();
                                metronome.tap();
                              },
                              child: const Text('Tap tempo'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                              onPressed: metronome.toggle,
                              icon: Icon(metronome.running ? Icons.stop_rounded : Icons.play_arrow_rounded, size: 28),
                              label: Text(metronome.running ? 'Stop' : 'Start'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Bar
                      _BeatDots(metronome: metronome, size: 30),
                      const SizedBox(height: 6),
                      Text(
                        'Tap a beat: accent → normal → mute',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 12),
                      _Labeled(
                        label: 'Beats per bar',
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: s.beats > 1
                                  ? () => metronome.update((s) => s.copyWith(beats: s.beats - 1))
                                  : null,
                            ),
                            SizedBox(
                              width: 44,
                              child: Text(
                                '${s.beats}/4',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.titleMedium,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: s.beats < maxBeats
                                  ? () => metronome.update((s) => s.copyWith(beats: s.beats + 1))
                                  : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Subdivision', style: theme.textTheme.labelLarge),
                      const SizedBox(height: 6),
                      SegmentedButton<Subdivision>(
                        showSelectedIcon: false,
                        segments: [for (final d in Subdivision.values) ButtonSegment(value: d, label: Text(d.label))],
                        selected: {s.subdivision},
                        onSelectionChanged: (v) => metronome.update((s) => s.copyWith(subdivision: v.first)),
                      ),
                      const SizedBox(height: 12),
                      Text('Sound', style: theme.textTheme.labelLarge),
                      const SizedBox(height: 6),
                      SegmentedButton<ClickSound>(
                        showSelectedIcon: false,
                        segments: [for (final c in ClickSound.values) ButtonSegment(value: c, label: Text(c.label))],
                        selected: {s.sound},
                        onSelectionChanged: (v) => metronome.update((s) => s.copyWith(sound: v.first)),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.volume_down, color: scheme.onSurfaceVariant),
                          Expanded(
                            child: Slider(
                              value: s.volume,
                              onChanged: (v) => metronome.update((s) => s.copyWith(volume: v)),
                            ),
                          ),
                          Icon(Icons.volume_up, color: scheme.onSurfaceVariant),
                        ],
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Flash on beat'),
                        subtitle: const Text('Visual pulse at the screen edge'),
                        value: s.flash,
                        onChanged: (v) => metronome.update((s) => s.copyWith(flash: v)),
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

class _Labeled extends StatelessWidget {
  const _Labeled({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(label, style: Theme.of(context).textTheme.labelLarge)),
      child,
    ],
  );
}

class _SongTempoRow extends StatelessWidget {
  const _SongTempoRow({required this.label, required this.action, required this.onPressed});
  final String label;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(Icons.music_note_outlined, size: 18, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 6),
        Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        TextButton(onPressed: onPressed, child: Text(action)),
      ],
    );
  }
}

/// Compact indicator while the metronome runs with the panel closed.
class MetronomePill extends StatelessWidget {
  const MetronomePill({super.key, required this.metronome, required this.onOpen});

  final Metronome metronome;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      elevation: 6,
      shadowColor: Colors.black54,
      color: scheme.surfaceContainerHigh,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
          child: ListenableBuilder(
            listenable: metronome,
            builder: (context, _) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 140),
                  child: _BeatDots(metronome: metronome, size: 12, editable: false),
                ),
                const SizedBox(width: 10),
                Text(
                  '${metronome.settings.bpm}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
                ),
                const SizedBox(width: 2),
                IconButton(tooltip: 'Stop metronome', icon: const Icon(Icons.stop_rounded), onPressed: metronome.stop),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Glows the screen edge on each beat (stronger on accents).
class MetronomeFlash extends StatefulWidget {
  const MetronomeFlash({super.key, required this.metronome});
  final Metronome metronome;

  @override
  State<MetronomeFlash> createState() => _MetronomeFlashState();
}

class _MetronomeFlashState extends State<MetronomeFlash> with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_tick);
  final _glow = ValueNotifier<(double, bool)>((0, false));

  @override
  void initState() {
    super.initState();
    widget.metronome.addListener(_sync);
    _sync();
  }

  void _sync() {
    final on = widget.metronome.running && widget.metronome.settings.flash;
    if (on && !_ticker.isActive) _ticker.start();
    if (!on && _ticker.isActive) {
      _ticker.stop();
      _glow.value = (0, false);
    }
  }

  void _tick(Duration _) {
    final p = widget.metronome.pulse();
    if (p == null) return;
    final accent = widget.metronome.settings.accents[p.beat];
    final strength = accent == BeatAccent.mute ? 0.0 : (1 - p.sinceBeat / 0.15).clamp(0.0, 1.0);
    _glow.value = (strength, accent == BeatAccent.accent);
  }

  @override
  void dispose() {
    widget.metronome.removeListener(_sync);
    _ticker.dispose();
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return IgnorePointer(
      child: ValueListenableBuilder(
        valueListenable: _glow,
        builder: (context, g, _) {
          final (strength, accent) = g;
          if (strength <= 0) return const SizedBox.expand();
          final color = (accent ? scheme.tertiary : scheme.primary).withValues(alpha: strength * 0.9);
          return DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: color, width: accent ? 8 : 5),
            ),
            child: const SizedBox.expand(),
          );
        },
      ),
    );
  }
}
