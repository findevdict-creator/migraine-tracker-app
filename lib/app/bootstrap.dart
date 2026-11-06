import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/app/app.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/firebase/firebase_bootstrap.dart';
import 'package:migraine_tracker/features/weather/application/background_refresh.dart';

/// Provides the resolved [AppConfig] to the whole widget tree.
///
/// Overridden in [bootstrap] with the flavor chosen by the entry point, and
/// in tests with whatever flavor the test needs.
final appConfigProvider = Provider<AppConfig>(
  (_) => throw UnimplementedError('appConfigProvider must be overridden'),
);

/// Starts the app for one flavor. Every `main_*.dart` calls this.
Future<void> bootstrap(AppFlavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig(flavor: flavor);
  final firebase = await initializeFirebase(config);
  await _scheduleBackgroundWork(flavor);
  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        firebaseStatusProvider.overrideWithValue(firebase),
      ],
      child: const MigraineTrackerApp(),
    ),
  );
}

/// Registers the daily weather refresh on phones. Never fatal: a device
/// that refuses background work still refreshes in the foreground.
Future<void> _scheduleBackgroundWork(AppFlavor flavor) async {
  if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return;
  try {
    await scheduleWeatherBackgroundRefresh(flavor);
  } on Object catch (error) {
    debugPrint('background refresh not scheduled: $error');
  }
}
