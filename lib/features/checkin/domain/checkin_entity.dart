import 'package:flutter/foundation.dart';

/// Where a check-in value came from. Stored per field so health sync (phase
/// 14) can fill a field without overwriting what the user typed.
enum CheckinSource {
  typed,
  healthkit,
  healthConnect;

  String get code => switch (this) {
    CheckinSource.typed => 'typed',
    CheckinSource.healthkit => 'healthkit',
    CheckinSource.healthConnect => 'health_connect',
  };

  static CheckinSource? fromCode(String code) =>
      values.where((v) => v.code == code).firstOrNull;
}

/// The fields of a check-in. The first three are the mandatory 1 to 5
/// scales (the "three taps"); the rest form the optional second row.
enum CheckinField {
  sleepQuality(min: 1, max: 5, mandatory: true),
  stress(min: 1, max: 5, mandatory: true),
  neckTension(min: 1, max: 5, mandatory: true),
  caffeine(min: 0, max: 5),
  hydration(min: 1, max: 5),
  alcohol(min: 0, max: 5),
  lightExposure(min: 1, max: 5),
  screenExposure(min: 1, max: 5);

  CheckinField({required this.min, required this.max, this.mandatory = false});

  final int min;
  final int max;
  final bool mandatory;

  static const List<CheckinField> mandatoryFields = [
    sleepQuality,
    stress,
    neckTension,
  ];

  static const List<CheckinField> optionalFields = [
    caffeine,
    hydration,
    alcohol,
    lightExposure,
    screenExposure,
  ];
}

/// One calendar day's check-in. Keyed by the local date (`yyyy-MM-dd`).
@immutable
class CheckinEntity {
  const CheckinEntity({
    required this.date,
    this.values = const {},
    this.sources = const {},
    this.cycleDay,
  });

  /// `yyyy-MM-dd`, local calendar date.
  final String date;
  final Map<CheckinField, int> values;
  final Map<CheckinField, CheckinSource> sources;

  /// Set by cycle tracking (phase 08); never typed here.
  final int? cycleDay;

  int? operator [](CheckinField field) => values[field];

  bool get isComplete => CheckinField.mandatoryFields.every(values.containsKey);

  bool get hasOptional => CheckinField.optionalFields.any(values.containsKey);

  CheckinEntity withValue(
    CheckinField field,
    int? value,
    CheckinSource source,
  ) {
    final nextValues = {...values};
    final nextSources = {...sources};
    if (value == null) {
      nextValues.remove(field);
      nextSources.remove(field);
    } else {
      assert(
        value >= field.min && value <= field.max,
        '$field must be ${field.min}..${field.max}',
      );
      nextValues[field] = value;
      nextSources[field] = source;
    }
    return CheckinEntity(
      date: date,
      values: nextValues,
      sources: nextSources,
      cycleDay: cycleDay,
    );
  }

  CheckinEntity copyWith({int? cycleDay, bool clearCycleDay = false}) =>
      CheckinEntity(
        date: date,
        values: values,
        sources: sources,
        cycleDay: clearCycleDay ? null : (cycleDay ?? this.cycleDay),
      );

  @override
  bool operator ==(Object other) =>
      other is CheckinEntity &&
      other.date == date &&
      mapEquals(other.values, values) &&
      mapEquals(other.sources, sources) &&
      other.cycleDay == cycleDay;

  @override
  int get hashCode => Object.hash(date, values.length, cycleDay);
}
