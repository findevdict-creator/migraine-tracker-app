import 'package:migraine_tracker/features/health/domain/health_entities.dart';

/// Local store of imported samples.
abstract interface class HealthRepository {
  /// Inserts samples, ignoring ones already present.
  Future<void> insertAll(List<HealthSampleEntity> samples);
  Future<DateTime?> latestEnd(HealthType type);
  Future<List<HealthSampleEntity>> ofType(
    HealthType type,
    DateTime from,
    DateTime to,
  );
  Future<int> deleteType(HealthType type);
}
