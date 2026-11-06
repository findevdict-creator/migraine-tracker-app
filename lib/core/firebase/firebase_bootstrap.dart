import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/firebase/firebase_options.dart';

/// Whether Firebase was initialised for this run. Features that need a
/// backend watch this and degrade when it is false.
final firebaseStatusProvider = Provider<FirebaseStatus>(
  (_) => const FirebaseStatus.notConfigured(),
);

/// Result of [initializeFirebase].
@immutable
class FirebaseStatus {
  const FirebaseStatus._({required this.enabled, required this.reason});

  const FirebaseStatus.enabled() : this._(enabled: true, reason: null);

  const FirebaseStatus.notConfigured()
    : this._(enabled: false, reason: 'not configured');

  const FirebaseStatus.failed(String reason)
    : this._(enabled: false, reason: reason);

  final bool enabled;
  final String? reason;

  @override
  String toString() => 'FirebaseStatus(enabled: $enabled, reason: $reason)';
}

/// Initialises Firebase for a flavor. Safe to call without any Firebase
/// values: the app then runs offline and reports `notConfigured`.
///
/// Crash reporting is always opt-in: it is never enabled here, only made
/// available to the settings toggle through [setCrashReportingEnabled].
Future<FirebaseStatus> initializeFirebase(AppConfig config) async {
  final options = AppFirebaseOptions.forCurrentPlatform();
  if (options == null) return const FirebaseStatus.notConfigured();
  try {
    await Firebase.initializeApp(options: options);
    final nonProd = config.flavor.isNonProd;
    await FirebaseAppCheck.instance.activate(
      providerAndroid: nonProd
          ? const AndroidDebugProvider()
          : const AndroidPlayIntegrityProvider(),
      providerApple: nonProd
          ? const AppleDebugProvider()
          : const AppleAppAttestProvider(),
    );
    // Off until the user opts in on the settings screen.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    return const FirebaseStatus.enabled();
  } on Object catch (error) {
    return FirebaseStatus.failed(error.toString());
  }
}

/// Turns crash reporting on or off for this device. Called by the settings
/// screen; health data never reaches a crash payload because the app logs
/// no field values (see CONTRIBUTING).
Future<void> setCrashReportingEnabled({required bool enabled}) async {
  if (Firebase.apps.isEmpty) return;
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(enabled);
  if (enabled) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      unawaited(
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
      );
      return true;
    };
  } else {
    FlutterError.onError = FlutterError.presentError;
    PlatformDispatcher.instance.onError = null;
  }
}
