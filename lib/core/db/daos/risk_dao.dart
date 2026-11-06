import 'package:drift/drift.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/tables/audit_days.dart';
import 'package:migraine_tracker/core/db/tables/factor_weights.dart';
import 'package:migraine_tracker/core/db/tables/risk_days.dart';

part 'risk_dao.g.dart';

/// Reads and writes the learned factor weights, the daily risk output and
/// the frozen levels the self-audit scores.
@DriftAccessor(tables: [FactorWeights, RiskDays, AuditDays])
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

  /// Days ahead take the newest forecast; today keeps its first score, so
  /// nothing learned during the day changes what was shown.
  Future<void> recordShown({
    required List<AuditDaysCompanion> ahead,
    AuditDaysCompanion? today,
  }) => batch((b) {
    b.insertAllOnConflictUpdate(auditDays, ahead);
    if (today != null) {
      b.insert(auditDays, today, mode: InsertMode.insertOrIgnore);
    }
  });

  Future<List<AuditDay>> allShown() =>
      (select(auditDays)..orderBy([(r) => OrderingTerm.asc(r.date)])).get();

  Stream<List<AuditDay>> watchShown() =>
      (select(auditDays)..orderBy([(r) => OrderingTerm.asc(r.date)])).watch();
}
