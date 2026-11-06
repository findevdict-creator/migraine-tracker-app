import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:migraine_tracker/config/app_config.dart';

/// Firebase options built from the central config instead of the generated
/// `firebase_options.dart`, so one Firebase project per flavor is selected
/// by `env/<flavor>.json` and no `google-services.json` or
/// `GoogleService-Info.plist` needs to be committed.
///
/// Returns null when the build has no Firebase values, in which case the app
/// runs fully offline (every feature except backup, share link and purchases
/// works without a backend).
abstract final class AppFirebaseOptions {
  static FirebaseOptions? forCurrentPlatform() {
    if (!AppEnv.hasFirebase) return null;
    if (Platform.isAndroid) {
      return const FirebaseOptions(
        apiKey: AppEnv.firebaseApiKey,
        appId: AppEnv.firebaseAppIdAndroid,
        messagingSenderId: AppEnv.firebaseMessagingSenderId,
        projectId: AppEnv.firebaseProjectId,
        storageBucket: AppEnv.firebaseStorageBucket,
      );
    }
    if (Platform.isIOS) {
      return const FirebaseOptions(
        apiKey: AppEnv.firebaseApiKey,
        appId: AppEnv.firebaseAppIdIos,
        messagingSenderId: AppEnv.firebaseMessagingSenderId,
        projectId: AppEnv.firebaseProjectId,
        storageBucket: AppEnv.firebaseStorageBucket,
        iosBundleId: AppEnv.firebaseIosBundleId,
      );
    }
    return null;
  }
}
