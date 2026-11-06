import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

/// Source of "now". Overridden in tests for deterministic timestamps.
final clockProvider = Provider<DateTime Function()>((_) => DateTime.now);

/// Source of new ids. Overridden in tests for stable ids.
final idGeneratorProvider = Provider<String Function()>((_) {
  const uuid = Uuid();
  return uuid.v4;
});

/// Date helpers shared by features. All "day" keys are local calendar dates
/// formatted as `yyyy-MM-dd`.
extension DateKeyX on DateTime {
  String get dateKey {
    final local = toLocal();
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '${local.year}-$m-$d';
  }

  /// Midnight (local) of this date.
  DateTime get startOfDay {
    final local = toLocal();
    return DateTime(local.year, local.month, local.day);
  }

  /// Truncates to the hour in UTC, for matching weather hours.
  DateTime get utcHour {
    final u = toUtc();
    return DateTime.utc(u.year, u.month, u.day, u.hour);
  }
}

/// Parses a `yyyy-MM-dd` key back to local midnight.
DateTime parseDateKey(String key) => DateTime.parse(key);
