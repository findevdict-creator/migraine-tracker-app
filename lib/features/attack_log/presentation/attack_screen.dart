import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/theme/app_theme.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_log_controller.dart';
import 'package:migraine_tracker/features/attack_log/presentation/head_map.dart';

/// The attack screen. Always rendered in the attack theme: true black,
/// 56 pt targets, no animation, nothing that needs reading closely.
class AttackScreen extends ConsumerWidget {
  const AttackScreen({required this.attackId, super.key});

  final String attackId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attack = ref.watch(attackEditorProvider(attackId));
    return Theme(
      data: AppTheme.attack(),
      child: attack.when(
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (error, _) => Scaffold(
          appBar: AppBar(),
          body: Center(child: Text(context.l10n.attackNotFound)),
        ),
        data: (entity) => _AttackForm(attack: entity),
      ),
    );
  }
}

class _AttackForm extends ConsumerStatefulWidget {
  const _AttackForm({required this.attack});

  final AttackEntity attack;

  @override
  ConsumerState<_AttackForm> createState() => _AttackFormState();
}

class _AttackFormState extends ConsumerState<_AttackForm> {
  late final TextEditingController _notes;

  @override
  void initState() {
    super.initState();
    _notes = TextEditingController(text: widget.attack.notes);
  }

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  AttackEditor get _editor =>
      ref.read(attackEditorProvider(widget.attack.id).notifier);

  Future<void> _leave(Future<void> Function() action) async {
    await _editor.setNotes(_notes.text);
    await action();
    if (mounted && context.canPop()) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final attack = widget.attack;
    final time = TimeOfDay.fromDateTime(attack.startedAt.toLocal())
        .format(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          attack.isRunning ? l10n.attackTitleRunning : l10n.attackTitleEnded,
        ),
        actions: [
          if (attack.isRunning)
            TextButton(
              key: const ValueKey('attack-finish-later'),
              onPressed: () => _leave(_editor.finishLater),
              child: Text(l10n.attackFinishLater),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          Text(l10n.attackStartedAt(time), style: context.textStyles.bodyLarge),
          const SizedBox(height: AppThemeTokens.space5),
          SectionHeader(title: l10n.attackIntensity),
          AppIntensitySlider(
            key: const ValueKey('attack-intensity'),
            value: attack.intensity,
            onChanged: _editor.setIntensity,
            semanticLabel: l10n.attackIntensity,
            lowLabel: l10n.attackIntensityLow,
            highLabel: l10n.attackIntensityHigh,
          ),
          const SizedBox(height: AppThemeTokens.space5),
          SectionHeader(title: l10n.attackWhereItHurts),
          Center(
            child: HeadMap(
              selected: attack.headLocations,
              onToggle: _editor.toggleHeadLocation,
            ),
          ),
          const SizedBox(height: AppThemeTokens.space5),
          SectionHeader(title: l10n.attackSymptoms),
          Wrap(
            spacing: AppThemeTokens.space2,
            runSpacing: AppThemeTokens.space2,
            children: [
              for (final symptom in Symptom.values)
                AppChoiceChip(
                  key: ValueKey('symptom-${symptom.name}'),
                  label: symptomLabel(l10n, symptom),
                  selected: attack.hasSymptom(symptom),
                  onSelected: (_) => _editor.toggleSymptom(symptom),
                ),
            ],
          ),
          const SizedBox(height: AppThemeTokens.space5),
          SectionHeader(title: l10n.attackPhases),
          Wrap(
            spacing: AppThemeTokens.space2,
            runSpacing: AppThemeTokens.space2,
            children: [
              for (final phase in AttackPhase.values)
                AppChoiceChip(
                  key: ValueKey('phase-${phase.name}'),
                  label: _phaseChipLabel(context, phase, attack.phases[phase]),
                  selected: attack.phases.containsKey(phase),
                  onSelected: (_) => _editor.togglePhase(phase),
                ),
            ],
          ),
          const SizedBox(height: AppThemeTokens.space5),
          SectionHeader(title: l10n.attackNotes),
          TextField(
            key: const ValueKey('attack-notes'),
            controller: _notes,
            minLines: 2,
            maxLines: 5,
            decoration: InputDecoration(hintText: l10n.attackNotesHint),
            onChanged: _editor.setNotes,
          ),
          const SizedBox(height: AppThemeTokens.space6),
          if (attack.isRunning)
            AppButton(
              key: const ValueKey('attack-end'),
              label: l10n.attackEnd,
              icon: Icons.stop_circle_outlined,
              large: true,
              expand: true,
              onPressed: () => _leave(_editor.end),
            )
          else
            AppButton(
              key: const ValueKey('attack-done'),
              label: l10n.attackDone,
              large: true,
              expand: true,
              onPressed: () => _leave(() async {}),
            ),
          const SizedBox(height: AppThemeTokens.space6),
        ],
      ),
    );
  }

  String _phaseChipLabel(
    BuildContext context,
    AttackPhase phase,
    DateTime? at,
  ) {
    final name = phaseLabel(context.l10n, phase);
    if (at == null) return name;
    final time = TimeOfDay.fromDateTime(at.toLocal()).format(context);
    return '$name · $time';
  }
}

String symptomLabel(AppLocalizations l10n, Symptom symptom) =>
    switch (symptom) {
      Symptom.aura => l10n.symptomAura,
      Symptom.neckTension => l10n.symptomNeckTension,
      Symptom.lightSensitivity => l10n.symptomLightSensitivity,
      Symptom.soundSensitivity => l10n.symptomSoundSensitivity,
      Symptom.smellSensitivity => l10n.symptomSmellSensitivity,
      Symptom.nausea => l10n.symptomNausea,
    };

String phaseLabel(AppLocalizations l10n, AttackPhase phase) => switch (phase) {
  AttackPhase.prodrome => l10n.phaseProdrome,
  AttackPhase.aura => l10n.phaseAura,
  AttackPhase.attack => l10n.phaseAttack,
  AttackPhase.postdrome => l10n.phasePostdrome,
};
