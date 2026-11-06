import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/medication/presentation/medication_controller.dart';
import 'package:migraine_tracker/features/medication/presentation/medication_entry_sheet.dart';
import 'package:migraine_tracker/features/medication/presentation/medication_widgets.dart';

/// Standalone medication log: this month's doses, the acute-day counter
/// and the add button.
class MedicationLogScreen extends ConsumerWidget {
  const MedicationLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final events = ref.watch(thisMonthMedicationsProvider).value ?? const [];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.medicationTitle)),
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('med-add'),
        onPressed: () => showMedicationEntrySheet(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.medicationAdd),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          const AcuteDaysCard(),
          SectionHeader(title: l10n.medicationThisMonth),
          if (events.isEmpty)
            Text(l10n.medicationEmpty, style: context.textStyles.bodyMedium)
          else
            for (final e in events.reversed) MedicationTile(event: e),
          const SizedBox(height: AppThemeTokens.space6 * 2),
        ],
      ),
    );
  }
}

/// Section shown inside the attack screen.
class AttackMedicationSection extends ConsumerWidget {
  const AttackMedicationSection({required this.attackId, super.key});

  final String attackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final events =
        ref.watch(attackMedicationsProvider(attackId)).value ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: l10n.medicationTitle),
        for (final e in events) MedicationTile(event: e),
        AppButton(
          key: const ValueKey('attack-add-medication'),
          label: l10n.medicationAdd,
          icon: Icons.medication,
          variant: AppButtonVariant.secondary,
          onPressed: () =>
              showMedicationEntrySheet(context, attackId: attackId),
        ),
      ],
    );
  }
}
