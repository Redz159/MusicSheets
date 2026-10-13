import 'package:flutter/material.dart';

import 'annotation_store.dart';
import 'tool_state.dart';

/// Floating toolbar shown while annotating.
class AnnotationToolbar extends StatelessWidget {
  const AnnotationToolbar({
    super.key,
    required this.tools,
    required this.store,
    required this.stylusOnly,
    required this.onStylusOnly,
    required this.onClearPage,
    required this.onDone,
  });

  final ToolState tools;
  final AnnotationStore store;
  final bool stylusOnly;
  final ValueChanged<bool> onStylusOnly;
  final VoidCallback onClearPage;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListenableBuilder(
      listenable: Listenable.merge([tools, store]),
      builder: (context, _) {
        final colors = tools.usesHighlightPalette ? highlightColors : penColors;
        final showColors = tools.tool != AnnoTool.eraser;
        final showWidths = tools.tool != AnnoTool.eraser;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Panel(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final t in AnnoTool.values)
                            _ToolButton(
                              icon: t.icon,
                              tooltip: t.label,
                              selected: tools.tool == t,
                              onTap: () => tools.tool = t,
                            ),
                          const _Sep(),
                          if (showColors)
                            _Flyout<int>(
                              // A new key per palette so it closes when switching pen/highlighter.
                              key: ValueKey(colors),
                              tooltip: 'Color',
                              options: colors,
                              selected: tools.color,
                              onSelected: (c) => tools.color = c,
                              itemBuilder: (c, selected) => Container(
                                width: 28,
                                height: 28,
                                margin: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: Color(c).withValues(alpha: 1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selected ? scheme.primary : scheme.outlineVariant,
                                    width: selected ? 3 : 1,
                                  ),
                                ),
                              ),
                            ),
                          if (showWidths) ...[
                            const _Sep(),
                            _Flyout<int>(
                              tooltip: 'Thickness',
                              options: const [0, 1, 2],
                              selected: tools.widthIndex,
                              onSelected: (i) => tools.widthIndex = i,
                              itemBuilder: (i, selected) => Container(
                                width: 42,
                                height: 42,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: selected ? scheme.primaryContainer : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  width: 18,
                                  height: 3.0 + i * 3,
                                  decoration: BoxDecoration(
                                    color: selected ? scheme.onPrimaryContainer : scheme.onSurface,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ],
                          const _Sep(),
                          _ToolButton(icon: Icons.undo, tooltip: 'Undo', onTap: store.canUndo ? store.undo : null),
                          _ToolButton(icon: Icons.redo, tooltip: 'Redo', onTap: store.canRedo ? store.redo : null),
                          _ToolButton(icon: Icons.delete_sweep_outlined, tooltip: 'Clear page', onTap: onClearPage),
                          _ToolButton(
                            icon: stylusOnly ? Icons.draw : Icons.touch_app_outlined,
                            tooltip: stylusOnly ? 'Stylus only (fingers turn pages)' : 'Draw with finger & stylus',
                            selected: stylusOnly,
                            onTap: () => onStylusOnly(!stylusOnly),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Pinned outside the scrolling tools so it is always reachable.
                  const _Sep(),
                  FilledButton.icon(onPressed: onDone, icon: const Icon(Icons.check), label: const Text('Done')),
                  const SizedBox(width: 4),
                ],
              ),
            ),
            if (tools.tool == AnnoTool.stamp) ...[
              const SizedBox(height: 8),
              _Panel(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final s in stamps)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: ChoiceChip(
                            label: Text(
                              s,
                              style: const TextStyle(
                                fontFamily: 'serif',
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            selected: tools.stamp == s,
                            showCheckmark: false,
                            onSelected: (_) => tools.stamp = s,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Shows only the current choice; tapping it slides the other options out to the right.
class _Flyout<T> extends StatefulWidget {
  const _Flyout({
    super.key,
    required this.tooltip,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.itemBuilder,
  });

  final String tooltip;
  final List<T> options;
  final T selected;
  final ValueChanged<T> onSelected;
  final Widget Function(T value, bool selected) itemBuilder;

  @override
  State<_Flyout<T>> createState() => _FlyoutState<T>();
}

class _FlyoutState<T> extends State<_Flyout<T>> {
  bool _open = false;

  Widget _tappable(T value, bool selected, VoidCallback onTap) =>
      InkWell(onTap: onTap, customBorder: const CircleBorder(), child: widget.itemBuilder(value, selected));

  @override
  Widget build(BuildContext context) {
    final others = [
      for (final o in widget.options)
        if (o != widget.selected) o,
    ];
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The current choice and the arrow form one tap target.
        Tooltip(
          message: widget.tooltip,
          child: InkWell(
            onTap: () => setState(() => _open = !_open),
            customBorder: const StadiumBorder(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.itemBuilder(widget.selected, true),
                SizedBox(
                  width: 22,
                  height: 42,
                  child: AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.chevron_right, size: 18, color: muted),
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          alignment: Alignment.centerLeft,
          child: _open
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final o in others)
                      _tappable(o, false, () {
                        widget.onSelected(o);
                        setState(() => _open = false);
                      }),
                  ],
                )
              : const SizedBox(height: 42),
        ),
      ],
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      shadowColor: Colors.black45,
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(28),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), child: child),
    );
  }
}

class _Sep extends StatelessWidget {
  const _Sep();

  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 28,
    margin: const EdgeInsets.symmetric(horizontal: 8),
    color: Theme.of(context).colorScheme.outlineVariant,
  );
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({required this.icon, required this.tooltip, this.selected = false, this.onTap});

  final IconData icon;
  final String tooltip;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? scheme.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            size: 22,
            color: onTap == null
                ? scheme.onSurface.withValues(alpha: 0.3)
                : selected
                ? scheme.onPrimaryContainer
                : scheme.onSurface,
          ),
        ),
      ),
    );
  }
}
