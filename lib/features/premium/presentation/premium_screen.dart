import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/account/presentation/account_controller.dart';
import 'package:migraine_tracker/features/premium/application/premium_controller.dart';
import 'package:migraine_tracker/features/premium/domain/premium.dart';
import 'package:migraine_tracker/features/premium/presentation/premium_text.dart';
import 'package:url_launcher/url_launcher.dart';

/// The paywall: what Premium adds, what stays free, the store's prices,
/// restore, and the renewal terms the stores require.
class PremiumScreen extends ConsumerStatefulWidget {
  const PremiumScreen({super.key});

  @override
  ConsumerState<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends ConsumerState<PremiumScreen> {
  bool _busy = false;
  String? _message;
  bool _messageIsError = false;

  Future<void> _run(
    Future<PremiumStatus> Function() action, {
    required bool restoring,
  }) async {
    final l10n = context.l10n;
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final status = await action();
      if (!mounted) return;
      setState(() {
        _messageIsError = !status.active;
        _message = status.active
            ? l10n.premiumThanks
            : (restoring ? l10n.premiumRestoredNone : null);
      });
    } on PurchaseException catch (e) {
      if (!mounted) return;
      setState(() {
        _messageIsError = true;
        _message = purchaseErrorText(l10n, e.error);
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _manage(PremiumStatus status) {
    final fallback = defaultTargetPlatform == TargetPlatform.android
        ? AppPremium.manageUrlAndroid
        : AppPremium.manageUrlIos;
    return launchUrl(
      Uri.parse(status.managementUrl ?? fallback),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final premium = ref.watch(premiumProvider);
    final signedOut = ref.watch(accountProvider).value == null;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.premiumTitle)),
      body: ListView(
        key: const ValueKey('premium-list'),
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          if (premium.active)
            _ActiveCard(status: premium.status, onManage: _manage)
          else
            Text(l10n.premiumIntro, style: context.textStyles.bodyLarge),
          const SizedBox(height: AppThemeTokens.space3),
          for (final f in AppPremium.features)
            ListTile(
              key: ValueKey('premium-feature-${f.name}'),
              contentPadding: EdgeInsets.zero,
              leading: Icon(premiumFeatureIcon(f)),
              title: Text(premiumFeatureName(l10n, f)),
              subtitle: Text(premiumFeatureHint(l10n, f)),
            ),
          const SizedBox(height: AppThemeTokens.space2),
          AppCard(
            key: const ValueKey('premium-free-note'),
            child: Text(l10n.premiumFreeNote),
          ),
          const SizedBox(height: AppThemeTokens.space4),
          if (premium.unlockedAll && !premium.storeAvailable)
            Text(
              l10n.premiumDevUnlocked,
              key: const ValueKey('premium-dev-unlocked'),
            )
          else if (!premium.storeAvailable)
            Text(
              l10n.premiumUnavailable,
              key: const ValueKey('premium-unavailable'),
            )
          else if (!premium.active)
            ..._offers(l10n, signedOut),
          if (premium.storeAvailable) ...[
            const SizedBox(height: AppThemeTokens.space2),
            AppButton(
              key: const ValueKey('premium-restore'),
              label: l10n.premiumRestore,
              variant: AppButtonVariant.text,
              onPressed: _busy
                  ? null
                  : () => _run(
                      ref.read(premiumActionsProvider).restore,
                      restoring: true,
                    ),
            ),
          ],
          if (_message != null) ...[
            const SizedBox(height: AppThemeTokens.space2),
            Semantics(
              liveRegion: true,
              child: Text(
                _message!,
                key: const ValueKey('premium-message'),
                style: context.textStyles.bodyMedium?.copyWith(
                  color: _messageIsError ? context.appColors.danger : null,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppThemeTokens.space4),
          Text(
            l10n.premiumRenewalTerms,
            key: const ValueKey('premium-terms'),
            style: context.textStyles.bodySmall,
          ),
          Wrap(
            spacing: AppThemeTokens.space2,
            children: [
              TextButton(
                onPressed: () => launchUrl(
                  Uri.parse(AppIdentity.termsUrl),
                  mode: LaunchMode.externalApplication,
                ),
                child: Text(l10n.settingsTerms),
              ),
              TextButton(
                onPressed: () => launchUrl(
                  Uri.parse(AppIdentity.privacyPolicyUrl),
                  mode: LaunchMode.externalApplication,
                ),
                child: Text(l10n.settingsPrivacyPolicy),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _offers(AppLocalizations l10n, bool signedOut) {
    final offers = ref.watch(premiumOffersProvider);
    return [
      if (signedOut && AppFeatureFlags.accountsAvailable) ...[
        Text(
          l10n.premiumAccountTip,
          key: const ValueKey('premium-account-tip'),
        ),
        const SizedBox(height: AppThemeTokens.space3),
      ],
      ...switch (offers) {
        AsyncData(value: final list) when list.isNotEmpty => [
          for (final offer in list)
            Padding(
              padding: const EdgeInsets.only(bottom: AppThemeTokens.space2),
              child: AppButton(
                key: ValueKey('premium-offer-${offer.id}'),
                label: premiumOfferLabel(l10n, offer),
                expand: true,
                large: true,
                variant: offer.period == PremiumPeriod.annual
                    ? AppButtonVariant.primary
                    : AppButtonVariant.secondary,
                onPressed: _busy
                    ? null
                    : () => _run(
                        () =>
                            ref.read(premiumActionsProvider).purchase(offer.id),
                        restoring: false,
                      ),
              ),
            ),
        ],
        AsyncLoading() => [
          Text(
            l10n.premiumLoadingOffers,
            key: const ValueKey('premium-offers-loading'),
          ),
        ],
        _ => [
          Text(l10n.premiumNoOffers, key: const ValueKey('premium-no-offers')),
          AppButton(
            key: const ValueKey('premium-offers-retry'),
            label: l10n.premiumRetry,
            variant: AppButtonVariant.secondary,
            onPressed: () => ref.invalidate(premiumOffersProvider),
          ),
        ],
      },
    ];
  }
}

class _ActiveCard extends StatelessWidget {
  const _ActiveCard({required this.status, required this.onManage});

  final PremiumStatus status;
  final Future<void> Function(PremiumStatus) onManage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final date = DateFormat.yMMMd(Localizations.localeOf(context).toString());
    final ends = status.expiresAt;
    return AppCard(
      key: const ValueKey('premium-active'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.premiumActive, style: context.textStyles.titleMedium),
          if (ends != null) ...[
            const SizedBox(height: AppThemeTokens.space1),
            Text(
              status.willRenew
                  ? l10n.premiumRenews(date.format(ends.toLocal()))
                  : l10n.premiumEnds(date.format(ends.toLocal())),
              key: const ValueKey('premium-period'),
            ),
          ],
          const SizedBox(height: AppThemeTokens.space3),
          AppButton(
            key: const ValueKey('premium-manage'),
            label: l10n.premiumManage,
            variant: AppButtonVariant.secondary,
            onPressed: () => onManage(status),
          ),
        ],
      ),
    );
  }
}
