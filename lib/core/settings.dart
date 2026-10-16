import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sorting.dart';

enum PageTint {
  none('Normal'),
  sepia('Sepia'),
  night('Night');

  const PageTint(this.label);
  final String label;
}

@immutable
class AppSettings {
  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.librarySort = SongSort.title,
    this.tapZoneFraction = 0.33,
    this.twoPageLandscape = true,
    this.halfPageTurn = false,
    this.stylusOnly = false,
    this.pageTint = PageTint.none,
    this.keepScreenOn = true,
    this.swapPedal = false,
    this.libraryGrid = false,
    this.fetchMetadata = false,
    this.metadataWifiOnly = true,
  });

  final ThemeMode themeMode;
  final SongSort librarySort;

  /// Width of the left/right tap zones as a fraction of the screen.
  final double tapZoneFraction;
  final bool twoPageLandscape;
  final bool halfPageTurn;

  /// When on, only a stylus draws; fingers keep scrolling and turning pages.
  final bool stylusOnly;
  final PageTint pageTint;
  final bool keepScreenOn;

  /// Swaps forward/back for pedals that send the keys the "wrong" way round.
  final bool swapPedal;
  final bool libraryGrid;

  /// Look songs up online (MusicBrainz, AcousticBrainz, Deezer). Off = no requests, no badges.
  final bool fetchMetadata;
  final bool metadataWifiOnly;

  AppSettings copyWith({
    ThemeMode? themeMode,
    SongSort? librarySort,
    double? tapZoneFraction,
    bool? twoPageLandscape,
    bool? halfPageTurn,
    bool? stylusOnly,
    PageTint? pageTint,
    bool? keepScreenOn,
    bool? swapPedal,
    bool? libraryGrid,
    bool? fetchMetadata,
    bool? metadataWifiOnly,
  }) =>
      AppSettings(
        themeMode: themeMode ?? this.themeMode,
        librarySort: librarySort ?? this.librarySort,
        tapZoneFraction: tapZoneFraction ?? this.tapZoneFraction,
        twoPageLandscape: twoPageLandscape ?? this.twoPageLandscape,
        halfPageTurn: halfPageTurn ?? this.halfPageTurn,
        stylusOnly: stylusOnly ?? this.stylusOnly,
        pageTint: pageTint ?? this.pageTint,
        keepScreenOn: keepScreenOn ?? this.keepScreenOn,
        swapPedal: swapPedal ?? this.swapPedal,
        libraryGrid: libraryGrid ?? this.libraryGrid,
        fetchMetadata: fetchMetadata ?? this.fetchMetadata,
        metadataWifiOnly: metadataWifiOnly ?? this.metadataWifiOnly,
      );
}

final sharedPrefsProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError('overridden in main'));

final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends Notifier<AppSettings> {
  SharedPreferences get _prefs => ref.read(sharedPrefsProvider);

  @override
  AppSettings build() {
    final p = ref.watch(sharedPrefsProvider);
    T pick<T extends Enum>(List<T> values, String key, T fallback) =>
        values.firstWhere((v) => v.name == p.getString(key), orElse: () => fallback);
    return AppSettings(
      themeMode: pick(ThemeMode.values, 'themeMode', ThemeMode.system),
      librarySort: pick(SongSort.values, 'librarySort', SongSort.title),
      tapZoneFraction: p.getDouble('tapZoneFraction') ?? 0.33,
      twoPageLandscape: p.getBool('twoPageLandscape') ?? true,
      halfPageTurn: p.getBool('halfPageTurn') ?? false,
      stylusOnly: p.getBool('stylusOnly') ?? false,
      pageTint: pick(PageTint.values, 'pageTint', PageTint.none),
      keepScreenOn: p.getBool('keepScreenOn') ?? true,
      swapPedal: p.getBool('swapPedal') ?? false,
      libraryGrid: p.getBool('libraryGrid') ?? false,
      fetchMetadata: p.getBool('fetchMetadata') ?? false,
      metadataWifiOnly: p.getBool('metadataWifiOnly') ?? true,
    );
  }

  void update(AppSettings s) {
    state = s;
    _prefs
      ..setString('themeMode', s.themeMode.name)
      ..setString('librarySort', s.librarySort.name)
      ..setDouble('tapZoneFraction', s.tapZoneFraction)
      ..setBool('twoPageLandscape', s.twoPageLandscape)
      ..setBool('halfPageTurn', s.halfPageTurn)
      ..setBool('stylusOnly', s.stylusOnly)
      ..setString('pageTint', s.pageTint.name)
      ..setBool('keepScreenOn', s.keepScreenOn)
      ..setBool('swapPedal', s.swapPedal)
      ..setBool('libraryGrid', s.libraryGrid)
      ..setBool('fetchMetadata', s.fetchMetadata)
      ..setBool('metadataWifiOnly', s.metadataWifiOnly);
  }

  void set(AppSettings Function(AppSettings s) change) => update(change(state));
}
