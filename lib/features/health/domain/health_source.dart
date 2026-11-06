import 'package:migraine_tracker/features/health/domain/health_entities.dart';

/// HealthKit or Health Connect behind one interface. Every call that can
/// prompt the person is explicit so screens control when prompts appear.
abstract interface class HealthSource {
  HealthStore get store;

  /// False on devices without a health store (Health Connect not installed).
  Future<bool> isAvailable();

  /// Asks for read access to [types]. Returns whether it was granted.
  Future<bool> requestRead(Set<HealthType> types);

  /// Health Connect only: permission to read more than 30 days back.
  Future<bool> requestHistory();

  Future<List<HealthSampleEntity>> read(
    Set<HealthType> types,
    DateTime from,
    DateTime to,
  );

  Future<bool> requestWriteHeadache();

  /// Writes one headache event. Returns false when not permitted.
  Future<bool> writeHeadache({
    required DateTime start,
    required DateTime end,
    required int? intensity,
  });
}

/// For platforms and tests without a health store.
class NoHealthSource implements HealthSource {
  const NoHealthSource();

  @override
  HealthStore get store => HealthStore.healthkit;

  @override
  Future<bool> isAvailable() async => false;

  @override
  Future<bool> requestRead(Set<HealthType> types) async => false;

  @override
  Future<bool> requestHistory() async => false;

  @override
  Future<List<HealthSampleEntity>> read(
    Set<HealthType> types,
    DateTime from,
    DateTime to,
  ) async => const [];

  @override
  Future<bool> requestWriteHeadache() async => false;

  @override
  Future<bool> writeHeadache({
    required DateTime start,
    required DateTime end,
    required int? intensity,
  }) async => false;
}
