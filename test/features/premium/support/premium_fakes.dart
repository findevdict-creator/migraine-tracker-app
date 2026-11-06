import 'dart:async';

import 'package:migraine_tracker/features/premium/domain/premium.dart';

/// Plays the store. Purchases succeed unless [failWith] is set.
class FakePurchasesGateway implements PurchasesGateway {
  FakePurchasesGateway({this.current = PremiumStatus.none, this.restorable});

  PremiumStatus current;

  /// What a restore finds; null finds nothing.
  PremiumStatus? restorable;
  PurchaseError? failWith;
  final identified = <String?>[];
  final bought = <String>[];
  final _changes = StreamController<PremiumStatus>.broadcast();

  static final active = PremiumStatus(
    active: true,
    expiresAt: DateTime.utc(2026, 12, 6),
    willRenew: true,
  );

  @override
  bool get available => true;

  @override
  Future<PremiumStatus> status() async => current;

  @override
  Stream<PremiumStatus> statusChanges() => _changes.stream;

  @override
  Future<List<PremiumOffer>> offers() async => const [
    PremiumOffer(
      id: r'$rc_annual',
      period: PremiumPeriod.annual,
      priceText: r'$19.99',
    ),
    PremiumOffer(
      id: r'$rc_monthly',
      period: PremiumPeriod.monthly,
      priceText: r'$2.99',
    ),
  ];

  @override
  Future<PremiumStatus> purchase(String offerId) async {
    final failure = failWith;
    if (failure != null) throw PurchaseException(failure);
    bought.add(offerId);
    return _set(active);
  }

  @override
  Future<PremiumStatus> restore() async {
    final failure = failWith;
    if (failure != null) throw PurchaseException(failure);
    return _set(restorable ?? current);
  }

  /// A change from the store, such as a renewal or an expiry.
  void push(PremiumStatus status) => _set(status);

  PremiumStatus _set(PremiumStatus status) {
    current = status;
    _changes.add(status);
    return status;
  }

  @override
  Future<void> identify(String? uid) async => identified.add(uid);
}
