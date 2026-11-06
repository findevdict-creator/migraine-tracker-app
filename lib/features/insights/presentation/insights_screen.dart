import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/insights/application/insights_controller.dart';
import 'package:migraine_tracker/features/insights/domain/factor_insight.dart';
import 'package:migraine_tracker/features/risk/presentation/risk_text.dart';

/// FR-11: four lists, one per bucket, with the same layout for "more
/// attacks followed" and "fewer attacks followed". Each row carries its
/// sample sizes so the person can judge the evidence.
class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final insights = ref.watch(factorInsightsProvider).value ?? const [];
    final learned = ref.watch(hasLearnedProvider);
    List<FactorInsight> bucket(InsightBucket b) =>
        insights.where((i) => i.bucket == b).toList();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.insightsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          Text(l10n.insightsIntro, style: context.textStyles.bodyMedium),
          if (!learned)
            Padding(
              padding: const EdgeInsets.only(top: AppThemeTokens.space2),
              child: Text(
                l10n.insightsNoRunYet,
                key: const ValueKey('insights-no-run'),
                style: context.textStyles.bodyMedium,
              ),
            ),
          const SizedBox(height: AppThemeTokens.space3),
          _Bucket(
            keyName: 'trigger',
            title: l10n.insightsTriggers,
            icon: Icons.trending_up,
            color: context.appColors.riskHigh,
            items: bucket(InsightBucket.trigger),
          ),
          _Bucket(
            keyName: 'protector',
            title: l10n.insightsProtectors,
            icon: Icons.trending_down,
            color: context.appColors.riskLow,
            items: bucket(InsightBucket.protector),
          ),
          _Bucket(
            keyName: 'neutral',
            title: l10n.insightsNeutral,
            icon: Icons.trending_flat,
            color: context.theme.colorScheme.onSurfaceVariant,
            items: bucket(InsightBucket.neutral),
          ),
          _Bucket(
            keyName: 'not-enough',
            title: l10n.insightsNotEnough,
            icon: Icons.hourglass_empty,
            color: context.theme.colorScheme.onSurfaceVariant,
            items: bucket(InsightBucket.notEnoughData),
          ),
          TextButton.icon(
            key: const ValueKey('insights-method'),
            onPressed: () => context.push(AppRoutes.insightsMethod),
            icon: const Icon(Icons.help_outline),
            label: Text(l10n.insightsMethodLink),
          ),
          const SizedBox(height: AppThemeTokens.space2),
          Text(
            AppIdentity.wellnessDisclaimer,
            style: context.textStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _Bucket extends StatelessWidget {
  const _Bucket({
    required this.keyName,
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
  });

  final String keyName;
  final String title;
  final IconData icon;
  final Color color;
  final List<FactorInsight> items;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppThemeTokens.space3),
      child: AppCard(
        key: ValueKey('insights-$keyName'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: AppThemeTokens.space2),
                Expanded(
                  child: Text(title, style: context.textStyles.titleMedium),
                ),
                Text(
                  '${items.length}',
                  key: ValueKey('insights-$keyName-count'),
                  style: context.textStyles.labelLarge,
                ),
              ],
            ),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppThemeTokens.space2),
                child: Text(
                  l10n.insightsEmptyBucket,
                  style: context.textStyles.bodyMedium,
                ),
              )
            else
              for (final i in items)
                ListTile(
                  key: ValueKey('insight-${i.factor.id}'),
                  contentPadding: EdgeInsets.zero,
                  title: Text(factorLabel(l10n, i.factor)),
                  subtitle: Text(
                    i.bucket == InsightBucket.notEnoughData
                        ? l10n.insightsNeedMore(
                            i.exposures,
                            AppThresholds.minExposuresForInsight,
                          )
                        : l10n.insightsSample(i.exposures, i.attacksAfter),
                  ),
                  trailing: i.bucket == InsightBucket.notEnoughData
                      ? null
                      : Text(
                          l10n.insightsLift(i.lift.toStringAsFixed(1)),
                          style: context.textStyles.labelLarge?.copyWith(
                            color: color,
                          ),
                        ),
                ),
          ],
        ),
      ),
    );
  }
}

/// The method page: what an exposure day is, what "followed" means, how
/// the ratio is formed, the sample floor, and that none of it is a cause.
class InsightsMethodScreen extends StatelessWidget {
  const InsightsMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final paragraphs = [
      l10n.insightsMethod1,
      l10n.insightsMethod2,
      l10n.insightsMethod3,
      l10n.insightsMethod4(AppThresholds.minExposuresForInsight),
      l10n.insightsMethod5,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.insightsMethodTitle)),
      body: ListView(
        key: const ValueKey('insights-method-page'),
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          for (final p in paragraphs)
            Padding(
              padding: const EdgeInsets.only(bottom: AppThemeTokens.space3),
              child: Text(p, style: context.textStyles.bodyMedium),
            ),
          Text(
            AppIdentity.wellnessDisclaimer,
            style: context.textStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}
