import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/risk/domain/risk_entities.dart';
import 'package:migraine_tracker/features/risk/presentation/risk_card.dart';
import 'package:migraine_tracker/features/risk/presentation/risk_controller.dart';
import 'package:migraine_tracker/features/risk/presentation/risk_text.dart';

/// Today and the next days in full: level, load, every driver with its
/// points, confidence, the learning badge, the explainer link and the
/// wellness disclaimer.
class RiskScreen extends ConsumerWidget {
  const RiskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final today = ref.watch(riskTodayProvider);
    final days = ref.watch(upcomingRiskProvider).value ?? const [];
    final status = ref.watch(learningStatusProvider).value;
    final locale = Localizations.localeOf(context).toString();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.riskScreenTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          if (days.isEmpty)
            AppCard(
              key: const ValueKey('risk-screen-empty'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.riskCardEmpty),
                  const SizedBox(height: AppThemeTokens.space2),
                  TextButton(
                    key: const ValueKey('risk-open-checkin'),
                    onPressed: () => context.push(AppRoutes.checkin(today)),
                    child: Text(l10n.riskOpenCheckin),
                  ),
                ],
              ),
            ),
          for (final (i, d) in days.indexed) ...[
            _DaySection(
              key: ValueKey('risk-section-$i'),
              risk: d,
              label: dayLabel(l10n, d.date, today, locale: locale),
            ),
            const SizedBox(height: AppThemeTokens.space3),
          ],
          if (status != null) ...[
            LearningBadge(status: status),
            const SizedBox(height: AppThemeTokens.space3),
          ],
          TextButton.icon(
            key: const ValueKey('risk-explainer'),
            onPressed: () => context.push(AppRoutes.explainer),
            icon: const Icon(Icons.info_outline),
            label: Text(l10n.riskExplainerLink),
          ),
          const SizedBox(height: AppThemeTokens.space2),
          Text(
            AppIdentity.wellnessDisclaimer,
            key: const ValueKey('risk-disclaimer'),
            style: context.textStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({required this.risk, required this.label, super.key});

  final RiskDayEntity risk;
  final String label;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final drivers = risk.drivers();
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label, style: context.textStyles.titleLarge),
              ),
              RiskLevelBadge(level: risk.level),
            ],
          ),
          const SizedBox(height: AppThemeTokens.space1),
          Text(
            l10n.riskLoad(risk.score.toStringAsFixed(0)),
            style: context.textStyles.bodyMedium,
          ),
          const SizedBox(height: AppThemeTokens.space2),
          Text(l10n.riskWhyTitle, style: context.textStyles.titleSmall),
          if (drivers.isEmpty)
            Text(l10n.riskNoDrivers, style: context.textStyles.bodyMedium)
          else
            for (final c in drivers)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.circle,
                  size: 10,
                  color: risk.level.color(context.appColors),
                ),
                title: Text(factorLabel(l10n, c.factor)),
                trailing: Text(
                  l10n.riskDriverPoints(c.points.toStringAsFixed(0)),
                  style: context.textStyles.bodySmall,
                ),
              ),
          const SizedBox(height: AppThemeTokens.space1),
          Text(
            l10n.riskConfidence(confidenceLabel(l10n, risk.confidence)),
            style: context.textStyles.bodySmall,
          ),
          Text(
            l10n.riskUpdated(
              DateFormat.MMMd(locale).add_Hm().format(risk.computedAt),
            ),
            style: context.textStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}
