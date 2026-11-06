import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/tables/factor_weights.dart';
import 'package:migraine_tracker/core/db/tables/risk_days.dart';

part 'risk_dao.g.dart';

/// Reads and writes the learned factor weights and the daily risk output.
@DriftAccessor(tables: [FactorWeights, RiskDays])
class RiskDao extends DatabaseAccessor<AppDatabase> with _$RiskDaoMixin {
  RiskDao(super.attachedDatabase);

  Future<List<FactorWeight>> weights() => select(factorWeights).get();

  Stream<List<FactorWeight>> watchWeights() => select(factorWeights).watch();

  Future<void> upsertWeights(List<FactorWeightsCompanion> rows) => batch((b) {
    b.insertAllOnConflictUpdate(factorWeights, rows);
  });

  Future<RiskDay?> riskFor(String date) =>
      (select(riskDays)..where((r) => r.date.equals(date))).getSingleOrNull();

  Future<List<RiskDay>> riskRange(String from, String to) =>
      (select(riskDays)
            ..where((r) => r.date.isBetweenValues(from, to))
            ..orderBy([(r) => OrderingTerm.asc(r.date)]))
          .get();

  Stream<List<RiskDay>> watchRiskRange(String from, String to) =>
      (select(riskDays)
            ..where((r) => r.date.isBetweenValues(from, to))
            ..orderBy([(r) => OrderingTerm.asc(r.date)]))
          .watch();

  Future<void> upsertRisk(List<RiskDaysCompanion> rows) => batch((b) {
    b.insertAllOnConflictUpdate(riskDays, rows);
  });

  Future<List<RiskDay>> allRisk() =>
      (select(riskDays)..orderBy([(r) => OrderingTerm.asc(r.date)])).get();
}
