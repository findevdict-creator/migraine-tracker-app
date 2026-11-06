import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/features/account/presentation/account_controller.dart';
import 'package:migraine_tracker/features/premium/application/premium_controller.dart';
import 'package:migraine_tracker/features/premium/data/revenuecat_gateway.dart';
import 'package:migraine_tracker/features/premium/domain/premium.dart';

/// Keeps the store's customer in step with the account: signing in links
/// purchases to the account, so they follow it to another phone and the
/// server can check them; signing out goes back to anonymous. The first
/// account event after start counts as a change, so an account that was
/// already signed in is linked too.
class PremiumIdentitySync extends ConsumerWidget {
  const PremiumIdentitySync({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(accountProvider.select((a) => a.value?.uid), (
      previous,
      uid,
    ) async {
      if (previous == uid) return;
      final gateway = ref.read(purchasesGatewayProvider);
      if (!gateway.available) return;
      try {
        await gateway.identify(uid);
        ref.invalidate(premiumStatusProvider);
      } on PurchaseException {
        // Offline: the next sign-in event or app start tries again.
      }
    });
    return child;
  }
}
