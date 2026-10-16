import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/settings.dart';
import 'data/providers.dart';
import 'services/metadata/background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pdfrxFlutterInitialize();
  // Without a playback category iOS keeps its default one, which the mute setting silences, and
  // the metronome engine (SoLoud) deliberately leaves the category alone.
  await (await AudioSession.instance).configure(const AudioSessionConfiguration.music());
  final results = await Future.wait([AppPaths.resolve(), SharedPreferences.getInstance()]);
  await BackgroundScheduler.init();
  runApp(ProviderScope(
    overrides: [
      appPathsProvider.overrideWithValue(results[0] as AppPaths),
      sharedPrefsProvider.overrideWithValue(results[1] as SharedPreferences),
    ],
    child: const MusicSheetsApp(),
  ));
}
