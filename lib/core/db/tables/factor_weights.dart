import 'package:drift/drift.dart';

/// The learned model: one row per factor, recomputed after each attack.
class FactorWeights extends Table {
  TextColumn get factor => text()();
  RealColumn get populationWeight => real()();
  RealColumn get personalWeight => real()();
  RealColumn get confidence => real()();
  IntColumn get nExposures => integer().withDefault(const Constant(0))();
  IntColumn get nAttacksAfter => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {factor};
}
