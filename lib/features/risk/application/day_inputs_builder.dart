import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_repository_impl.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:migraine_tracker/features/cycle/domain/cycle_calculator.dart';
import 'package:migraine_tracker/features/health/data/health_repository_impl.dart';
import 'package:migraine_tracker/features/health/domain/health_entities.dart';
import 'package:migraine_tracker/features/weather/data/weather_repository_impl.dart';
import 'package:migraine_tracker/features/weather/domain/weather_entities.dart';
import 'package:risk_model/risk_model.dart';

final dayInputsBuilderProvider = Provider<DayInputsBuilder>(
  DayInputsBuilder.new,
);

/// Assembles the model's per-day inputs from the local stores: weather
/// hours (pressure drop, humidity, temperature swing), environment days
/// (AQI, pollen, UV), check-ins (answers, cycle day), health sleep and
/// the cycle length. Days with nothing at all are left out.
class DayInputsBuilder {
  DayInputsBuilder(this._ref);

  final Ref _ref;

  SettingsRepository get _settings => _ref.read(settingsRepositoryProvider);

  /// Inputs for every local date from [from] to [to] inclusive
  /// (`yyyy-MM-dd`) that has any data.
  Future<List<DayInputs>> build(String from, String to) async {
    final first = parseDateKey(from);
    final last = parseDateKey(to);
    if (last.isBefore(first)) return const [];
    final cell = await _settings.read<String>(SettingsKeys.weatherLastCell);

    final weather = _ref.read(weatherRepositoryProvider);
    final hours = cell == null
        ? const <WeatherHourEntity>[]
        : await weather.hours(
            cell,
            first.subtract(const Duration(hours: 48)).toUtc(),
            last.add(const Duration(days: 1)).toUtc(),
          );
    final days = cell == null
        ? const <EnvironmentDayEntity>[]
        : await weather.days(from, to);
    final envByDate = {for (final d in days) d.date: d};

    final checkins = await _ref
        .read(checkinRepositoryProvider)
        .inRange(from, to);
    final checkinByDate = {for (final c in checkins) c.date: c};

    final sleepByDate = await _sleepMinutes(first, last);
    final starts = await _periodStarts();

    final byHour = <DateTime, WeatherHourEntity>{
      for (final h in hours) h.hourUtc.toUtc(): h,
    };

    final out = <DayInputs>[];
    for (
      var day = first;
      !day.isAfter(last);
      day = day.add(const Duration(days: 1))
    ) {
      final date = day.dateKey;
      final w = _WeatherDay.from(byHour, day);
      final env = envByDate[date];
      final checkin = checkinByDate[date];
      final sleep = sleepByDate[date];
      final cycle = starts == null
          ? null
          : CycleCalculator.infoFor(date, starts);
      if (w.isEmpty && env == null && checkin == null && sleep == null) {
        continue;
      }
      out.add(
        DayInputs(
          date: date,
          pressureDelta24h: w.pressureDrop,
          humidity: w.humidity,
          temperatureSwing: w.temperatureSwing,
          aqiUs: env?.aqiUs,
          pollenMax: env?.pollen?.values.fold<double?>(
            null,
            (a, b) => a == null || b > a ? b : a,
          ),
          uvMax: env?.uvMax ?? w.uvMax,
          lightExposure: checkin?[CheckinField.lightExposure],
          screenExposure: checkin?[CheckinField.screenExposure],
          sleepQuality: checkin?[CheckinField.sleepQuality],
          sleepMinutes: sleep,
          stress: checkin?[CheckinField.stress],
          neckTension: checkin?[CheckinField.neckTension],
          caffeine: checkin?[CheckinField.caffeine],
          alcohol: checkin?[CheckinField.alcohol],
          hydration: checkin?[CheckinField.hydration],
          cycleDay: checkin?.cycleDay ?? cycle?.day,
          cycleLength: cycle?.cycleLength,
        ),
      );
    }
    return out;
  }

  /// Minutes asleep per local date (the date the sleep ended on).
  Future<Map<String, int>> _sleepMinutes(DateTime first, DateTime last) async {
    final samples = await _ref
        .read(healthRepositoryProvider)
        .ofType(
          HealthType.sleep,
          first.subtract(const Duration(hours: 12)),
          last.add(const Duration(hours: 36)),
        );
    final out = <String, int>{};
    for (final s in samples) {
      final date = s.end.dateKey;
      out[date] = (out[date] ?? 0) + s.value.round();
    }
    return out;
  }

  /// Period starts when cycle tracking is on, else null.
  Future<List<String>?> _periodStarts() async {
    if (!AppFeatureFlags.cycleTrackingAvailable) return null;
    final enabled =
        await _settings.read<bool>(SettingsKeys.cycleTrackingEnabled) ?? false;
    if (!enabled) return null;
    final stored = await _settings.read<List<dynamic>>(
      SettingsKeys.cyclePeriodStarts,
    );
    final starts = List<String>.from(stored ?? const <dynamic>[])..sort();
    return starts.isEmpty ? null : starts;
  }
}

/// A local day's weather, derived from the hourly series.
class _WeatherDay {
  const _WeatherDay({
    this.pressureDrop,
    this.humidity,
    this.temperatureSwing,
    this.uvMax,
  });

  /// [day] is local midnight. The pressure drop is the most negative
  /// 24 h change seen at any hour of the day (positive when pressure
  /// only rose); humidity is the day's mean; the swing is the mean
  /// temperature against the day before.
  factory _WeatherDay.from(
    Map<DateTime, WeatherHourEntity> byHour,
    DateTime day,
  ) {
    double? minDelta;
    double? uvMax;
    final humidities = <double>[];
    final temps = <double>[];
    final prevTemps = <double>[];
    for (var h = 0; h < 24; h++) {
      final at = day.add(Duration(hours: h)).utcHour;
      final hour = byHour[at];
      final prev = byHour[at.subtract(const Duration(hours: 24))];
      if (prev?.temperature != null) prevTemps.add(prev!.temperature!);
      if (hour == null) continue;
      if (hour.humidity != null) humidities.add(hour.humidity!);
      if (hour.temperature != null) temps.add(hour.temperature!);
      if (hour.uv != null && (uvMax == null || hour.uv! > uvMax)) {
        uvMax = hour.uv;
      }
      final now = hour.pressureMsl;
      final then = prev?.pressureMsl;
      if (now != null && then != null) {
        final delta = now - then;
        if (minDelta == null || delta < minDelta) minDelta = delta;
      }
    }
    return _WeatherDay(
      pressureDrop: minDelta == null ? null : _round1(minDelta),
      humidity: humidities.isEmpty ? null : _round1(_mean(humidities)),
      temperatureSwing: temps.isEmpty || prevTemps.isEmpty
          ? null
          : _round1((_mean(temps) - _mean(prevTemps)).abs()),
      uvMax: uvMax,
    );
  }

  final double? pressureDrop;
  final double? humidity;
  final double? temperatureSwing;
  final double? uvMax;

  bool get isEmpty =>
      pressureDrop == null &&
      humidity == null &&
      temperatureSwing == null &&
      uvMax == null;

  static double _mean(List<double> v) => v.reduce((a, b) => a + b) / v.length;
  static double _round1(double v) => (v * 10).roundToDouble() / 10;
}
