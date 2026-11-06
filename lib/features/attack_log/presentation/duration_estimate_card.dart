import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/attack_log/application/duration_estimate_provider.dart';
import 'package:migraine_tracker/features/attack_log/domain/duration_estimate.dart';

/// "Typically 4 to 7 h", with how many past attacks it comes from. Shows
/// nothing until there are enough completed attacks.
class DurationEstimateCard extends ConsumerWidget {
  const DurationEstimateCard({required this.attackId, super.key});

  final String attackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final estimate = ref.watch(durationEstimateProvider(attackId));
    if (estimate == null) return const SizedBox.shrink();
    final l10n = context.l10n;
    // "4" or "1.5": one decimal only when the range is in half hours.
    final hours = NumberFormat(
      '0.#',
      Localizations.localeOf(context).toString(),
    );
    String h(Duration d) => hours.format(d.inMinutes / 60);

    final basis = switch (estimate.basis) {
      EstimateBasis.sameMedication => l10n.durationEstimateSameMedication(
        estimate.sample,
      ),
      EstimateBasis.noMedication => l10n.durationEstimateNoMedication(
        estimate.sample,
      ),
      EstimateBasis.similarIntensity => l10n.durationEstimateSimilar(
        estimate.sample,
      ),
      EstimateBasis.allAttacks => l10n.durationEstimateAll(estimate.sample),
    };
    return Padding(
      padding: const EdgeInsets.only(top: AppThemeTokens.space4),
      child: AppCard(
        key: const ValueKey('attack-duration-estimate'),
        child: Semantics(
          container: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.durationEstimateTitle,
                style: context.textStyles.labelLarge,
              ),
              const SizedBox(height: AppThemeTokens.space2),
              Text(
                l10n.durationEstimateRange(h(estimate.low), h(estimate.high)),
                key: const ValueKey('attack-duration-range'),
                style: context.textStyles.titleLarge,
              ),
              const SizedBox(height: AppThemeTokens.space1),
              Text(
                basis,
                key: const ValueKey('attack-duration-basis'),
                style: context.textStyles.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
