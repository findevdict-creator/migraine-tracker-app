import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/converters.dart';
import 'package:migraine_tracker/core/db/daos/attack_dao.dart';
import 'package:migraine_tracker/core/db/daos/barometer_dao.dart';
import 'package:migraine_tracker/core/db/daos/checkin_dao.dart';
import 'package:migraine_tracker/core/db/daos/environment_dao.dart';
import 'package:migraine_tracker/core/db/daos/experiment_dao.dart';
import 'package:migraine_tracker/core/db/daos/health_dao.dart';
import 'package:migraine_tracker/core/db/daos/medication_dao.dart';
import 'package:migraine_tracker/core/db/daos/questionnaire_dao.dart';
import 'package:migraine_tracker/core/db/daos/risk_dao.dart';
import 'package:migraine_tracker/core/db/daos/settings_dao.dart';
import 'package:migraine_tracker/core/db/daos/share_link_dao.dart';
import 'package:migraine_tracker/core/db/daos/weather_dao.dart';
import 'package:migraine_tracker/core/db/tables/attacks.dart';
import 'package:migraine_tracker/core/db/tables/audit_days.dart';
import 'package:migraine_tracker/core/db/tables/barometer_readings.dart';
import 'package:migraine_tracker/core/db/tables/checkins.dart';
import 'package:migraine_tracker/core/db/tables/environment_days.dart';
import 'package:migraine_tracker/core/db/tables/experiments.dart';
import 'package:migraine_tracker/core/db/tables/factor_weights.dart';
import 'package:migraine_tracker/core/db/tables/health_samples.dart';
import 'package:migraine_tracker/core/db/tables/medication_events.dart';
import 'package:migraine_tracker/core/db/tables/questionnaires.dart';
import 'package:migraine_tracker/core/db/tables/risk_days.dart';
import 'package:migraine_tracker/core/db/tables/settings.dart';
import 'package:migraine_tracker/core/db/tables/share_links.dart';
import 'package:migraine_tracker/core/db/tables/weather_hours.dart';

part 'app_database.g.dart';

/// The on-device database: the 12 tables of the requirements doc data model
/// plus the barometer sample table added in phase 12 and the frozen
/// self-audit levels added in phase 36.
///
/// Dates are stored as ISO-8601 text so exports stay readable and the file is
/// portable. Every write that belongs to one user action runs in a single
/// transaction (reliability NFR: no data loss on crash).
@DriftDatabase(
  tables: [
    Attacks,
    Checkins,
    MedicationEvents,
    WeatherHours,
    EnvironmentDays,
    HealthSamples,
    FactorWeights,
    RiskDays,
    Experiments,
    Questionnaires,
    ShareLinks,
    Settings,
    BarometerReadings,
    AuditDays,
  ],
  daos: [
    AttackDao,
    CheckinDao,
    MedicationDao,
    WeatherDao,
    EnvironmentDao,
    HealthDao,
    RiskDao,
    ExperimentDao,
    QuestionnaireDao,
    ShareLinkDao,
    SettingsDao,
    BarometerDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Bump on every schema change and add a step in [migration].
  static const int currentSchemaVersion = 3;

  @override
  int get schemaVersion => currentSchemaVersion;

  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // Migrations are written as explicit steps so each one can be
      // tested against the schema dump of the version it upgrades from.
      // Version 1 has no predecessor.
      if (from < 2) await m.createTable(barometerReadings);
      if (from < 3) await m.createTable(auditDays);
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Deletes every row of every table in one transaction (FR-23 "delete
  /// everything in one tap"). Settings are cleared too.
  Future<void> deleteEverything() => transaction(() async {
    for (final table in allTables) {
      await delete(table).go();
    }
  });

  /// Row counts per table, used by the export and the delete confirmation.
  Future<Map<String, int>> rowCounts() async {
    final counts = <String, int>{};
    for (final table in allTables) {
      final count = countAll();
      final row = await (selectOnly(table)..addColumns([count])).getSingle();
      counts[table.actualTableName] = row.read(count) ?? 0;
    }
    return counts;
  }
}
