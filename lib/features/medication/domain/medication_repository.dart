import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';

/// Persistence boundary for medication events.
abstract interface class MedicationRepository {
  Future<MedicationEntity?> byId(String id);
  Future<List<MedicationEntity>> forAttack(String attackId);
  Stream<List<MedicationEntity>> watchForAttack(String attackId);

  /// Events with `from <= takenAt < to`, oldest first.
  Future<List<MedicationEntity>> inRange(DateTime from, DateTime to);
  Stream<List<MedicationEntity>> watchRange(DateTime from, DateTime to);
  Future<List<MedicationEntity>> all();
  Stream<List<MedicationEntity>> watchAll();

  /// Distinct names, most recently used first.
  Future<List<String>> recentNames({int limit});
  Future<void> save(MedicationEntity event);
  Future<void> delete(String id);
}
