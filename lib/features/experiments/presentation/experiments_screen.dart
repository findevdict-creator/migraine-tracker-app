import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/experiments/domain/experiment.dart';
import 'package:migraine_tracker/features/experiments/presentation/experiment_controller.dart';
import 'package:migraine_tracker/features/experiments/presentation/experiment_text.dart';
import 'package:migraine_tracker/features/premium/application/premium_controller.dart';
import 'package:migraine_tracker/features/premium/presentation/premium_lock.dart';

/// FR-12: one change at a time, a daily "did you stick with it", and the
/// two weeks before against the experiment days.
class ExperimentsScreen extends ConsumerWidget {
  const ExperimentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final active = ref.watch(activeExperimentProvider);
    final past = ref.watch(pastExperimentsProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.experimentsTitle)),
      body: ListView(
        key: const ValueKey('experiments-list'),
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          Text(l10n.experimentsIntro, style: context.textStyles.bodyMedium),
          const SizedBox(height: AppThemeTokens.space4),
          ...switch (active) {
            AsyncData(value: final experiment?) => [
              _ActiveExperiment(experiment: experiment),
            ],
            AsyncData()
                when !ref
                    .watch(premiumProvider)
                    .allows(PremiumFeature.experiments) =>
              [
                PremiumLockCard(
                  feature: PremiumFeature.experiments,
                  note: past.isEmpty ? null : l10n.premiumLockExperimentsNote,
                ),
              ],
            AsyncData() => [const _ChangePicker()],
            // Loading takes a frame or two; nothing flashes meanwhile.
            _ => const <Widget>[],
          },
          if (past.isNotEmpty) ...[
            const SizedBox(height: AppThemeTokens.space4),
            SectionHeader(title: l10n.experimentPast),
            for (final e in past) _PastExperiment(experiment: e),
          ],
        ],
      ),
    );
  }
}

class _ChangePicker extends ConsumerWidget {
  const _ChangePicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: l10n.experimentsPick),
        for (final change in ExperimentChange.values)
          ListTile(
            key: ValueKey('experiment-pick-${change.code}'),
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.science_outlined),
            title: Text(change.label(l10n)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () =>
                unawaited(ref.read(experimentActionsProvider).start(change)),
          ),
      ],
    );
  }
}

class _ActiveExperiment extends ConsumerWidget {
  const _ActiveExperiment({required this.experiment});

  final ExperimentEntity experiment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final now = ref.watch(clockProvider)();
    final actions = ref.read(experimentActionsProvider);
    final today = experiment.adherence[now.dateKey];
    final day = experiment.dayOn(now);
    final due = experiment.isDueOn(now);
    final comparison = ref.watch(experimentComparisonProvider).value;
    return AppCard(
      key: const ValueKey('experiment-active'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            experiment.change.label(l10n),
            style: context.textStyles.titleMedium,
          ),
          Text(
            l10n.experimentDay(day, AppThresholds.experimentWindowDays),
            key: const ValueKey('experiment-day'),
          ),
          const SizedBox(height: AppThemeTokens.space3),
          if (!due) ...[
            Text(l10n.experimentAdherenceQuestion),
            const SizedBox(height: AppThemeTokens.space2),
            Wrap(
              spacing: AppThemeTokens.space2,
              children: [
                ChoiceChip(
                  key: const ValueKey('experiment-kept-yes'),
                  label: Text(l10n.experimentYes),
                  selected: today ?? false,
                  onSelected: (_) =>
                      unawaited(actions.setAdherence(experiment, kept: true)),
                ),
                ChoiceChip(
                  key: const ValueKey('experiment-kept-no'),
                  label: Text(l10n.experimentNo),
                  selected: today == false,
                  onSelected: (_) =>
                      unawaited(actions.setAdherence(experiment, kept: false)),
                ),
              ],
            ),
          ],
          const SizedBox(height: AppThemeTokens.space2),
          Text(
            l10n.experimentAdherence(experiment.daysKept, day),
            key: const ValueKey('experiment-adherence'),
            style: context.textStyles.bodySmall,
          ),
          if (comparison != null) ...[
            const SizedBox(height: AppThemeTokens.space4),
            ComparisonTable(comparison: comparison),
          ],
          const SizedBox(height: AppThemeTokens.space3),
          if (due) ...[
            Text(l10n.experimentDue),
            const SizedBox(height: AppThemeTokens.space2),
            FilledButton(
              key: const ValueKey('experiment-finish'),
              onPressed: () => unawaited(actions.finish(experiment)),
              child: Text(l10n.experimentFinish),
            ),
          ] else
            OutlinedButton(
              key: const ValueKey('experiment-stop'),
              onPressed: () => unawaited(actions.stop(experiment)),
              child: Text(l10n.experimentStop),
            ),
        ],
      ),
    );
  }
}

/// Before against during, with what each number rests on, and the
/// caveats that keep it honest.
class ComparisonTable extends StatelessWidget {
  const ComparisonTable({required this.comparison, super.key});

  final ExperimentComparison comparison;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final format = ExperimentFormat(
      l10n,
      Localizations.localeOf(context).toString(),
    );
    final b = comparison.before;
    final d = comparison.during;
    TableRow row(
      String label,
      String before,
      String during, {
      bool bold = false,
    }) => TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppThemeTokens.space1),
          child: Text(label),
        ),
        Text(before, style: bold ? context.textStyles.titleSmall : null),
        Text(during, style: bold ? context.textStyles.titleSmall : null),
      ],
    );
    final small = context.textStyles.bodySmall;
    return Column(
      key: const ValueKey('experiment-comparison'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.experimentCompareTitle, style: context.textStyles.titleSmall),
        const SizedBox(height: AppThemeTokens.space2),
        Table(
          columnWidths: const {0: FlexColumnWidth(2)},
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            row(
              '',
              '${l10n.experimentBefore}\n${l10n.experimentDays(b.days)}',
              '${l10n.experimentDuring}\n${l10n.experimentDays(d.days)}',
            ),
            row(
              l10n.experimentRowRate,
              format.number(b.perWeek),
              format.number(d.perWeek),
              bold: true,
            ),
            row(
              '',
              l10n.experimentSample(b.attacks),
              l10n.experimentSample(d.attacks),
            ),
            row(
              l10n.experimentRowIntensity,
              format.number(b.meanIntensity),
              format.number(d.meanIntensity),
              bold: true,
            ),
            row(
              '',
              l10n.experimentSample(b.intensityCount),
              l10n.experimentSample(d.intensityCount),
            ),
            row(
              l10n.experimentRowDuration,
              format.hours(b.medianDuration),
              format.hours(d.medianDuration),
              bold: true,
            ),
            row(
              '',
              l10n.experimentSample(b.durationCount),
              l10n.experimentSample(d.durationCount),
            ),
          ],
        ),
        const SizedBox(height: AppThemeTokens.space2),
        if (comparison.small)
          Text(
            l10n.experimentSmallSample(AppThresholds.experimentMinAttacks),
            key: const ValueKey('experiment-small'),
            style: small,
          ),
        Text(
          l10n.experimentCaveat,
          key: const ValueKey('experiment-caveat'),
          style: small,
        ),
      ],
    );
  }
}

class _PastExperiment extends StatelessWidget {
  const _PastExperiment({required this.experiment});

  final ExperimentEntity experiment;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final format = ExperimentFormat(l10n, locale);
    final end = experiment.end ?? experiment.windowEnd;
    final date = DateFormat.yMMMd(locale).format(end);
    final result = experiment.result;
    return ListTile(
      key: ValueKey('experiment-past-${experiment.id}'),
      contentPadding: EdgeInsets.zero,
      title: Text(experiment.change.label(l10n)),
      subtitle: Text(
        [
          if (experiment.status == ExperimentStatus.completed)
            l10n.experimentFinished(date)
          else
            l10n.experimentStopped(date),
          if (result != null)
            l10n.experimentPastSummary(
              format.number(result.before.perWeek),
              format.number(result.during.perWeek),
            ),
        ].join('\n'),
      ),
    );
  }
}
