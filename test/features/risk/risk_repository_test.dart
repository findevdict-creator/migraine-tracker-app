import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart'
    hide FactorWeight, RiskDay;
import 'package:migraine_tracker/features/risk/data/risk_repository_impl.dart';
import 'package:risk_model/risk_model.dart';

import '../../support/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftRiskRepository repo;
  final now = DateTime(2026, 11, 6, 9, 30);

  setUp(() {
    db = newTestDatabase();
    repo = DriftRiskRepository(db);
  });

  tearDown(() => db.close());

  test('weights round trip and null before the first save', () async {
    expect(await repo.weights(), isNull);
    final table = WeightTable.population().copyWith(
      Factor.alcohol,
      const FactorWeight(
        population: 0.35,
        personal: 0.8,
        confidence: 0.4,
        nExposures: 7,
        nAttacksAfter: 3,
      ),
    );
    await repo.saveWeights(table, now: now);
    final back = await repo.weights();
    expect(back![Factor.alcohol].personal, 0.8);
    expect(back[Factor.alcohol].nExposures, 7);
    expect(back[Factor.stress].effective, 0.45);
    expect((await repo.watchWeights().first)![Factor.alcohol].confidence, 0.4);
  });

  test('risk days round trip with contributions', () async {
    final risk = const DailyLoad().compute(
      const DayInputs(date: '2026-11-06', stress: 5, alcohol: 3),
    );
    await repo.saveRisk([risk], now: now);
    final back = await repo.riskFor('2026-11-06');
    expect(back!.score, risk.load);
    expect(back.level, risk.level);
    expect(back.contributions.length, 2);
    expect(back.drivers().first.factor, Factor.stress);
    expect(back.modelVersion, modelVersion);
    expect((await repo.riskRange('2026-11-01', '2026-11-30')).length, 1);
    expect(
      (await repo.watchRiskRange('2026-11-06', '2026-11-06').first).length,
      1,
    );
    expect(await repo.riskFor('2026-11-07'), isNull);
  });

  test('unknown factor ids in stored drivers are skipped', () async {
    await db.riskDao.upsertRisk([
      RiskDaysCompanion.insert(
        date: '2026-11-06',
        level: 'high',
        score: 70,
        drivers: const Value([
          {'factor': 'moon_phase', 'points': 70},
        ]),
        modelVersion: '0.0.1',
        computedAt: now,
      ),
    ]);
    final back = await repo.riskFor('2026-11-06');
    expect(back!.contributions, isEmpty);
    expect(back.level, RiskLevel.high);
  });
}
