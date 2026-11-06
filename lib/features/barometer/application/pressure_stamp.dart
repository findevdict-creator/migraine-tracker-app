import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_repository.dart';
import 'package:migraine_tracker/features/barometer/application/barometer_sampler.dart';
import 'package:migraine_tracker/features/barometer/data/barometer_repository_impl.dart';
import 'package:migraine_tracker/features/weather/data/weather_repository_impl.dart';

final sensorPressureStampProvider = Provider<PressureStampSource>(
  SensorPressureStamp.new,
);

/// Stamps a new attack with the raw sensor reading (live, else the newest
/// stored sample inside [AppThresholds.barometerStampMaxAge]) and the
/// station pressure for the hour. Either may be null.
class SensorPressureStamp implements PressureStampSource {
  SensorPressureStamp(this._ref);

  final Ref _ref;

  @override
  Future<PressureStamp> read() async {
    final now = _ref.read(clockProvider)();
    final live = _ref.read(liveReadingProvider).value;
    var sensor = live?.hpa;
    if (sensor == null) {
      final stored = await _ref.read(barometerRepositoryProvider).latest();
      if (stored != null &&
          now.difference(stored.at) <= AppThresholds.barometerStampMaxAge) {
        sensor = stored.hpa;
      }
    }
    double? station;
    final cell = await _ref
        .read(settingsRepositoryProvider)
        .read<String>(SettingsKeys.weatherLastCell);
    if (cell != null) {
      final hour = await _ref
          .read(weatherRepositoryProvider)
          .hourAt(cell, now.utcHour);
      station = hour?.pressureMsl;
    }
    return PressureStamp(sensorHpa: sensor, stationHpa: station);
  }
}
