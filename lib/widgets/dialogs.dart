import 'package:flutter/material.dart';

const paletteColors = [
  0xFF5C6BC0, 0xFF42A5F5, 0xFF26A69A, 0xFF66BB6A, 0xFFFFCA28, //
  0xFFFFA726, 0xFFEF5350, 0xFFEC407A, 0xFFAB47BC, 0xFF8D6E63, 0xFF78909C,
];

Future<String?> promptText(
  BuildContext context, {
  required String title,
  String initial = '',
  String hint = '',
  String action = 'Save',
  int maxLines = 1,
}) {
  final controller = TextEditingController(text: initial)..selection = TextSelection(baseOffset: 0, extentOffset: initial.length);
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        autofocus: true,
        minLines: 1,
        maxLines: maxLines,
        decoration: InputDecoration(hintText: hint),
        textCapitalization: TextCapitalization.sentences,
        onSubmitted: maxLines == 1 ? (v) => Navigator.pop(context, v.trim()) : null,
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: Text(action)),
      ],
    ),
  ).then((v) => (v == null || v.isEmpty) ? null : v);
}

/// Asks for a name and a colour. Returns null when cancelled.
Future<(String, int)?> promptNameAndColor(
  BuildContext context, {
  required String title,
  String initial = '',
  int? color,
  String action = 'Save',
}) {
  final controller = TextEditingController(text: initial);
  var selected = color ?? paletteColors.first;
  return showDialog<(String, int)>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(title),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(hintText: 'Name'),
          ),
          const SizedBox(height: 16),
          ColorPickerRow(selected: selected, onSelected: (c) => setState(() => selected = c)),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) Navigator.pop(context, (name, selected));
            },
            child: Text(action),
          ),
        ],
      ),
    ),
  );
}

class ColorPickerRow extends StatelessWidget {
  const ColorPickerRow({super.key, required this.selected, required this.onSelected, this.colors = paletteColors});

  final int selected;
  final ValueChanged<int> onSelected;
  final List<int> colors;

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 10, runSpacing: 10, children: [
      for (final c in colors)
        GestureDetector(
          onTap: () => onSelected(c),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Color(c),
              shape: BoxShape.circle,
              border: Border.all(
                color: c == selected ? Theme.of(context).colorScheme.onSurface : Colors.transparent,
                width: 3,
              ),
            ),
            child: c == selected ? const Icon(Icons.check, size: 18, color: Colors.white) : null,
          ),
        ),
    ]);
  }
}

Future<bool> confirm(
  BuildContext context, {
  required String title,
  String? message,
  String action = 'Delete',
  bool destructive = true,
}) async {
  final scheme = Theme.of(context).colorScheme;
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: message == null ? null : Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        FilledButton(
          style: destructive ? FilledButton.styleFrom(backgroundColor: scheme.error, foregroundColor: scheme.onError) : null,
          onPressed: () => Navigator.pop(context, true),
          child: Text(action),
        ),
      ],
    ),
  );
  return ok ?? false;
}

void showSnack(BuildContext context, String message, {SnackBarAction? action}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message), action: action));
}

/// Runs [task] while showing a small blocking progress dialog.
Future<T> withProgress<T>(BuildContext context, String label, Future<T> Function() task) async {
  final nav = Navigator.of(context, rootNavigator: true);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: AlertDialog(
        content: Row(children: [
          const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 3)),
          const SizedBox(width: 20),
          Expanded(child: Text(label)),
        ]),
      ),
    ),
  );
  try {
    return await task();
  } finally {
    nav.pop();
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, required this.message, this.action});

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: t.colorScheme.primaryContainer, shape: BoxShape.circle),
            child: Icon(icon, size: 48, color: t.colorScheme.onPrimaryContainer),
          ),
          const SizedBox(height: 20),
          Text(title, style: t.textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Text(message,
                style: t.textTheme.bodyMedium?.copyWith(color: t.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center),
          ),
          if (action != null) ...[const SizedBox(height: 24), action!],
        ]),
      ),
    );
  }
}
