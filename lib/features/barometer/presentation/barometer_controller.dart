import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/barometer/application/barometer_sampler.dart';
import 'package:migraine_tracker/features/barometer/data/barometer_repository_impl.dart';
import 'package:migraine_tracker/features/barometer/domain/barometer_entities.dart';
import 'package:migraine_tracker/features/weather/data/weather_repository_impl.dart';
import 'package:migraine_tracker/features/weather/domain/weather_entities.dart';

/// Station hours around now for calibration and the fallback value.
final _stationHoursProvider = FutureProvider<List<WeatherHourEntity>>((
  ref,
) async {
  final cell = await ref
      .watch(settingsRepositoryProvider)
      .read<String>(SettingsKeys.weatherLastCell);
  if (cell == null) return const [];
  final now = ref.watch(clockProvider)().utcHour;
  return await ref
      .watch(weatherRepositoryProvider)
      .hours(
        cell,
        now.subtract(AppThresholds.barometerCalibrationWindow),
        now.add(const Duration(hours: 1)),
      );
});

/// Samples in the trend window.
final barometerTrendProvider = StreamProvider<List<PressureReading>>((ref) {
  final now = ref.watch(clockProvider)();
  return ref
      .watch(barometerRepositoryProvider)
      .watchSeries(now.subtract(AppThresholds.barometerTrendWindow), now);
});

/// The gauge screen state.
final barometerStateProvider = Provider<AsyncValue<BarometerState>>((ref) {
  final live = ref.watch(liveReadingProvider);
  final trend = ref.watch(barometerTrendProvider);
  final station = ref.watch(_stationHoursProvider);
  if (trend.isLoading || station.isLoading || live.isLoading) {
    return const AsyncLoading();
  }
  final now = ref.watch(clockProvider)();
  final samples = trend.value ?? const [];
  final hours = station.value ?? const [];
  final reading = live.value ?? (samples.isEmpty ? null : samples.last);
  final fresh =
      reading != null &&
      now.difference(reading.at) <= AppThresholds.barometerStampMaxAge;
  final stationNow = hours
      .where((h) => h.hourUtc == now.utcHour)
      .map((h) => h.pressureMsl)
      .firstOrNull;
  return AsyncData(
    BarometerState(
      origin: fresh
          ? PressureOrigin.sensor
          : stationNow != null
          ? PressureOrigin.station
          : PressureOrigin.none,
      reading: fresh ? reading : null,
      stationHpa: stationNow,
      calibration: PressureCalibration.from(samples, hours),
      trend: samples,
    ),
  );
});
