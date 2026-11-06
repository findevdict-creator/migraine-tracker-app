import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';

/// Converts between the Drift row and the domain entity.
abstract final class AttackMapper {
  static AttackEntity toEntity(Attack row) => AttackEntity(
    id: row.id,
    startedAt: row.startedAt,
    endedAt: row.endedAt,
    intensity: row.intensity,
    headLocations: row.headLocations
        .map(HeadLocation.fromCode)
        .nonNulls
        .toSet(),
    phases: {
      for (final e in row.phases.entries)
        ?AttackPhase.fromCode(e.key): DateTime.parse(e.value as String),
    },
    symptoms: [
      for (final s in row.symptoms)
        if (Symptom.fromCode(s['code'] as String) case final symptom?)
          SymptomTap(symptom: symptom, at: DateTime.parse(s['at'] as String)),
    ],
    notes: row.notes,
    pressureSensorHpa: row.pressureSensorHpa,
    pressureStationHpa: row.pressureStationHpa,
    finishLater: row.finishLater,
  );

  static AttacksCompanion toCompanion(
    AttackEntity attack, {
    required DateTime now,
    DateTime? createdAt,
  }) => AttacksCompanion(
    id: Value(attack.id),
    startedAt: Value(attack.startedAt),
    endedAt: Value(attack.endedAt),
    intensity: Value(attack.intensity),
    headLocations: Value(attack.headLocations.map((h) => h.name).toList()),
    phases: Value({
      for (final e in attack.phases.entries)
        e.key.name: e.value.toUtc().toIso8601String(),
    }),
    symptoms: Value([
      for (final s in attack.symptoms)
        {'code': s.symptom.name, 'at': s.at.toUtc().toIso8601String()},
    ]),
    notes: Value(attack.notes),
    pressureSensorHpa: Value(attack.pressureSensorHpa),
    pressureStationHpa: Value(attack.pressureStationHpa),
    finishLater: Value(attack.finishLater),
    createdAt: Value(createdAt ?? now),
    updatedAt: Value(now),
  );
}
