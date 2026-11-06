import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/medication/domain/acute_day_counter.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';
import 'package:migraine_tracker/features/medication/presentation/medication_controller.dart';
import 'package:url_launcher/url_launcher.dart';

/// One logged dose, with the relief question once two hours have passed.
class MedicationTile extends ConsumerWidget {
  const MedicationTile({required this.event, super.key});

  final MedicationEntity event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final now = ref.watch(clockProvider)();
    final time = TimeOfDay.fromDateTime(event.takenAt.toLocal())
        .format(context);
    final subtitle = [
      ?event.dose,
      time,
      if (event.isAcute)
        l10n.medicationKindAcute
      else
        l10n.medicationKindPreventive,
    ].join(' · ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          key: ValueKey('med-tile-${event.id}'),
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            event.isAcute ? Icons.medication : Icons.shield_outlined,
          ),
          title: Text(event.name),
          subtitle: Text(subtitle),
          trailing: IconButton(
            key: ValueKey('med-delete-${event.id}'),
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.medicationDelete,
            onPressed: () => ref.read(medicationLogProvider).delete(event.id),
          ),
        ),
        if (event.reliefDue(now))
          Padding(
            padding: const EdgeInsets.only(bottom: AppThemeTokens.space2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.medicationReliefQuestion,
                    style: context.textStyles.bodyMedium,
                  ),
                ),
                for (final r in Relief.values) ...[
                  AppChoiceChip(
                    key: ValueKey('med-relief-${event.id}-${r.name}'),
                    label: reliefLabel(l10n, r),
                    selected: event.reliefAt2h == r,
                    onSelected: (_) => ref
                        .read(medicationLogProvider)
                        .setRelief(event.id, event.reliefAt2h == r ? null : r),
                  ),
                  const SizedBox(width: AppThemeTokens.space1),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

/// Acute days this month and, past the thresholds, the gentle note with a
/// link to "talk to your clinician".
class AcuteDaysCard extends ConsumerWidget {
  const AcuteDaysCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final days = ref.watch(acuteDaysThisMonthProvider);
    final note = ref.watch(overuseNoteProvider);
    final colors = context.appColors;
    return AppCard(
      key: const ValueKey('acute-days-card'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.medicationAcuteDays(days),
            style: context.textStyles.titleMedium,
          ),
          Text(
            l10n.medicationAcuteDaysHint,
            style: context.textStyles.bodySmall,
          ),
          if (note != OveruseNote.none) ...[
            const SizedBox(height: AppThemeTokens.space3),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: note == OveruseNote.second
                      ? colors.danger
                      : colors.warning,
                ),
                const SizedBox(width: AppThemeTokens.space2),
                Expanded(
                  child: Text(
                    note == OveruseNote.second
                        ? l10n.medicationOveruseSecondNote(
                            AppThresholds.medicationOveruseSecondNote,
                          )
                        : l10n.medicationOveruseFirstNote(
                            AppThresholds.medicationOveruseFirstNote,
                          ),
                    key: const ValueKey('overuse-note'),
                  ),
                ),
              ],
            ),
            AppButton(
              key: const ValueKey('overuse-link'),
              label: l10n.medicationTalkToClinician,
              icon: Icons.open_in_new,
              variant: AppButtonVariant.text,
              onPressed: () => launchUrl(
                Uri.parse(AppIdentity.clinicianGuidanceUrl),
                mode: LaunchMode.externalApplication,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

String reliefLabel(AppLocalizations l10n, Relief r) => switch (r) {
  Relief.none => l10n.medicationReliefNone,
  Relief.partial => l10n.medicationReliefPartial,
  Relief.full => l10n.medicationReliefFull,
};
