import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/licenses.dart';
import 'core/settings.dart';
import 'data/providers.dart';
import 'services/metadata/background.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pdfrxFlutterInitialize();
  registerNativeLicenses();
  if (Platform.isIOS) {
    final session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration.music().copyWith(
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.mixWithOthers,
      ),
    );
  }
  final results = await Future.wait([
    AppPaths.resolve(),
    SharedPreferences.getInstance(),
  ]);
  await BackgroundScheduler.init();
  runApp(
    ProviderScope(
      overrides: [
        appPathsProvider.overrideWithValue(results[0] as AppPaths),
        sharedPrefsProvider.overrideWithValue(results[1] as SharedPreferences),
      ],
      child: const MusicSheetsApp(),
    ),
  );
}
