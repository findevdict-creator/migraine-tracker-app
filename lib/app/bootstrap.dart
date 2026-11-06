import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/app/app.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/firebase/firebase_bootstrap.dart';
import 'package:migraine_tracker/features/push/application/push_wakeup.dart';
import 'package:migraine_tracker/features/push/data/firebase_push_gateway.dart';
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
  LicenseRegistry.addLicense(() async* {
    final text = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(const ['Noto Sans JP'], text);
  });
  final config = AppConfig(flavor: flavor);
  final firebase = await initializeFirebase(config);
  await _scheduleBackgroundWork(flavor);
  _registerPushHandler(firebase);
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

/// Points Firebase Messaging at the background wake-up handler. Must run
/// before the first message arrives; harmless without Firebase.
void _registerPushHandler(FirebaseStatus firebase) {
  if (!pushAvailable(firebase)) return;
  try {
    FirebaseMessaging.onBackgroundMessage(pushWakeupBackgroundHandler);
  } on Object catch (error) {
    debugPrint('push handler not registered: $error');
  }
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
