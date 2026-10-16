import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/settings.dart';
import '../data/db.dart';
import '../data/providers.dart';
import 'backup_service.dart';
import 'export_service.dart';
import 'import_service.dart';
import 'metadata/background.dart';
import 'metadata/lookup_runner.dart';
import 'metadata/lookup_service.dart';
import 'pdf_render.dart';

final importServiceProvider =
    Provider((ref) => ImportService(ref.watch(databaseProvider), ref.watch(appPathsProvider)));

final exportServiceProvider =
    Provider((ref) => ExportService(ref.watch(databaseProvider), ref.watch(appPathsProvider)));

final backupServiceProvider = Provider((ref) => BackupService(ref.watch(appPathsProvider)));

final thumbnailServiceProvider = Provider((ref) => ThumbnailService(ref.watch(appPathsProvider).thumbDir));

final lookupServiceProvider =
    Provider((ref) => LookupService.create(ref.watch(databaseProvider), ref.watch(appPathsProvider)));

final lookupRunnerProvider = Provider((ref) {
  final runner = LookupRunner(
    ref.watch(lookupServiceProvider),
    enabled: () => ref.read(settingsProvider).fetchMetadata,
    wifiOnly: () => ref.read(settingsProvider).metadataWifiOnly,
  );
  runner.watchConnectivity();
  ref.onDispose(runner.dispose);
  return runner;
});

/// Songs waiting for the user to pick a match.
final reviewSongsProvider = Provider<List<Song>>((ref) {
  if (!ref.watch(settingsProvider.select((s) => s.fetchMetadata))) return const [];
  final songs = ref.watch(songsProvider).value ?? const <Song>[];
  return [for (final s in songs) if (s.lookupStatus == 'needsReview') s];
});

/// Keeps the queue moving: runs it on start, after imports, when settings change, and keeps the
/// OS background task in line with the settings. Read once from the app shell to start it.
final lookupControllerProvider = Provider<LookupController>((ref) {
  final c = LookupController(ref);
  ref.onDispose(c.dispose);
  return c;
});

class LookupController with WidgetsBindingObserver {
  LookupController(this._ref) {
    WidgetsBinding.instance.addObserver(this);
    _ref.listen(settingsProvider.select((s) => (s.fetchMetadata, s.metadataWifiOnly)), (_, _) => _sync(), fireImmediately: true);
    // New or re-queued songs wake the worker.
    _ref.listen(songsProvider.select((a) => a.value?.where((s) => s.lookupStatus == 'pending').length ?? 0),
        (prev, next) {
      if (next > 0 && (prev ?? 0) != next) kick();
    });
  }

  final Ref _ref;

  void kick() {
    if (!_ref.read(settingsProvider).fetchMetadata) return;
    _ref.read(lookupRunnerProvider).run();
  }

  void _sync() {
    final s = _ref.read(settingsProvider);
    if (!s.fetchMetadata) {
      _ref.read(lookupRunnerProvider).stop();
      BackgroundScheduler.cancel();
      return;
    }
    BackgroundScheduler.schedule(wifiOnly: s.metadataWifiOnly);
    kick();
  }

  /// iOS runs the background task only when it sees fit, so coming back to the app always
  /// catches the queue up.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) kick();
  }

  void dispose() => WidgetsBinding.instance.removeObserver(this);
}
