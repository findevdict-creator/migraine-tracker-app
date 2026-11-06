import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/cycle/domain/cycle_calculator.dart';
import 'package:migraine_tracker/features/cycle/presentation/cycle_controller.dart';

/// The on/off switch. Lives here and on the settings screen (phase 09).
class CycleTrackingToggle extends ConsumerWidget {
  const CycleTrackingToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final enabled = ref.watch(cycleTrackingEnabledProvider).value ?? false;
    return SwitchListTile(
      key: const ValueKey('cycle-toggle'),
      title: Text(l10n.cycleToggleTitle),
      subtitle: Text(l10n.cycleToggleSubtitle),
      value: enabled,
      onChanged: (v) => ref.read(cycleLogProvider).setEnabled(enabled: v),
    );
  }
}

/// Cycle screen: toggle, today's day and phase, period start log.
class CycleScreen extends ConsumerWidget {
  const CycleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final enabled = ref.watch(cycleTrackingEnabledProvider).value ?? false;
    final today = ref.watch(cycleTodayProvider);
    final info = ref.watch(cycleInfoProvider(today));
    final starts = ref.watch(periodStartsProvider).value ?? const [];
    final locale = Localizations.localeOf(context).toString();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.cycleTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          const CycleTrackingToggle(),
          if (enabled) ...[
            const SizedBox(height: AppThemeTokens.space4),
            AppCard(
              key: const ValueKey('cycle-today-card'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    info == null
                        ? l10n.cycleNoData
                        : l10n.cycleDayAndPhase(
                            info.day,
                            cyclePhaseLabel(l10n, info.phase),
                          ),
                    style: context.textStyles.titleMedium,
                  ),
                  if (info != null)
                    Text(
                      l10n.cycleLength(info.cycleLength),
                      style: context.textStyles.bodySmall,
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppThemeTokens.space3),
            PeriodStartChip(date: today),
            SectionHeader(title: l10n.cyclePeriodStarts),
            if (starts.isEmpty)
              Text(l10n.cycleNoStarts, style: context.textStyles.bodyMedium),
            for (final s in starts.reversed)
              ListTile(
                key: ValueKey('period-$s'),
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.water_drop_outlined),
                title: Text(DateFormat.yMMMd(locale).format(parseDateKey(s))),
                trailing: IconButton(
                  key: ValueKey('period-delete-$s'),
                  icon: const Icon(Icons.delete_outline),
                  tooltip: l10n.cycleRemoveStart,
                  onPressed: () =>
                      ref.read(cycleLogProvider).togglePeriodStart(s),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// "Period started" chip for one day. Also used on the check-in screen.
class PeriodStartChip extends ConsumerWidget {
  const PeriodStartChip({required this.date, super.key});

  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final starts = ref.watch(periodStartsProvider).value ?? const [];
    return Align(
      alignment: Alignment.centerLeft,
      child: AppChoiceChip(
        key: ValueKey('period-start-$date'),
        label: l10n.cyclePeriodStartedToday,
        icon: Icons.water_drop_outlined,
        selected: starts.contains(date),
        onSelected: (_) => ref.read(cycleLogProvider).togglePeriodStart(date),
      ),
    );
  }
}

/// One line for the check-in screen: cycle day and phase, plus the chip.
/// Renders nothing when tracking is off.
class CheckinCycleRow extends ConsumerWidget {
  const CheckinCycleRow({required this.date, super.key});

  final String date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final enabled = ref.watch(cycleTrackingEnabledProvider).value ?? false;
    if (!enabled) return const SizedBox.shrink();
    final info = ref.watch(cycleInfoProvider(date));
    return Padding(
      padding: const EdgeInsets.only(top: AppThemeTokens.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            info == null
                ? l10n.cycleNoData
                : l10n.cycleDayAndPhase(
                    info.day,
                    cyclePhaseLabel(l10n, info.phase),
                  ),
            key: const ValueKey('checkin-cycle-info'),
            style: context.textStyles.titleMedium,
          ),
          const SizedBox(height: AppThemeTokens.space2),
          PeriodStartChip(date: date),
        ],
      ),
    );
  }
}

String cyclePhaseLabel(AppLocalizations l10n, CyclePhase p) => switch (p) {
  CyclePhase.menstrual => l10n.cyclePhaseMenstrual,
  CyclePhase.follicular => l10n.cyclePhaseFollicular,
  CyclePhase.ovulation => l10n.cyclePhaseOvulation,
  CyclePhase.luteal => l10n.cyclePhaseLuteal,
};
