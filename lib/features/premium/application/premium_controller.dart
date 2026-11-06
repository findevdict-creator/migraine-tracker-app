import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/premium/data/revenuecat_gateway.dart';
import 'package:migraine_tracker/features/premium/domain/premium.dart';

/// The store's answer, then every change. A store that cannot be reached
/// reads as not subscribed; it never takes a free feature away.
final premiumStatusProvider = StreamProvider<PremiumStatus>((ref) async* {
  final gateway = ref.watch(purchasesGatewayProvider);
  if (!gateway.available) {
    yield PremiumStatus.none;
    return;
  }
  try {
    yield await gateway.status();
  } on PurchaseException {
    yield PremiumStatus.none;
  }
  yield* gateway.statusChanges();
});

/// What the app may show. Every gate reads this.
final premiumProvider = Provider<PremiumState>((ref) {
  final flavor = ref.watch(appConfigProvider).flavor;
  final gateway = ref.watch(purchasesGatewayProvider);
  final status = ref.watch(premiumStatusProvider).value ?? PremiumStatus.none;
  return PremiumState(
    status: status,
    storeAvailable: gateway.available,
    unlockedAll:
        !AppFeatureFlags.premiumAvailable ||
        (!gateway.available && AppPremium.unlockWithoutStore(flavor)),
  );
});

/// Offers for the paywall, cheapest period first.
final premiumOffersProvider = FutureProvider<List<PremiumOffer>>((ref) async {
  final offers = [...await ref.watch(purchasesGatewayProvider).offers()];
  return offers..sort((a, b) => a.period.index.compareTo(b.period.index));
});

final premiumActionsProvider = Provider<PremiumActions>(PremiumActions.new);

class PremiumActions {
  PremiumActions(this._ref);

  final Ref _ref;

  Future<PremiumStatus> purchase(String offerId) =>
      _apply(() => _ref.read(purchasesGatewayProvider).purchase(offerId));

  Future<PremiumStatus> restore() =>
      _apply(() => _ref.read(purchasesGatewayProvider).restore());

  Future<PremiumStatus> _apply(Future<PremiumStatus> Function() body) async {
    final status = await body();
    _ref.invalidate(premiumStatusProvider);
    return status;
  }
}
