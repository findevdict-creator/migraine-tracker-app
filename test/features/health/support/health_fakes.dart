import 'package:migraine_tracker/features/health/domain/health_entities.dart';
import 'package:migraine_tracker/features/health/domain/health_source.dart';

/// A health store the test fills by hand.
class FakeHealthSource implements HealthSource {
  FakeHealthSource({this.store = HealthStore.healthConnect});

  @override
  HealthStore store;
  bool available = true;
  bool grantRead = true;
  bool grantWrite = true;
  bool grantHistory = true;
  Exception? readError;
  final samples = <HealthSampleEntity>[];
  final readRequests = <Set<HealthType>>[];
  final reads = <(Set<HealthType>, DateTime, DateTime)>[];
  final headaches = <(DateTime, DateTime, int?)>[];
  int historyRequests = 0;
  int writeRequests = 0;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<bool> requestRead(Set<HealthType> types) async {
    readRequests.add(types);
    return grantRead;
  }

  @override
  Future<bool> requestHistory() async {
    historyRequests++;
    return grantHistory;
  }

  @override
  Future<List<HealthSampleEntity>> read(
    Set<HealthType> types,
    DateTime from,
    DateTime to,
  ) async {
    reads.add((types, from, to));
    if (readError != null) throw readError!;
    return [
      for (final s in samples)
        if (types.contains(s.type) &&
            s.end.isAfter(from) &&
            !s.start.isAfter(to))
          s,
    ];
  }

  @override
  Future<bool> requestWriteHeadache() async {
    writeRequests++;
    return grantWrite;
  }

  @override
  Future<bool> writeHeadache({
    required DateTime start,
    required DateTime end,
    required int? intensity,
  }) async {
    headaches.add((start, end, intensity));
    return true;
  }
}

HealthSampleEntity sample(
  HealthType type,
  DateTime start,
  Duration length,
  double value, {
  HealthStore store = HealthStore.healthConnect,
}) => HealthSampleEntity(
  id: '${type.code}-${start.toIso8601String()}',
  type: type,
  start: start,
  end: start.add(length),
  value: value,
  store: store,
  importedAt: start,
);
