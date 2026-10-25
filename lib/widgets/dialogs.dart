import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const paletteColors = [
  0xFF5C6BC0, 0xFF42A5F5, 0xFF26A69A, 0xFF66BB6A, 0xFFFFCA28, //
  0xFFFFA726, 0xFFEF5350, 0xFFEC407A, 0xFFAB47BC, 0xFF8D6E63, 0xFF78909C,
];

bool get _usesCupertinoPresentation =>
    defaultTargetPlatform == TargetPlatform.iOS;

Future<T?> showPlatformDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  if (_usesCupertinoPresentation) {
    return showCupertinoDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: builder,
  );
}

Future<T?> showPlatformSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,
  bool useSafeArea = false,
}) {
  if (_usesCupertinoPresentation) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (context) {
        final height = MediaQuery.sizeOf(context).height;
        return CupertinoPopupSurface(
          child: SafeArea(
            top: useSafeArea,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: height * (isScrollControlled ? 0.9 : 0.65),
              ),
              child: builder(context),
            ),
          ),
        );
      },
    );
  }
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    builder: builder,
  );
}

Widget platformDialogAction(
  BuildContext context, {
  required String label,
  required VoidCallback onPressed,
  bool isDefault = false,
  bool isDestructive = false,
}) {
  if (_usesCupertinoPresentation) {
    return CupertinoDialogAction(
      isDefaultAction: isDefault,
      isDestructiveAction: isDestructive,
      onPressed: onPressed,
      child: Text(label),
    );
  }
  if (isDefault || isDestructive) {
    final scheme = Theme.of(context).colorScheme;
    return FilledButton(
      style: isDestructive
          ? FilledButton.styleFrom(
              backgroundColor: scheme.error,
              foregroundColor: scheme.onError,
            )
          : null,
      onPressed: onPressed,
      child: Text(label),
    );
  }
  return TextButton(onPressed: onPressed, child: Text(label));
}

Widget platformTextField({
  required TextEditingController controller,
  String hint = '',
  int maxLines = 1,
  int minLines = 1,
  bool autofocus = true,
  TextInputType? keyboardType,
  TextCapitalization textCapitalization = TextCapitalization.sentences,
  InputDecoration? decoration,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmitted,
}) {
  if (_usesCupertinoPresentation) {
    return CupertinoTextField(
      controller: controller,
      autofocus: autofocus,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
      placeholder: hint.isNotEmpty
          ? hint
          : (decoration?.hintText ?? decoration?.labelText),
      textCapitalization: textCapitalization,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
  return TextField(
    controller: controller,
    autofocus: autofocus,
    minLines: minLines,
    maxLines: maxLines,
    keyboardType: keyboardType,
    decoration: decoration ?? InputDecoration(hintText: hint),
    textCapitalization: textCapitalization,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
  );
}

Future<String?> promptText(
  BuildContext context, {
  required String title,
  String initial = '',
  String hint = '',
  String action = 'Save',
  int maxLines = 1,
}) {
  final controller = TextEditingController(text: initial)
    ..selection = TextSelection(baseOffset: 0, extentOffset: initial.length);
  return showPlatformDialog<String>(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: Text(title),
      content: platformTextField(
        controller: controller,
        hint: hint,
        maxLines: maxLines,
        onSubmitted: maxLines == 1
            ? (v) => Navigator.pop(context, v.trim())
            : null,
      ),
      actions: [
        platformDialogAction(
          context,
          label: 'Cancel',
          onPressed: () => Navigator.pop(context),
        ),
        platformDialogAction(
          context,
          label: action,
          isDefault: true,
          onPressed: () => Navigator.pop(context, controller.text.trim()),
        ),
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
  return showPlatformDialog<(String, int)>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog.adaptive(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            platformTextField(
              controller: controller,
              hint: 'Name',
              maxLines: 1,
            ),
            const SizedBox(height: 16),
            ColorPickerRow(
              selected: selected,
              onSelected: (c) => setState(() => selected = c),
            ),
          ],
        ),
        actions: [
          platformDialogAction(
            context,
            label: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
          platformDialogAction(
            context,
            label: action,
            isDefault: true,
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) Navigator.pop(context, (name, selected));
            },
          ),
        ],
      ),
    ),
  );
}

class ColorPickerRow extends StatelessWidget {
  const ColorPickerRow({
    super.key,
    required this.selected,
    required this.onSelected,
    this.colors = paletteColors,
  });

  final int selected;
  final ValueChanged<int> onSelected;
  final List<int> colors;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
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
                  color: c == selected
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.transparent,
                  width: 3,
                ),
              ),
              child: c == selected
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
          ),
      ],
    );
  }
}

Future<bool> confirm(
  BuildContext context, {
  required String title,
  String? message,
  String action = 'Delete',
  bool destructive = true,
}) async {
  final ok = await showPlatformDialog<bool>(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: Text(title),
      content: message == null ? null : Text(message),
      actions: [
        platformDialogAction(
          context,
          label: 'Cancel',
          onPressed: () => Navigator.pop(context, false),
        ),
        platformDialogAction(
          context,
          label: action,
          isDefault: !destructive,
          isDestructive: destructive,
          onPressed: () => Navigator.pop(context, true),
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
Future<T> withProgress<T>(
  BuildContext context,
  String label,
  Future<T> Function() task,
) async {
  final nav = Navigator.of(context, rootNavigator: true);
  showPlatformDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false,
      child: AlertDialog.adaptive(
        content: Row(
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator.adaptive(strokeWidth: 3),
            ),
            const SizedBox(width: 20),
            Expanded(child: Text(label)),
          ],
        ),
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
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            !Platform.isIOS ? 
              Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: t.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: t.colorScheme.onPrimaryContainer,
              ),
            ) : Container(),
            !Platform.isIOS ? const SizedBox(height: 20) : Container(),
            Text(
              title,
              style: t.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Text(
                message,
                style: t.textTheme.bodyMedium?.copyWith(
                  color: t.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}
