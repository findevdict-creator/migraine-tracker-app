import 'package:migraine_tracker/features/risk/domain/risk_entities.dart';
import 'package:risk_model/risk_model.dart';

/// Local store of learned weights and daily risk output.
abstract interface class RiskRepository {
  /// Null until the first learning run.
  Future<WeightTable?> weights();
  Stream<WeightTable?> watchWeights();
  Future<void> saveWeights(WeightTable table, {required DateTime now});

  Future<RiskDayEntity?> riskFor(String date);
  Future<List<RiskDayEntity>> riskRange(String from, String to);
  Stream<List<RiskDayEntity>> watchRiskRange(String from, String to);
  Future<void> saveRisk(List<DayRisk> days, {required DateTime now});
  Future<List<RiskDayEntity>> allRisk();
}
