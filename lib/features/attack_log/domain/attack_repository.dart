import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';

/// Persistence boundary for attacks. Every write is one transaction so a
/// crash mid-attack loses nothing (reliability NFR).
abstract interface class AttackRepository {
  Stream<AttackEntity?> watchRunning();
  Future<AttackEntity?> running();
  Future<AttackEntity?> byId(String id);
  Stream<List<AttackEntity>> watchAll();
  Future<List<AttackEntity>> all();
  Future<List<AttackEntity>> inRange(DateTime from, DateTime to);
  Future<List<AttackEntity>> completed();
  Future<int> count();

  /// Inserts or replaces the whole attack.
  Future<void> save(AttackEntity attack);

  Future<void> delete(String id);
}

/// Where the pressure stamp for a new attack comes from. The barometer
/// phase provides the real one; until then nothing is stamped.
abstract interface class PressureStampSource {
  Future<PressureStamp> read();
}

class PressureStamp {
  const PressureStamp({this.sensorHpa, this.stationHpa});

  const PressureStamp.none() : sensorHpa = null, stationHpa = null;

  final double? sensorHpa;
  final double? stationHpa;
}

class NoPressureStamp implements PressureStampSource {
  const NoPressureStamp();

  @override
  Future<PressureStamp> read() async => const PressureStamp.none();
}
