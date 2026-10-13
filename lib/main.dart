import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/settings.dart';
import 'data/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pdfrxFlutterInitialize();
  final results = await Future.wait([AppPaths.resolve(), SharedPreferences.getInstance()]);
  runApp(ProviderScope(
    overrides: [
      appPathsProvider.overrideWithValue(results[0] as AppPaths),
      sharedPrefsProvider.overrideWithValue(results[1] as SharedPreferences),
    ],
    child: const MusicSheetsApp(),
  ));
}
