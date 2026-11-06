import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('resolves identity per flavor', () {
      expect(
        const AppConfig(flavor: AppFlavor.dev).displayName,
        '${AppIdentity.name} (dev)',
      );
      expect(
        const AppConfig(flavor: AppFlavor.staging).displayName,
        '${AppIdentity.name} (beta)',
      );
      expect(
        const AppConfig(flavor: AppFlavor.prod).displayName,
        AppIdentity.name,
      );
      expect(
        const AppConfig(flavor: AppFlavor.dev).bundleId,
        '${AppIdentity.bundleId}.dev',
      );
      expect(
        const AppConfig(flavor: AppFlavor.prod).bundleId,
        AppIdentity.bundleId,
      );
    });

    test('dev tools and emulators are off in prod', () {
      const prod = AppConfig(flavor: AppFlavor.prod);
      const dev = AppConfig(flavor: AppFlavor.dev);
      expect(prod.showDevTools, isFalse);
      expect(prod.useEmulators, isFalse);
      expect(dev.showDevTools, isTrue);
      expect(dev.useEmulators, isTrue);
    });

    test('functions base URL points at the emulator in dev', () {
      const dev = AppConfig(flavor: AppFlavor.dev);
      expect(dev.functionsBaseUrl, startsWith('http://'));
      expect(dev.functionsBaseUrl, contains(':5001/'));
    });

    test('functions base URL points at the cloud in prod', () {
      const prod = AppConfig(flavor: AppFlavor.prod);
      expect(prod.functionsBaseUrl, startsWith('https://'));
      expect(prod.functionsBaseUrl, contains('cloudfunctions.net'));
    });

    test('firebase is not configured without dart-defines', () {
      expect(AppEnv.hasFirebase, isFalse);
    });

    test('the fallback locale is in the supported list', () {
      expect(AppLocales.supported, contains(AppLocales.fallback));
      expect(AppLocales.supported.first, AppLocales.fallback);
    });

    test('thresholds match the requirements doc', () {
      expect(AppThresholds.medicationOveruseFirstNote, 10);
      expect(AppThresholds.medicationOveruseSecondNote, 15);
      expect(AppThresholds.attacksBeforeModelIsTuned, 10);
      expect(AppThresholds.attacksBeforeDurationEstimate, 5);
      expect(AppThresholds.locationRoundingDegrees, 0.1);
      expect(AppThemeTokens.attackTapTarget, 56);
    });
  });
}
