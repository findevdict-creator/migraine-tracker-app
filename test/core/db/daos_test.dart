import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';

import '../../support/test_database.dart';

void main() {
  late AppDatabase db;
  final t0 = DateTime.utc(2026, 11, 6, 8);

  setUp(() => db = newTestDatabase());
  tearDown(() => db.close());

  AttacksCompanion attack(String id, DateTime start, {DateTime? end}) =>
      AttacksCompanion.insert(
        id: id,
        startedAt: start,
        endedAt: Value(end),
        createdAt: start,
        updatedAt: start,
      );

  group('AttackDao', () {
    test('round-trips JSON columns with per-tap timestamps', () async {
      await db.attackDao.upsert(
        attack('a1', t0).copyWith(
          intensity: const Value(7),
          headLocations: const Value(['left_temple', 'behind_eyes']),
          phases: Value({'aura': t0.toIso8601String()}),
          symptoms: Value([
            {'code': 'aura', 'at': t0.toIso8601String()},
            {
              'code': 'nausea',
              'at': t0.add(const Duration(minutes: 3)).toIso8601String(),
            },
          ]),
        ),
      );
      final row = await db.attackDao.byId('a1');
      expect(row!.intensity, 7);
      expect(row.headLocations, ['left_temple', 'behind_eyes']);
      expect(row.phases['aura'], t0.toIso8601String());
      expect(row.symptoms, hasLength(2));
      expect(row.symptoms.last['code'], 'nausea');
    });

    test('running returns the open attack and null once ended', () async {
      await db.attackDao.upsert(attack('a1', t0));
      expect((await db.attackDao.running())!.id, 'a1');
      await db.attackDao.upsert(
        attack('a1', t0, end: t0.add(const Duration(hours: 4))),
      );
      expect(await db.attackDao.running(), isNull);
      expect(await db.attackDao.completed(), hasLength(1));
    });

    test('inRange is half-open and newest first', () async {
      await db.attackDao.upsert(attack('a1', t0));
      await db.attackDao.upsert(attack('a2', t0.add(const Duration(days: 1))));
      await db.attackDao.upsert(attack('a3', t0.add(const Duration(days: 2))));
      final rows = await db.attackDao.inRange(
        t0,
        t0.add(const Duration(days: 2)),
      );
      expect(rows.map((a) => a.id), ['a2', 'a1']);
      expect(await db.attackDao.count(), 3);
    });
  });

  group('CheckinDao', () {
    test('upserts by date and keeps field sources', () async {
      await db.checkinDao.upsert(
        CheckinsCompanion.insert(
          date: '2026-11-06',
          sleepQuality: const Value(3),
          sources: const Value({'sleepQuality': 'healthkit'}),
          createdAt: t0,
          updatedAt: t0,
        ),
      );
      await db.checkinDao.upsert(
        CheckinsCompanion.insert(
          date: '2026-11-06',
          sleepQuality: const Value(4),
          stress: const Value(2),
          sources: const Value({'sleepQuality': 'typed'}),
          createdAt: t0,
          updatedAt: t0,
        ),
      );
      final row = await db.checkinDao.byDate('2026-11-06');
      expect(row!.sleepQuality, 4);
      expect(row.stress, 2);
      expect(row.sources['sleepQuality'], 'typed');
      expect(await db.checkinDao.all(), hasLength(1));
    });

    test('inRange is inclusive on both ends', () async {
      for (final d in ['2026-11-01', '2026-11-02', '2026-11-03']) {
        await db.checkinDao.upsert(
          CheckinsCompanion.insert(date: d, createdAt: t0, updatedAt: t0),
        );
      }
      final rows = await db.checkinDao.inRange('2026-11-02', '2026-11-03');
      expect(rows.map((c) => c.date), ['2026-11-02', '2026-11-03']);
    });
  });

  group('MedicationDao', () {
    test('links to attacks and unlinks when the attack is deleted', () async {
      await db.attackDao.upsert(attack('a1', t0));
      await db.medicationDao.upsert(
        MedicationEventsCompanion.insert(
          id: 'm1',
          attackId: const Value('a1'),
          name: 'Sumatriptan',
          takenAt: t0,
          kind: 'acute',
          createdAt: t0,
        ),
      );
      expect(await db.medicationDao.forAttack('a1'), hasLength(1));
      await db.attackDao.deleteById('a1');
      final row = await db.medicationDao.byId('m1');
      expect(row, isNotNull);
      expect(row!.attackId, isNull);
    });

    test('recentNames lists distinct names, most recent first', () async {
      for (final (i, name) in ['A', 'B', 'A', 'C'].indexed) {
        await db.medicationDao.upsert(
          MedicationEventsCompanion.insert(
            id: 'm$i',
            name: name,
            takenAt: t0.add(Duration(hours: i)),
            kind: 'acute',
            createdAt: t0,
          ),
        );
      }
      expect(await db.medicationDao.recentNames(), ['C', 'A', 'B']);
    });
  });

  group('WeatherDao', () {
    WeatherHoursCompanion hour(DateTime h, {double? p}) =>
        WeatherHoursCompanion.insert(
          cell: '51.5,-0.1',
          hourUtc: h,
          pressureMsl: Value(p),
          fetchedAt: t0,
        );

    test('upserts a series and reports the last fetch', () async {
      await db.weatherDao.upsertAll([
        hour(t0, p: 1010),
        hour(t0.add(const Duration(hours: 1)), p: 1008),
      ]);
      await db.weatherDao.upsertAll([hour(t0, p: 1011)]);
      final series = await db.weatherDao.series(
        '51.5,-0.1',
        t0,
        t0.add(const Duration(hours: 2)),
      );
      expect(series.map((w) => w.pressureMsl), [1011, 1008]);
      expect(await db.weatherDao.lastFetchedAt('51.5,-0.1'), t0);
      expect(await db.weatherDao.lastFetchedAt('other'), isNull);
    });

    test('prune keeps pinned hours', () async {
      await db.weatherDao.upsertAll([
        hour(t0.subtract(const Duration(days: 20))),
        hour(t0.subtract(const Duration(days: 19))),
        hour(t0),
      ]);
      await db.weatherDao.pin(
        '51.5,-0.1',
        t0.subtract(const Duration(days: 20)),
      );
      final removed = await db.weatherDao.prune(
        t0.subtract(const Duration(days: 14)),
      );
      expect(removed, 1);
      expect(await db.weatherDao.all(), hasLength(2));
    });
  });

  group('HealthDao', () {
    test('ignores duplicate samples', () async {
      final sample = HealthSamplesCompanion.insert(
        id: 'h1',
        type: 'sleep',
        start: t0.subtract(const Duration(hours: 8)),
        end: t0,
        value: 8,
        unit: 'h',
        sourceStore: 'healthkit',
        importedAt: t0,
      );
      await db.healthDao.insertAllIgnoringDuplicates([sample]);
      await db.healthDao.insertAllIgnoringDuplicates([
        sample.copyWith(id: const Value('h2')),
      ]);
      expect(await db.healthDao.all(), hasLength(1));
      expect(await db.healthDao.latestEnd('sleep'), t0);
      expect(await db.healthDao.latestEnd('hrv'), isNull);
    });
  });

  group('RiskDao', () {
    test('stores weights and daily risk with drivers', () async {
      await db.riskDao.upsertWeights([
        FactorWeightsCompanion.insert(
          factor: 'pressure_drop',
          populationWeight: 0.8,
          personalWeight: 0.8,
          confidence: 0.2,
          updatedAt: t0,
        ),
      ]);
      await db.riskDao.upsertRisk([
        RiskDaysCompanion.insert(
          date: '2026-11-06',
          level: 'high',
          score: 71,
          drivers: const Value([
            {'factor': 'pressure_drop', 'contribution': 62},
          ]),
          modelVersion: '1',
          computedAt: t0,
        ),
      ]);
      final risk = await db.riskDao.riskFor('2026-11-06');
      expect(risk!.level, 'high');
      expect(risk.drivers.first['factor'], 'pressure_drop');
      expect((await db.riskDao.weights()).single.factor, 'pressure_drop');
    });
  });

  group('ExperimentDao', () {
    test('allows one active experiment at a time', () async {
      await db.experimentDao.start(
        ExperimentsCompanion.insert(
          id: 'e1',
          change: 'cut_caffeine',
          start: t0,
        ),
      );
      expect(
        () => db.experimentDao.start(
          ExperimentsCompanion.insert(
            id: 'e2',
            change: 'fixed_bedtime',
            start: t0,
          ),
        ),
        throwsStateError,
      );
      expect((await db.experimentDao.active())!.id, 'e1');
    });
  });

  group('QuestionnaireDao', () {
    test('returns the latest of a type', () async {
      for (final (i, score) in [12, 18].indexed) {
        await db.questionnaireDao.upsert(
          QuestionnairesCompanion.insert(
            id: 'q$i',
            type: 'midas',
            date: t0.add(Duration(days: 90 * i)),
            answers: const {'q1': 1},
            score: score,
          ),
        );
      }
      expect((await db.questionnaireDao.latest('midas'))!.score, 18);
      expect(await db.questionnaireDao.latest('hit6'), isNull);
    });
  });

  group('ShareLinkDao', () {
    test('revokes by token', () async {
      await db.shareLinkDao.upsert(
        ShareLinksCompanion.insert(
          token: 'tok',
          createdAt: t0,
          expiresAt: t0.add(const Duration(days: 7)),
        ),
      );
      await db.shareLinkDao.revoke('tok');
      expect((await db.shareLinkDao.all()).single.revoked, isTrue);
    });
  });

  group('SettingsDao', () {
    test('round-trips JSON values', () async {
      await db.settingsDao.write('units', {'pressure': 'hPa', 'temp': 'C'});
      await db.settingsDao.write('reminderHour', 20);
      await db.settingsDao.write('consent.sleep', true);
      expect(await db.settingsDao.read<Map<String, dynamic>>('units'), {
        'pressure': 'hPa',
        'temp': 'C',
      });
      expect(await db.settingsDao.read<int>('reminderHour'), 20);
      expect(await db.settingsDao.read<bool>('consent.sleep'), isTrue);
      expect(await db.settingsDao.read<String>('missing'), isNull);
      await db.settingsDao.remove('reminderHour');
      expect((await db.settingsDao.all()).keys, hasLength(2));
    });
  });
}
