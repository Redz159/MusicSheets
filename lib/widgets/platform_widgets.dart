import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool get usesCupertinoPresentation =>
    defaultTargetPlatform == TargetPlatform.iOS;

class PlatformMenuAction<T> {
  const PlatformMenuAction({
    required this.value,
    required this.title,
    this.icon,
    this.cupertinoIcon,
    this.selected = false,
    this.destructive = false,
  });

  final T value;
  final String title;
  final IconData? icon;
  final IconData? cupertinoIcon;
  final bool selected;
  final bool destructive;
}

class PlatformMenuButton<T> extends StatelessWidget {
  const PlatformMenuButton({
    super.key,
    required this.actions,
    required this.onSelected,
    required this.icon,
    this.cupertinoIcon,
    this.tooltip,
  });

  final List<PlatformMenuAction<T>> actions;
  final ValueChanged<T> onSelected;
  final Widget icon;
  final IconData? cupertinoIcon;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    if (!usesCupertinoPresentation) {
      return PopupMenuButton<T>(
        tooltip: tooltip,
        icon: icon,
        onSelected: onSelected,
        itemBuilder: (context) => [
          for (final action in actions)
            PopupMenuItem<T>(
              value: action.value,
              child: Row(
                children: [
                  if (action.icon != null) ...[
                    Icon(action.icon, size: 20),
                    const SizedBox(width: 12),
                  ],
                  Expanded(child: Text(action.title)),
                  if (action.selected) const Icon(Icons.check, size: 18),
                ],
              ),
            ),
        ],
      );
    }

    final button = CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () async {
        final selected = await showCupertinoModalPopup<T>(
          context: context,
          builder: (popupContext) => CupertinoActionSheet(
            title: tooltip == null ? null : Text(tooltip!),
            actions: [
              for (final action in actions)
                CupertinoActionSheetAction(
                  isDestructiveAction: action.destructive,
                  onPressed: () => Navigator.pop(popupContext, action.value),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (action.icon != null ||
                          action.cupertinoIcon != null) ...[
                        Icon(
                          action.cupertinoIcon ?? action.icon,
                          size: 19,
                          color: action.destructive
                              ? CupertinoColors.destructiveRed
                              : null,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(action.title),
                      if (action.selected) ...[
                        const SizedBox(width: 8),
                        const Icon(CupertinoIcons.check_mark, size: 16),
                      ],
                    ],
                  ),
                ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(popupContext),
              child: const Text('Cancel'),
            ),
          ),
        );
        if (selected != null) onSelected(selected);
      },
      child: cupertinoIcon == null ? icon : Icon(cupertinoIcon),
    );
    return tooltip == null ? button : Tooltip(message: tooltip!, child: button);
  }
}

IconData _cupertinoIconFor(IconData icon) => switch (icon) {
  Icons.arrow_back => CupertinoIcons.back,
  Icons.close => CupertinoIcons.xmark,
  Icons.search => CupertinoIcons.search,
  Icons.sort => CupertinoIcons.sort_down,
  Icons.more_horiz || Icons.more_vert => CupertinoIcons.ellipsis,
  Icons.add => CupertinoIcons.add,
  Icons.playlist_add => CupertinoIcons.music_note_list,
  Icons.file_upload_outlined || Icons.upload_file => CupertinoIcons.share,
  Icons.create_new_folder_outlined => CupertinoIcons.folder_badge_plus,
  Icons.folder_off_outlined => CupertinoIcons.folder,
  Icons.checklist || Icons.select_all => CupertinoIcons.check_mark_circled,
  Icons.delete_outline => CupertinoIcons.delete,
  Icons.ios_share || Icons.share => CupertinoIcons.share,
  Icons.info_outline => CupertinoIcons.info,
  _ => icon,
};

Widget _cupertinoActionIcon(
  Widget icon, {
  Color? color,
  bool selected = false,
}) {
  if (icon is! Icon || icon.icon == null) return icon;
  return Icon(
    _cupertinoIconFor(icon.icon!),
    size: icon.size,
    color:
        icon.color ?? color ?? (selected ? CupertinoColors.activeBlue : null),
  );
}

Widget _navigationAction(Widget action, {Color? foregroundColor}) {
  if (action is IconButton) {
    final button = CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: action.onPressed,
      child: _cupertinoActionIcon(
        action.isSelected == true
            ? (action.selectedIcon ?? action.icon)
            : action.icon,
        color: action.color ?? foregroundColor,
        selected: action.isSelected == true,
      ),
    );
    return action.tooltip == null
        ? button
        : Tooltip(message: action.tooltip!, child: button);
  }
  if (action is TextButton) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      onPressed: action.onPressed,
      child: DefaultTextStyle(
        style: TextStyle(color: foregroundColor ?? CupertinoColors.activeBlue),
        child: action.child ?? const SizedBox(),
      ),
    );
  }
  return action;
}

class PlatformScaffold extends StatelessWidget {
  const PlatformScaffold({
    super.key,
    this.appBar,
    this.largeTitle,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final PreferredSizeWidget? appBar;
  final String? largeTitle;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    if (!usesCupertinoPresentation) {
      return Scaffold(
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      );
    }

    final materialBar = appBar is AppBar ? appBar! as AppBar : null;
    final materialActions = materialBar?.actions ?? const <Widget>[];
    final foregroundColor =
        materialBar?.foregroundColor ?? Theme.of(context).colorScheme.onSurface;
    final adaptedActions = materialActions
        .map(
          (action) =>
              _navigationAction(action, foregroundColor: foregroundColor),
        )
        .toList();
    final adaptedLeading = materialBar?.leading == null
        ? null
        : _navigationAction(
            materialBar!.leading!,
            foregroundColor: foregroundColor,
          );
    final cupertinoBackground =
        materialBar?.backgroundColor ??
        CupertinoColors.systemGroupedBackground.resolveFrom(context);
    final navigationBorder = materialBar?.elevation == 0
        ? null
        : const Border(bottom: BorderSide(color: CupertinoColors.separator));
    final navigationTitle = materialBar?.title == null
        ? null
        : DefaultTextStyle.merge(
            style: TextStyle(color: foregroundColor),
            child: materialBar!.title!,
          );
    Widget bodyWithOverlay() => Stack(
      fit: StackFit.expand,
      children: [
        body,
        if (floatingActionButton != null)
          Positioned(
            right: 16,
            bottom: 16,
            child: SafeArea(child: floatingActionButton!),
          ),
      ],
    );

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: largeTitle != null || materialBar == null
          ? null
          : CupertinoNavigationBar(
              middle: navigationTitle,
              backgroundColor: cupertinoBackground,
              border: navigationBorder,
              leading: adaptedLeading,
              automaticallyImplyLeading: materialBar.automaticallyImplyLeading,
              trailing: adaptedActions.isEmpty
                  ? null
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: adaptedActions,
                    ),
            ),
      child: largeTitle == null
          ? bodyWithOverlay()
          : NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                CupertinoSliverNavigationBar(
                  largeTitle: Text(
                    largeTitle!,
                    style: TextStyle(color: foregroundColor),
                  ),
                  middle: navigationTitle,
                  backgroundColor: cupertinoBackground,
                  border: navigationBorder,
                  leading: adaptedLeading,
                  automaticallyImplyLeading:
                      materialBar?.automaticallyImplyLeading ?? true,
                  trailing: adaptedActions.isEmpty
                      ? null
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: adaptedActions,
                        ),
                ),
              ],
              body: bodyWithOverlay(),
            ),
    );
  }
}

class PlatformSwitchTile extends StatelessWidget {
  const PlatformSwitchTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final Widget title;
  final Widget? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    if (usesCupertinoPresentation) {
      return CupertinoListTile(
        title: title,
        subtitle: subtitle,
        trailing: CupertinoSwitch(value: value, onChanged: onChanged),
        onTap: onChanged == null ? null : () => onChanged!(!value),
      );
    }
    return SwitchListTile(
      title: title,
      subtitle: subtitle,
      value: value,
      onChanged: onChanged,
    );
  }
}

class PlatformListTile extends StatelessWidget {
  const PlatformListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (usesCupertinoPresentation) {
      return CupertinoListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: onTap,
      );
    }
    return ListTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class PlatformSettingsSection extends StatelessWidget {
  const PlatformSettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.footer,
  });

  final String title;
  final List<Widget> children;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    if (usesCupertinoPresentation) {
      return CupertinoListSection.insetGrouped(
        header: Text(title.toUpperCase()),
        footer: footer,
        children: children,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 4),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ...children,
        if (footer != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: footer,
          ),
      ],
    );
  }
}

class PlatformSlider extends StatelessWidget {
  const PlatformSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.label,
    required this.onChanged,
  });

  final double value;
  final double min;
  final double max;
  final int divisions;
  final String label;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    if (usesCupertinoPresentation) {
      return Row(
        children: [
          Expanded(
            child: CupertinoSlider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
          if (label.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      );
    }
    return Slider(
      value: value,
      min: min,
      max: max,
      divisions: divisions,
      label: label,
      onChanged: onChanged,
    );
  }
}

class PlatformSliderTile extends StatelessWidget {
  const PlatformSliderTile({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.label,
    required this.onChanged,
  });

  final Widget title;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String label;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    if (usesCupertinoPresentation) {
      return CupertinoListTile(
        title: title,
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: PlatformSlider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: label,
            onChanged: onChanged,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: 4),
          PlatformSlider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: label,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class PlatformActionButton extends StatelessWidget {
  const PlatformActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback onPressed;
  final Widget icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    if (usesCupertinoPresentation) {
      return CupertinoButton.filled(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [icon, const SizedBox(width: 8), label],
        ),
      );
    }
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: icon,
      label: label,
    );
  }
}

class PlatformPrimaryButton extends StatelessWidget {
  const PlatformPrimaryButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback onPressed;
  final Widget icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    if (usesCupertinoPresentation) {
      return CupertinoButton(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [icon, const SizedBox(width: 8), label],
        ),
      );
    }
    return FilledButton.icon(onPressed: onPressed, icon: icon, label: label);
  }
}

class PlatformSecondaryButton extends StatelessWidget {
  const PlatformSecondaryButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  final VoidCallback onPressed;
  final Widget icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    if (usesCupertinoPresentation) {
      return CupertinoButton(
        onPressed: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [icon, const SizedBox(width: 8), label],
        ),
      );
    }
    return OutlinedButton.icon(onPressed: onPressed, icon: icon, label: label);
  }
}
