import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/settings.dart';
import 'features/folders/folder_screen.dart';
import 'features/folders/folders_screen.dart';
import 'features/library/library_screen.dart';
import 'features/setlists/setlist_screen.dart';
import 'features/setlists/setlists_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/viewer/viewer_screen.dart';
import 'services/services.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/library',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                builder: (_, _) => const LibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/folders',
                builder: (_, _) => const FoldersScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (_, s) => FolderScreen(
                      folderId: int.parse(s.pathParameters['id']!),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/setlists',
                builder: (_, _) => const SetlistsScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (_, s) => SetlistScreen(
                      setlistId: int.parse(s.pathParameters['id']!),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, _) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/viewer',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: ViewerScreen(args: state.extra! as ViewerArgs),
          transitionDuration: const Duration(milliseconds: 260),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (defaultTargetPlatform == TargetPlatform.iOS) {
              return CupertinoPageTransition(
                primaryRouteAnimation: animation,
                secondaryRouteAnimation: secondaryAnimation,
                linearTransition: false,
                child: child,
              );
            }
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: ScaleTransition(
                scale: Tween(begin: 0.97, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
                child: child,
              ),
            );
          },
        ),
      ),
    ],
  );
});

ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoColors.activeBlue
        : const Color(0xFF4C5FD5),
    brightness: brightness,
  );
  final typography = Typography.material2021(platform: defaultTargetPlatform);
  return ThemeData(
    colorScheme: scheme,
    brightness: brightness,
    platform: defaultTargetPlatform,
    useSystemColors: true,
    typography: typography,
    visualDensity: VisualDensity.standard,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal,
        ),
      },
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 1,
      centerTitle: defaultTargetPlatform == TargetPlatform.iOS,
      titleTextStyle: typography.black.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(showDragHandle: true),
    cardTheme: CardThemeData(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      clipBehavior: Clip.antiAlias,
    ),
  );
}

class MusicSheetsApp extends ConsumerWidget {
  const MusicSheetsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingsProvider.select((s) => s.themeMode));
    return MaterialApp.router(
      title: 'MusicSheets',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: themeMode,
      routerConfig: ref.watch(routerProvider),
    );
  }
}

/// Tablet: navigation rail. Phone: bottom navigation bar.
class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  static const _destinations = [
    (Icons.library_music_outlined, Icons.library_music, 'Library'),
    (Icons.folder_outlined, Icons.folder, 'Folders'),
    (Icons.queue_music_outlined, Icons.queue_music, 'Setlists'),
    (Icons.settings_outlined, Icons.settings, 'Settings'),
  ];
  static const _cupertinoIcons = [
    CupertinoIcons.music_note,
    CupertinoIcons.folder,
    CupertinoIcons.music_note_list,
    CupertinoIcons.gear,
  ];

  void _go(int i) =>
      shell.goBranch(i, initialLocation: i == shell.currentIndex);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(lookupControllerProvider); // keeps the metadata queue running
    final wide = MediaQuery.sizeOf(context).width >= 720;
    if (wide) {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return CupertinoPageScaffold(
          child: SafeArea(
            child: Row(
              children: [
                SizedBox(
                  width: 220,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 12, 18),
                        child: Text(
                          'MusicSheets',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      for (var i = 0; i < _destinations.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          child: CupertinoButton(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            color: i == shell.currentIndex
                                ? CupertinoColors.activeBlue.withValues(
                                    alpha: 0.12,
                                  )
                                : null,
                            onPressed: () => _go(i),
                            child: Row(
                              children: [
                                Icon(
                                  _cupertinoIcons[i],
                                  size: 19,
                                  color: i == shell.currentIndex
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _destinations[i].$3,
                                  style: TextStyle(
                                    color: i == shell.currentIndex
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                    fontWeight: i == shell.currentIndex
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  color: CupertinoColors.separator.resolveFrom(context),
                ),
                Expanded(child: shell),
              ],
            ),
          ),
        );
      }
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: _go,
              labelType: NavigationRailLabelType.all,
              groupAlignment: -0.85,
              leading: Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                child: Icon(
                  Icons.music_note_rounded,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              destinations: [
                for (final d in _destinations)
                  NavigationRailDestination(
                    icon: Icon(d.$1),
                    selectedIcon: Icon(d.$2),
                    label: Text(d.$3),
                  ),
              ],
            ),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(child: shell),
          ],
        ),
      );
    }
    return Scaffold(
      body: shell,
      bottomNavigationBar: defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoTabBar(
              currentIndex: shell.currentIndex,
              onTap: _go,
              items: [
                for (var i = 0; i < _destinations.length; i++)
                  BottomNavigationBarItem(
                    icon: Icon(_cupertinoIcons[i]),
                    label: _destinations[i].$3,
                  ),
              ],
            )
          : NavigationBar(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: _go,
              destinations: [
                for (final d in _destinations)
                  NavigationDestination(
                    icon: Icon(d.$1),
                    selectedIcon: Icon(d.$2),
                    label: d.$3,
                  ),
              ],
            ),
    );
  }
}
