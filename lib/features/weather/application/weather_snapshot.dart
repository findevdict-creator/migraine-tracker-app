import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/weather/data/weather_repository_impl.dart';
import 'package:migraine_tracker/features/weather/domain/pressure_deltas.dart';

final weatherSnapshotProvider = Provider<WeatherSnapshot>(WeatherSnapshot.new);

/// Builds the weather map attached to attacks and check-ins at save time:
/// the hour's values plus the pressure deltas, or null when nothing is
/// cached for the current cell. The hour is pinned so pruning keeps it.
class WeatherSnapshot {
  WeatherSnapshot(this._ref);

  final Ref _ref;

  Future<Map<String, Object?>?> at(DateTime when, {bool pin = false}) async {
    final cellKey = await _ref
        .read(settingsRepositoryProvider)
        .read<String>(SettingsKeys.weatherLastCell);
    if (cellKey == null) return null;
    final repo = _ref.read(weatherRepositoryProvider);
    final hourUtc = when.utcHour;
    final hour = await repo.hourAt(cellKey, hourUtc);
    if (hour == null) return null;
    final series = await repo.hours(
      cellKey,
      hourUtc.subtract(const Duration(hours: 24)),
      hourUtc.add(const Duration(hours: 1)),
    );
    if (pin) await repo.pin(cellKey, hourUtc);
    return {
      ...hour.toSnapshot(),
      ...PressureDeltas.from(series, when).toJson(),
      'fetchedAt': hour.fetchedAt.toIso8601String(),
    };
  }

  /// Convenience for "now".
  Future<Map<String, Object?>?> now({bool pin = false}) =>
      at(_ref.read(clockProvider)(), pin: pin);
}
