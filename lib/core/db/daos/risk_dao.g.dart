// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'risk_dao.dart';

// ignore_for_file: type=lint
mixin _$RiskDaoMixin on DatabaseAccessor<AppDatabase> {
  $FactorWeightsTable get factorWeights => attachedDatabase.factorWeights;
  $RiskDaysTable get riskDays => attachedDatabase.riskDays;
  $AuditDaysTable get auditDays => attachedDatabase.auditDays;
  RiskDaoManager get managers => RiskDaoManager(this);
}

class RiskDaoManager {
  final _$RiskDaoMixin _db;
  RiskDaoManager(this._db);
  $$FactorWeightsTableTableManager get factorWeights =>
      $$FactorWeightsTableTableManager(_db.attachedDatabase, _db.factorWeights);
  $$RiskDaysTableTableManager get riskDays =>
      $$RiskDaysTableTableManager(_db.attachedDatabase, _db.riskDays);
  $$AuditDaysTableTableManager get auditDays =>
      $$AuditDaysTableTableManager(_db.attachedDatabase, _db.auditDays);
}
