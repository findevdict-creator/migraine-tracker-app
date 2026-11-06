import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';

/// Converts between the Drift row (one column per field) and the entity
/// (a map per field), tolerating unknown source codes.
abstract final class CheckinMapper {
  static CheckinEntity toEntity(Checkin row) {
    final values = <CheckinField, int>{
      for (final e in {
        CheckinField.sleepQuality: row.sleepQuality,
        CheckinField.stress: row.stress,
        CheckinField.neckTension: row.neckTension,
        CheckinField.caffeine: row.caffeine,
        CheckinField.hydration: row.hydration,
        CheckinField.alcohol: row.alcohol,
        CheckinField.lightExposure: row.lightExposure,
        CheckinField.screenExposure: row.screenExposure,
      }.entries)
        e.key: ?e.value,
    };
    final sources = <CheckinField, CheckinSource>{
      for (final field in values.keys)
        field:
            CheckinSource.fromCode(row.sources[field.name] as String? ?? '') ??
            CheckinSource.typed,
    };
    return CheckinEntity(
      date: row.date,
      values: values,
      sources: sources,
      cycleDay: row.cycleDay,
      weather: row.weather?.cast<String, Object?>(),
    );
  }

  static CheckinsCompanion toCompanion(
    CheckinEntity c, {
    required DateTime now,
    DateTime? createdAt,
  }) => CheckinsCompanion(
    date: Value(c.date),
    sleepQuality: Value(c[CheckinField.sleepQuality]),
    stress: Value(c[CheckinField.stress]),
    neckTension: Value(c[CheckinField.neckTension]),
    caffeine: Value(c[CheckinField.caffeine]),
    hydration: Value(c[CheckinField.hydration]),
    alcohol: Value(c[CheckinField.alcohol]),
    lightExposure: Value(c[CheckinField.lightExposure]),
    screenExposure: Value(c[CheckinField.screenExposure]),
    cycleDay: Value(c.cycleDay),
    weather: Value(c.weather),
    sources: Value({
      for (final e in c.sources.entries) e.key.name: e.value.code,
    }),
    createdAt: Value(createdAt ?? now),
    updatedAt: Value(now),
  );
}
