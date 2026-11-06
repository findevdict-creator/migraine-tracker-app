import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';

import '../../support/test_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = newTestDatabase());
  tearDown(() => db.close());

  group('AppDatabase', () {
    test(
      'creates the 12 tables of the data model plus barometer samples',
      () async {
        final counts = await db.rowCounts();
        expect(counts.keys, hasLength(13));
        expect(
          counts.keys,
          containsAll([
            'attacks',
            'barometer_readings',
            'checkins',
            'medication_events',
            'weather_hours',
            'environment_days',
            'health_samples',
            'factor_weights',
            'risk_days',
            'experiments',
            'questionnaires',
            'share_links',
            'settings',
          ]),
        );
        expect(counts.values.every((c) => c == 0), isTrue);
      },
    );

    test('stores dates as ISO-8601 text', () async {
      final now = DateTime.utc(2026, 11, 6, 8, 30);
      await db.attackDao.upsert(
        AttacksCompanion.insert(
          id: 'a1',
          startedAt: now,
          createdAt: now,
          updatedAt: now,
        ),
      );
      final raw = await db
          .customSelect(
            'SELECT started_at FROM attacks WHERE id = ?',
            variables: [Variable.withString('a1')],
          )
          .getSingle();
      expect(raw.read<String>('started_at'), '2026-11-06T08:30:00.000Z');
    });

    test('enforces foreign keys', () async {
      final now = DateTime.utc(2026, 11, 6);
      expect(
        () => db.medicationDao.upsert(
          MedicationEventsCompanion.insert(
            id: 'm1',
            attackId: const Value('missing'),
            name: 'ibuprofen',
            takenAt: now,
            kind: 'acute',
            createdAt: now,
          ),
        ),
        throwsA(anything),
      );
    });

    test('deleteEverything empties every table in one transaction', () async {
      final now = DateTime.utc(2026, 11, 6);
      await db.attackDao.upsert(
        AttacksCompanion.insert(
          id: 'a1',
          startedAt: now,
          createdAt: now,
          updatedAt: now,
        ),
      );
      await db.settingsDao.write('units', 'hPa');
      await db.deleteEverything();
      final counts = await db.rowCounts();
      expect(counts.values.every((c) => c == 0), isTrue);
    });
  });
}
