import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/premium/domain/premium.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// RevenueCat when this build has a key for the platform, otherwise the
/// stand-in.
final purchasesGatewayProvider = Provider<PurchasesGateway>((ref) {
  final key = revenueCatKeyFor(defaultTargetPlatform);
  if (!AppFeatureFlags.premiumAvailable || key.isEmpty) {
    return const UnavailablePurchasesGateway();
  }
  return RevenueCatGateway(key);
});

/// The public SDK key for a platform; empty where there is no store.
String revenueCatKeyFor(TargetPlatform platform) => switch (platform) {
  TargetPlatform.android => AppEnv.revenueCatApiKeyAndroid,
  TargetPlatform.iOS || TargetPlatform.macOS => AppEnv.revenueCatApiKeyIos,
  _ => '',
};

class RevenueCatGateway implements PurchasesGateway {
  RevenueCatGateway(this._apiKey);

  final String _apiKey;
  Future<void>? _ready;
  final Map<String, Package> _packages = {};

  Future<void> _configure() =>
      _ready ??= Purchases.configure(PurchasesConfiguration(_apiKey));

  @override
  bool get available => true;

  @override
  Future<PremiumStatus> status() =>
      _guard(() async => statusOf(await Purchases.getCustomerInfo()));

  @override
  Stream<PremiumStatus> statusChanges() {
    late final StreamController<PremiumStatus> controller;
    void listener(CustomerInfo info) => controller.add(statusOf(info));
    controller = StreamController<PremiumStatus>(
      onListen: () async {
        await _configure();
        Purchases.addCustomerInfoUpdateListener(listener);
      },
      onCancel: () => Purchases.removeCustomerInfoUpdateListener(listener),
    );
    return controller.stream;
  }

  @override
  Future<List<PremiumOffer>> offers() => _guard(() async {
    final offerings = await Purchases.getOfferings();
    final offering = AppPremium.offeringId.isEmpty
        ? offerings.current
        : offerings.all[AppPremium.offeringId];
    final packages = offering?.availablePackages ?? const <Package>[];
    _packages
      ..clear()
      ..addEntries(packages.map((p) => MapEntry(p.identifier, p)));
    return [
      for (final p in packages)
        PremiumOffer(
          id: p.identifier,
          period: switch (p.packageType) {
            PackageType.monthly => PremiumPeriod.monthly,
            PackageType.annual => PremiumPeriod.annual,
            _ => PremiumPeriod.other,
          },
          priceText: p.storeProduct.priceString,
        ),
    ];
  });

  @override
  Future<PremiumStatus> purchase(String offerId) => _guard(() async {
    final package = _packages[offerId];
    if (package == null) {
      throw const PurchaseException(PurchaseError.storeProblem);
    }
    final result = await Purchases.purchase(PurchaseParams.package(package));
    return statusOf(result.customerInfo);
  });

  @override
  Future<PremiumStatus> restore() =>
      _guard(() async => statusOf(await Purchases.restorePurchases()));

  @override
  Future<void> identify(String? uid) => _guard(() async {
    if (uid != null) {
      await Purchases.logIn(uid);
    } else if (!await Purchases.isAnonymous) {
      await Purchases.logOut();
    }
  });

  Future<T> _guard<T>(Future<T> Function() body) async {
    await _configure();
    try {
      return await body();
    } on PlatformException catch (e) {
      throw PurchaseException(errorFor(PurchasesErrorHelper.getErrorCode(e)));
    }
  }

  static PremiumStatus statusOf(CustomerInfo info) {
    final entitlement = info.entitlements.active[AppPremium.entitlementId];
    if (entitlement == null || !entitlement.isActive) {
      return PremiumStatus(active: false, managementUrl: info.managementURL);
    }
    return PremiumStatus(
      active: true,
      expiresAt: switch (entitlement.expirationDate) {
        final String date => DateTime.tryParse(date),
        null => null,
      },
      willRenew: entitlement.willRenew,
      managementUrl: info.managementURL,
    );
  }

  static PurchaseError errorFor(PurchasesErrorCode code) => switch (code) {
    PurchasesErrorCode.purchaseCancelledError => PurchaseError.cancelled,
    PurchasesErrorCode.purchaseNotAllowedError ||
    PurchasesErrorCode.insufficientPermissionsError ||
    PurchasesErrorCode.ineligibleError => PurchaseError.notAllowed,
    PurchasesErrorCode.paymentPendingError => PurchaseError.pending,
    PurchasesErrorCode.networkError ||
    PurchasesErrorCode.offlineConnectionError ||
    PurchasesErrorCode.productRequestTimeout => PurchaseError.network,
    PurchasesErrorCode.storeProblemError ||
    PurchasesErrorCode.productNotAvailableForPurchaseError ||
    PurchasesErrorCode.purchaseInvalidError => PurchaseError.storeProblem,
    PurchasesErrorCode.configurationError ||
    PurchasesErrorCode.invalidCredentialsError => PurchaseError.unavailable,
    _ => PurchaseError.unknown,
  };
}
