import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/premium/presentation/premium_text.dart';

/// Shown in place of a Premium feature's controls. Says what stays usable
/// and links to the paywall.
class PremiumLockCard extends StatelessWidget {
  const PremiumLockCard({
    required this.feature,
    this.note,
    this.beforeOpen,
    super.key,
  });

  final PremiumFeature feature;

  /// What still works without Premium, if anything.
  final String? note;

  /// Runs before the paywall opens, for example to close a sheet.
  final VoidCallback? beforeOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppCard(
      key: ValueKey('premium-lock-${feature.name}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(premiumFeatureIcon(feature)),
              const SizedBox(width: AppThemeTokens.space3),
              Expanded(
                child: Text(
                  l10n.premiumLockTitle(premiumFeatureName(l10n, feature)),
                  style: context.textStyles.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppThemeTokens.space2),
          Text(premiumFeatureHint(l10n, feature)),
          if (note != null) ...[
            const SizedBox(height: AppThemeTokens.space2),
            Text(note!, style: context.textStyles.bodySmall),
          ],
          const SizedBox(height: AppThemeTokens.space3),
          AppButton(
            key: ValueKey('premium-lock-open-${feature.name}'),
            label: l10n.premiumLockButton,
            expand: true,
            onPressed: () async {
              final router = GoRouter.of(context);
              beforeOpen?.call();
              await router.push<void>(AppRoutes.premium);
            },
          ),
        ],
      ),
    );
  }
}
