import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/core/db/app_database.dart' as db;
import 'package:migraine_tracker/core/db/daos/risk_dao.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/features/risk/domain/risk_entities.dart';
import 'package:migraine_tracker/features/risk/domain/risk_repository.dart';
import 'package:risk_model/risk_model.dart';

final riskRepositoryProvider = Provider<RiskRepository>(
  (ref) => DriftRiskRepository(ref.watch(appDatabaseProvider)),
);

/// Drift-backed [RiskRepository]. The database row classes share names
/// with the model's, hence the prefix.
class DriftRiskRepository implements RiskRepository {
  DriftRiskRepository(this._db);

  final db.AppDatabase _db;

  RiskDao get _dao => _db.riskDao;

  @override
  Future<WeightTable?> weights() async => _table(await _dao.weights());

  @override
  Stream<WeightTable?> watchWeights() => _dao.watchWeights().map(_table);

  WeightTable? _table(List<db.FactorWeight> rows) {
    if (rows.isEmpty) return null;
    return WeightTable({
      for (final r in rows)
        if (Factor.fromId(r.factor) != null)
          Factor.fromId(r.factor)!: FactorWeight(
            population: r.populationWeight,
            personal: r.personalWeight,
            confidence: r.confidence,
            nExposures: r.nExposures,
            nAttacksAfter: r.nAttacksAfter,
          ),
    });
  }

  @override
  Future<void> saveWeights(WeightTable table, {required DateTime now}) =>
      _dao.upsertWeights([
        for (final f in Factor.values)
          db.FactorWeightsCompanion(
            factor: Value(f.id),
            populationWeight: Value(table[f].population),
            personalWeight: Value(table[f].personal),
            confidence: Value(table[f].confidence),
            nExposures: Value(table[f].nExposures),
            nAttacksAfter: Value(table[f].nAttacksAfter),
            updatedAt: Value(now),
          ),
      ]);

  @override
  Future<RiskDayEntity?> riskFor(String date) async {
    final row = await _dao.riskFor(date);
    return row == null ? null : _entity(row);
  }

  @override
  Future<List<RiskDayEntity>> riskRange(String from, String to) async =>
      (await _dao.riskRange(from, to)).map(_entity).toList();

  @override
  Stream<List<RiskDayEntity>> watchRiskRange(String from, String to) =>
      _dao.watchRiskRange(from, to).map((rows) => rows.map(_entity).toList());

  @override
  Future<void> saveRisk(List<DayRisk> days, {required DateTime now}) =>
      _dao.upsertRisk([
        for (final d in days)
          db.RiskDaysCompanion(
            date: Value(d.date),
            level: Value(d.level.id),
            score: Value(d.load),
            drivers: Value([for (final c in d.contributions) c.toJson()]),
            modelVersion: Value(d.version),
            computedAt: Value(now),
          ),
      ]);

  @override
  Future<List<RiskDayEntity>> allRisk() async =>
      (await _dao.allRisk()).map(_entity).toList();

  RiskDayEntity _entity(db.RiskDay row) => RiskDayEntity(
    date: row.date,
    level: RiskLevel.fromId(row.level),
    score: row.score,
    contributions: [
      for (final c in row.drivers.map((m) => m.cast<String, Object?>()))
        if (Factor.fromId(c['factor'] as String? ?? '') != null)
          Contribution.fromJson(c),
    ],
    modelVersion: row.modelVersion,
    computedAt: row.computedAt,
  );
}
