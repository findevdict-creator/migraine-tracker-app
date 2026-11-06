import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';

/// Persistence boundary for daily check-ins.
abstract interface class CheckinRepository {
  Future<CheckinEntity?> byDate(String date);
  Stream<CheckinEntity?> watchByDate(String date);

  /// Inclusive range of date keys, oldest first.
  Future<List<CheckinEntity>> inRange(String from, String to);
  Stream<List<CheckinEntity>> watchRange(String from, String to);
  Future<List<CheckinEntity>> all();
  Future<void> save(CheckinEntity checkin);
  Future<void> delete(String date);
}
