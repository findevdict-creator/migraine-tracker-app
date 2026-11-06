import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/firebase/firebase_bootstrap.dart';
import 'package:migraine_tracker/core/firebase/firebase_options.dart';

void main() {
  group('Firebase bootstrap', () {
    test('has no options when the env files are not filled', () {
      expect(AppEnv.hasFirebase, isFalse);
      expect(AppFirebaseOptions.forCurrentPlatform(), isNull);
    });

    test(
      'initializeFirebase reports notConfigured without touching plugins',
      () async {
        final status = await initializeFirebase(
          const AppConfig(flavor: AppFlavor.dev),
        );
        expect(status.enabled, isFalse);
        expect(status.reason, 'not configured');
      },
    );

    test('status values describe themselves', () {
      expect(const FirebaseStatus.enabled().enabled, isTrue);
      expect(const FirebaseStatus.failed('boom').reason, 'boom');
      expect(const FirebaseStatus.failed('boom').enabled, isFalse);
    });

    test('setCrashReportingEnabled is a no-op without Firebase', () async {
      await setCrashReportingEnabled(enabled: true);
      await setCrashReportingEnabled(enabled: false);
    });
  });
}
