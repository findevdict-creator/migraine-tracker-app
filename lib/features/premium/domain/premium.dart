import 'package:migraine_tracker/config/app_config.dart';

/// Billing period of an offer on the paywall.
enum PremiumPeriod { monthly, annual, other }

/// One thing the paywall can sell, priced by the store.
class PremiumOffer {
  const PremiumOffer({
    required this.id,
    required this.period,
    required this.priceText,
  });

  final String id;
  final PremiumPeriod period;

  /// Localized price from the store, for example "$2.99".
  final String priceText;
}

/// What the store says about this person's subscription.
class PremiumStatus {
  const PremiumStatus({
    required this.active,
    this.expiresAt,
    this.willRenew = false,
    this.managementUrl,
  });

  static const none = PremiumStatus(active: false);

  final bool active;

  /// End of the paid period; null for a lifetime purchase or when inactive.
  final DateTime? expiresAt;
  final bool willRenew;

  /// Store page to manage or cancel, when the store gives one.
  final String? managementUrl;
}

enum PurchaseError {
  cancelled,
  notAllowed,
  pending,
  network,
  storeProblem,
  unavailable,
  unknown,
}

class PurchaseException implements Exception {
  const PurchaseException(this.error);

  final PurchaseError error;

  @override
  String toString() => 'PurchaseException($error)';
}

/// The store, through one SDK on both platforms.
abstract interface class PurchasesGateway {
  /// False when this build has no store key.
  bool get available;

  Future<PremiumStatus> status();

  /// Every later change, such as a renewal, an expiry or a purchase made on
  /// another phone with the same account.
  Stream<PremiumStatus> statusChanges();

  Future<List<PremiumOffer>> offers();

  Future<PremiumStatus> purchase(String offerId);

  Future<PremiumStatus> restore();

  /// Ties purchases to the signed-in account, so they follow it to another
  /// phone and the server can check them. Null goes back to anonymous.
  Future<void> identify(String? uid);
}

/// Stand-in when the build has no store key.
class UnavailablePurchasesGateway implements PurchasesGateway {
  const UnavailablePurchasesGateway();

  @override
  bool get available => false;

  @override
  Future<PremiumStatus> status() async => PremiumStatus.none;

  @override
  Stream<PremiumStatus> statusChanges() => const Stream.empty();

  @override
  Future<List<PremiumOffer>> offers() async => const [];

  @override
  Future<PremiumStatus> purchase(String offerId) =>
      Future.error(const PurchaseException(PurchaseError.unavailable));

  @override
  Future<PremiumStatus> restore() =>
      Future.error(const PurchaseException(PurchaseError.unavailable));

  @override
  Future<void> identify(String? uid) async {}
}

/// What the app may show right now. The only input is the store's answer:
/// there is no trial clock and no install date, so the free tier never runs
/// out.
class PremiumState {
  const PremiumState({
    required this.status,
    required this.storeAvailable,
    this.unlockedAll = false,
  });

  final PremiumStatus status;
  final bool storeAvailable;

  /// Premium is switched off, or this is a dev build without a store key.
  final bool unlockedAll;

  bool get active => status.active;

  /// The single gate. Free features always pass.
  bool allows(PremiumFeature feature) =>
      !AppPremium.features.contains(feature) || unlockedAll || status.active;
}
