import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:migraine_tracker/features/attack_log/domain/duration_estimate.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_log_controller.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';
import 'package:migraine_tracker/features/medication/presentation/medication_controller.dart';

/// The duration estimate for a running attack, or null when it is over,
/// still loading, or there are too few past attacks (FR-5).
final ProviderFamily<DurationEstimate?, String> durationEstimateProvider =
    Provider.family((ref, attackId) {
      final attack = ref.watch(attackEditorProvider(attackId)).value;
      if (attack == null || !attack.isRunning) return null;
      final attacks = ref.watch(attacksProvider).value;
      final meds = ref.watch(allMedicationsProvider).value;
      if (attacks == null || meds == null) return null;
      return DurationEstimator.estimate(
        running: attack,
        attacks: attacks,
        medsByAttack: acuteNamesByAttack(meds),
      );
    });

/// Acute medication names per attack, trimmed and lower-cased so "Ibuprofen"
/// and "ibuprofen " match.
Map<String, Set<String>> acuteNamesByAttack(Iterable<MedicationEntity> meds) {
  final out = <String, Set<String>>{};
  for (final m in meds) {
    final id = m.attackId;
    if (id == null || !m.isAcute) continue;
    (out[id] ??= {}).add(m.name.trim().toLowerCase());
  }
  return out;
}
