import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_repository_impl.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:migraine_tracker/features/export/data/export_service.dart';
import 'package:migraine_tracker/features/export/domain/data_export.dart';
import 'package:migraine_tracker/features/medication/data/medication_repository_impl.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';

import '../../support/test_database.dart';

void main() {
  late AppDatabase db;
  late ExportService service;
  final t0 = DateTime.utc(2026, 11, 6, 9);

  Future<void> seed() async {
    await DriftAttackRepository(db, clock: () => t0).save(
      AttackEntity(
        id: 'a1',
        startedAt: t0,
        intensity: 6,
        headLocations: const {HeadLocation.forehead},
        phases: {AttackPhase.attack: t0},
        symptoms: [SymptomTap(symptom: Symptom.nausea, at: t0)],
        notes: 'quote " and, comma\nnewline',
      ),
    );
    await DriftCheckinRepository(db, clock: () => t0).save(
      const CheckinEntity(date: '2026-11-06')
          .withValue(CheckinField.stress, 3, CheckinSource.typed),
    );
    await DriftMedicationRepository(db, clock: () => t0).save(
      MedicationEntity(
        id: 'm1',
        attackId: 'a1',
        name: 'Ibuprofen',
        takenAt: t0,
        kind: MedicationKind.acute,
      ),
    );
    await db.settingsDao.write('cycle.enabled', true);
  }

  setUp(() async {
    db = newTestDatabase();
    service = ExportService(db, clock: () => t0);
    await seed();
  });

  tearDown(() => db.close());

  test('export covers every table with raw column values', () async {
    final data = await service.export();
    expect(data.tables.keys.toSet(), {
      for (final t in db.allTables) t.actualTableName,
    });
    expect(data.rowCount, 4);
    final attack = data.tables['attacks']!.single;
    expect(attack['id'], 'a1');
    expect(attack['started_at'], isA<String>());
    expect(attack['head_locations'], '["forehead"]');
    expect(data.schemaVersion, AppDatabase.currentSchemaVersion);
  });

  test('JSON export re-imports to an identical database', () async {
    final before = await service.export();
    final json = service.toJsonString(before);

    await service.deleteEverything();
    expect((await db.rowCounts()).values.every((n) => n == 0), isTrue);

    await service.import(service.fromJsonString(json));
    final after = await service.export();
    expect(after.tables, before.tables);
    expect(
      (await DriftAttackRepository(db, clock: () => t0).byId('a1'))!.notes,
      'quote " and, comma\nnewline',
    );
    expect(
      (await DriftMedicationRepository(db, clock: () => t0).byId('m1'))!
          .attackId,
      'a1',
    );
    expect(await db.settingsDao.read<bool>('cycle.enabled'), isTrue);
  });

  test('import skips unknown tables and columns', () async {
    final data = await service.export();
    final patched = DataExport(
      schemaVersion: data.schemaVersion,
      exportedAt: data.exportedAt,
      tables: {
        ...data.tables,
        'future_table': const [
          {'x': 1},
        ],
        'attacks': [
          {...data.tables['attacks']!.single, 'future_column': 'ignored'},
        ],
      },
    );
    await service.import(patched);
    expect((await db.rowCounts())['attacks'], 1);
  });

  test('foreign JSON is refused', () {
    expect(
      () => service.fromJsonString('{"format":"other","tables":{}}'),
      throwsFormatException,
    );
  });

  test('CSV export writes one file per non-empty table, re-parsable', () async {
    final data = await service.export();
    final files = service.toCsvFiles(data);
    expect(files.keys, containsAll(['attacks.csv', 'checkins.csv']));
    expect(files.containsKey('weather_hours.csv'), isFalse);

    final rows = Csv.decode(files['attacks.csv']!);
    final header = rows.first.cast<String>();
    final record = Map.fromIterables(header, rows[1]);
    expect(record['id'], 'a1');
    expect(record['notes'], 'quote " and, comma\nnewline');
    expect(record['ended_at'], isNull);
    expect(record['intensity'], '6');
  });

  test('files are written with the product name and a timestamp', () async {
    final dir = await Directory.systemTemp.createTemp('export');
    addTearDown(() => dir.delete(recursive: true));
    final json = await service.writeJsonFile(directory: dir);
    expect(json.path, endsWith('aurawell-export-20261106-0900.json'));
    final csv = await service.writeCsvFiles(directory: dir);
    expect(
      csv.map((f) => f.uri.pathSegments.last),
      contains('aurawell-export-20261106-0900-attacks.csv'),
    );
    expect(await json.readAsString(), contains('"format": "aurawell-export"'));
  });
}
