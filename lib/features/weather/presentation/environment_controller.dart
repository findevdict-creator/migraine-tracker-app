import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/weather/application/weather_sync.dart';
import 'package:migraine_tracker/features/weather/data/weather_repository_impl.dart';
import 'package:migraine_tracker/features/weather/domain/pressure_deltas.dart';
import 'package:migraine_tracker/features/weather/domain/weather_entities.dart';

/// Hours shown on the pressure chart: 48 h back and 24 h ahead.
const int environmentHoursBack = 48;
const int environmentHoursAhead = 24;

/// What the environment screen and the home card show.
@immutable
class EnvironmentView {
  const EnvironmentView({
    required this.hours,
    required this.deltas,
    required this.now,
    this.fetchedAt,
  });

  final List<WeatherHourEntity> hours;
  final PressureDeltas deltas;
  final DateTime now;

  /// When the newest hour was fetched; null when nothing is cached.
  final DateTime? fetchedAt;

  bool get hasData => hours.any((h) => h.pressureMsl != null);

  Duration? get age => fetchedAt == null ? null : now.difference(fetchedAt!);

  bool get isStale => (age ?? Duration.zero) > AppThresholds.weatherStaleAfter;

  /// Hours up to and including now, oldest first.
  List<WeatherHourEntity> get past =>
      hours.where((h) => !h.hourUtc.isAfter(now.utcHour)).toList();
}

/// Live view of the cached weather for the current cell. Re-evaluates when
/// the location changes or new hours are written.
final environmentViewProvider = StreamProvider<EnvironmentView>((ref) async* {
  final location = await ref.watch(weatherLocationProvider.future);
  final now = ref.watch(clockProvider)();
  final cell = location.cell;
  if (cell == null) {
    yield EnvironmentView(
      hours: const [],
      deltas: const PressureDeltas(),
      now: now,
    );
    return;
  }
  final repo = ref.watch(weatherRepositoryProvider);
  final from = now.utcHour.subtract(
    const Duration(hours: environmentHoursBack),
  );
  final to = now.utcHour.add(const Duration(hours: environmentHoursAhead + 1));
  yield* repo.watchHours(cell.key, from, to).map((hours) {
    DateTime? fetchedAt;
    for (final h in hours) {
      if (fetchedAt == null || h.fetchedAt.isAfter(fetchedAt)) {
        fetchedAt = h.fetchedAt;
      }
    }
    return EnvironmentView(
      hours: hours,
      deltas: PressureDeltas.from(hours, now),
      now: now,
      fetchedAt: fetchedAt,
    );
  });
});
