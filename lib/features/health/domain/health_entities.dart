import 'package:flutter/foundation.dart';
import 'package:migraine_tracker/config/app_config.dart';

/// The health types the app reads. Codes are the `type` column values.
enum HealthType {
  sleep('sleep', 'min'),
  restingHr('resting_hr', 'bpm'),
  hrv('hrv', 'ms'),
  steps('steps', 'count'),
  menstrualFlow('menstrual_flow', 'flow');

  HealthType(this.code, this.unit);

  final String code;
  final String unit;

  static HealthType? fromCode(String code) =>
      values.where((t) => t.code == code).firstOrNull;
}

/// Which store a sample came from.
enum HealthStore {
  healthkit('healthkit'),
  healthConnect('health_connect');

  HealthStore(this.code);

  final String code;

  static HealthStore? fromCode(String code) =>
      values.where((s) => s.code == code).firstOrNull;
}

/// Menstrual flow as stored in `value` for [HealthType.menstrualFlow].
enum FlowLevel {
  none(0),
  spotting(1),
  light(2),
  medium(3),
  heavy(4);

  FlowLevel(this.value);

  final int value;

  bool get isBleeding => this != none;
}

/// One imported sample. Never leaves the device.
@immutable
class HealthSampleEntity {
  const HealthSampleEntity({
    required this.id,
    required this.type,
    required this.start,
    required this.end,
    required this.value,
    required this.store,
    required this.importedAt,
    this.sourceName,
  });

  final String id;
  final HealthType type;
  final DateTime start;
  final DateTime end;
  final double value;
  final HealthStore store;
  final String? sourceName;
  final DateTime importedAt;

  @override
  bool operator ==(Object other) =>
      other is HealthSampleEntity &&
      other.type == type &&
      other.start == start &&
      other.end == end &&
      other.store == store &&
      other.value == value;

  @override
  int get hashCode => Object.hash(type, start, end, store);
}

/// Per-type consent. Everything is off until the person turns it on.
@immutable
class HealthConsent {
  const HealthConsent(this.types);

  const HealthConsent.none() : types = const {};

  factory HealthConsent.fromJson(Map<String, Object?> json) => HealthConsent({
    for (final e in json.entries)
      if (e.value == true && HealthType.fromCode(e.key) != null)
        HealthType.fromCode(e.key)!,
  });

  final Set<HealthType> types;

  bool allows(HealthType type) => types.contains(type);

  bool get any => types.isNotEmpty;

  Map<String, Object?> toJson() => {for (final t in types) t.code: true};

  HealthConsent with_(HealthType type, {required bool allowed}) {
    final next = {...types};
    if (allowed) {
      next.add(type);
    } else {
      next.remove(type);
    }
    return HealthConsent(next);
  }
}

/// Maps imported sleep minutes onto the 1 to 5 check-in scale.
int sleepQualityFromMinutes(int minutes) {
  const bands = AppThresholds.sleepQualityMinuteBands;
  for (var i = 0; i < bands.length; i++) {
    if (minutes <= bands[i]) return i + 1;
  }
  return bands.length + 1;
}
