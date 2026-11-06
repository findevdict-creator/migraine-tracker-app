import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/premium/data/revenuecat_gateway.dart';
import 'package:migraine_tracker/features/premium/domain/premium.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

void main() {
  group('the gate', () {
    test('without Premium every listed feature is closed', () {
      const state = PremiumState(
        status: PremiumStatus.none,
        storeAvailable: true,
      );
      for (final f in AppPremium.features) {
        expect(state.allows(f), isFalse, reason: f.name);
      }
    });

    test('an active subscription opens every feature', () {
      const state = PremiumState(
        status: PremiumStatus(active: true),
        storeAvailable: true,
      );
      for (final f in PremiumFeature.values) {
        expect(state.allows(f), isTrue, reason: f.name);
      }
    });

    test('premium switched off, or a dev build without a store, opens all', () {
      const state = PremiumState(
        status: PremiumStatus.none,
        storeAvailable: false,
        unlockedAll: true,
      );
      for (final f in PremiumFeature.values) {
        expect(state.allows(f), isTrue, reason: f.name);
      }
      expect(AppPremium.unlockWithoutStore(AppFlavor.dev), isTrue);
      expect(AppPremium.unlockWithoutStore(AppFlavor.staging), isFalse);
      expect(AppPremium.unlockWithoutStore(AppFlavor.prod), isFalse);
    });

    test('FR-27: Premium covers exactly the share link, experiments, '
        'extended factors and backup', () {
      expect(AppPremium.features, {
        PremiumFeature.shareLink,
        PremiumFeature.experiments,
        PremiumFeature.extendedFactors,
        PremiumFeature.backup,
      });
      // The always-visible factors stay free.
      for (final free in ['aqi-us', 'aqi-eu', 'uv', 'daylight', 'sun']) {
        expect(AppPremium.extendedFactorKeys, isNot(contains(free)));
      }
    });
  });

  group('RevenueCat', () {
    test('keys are chosen per platform; other platforms have no store', () {
      expect(revenueCatKeyFor(TargetPlatform.android), isEmpty);
      expect(revenueCatKeyFor(TargetPlatform.iOS), isEmpty);
      expect(revenueCatKeyFor(TargetPlatform.linux), isEmpty);
    });

    test('store errors map to what the paywall can say', () {
      expect(
        RevenueCatGateway.errorFor(PurchasesErrorCode.purchaseCancelledError),
        PurchaseError.cancelled,
      );
      expect(
        RevenueCatGateway.errorFor(PurchasesErrorCode.paymentPendingError),
        PurchaseError.pending,
      );
      expect(
        RevenueCatGateway.errorFor(PurchasesErrorCode.offlineConnectionError),
        PurchaseError.network,
      );
      expect(
        RevenueCatGateway.errorFor(PurchasesErrorCode.purchaseNotAllowedError),
        PurchaseError.notAllowed,
      );
      expect(
        RevenueCatGateway.errorFor(PurchasesErrorCode.configurationError),
        PurchaseError.unavailable,
      );
      expect(
        RevenueCatGateway.errorFor(PurchasesErrorCode.unknownBackendError),
        PurchaseError.unknown,
      );
    });
  });
}
