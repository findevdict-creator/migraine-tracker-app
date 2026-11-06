import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';
import 'package:migraine_tracker/features/medication/presentation/medication_controller.dart';

/// Opens the add-medication sheet. Returns the saved event, or null.
Future<MedicationEntity?> showMedicationEntrySheet(
  BuildContext context, {
  String? attackId,
  MedicationKind initialKind = MedicationKind.acute,
}) => showModalBottomSheet<MedicationEntity>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: MedicationEntryForm(attackId: attackId, initialKind: initialKind),
  ),
);

/// Name with suggestions, dose, kind and time. Saves on "Log".
class MedicationEntryForm extends ConsumerStatefulWidget {
  const MedicationEntryForm({
    this.attackId,
    this.initialKind = MedicationKind.acute,
    super.key,
  });

  final String? attackId;
  final MedicationKind initialKind;

  @override
  ConsumerState<MedicationEntryForm> createState() =>
      _MedicationEntryFormState();
}

class _MedicationEntryFormState extends ConsumerState<MedicationEntryForm> {
  final _name = TextEditingController();
  final _dose = TextEditingController();
  late MedicationKind _kind = widget.initialKind;
  late DateTime _takenAt = ref.read(clockProvider)();

  @override
  void dispose() {
    _name.dispose();
    _dose.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_takenAt.toLocal()),
    );
    if (picked == null) return;
    final local = _takenAt.toLocal();
    setState(() {
      _takenAt = DateTime(
        local.year,
        local.month,
        local.day,
        picked.hour,
        picked.minute,
      );
    });
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) return;
    final event = await ref
        .read(medicationLogProvider)
        .add(
          name: _name.text,
          dose: _dose.text,
          kind: _kind,
          takenAt: _takenAt,
          attackId: widget.attackId,
        );
    if (mounted) Navigator.of(context).pop(event);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final suggestions =
        ref.watch(recentMedicationNamesProvider).value ?? const <String>[];
    return Padding(
      padding: const EdgeInsets.all(AppThemeTokens.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.medicationAddTitle, style: context.textStyles.titleLarge),
          const SizedBox(height: AppThemeTokens.space3),
          if (suggestions.isNotEmpty) ...[
            Wrap(
              spacing: AppThemeTokens.space2,
              runSpacing: AppThemeTokens.space2,
              children: [
                for (final name in suggestions)
                  AppChoiceChip(
                    key: ValueKey('med-suggest-$name'),
                    label: name,
                    selected: _name.text == name,
                    onSelected: (_) => setState(() => _name.text = name),
                  ),
              ],
            ),
            const SizedBox(height: AppThemeTokens.space3),
          ],
          TextField(
            key: const ValueKey('med-name'),
            controller: _name,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(labelText: l10n.medicationName),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppThemeTokens.space3),
          TextField(
            key: const ValueKey('med-dose'),
            controller: _dose,
            decoration: InputDecoration(
              labelText: l10n.medicationDose,
              hintText: l10n.medicationDoseHint,
            ),
          ),
          const SizedBox(height: AppThemeTokens.space3),
          SegmentedButton<MedicationKind>(
            key: const ValueKey('med-kind'),
            segments: [
              ButtonSegment(
                value: MedicationKind.acute,
                label: Text(l10n.medicationKindAcute),
              ),
              ButtonSegment(
                value: MedicationKind.preventive,
                label: Text(l10n.medicationKindPreventive),
              ),
            ],
            selected: {_kind},
            onSelectionChanged: (s) => setState(() => _kind = s.first),
          ),
          const SizedBox(height: AppThemeTokens.space3),
          AppButton(
            key: const ValueKey('med-time'),
            label: l10n.medicationTakenAt(
              TimeOfDay.fromDateTime(_takenAt.toLocal()).format(context),
            ),
            icon: Icons.schedule,
            variant: AppButtonVariant.secondary,
            onPressed: _pickTime,
          ),
          const SizedBox(height: AppThemeTokens.space4),
          AppButton(
            key: const ValueKey('med-save'),
            label: l10n.medicationLog,
            expand: true,
            onPressed: _name.text.trim().isEmpty ? null : _save,
          ),
        ],
      ),
    );
  }
}
