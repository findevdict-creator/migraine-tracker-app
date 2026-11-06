import 'package:drift/drift.dart';

/// On-device barometer samples (phase 12). One row per sample, kept for
/// the trend window only; the stamp at attack start lives on the attack.
class BarometerReadings extends Table {
  DateTimeColumn get at => dateTime()();

  /// Raw sensor value in hPa, before calibration.
  RealColumn get hpa => real()();

  @override
  Set<Column<Object>> get primaryKey => {at};
}
