import 'package:flutter/foundation.dart';

/// Regions of the head map. Codes are stored in the database, so renaming
/// one needs a migration.
enum HeadLocation {
  forehead,
  leftTemple,
  rightTemple,
  behindEyes,
  leftSide,
  rightSide,
  topOfHead,
  backOfHead,
  neck;

  static HeadLocation? fromCode(String code) =>
      values.where((v) => v.name == code).firstOrNull;
}

/// Symptom chips on the attack screen (requirements doc FR-1).
enum Symptom {
  aura,
  neckTension,
  lightSensitivity,
  soundSensitivity,
  smellSensitivity,
  nausea;

  static Symptom? fromCode(String code) =>
      values.where((v) => v.name == code).firstOrNull;
}

/// Phases of one attack event. Columns of one record, never separate rows.
enum AttackPhase {
  prodrome,
  aura,
  attack,
  postdrome;

  static AttackPhase? fromCode(String code) =>
      values.where((v) => v.name == code).firstOrNull;
}

/// A symptom chip with the moment it was tapped.
@immutable
class SymptomTap {
  const SymptomTap({required this.symptom, required this.at});

  final Symptom symptom;
  final DateTime at;

  @override
  bool operator ==(Object other) =>
      other is SymptomTap && other.symptom == symptom && other.at == at;

  @override
  int get hashCode => Object.hash(symptom, at);
}

/// One attack event.
@immutable
class AttackEntity {
  const AttackEntity({
    required this.id,
    required this.startedAt,
    this.endedAt,
    this.intensity,
    this.headLocations = const {},
    this.phases = const {},
    this.symptoms = const [],
    this.notes,
    this.pressureSensorHpa,
    this.pressureStationHpa,
    this.finishLater = false,
  });

  final String id;
  final DateTime startedAt;
  final DateTime? endedAt;

  /// 0 to 10, null until answered.
  final int? intensity;
  final Set<HeadLocation> headLocations;
  final Map<AttackPhase, DateTime> phases;
  final List<SymptomTap> symptoms;
  final String? notes;
  final double? pressureSensorHpa;
  final double? pressureStationHpa;
  final bool finishLater;

  bool get isRunning => endedAt == null;

  Duration? get duration => endedAt?.difference(startedAt);

  bool hasSymptom(Symptom s) => symptoms.any((t) => t.symptom == s);

  AttackEntity copyWith({
    DateTime? startedAt,
    DateTime? endedAt,
    bool clearEndedAt = false,
    int? intensity,
    Set<HeadLocation>? headLocations,
    Map<AttackPhase, DateTime>? phases,
    List<SymptomTap>? symptoms,
    String? notes,
    double? pressureSensorHpa,
    double? pressureStationHpa,
    bool? finishLater,
  }) => AttackEntity(
    id: id,
    startedAt: startedAt ?? this.startedAt,
    endedAt: clearEndedAt ? null : (endedAt ?? this.endedAt),
    intensity: intensity ?? this.intensity,
    headLocations: headLocations ?? this.headLocations,
    phases: phases ?? this.phases,
    symptoms: symptoms ?? this.symptoms,
    notes: notes ?? this.notes,
    pressureSensorHpa: pressureSensorHpa ?? this.pressureSensorHpa,
    pressureStationHpa: pressureStationHpa ?? this.pressureStationHpa,
    finishLater: finishLater ?? this.finishLater,
  );

  @override
  bool operator ==(Object other) =>
      other is AttackEntity &&
      other.id == id &&
      other.startedAt == startedAt &&
      other.endedAt == endedAt &&
      other.intensity == intensity &&
      setEquals(other.headLocations, headLocations) &&
      mapEquals(other.phases, phases) &&
      listEquals(other.symptoms, symptoms) &&
      other.notes == notes &&
      other.pressureSensorHpa == pressureSensorHpa &&
      other.pressureStationHpa == pressureStationHpa &&
      other.finishLater == finishLater;

  @override
  int get hashCode => Object.hash(id, startedAt, endedAt, intensity, notes);
}
