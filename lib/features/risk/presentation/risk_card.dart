import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/risk/domain/risk_entities.dart';
import 'package:migraine_tracker/features/risk/presentation/risk_controller.dart';
import 'package:migraine_tracker/features/risk/presentation/risk_text.dart';

/// Home card: today's level, the top three drivers in plain words, the
/// confidence label, the "still learning" badge and the next days'
/// levels. Everything comes from the local store, so it shows offline.
class RiskCard extends ConsumerWidget {
  const RiskCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final today = ref.watch(riskTodayProvider);
    final days = ref.watch(upcomingRiskProvider).value ?? const [];
    final status = ref.watch(learningStatusProvider).value;
    final todayRisk = days.where((d) => d.date == today).firstOrNull;
    final ahead = days.where((d) => d.date != today).toList();
    return AppCard(
      key: const ValueKey('risk-card'),
      onTap: () => context.push(AppRoutes.risk),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.riskCardTitle,
                  style: context.textStyles.titleMedium,
                ),
              ),
              if (todayRisk != null)
                RiskLevelBadge(
                  key: const ValueKey('risk-level'),
                  level: todayRisk.level,
                  large: true,
                ),
            ],
          ),
          const SizedBox(height: AppThemeTokens.space2),
          if (todayRisk == null)
            Text(
              l10n.riskCardEmpty,
              key: const ValueKey('risk-empty'),
              style: context.textStyles.bodyMedium,
            )
          else
            _Drivers(risk: todayRisk),
          if (status != null) ...[
            const SizedBox(height: AppThemeTokens.space2),
            LearningBadge(status: status),
          ],
          if (ahead.isNotEmpty) ...[
            const SizedBox(height: AppThemeTokens.space3),
            Wrap(
              spacing: AppThemeTokens.space2,
              runSpacing: AppThemeTokens.space1,
              children: [
                for (final (i, d) in ahead.indexed)
                  _DayChip(
                    key: ValueKey('risk-day-$i'),
                    label: dayLabel(
                      l10n,
                      d.date,
                      today,
                      locale: Localizations.localeOf(context).toString(),
                    ),
                    level: d.level,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Drivers extends StatelessWidget {
  const _Drivers({required this.risk});

  final RiskDayEntity risk;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final drivers = risk.drivers();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (drivers.isEmpty)
          Text(
            l10n.riskNoDrivers,
            key: const ValueKey('risk-no-drivers'),
            style: context.textStyles.bodyMedium,
          )
        else
          for (final (i, c) in drivers.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: AppThemeTokens.space1),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 8,
                    color: risk.level.color(context.appColors),
                  ),
                  const SizedBox(width: AppThemeTokens.space2),
                  Expanded(
                    child: Text(
                      factorLabel(l10n, c.factor),
                      key: ValueKey('risk-driver-$i'),
                      style: context.textStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
        const SizedBox(height: AppThemeTokens.space1),
        Text(
          l10n.riskConfidence(confidenceLabel(l10n, risk.confidence)),
          key: const ValueKey('risk-confidence'),
          style: context.textStyles.bodySmall,
        ),
      ],
    );
  }
}

/// "Still learning: n of 10 attacks logged" until the model is tuned,
/// then "Tuned to your log".
class LearningBadge extends StatelessWidget {
  const LearningBadge({required this.status, super.key});

  final LearningStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final learning = status.stillLearning;
    return Row(
      children: [
        Icon(
          learning ? Icons.school_outlined : Icons.verified_outlined,
          size: 16,
          color: learning ? colors.info : colors.success,
        ),
        const SizedBox(width: AppThemeTokens.space1),
        Expanded(
          child: Text(
            learning
                ? l10n.riskStillLearning(status.attacks, status.needed)
                : l10n.riskTuned,
            key: ValueKey(learning ? 'risk-learning' : 'risk-tuned'),
            style: context.textStyles.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.label, required this.level, super.key});

  final String label;
  final RiskLevel level;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Semantics(
      label: '$label: ${level.label(context.l10n)}',
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppThemeTokens.space3,
          vertical: AppThemeTokens.space1,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: level.color(colors), width: 2),
          borderRadius: BorderRadius.circular(AppThemeTokens.radiusLarge),
        ),
        child: Text(
          '$label · ${level.label(context.l10n)}',
          style: context.textStyles.labelLarge,
        ),
      ),
    );
  }
}
