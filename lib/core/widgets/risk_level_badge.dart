import 'package:flutter/material.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';

/// The three risk levels. The order is the severity order.
enum RiskLevel { low, moderate, high }

extension RiskLevelX on RiskLevel {
  Color color(AppColors colors) => switch (this) {
    RiskLevel.low => colors.riskLow,
    RiskLevel.moderate => colors.riskModerate,
    RiskLevel.high => colors.riskHigh,
  };

  String label(AppLocalizations l10n) => switch (this) {
    RiskLevel.low => l10n.riskLevelLow,
    RiskLevel.moderate => l10n.riskLevelModerate,
    RiskLevel.high => l10n.riskLevelHigh,
  };
}

/// Pill showing a risk level in its colour. Colour is never the only
/// signal: the label is always present.
class RiskLevelBadge extends StatelessWidget {
  const RiskLevelBadge({required this.level, this.large = false, super.key});

  final RiskLevel level;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final label = level.label(context.l10n);
    return Semantics(
      label: label,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: large ? AppThemeTokens.space4 : AppThemeTokens.space3,
          vertical: large ? AppThemeTokens.space2 : AppThemeTokens.space1,
        ),
        decoration: BoxDecoration(
          color: level.color(colors),
          borderRadius: BorderRadius.circular(AppThemeTokens.radiusLarge),
        ),
        child: Text(
          label,
          style:
              (large
                      ? context.textStyles.titleLarge
                      : context.textStyles.labelLarge)
                  ?.copyWith(color: colors.onRisk),
        ),
      ),
    );
  }
}
