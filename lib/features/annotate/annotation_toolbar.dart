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
        return Column(mainAxisSize: MainAxisSize.min, children: [
          _Panel(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                for (final t in AnnoTool.values)
                  _ToolButton(
                    icon: t.icon,
                    tooltip: t.label,
                    selected: tools.tool == t,
                    onTap: () => tools.tool = t,
                  ),
                const _Sep(),
                if (showColors)
                  for (final c in colors)
                    GestureDetector(
                      onTap: () => tools.color = c,
                      child: Container(
                        width: 28,
                        height: 28,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: Color(c).withValues(alpha: 1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: tools.color == c ? scheme.primary : scheme.outlineVariant,
                            width: tools.color == c ? 3 : 1,
                          ),
                        ),
                      ),
                    ),
                if (showWidths) ...[
                  const _Sep(),
                  for (var i = 0; i < 3; i++)
                    _ToolButton(
                      tooltip: ['Thin', 'Medium', 'Thick'][i],
                      selected: tools.widthIndex == i,
                      onTap: () => tools.widthIndex = i,
                      child: Container(
                        width: 18,
                        height: 3.0 + i * 3,
                        decoration: BoxDecoration(color: scheme.onSurface, borderRadius: BorderRadius.circular(4)),
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
                const SizedBox(width: 4),
                FilledButton(onPressed: onDone, child: const Text('Done')),
                const SizedBox(width: 4),
              ]),
            ),
          ),
          if (tools.tool == AnnoTool.stamp) ...[
            const SizedBox(height: 8),
            _Panel(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  for (final s in stamps)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: ChoiceChip(
                        label: Text(s,
                            style: const TextStyle(
                                fontFamily: 'serif', fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                        selected: tools.stamp == s,
                        showCheckmark: false,
                        onSelected: (_) => tools.stamp = s,
                      ),
                    ),
                ]),
              ),
            ),
          ],
        ]);
      },
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
  const _ToolButton({this.icon, this.child, required this.tooltip, this.selected = false, this.onTap});

  final IconData? icon;
  final Widget? child;
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
          child: child ??
              Icon(icon,
                  size: 22,
                  color: onTap == null
                      ? scheme.onSurface.withValues(alpha: 0.3)
                      : selected
                          ? scheme.onPrimaryContainer
                          : scheme.onSurface),
        ),
      ),
    );
  }
}
