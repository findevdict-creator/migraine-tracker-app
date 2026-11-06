import 'package:migraine_tracker/features/barometer/domain/barometer_entities.dart';

/// Local store of barometer samples.
abstract interface class BarometerRepository {
  Future<void> add(PressureReading reading);
  Future<PressureReading?> latest();
  Future<List<PressureReading>> series(DateTime from, DateTime to);
  Stream<List<PressureReading>> watchSeries(DateTime from, DateTime to);
  Future<int> prune(DateTime before);
}
