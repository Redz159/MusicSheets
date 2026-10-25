import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../data/db.dart';
import '../../data/providers.dart';
import 'lookup_runner.dart';
import 'lookup_service.dart';

const lookupTaskName = 'metadata-lookup';
const _uniqueName = 'metadata-lookup-queue';

/// Entry point of the background isolate. Runs the queue for a bounded time.
@pragma('vm:entry-point')
void backgroundDispatcher() {
  Workmanager().executeTask((task, input) async {
    if (task != lookupTaskName) return true;
    WidgetsFlutterBinding.ensureInitialized();
    AppDatabase? db;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final enabled = prefs.getBool('fetchMetadata') ?? false;
      if (!enabled) return true;
      final wifiOnly = prefs.getBool('metadataWifiOnly') ?? true;
      final paths = await AppPaths.resolve();
      db = AppDatabase.open(paths.dbPath);
      final runner = LookupRunner(LookupService.create(db, paths), enabled: () => true, wifiOnly: () => wifiOnly);
      // Stay well inside the limits the OS puts on background work (about 10 minutes on Android).
      final finished = await runner.run(budget: const Duration(minutes: 8));
      return finished;
    } catch (_) {
      return false;
    } finally {
      await db?.close();
    }
  });
}

/// Registers the background work with the OS. The queue itself lives in the database,
/// so scheduling is idempotent: calling this again only refreshes the constraints.
class BackgroundScheduler {
  static bool _initialized = false;

  // TODO(iOS): background lookups are Android-only for now. iOS is out of scope for this change and
  // tracked in a separate issue; the foreground runner still handles the queue there.
  static bool get supported => !kIsWeb && Platform.isAndroid;

  static Future<void> init() async {
    if (!supported || _initialized) return;
    try {
      await Workmanager().initialize(backgroundDispatcher);
      _initialized = true;
    } catch (e) {
      debugPrint('BackgroundScheduler init failed: $e');
    }
  }

  static Future<void> schedule({required bool wifiOnly}) async {
    if (!supported) return;
    try {
      await init();
      await Workmanager().registerPeriodicTask(
        _uniqueName,
        lookupTaskName,
        frequency: const Duration(minutes: 15),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
        constraints: Constraints(networkType: wifiOnly ? NetworkType.unmetered : NetworkType.connected),
      );
    } catch (e) {
      debugPrint('BackgroundScheduler schedule failed: $e');
    }
  }

  static Future<void> cancel() async {
    if (!supported) return;
    try {
      await init();
      await Workmanager().cancelByUniqueName(_uniqueName);
    } catch (e) {
      debugPrint('BackgroundScheduler cancel failed: $e');
    }
  }
}
