import 'package:flutter/foundation.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/weather/domain/weather_entities.dart';

/// One raw barometer sample in hPa.
@immutable
class PressureReading {
  const PressureReading({required this.at, required this.hpa});

  final DateTime at;
  final double hpa;

  @override
  bool operator ==(Object other) =>
      other is PressureReading && other.at == at && other.hpa == hpa;

  @override
  int get hashCode => Object.hash(at, hpa);
}

/// Offset between the station series and the sensor, so the gauge can show
/// a sea-level-comparable number. Positive means the sensor reads low.
@immutable
class PressureCalibration {
  const PressureCalibration({required this.offset, required this.pairs});

  const PressureCalibration.none() : offset = null, pairs = 0;

  /// Pairs each sample with the station hour it falls in and takes the
  /// median of `station - sensor`. Null offset below the minimum pair count.
  factory PressureCalibration.from(
    Iterable<PressureReading> readings,
    Iterable<WeatherHourEntity> station,
  ) {
    final byHour = <DateTime, double>{
      for (final h in station)
        if (h.pressureMsl != null) h.hourUtc.toUtc(): h.pressureMsl!,
    };
    // One sensor value per hour (the last one) keeps busy hours from
    // dominating the median.
    final sensorByHour = <DateTime, double>{};
    for (final r in readings) {
      sensorByHour[r.at.utcHour] = r.hpa;
    }
    final diffs = <double>[
      for (final e in sensorByHour.entries)
        if (byHour[e.key] case final s?) s - e.value,
    ]..sort();
    if (diffs.length < AppThresholds.barometerCalibrationMinPairs) {
      return PressureCalibration(offset: null, pairs: diffs.length);
    }
    final mid = diffs.length ~/ 2;
    final median = diffs.length.isOdd
        ? diffs[mid]
        : (diffs[mid - 1] + diffs[mid]) / 2;
    return PressureCalibration(
      offset: double.parse(median.toStringAsFixed(1)),
      pairs: diffs.length,
    );
  }

  final double? offset;
  final int pairs;

  bool get isCalibrated => offset != null;

  double apply(double raw) => raw + (offset ?? 0);
}

/// Where the number on the gauge comes from.
enum PressureOrigin { sensor, station, none }

/// Everything the gauge screen shows.
@immutable
class BarometerState {
  const BarometerState({
    required this.origin,
    required this.calibration,
    required this.trend,
    this.reading,
    this.stationHpa,
  });

  final PressureOrigin origin;
  final PressureReading? reading;
  final double? stationHpa;
  final PressureCalibration calibration;

  /// Samples in the trend window, oldest first.
  final List<PressureReading> trend;

  /// The displayed value: calibrated sensor, else the station.
  double? get displayHpa => switch (origin) {
    PressureOrigin.sensor => calibration.apply(reading!.hpa),
    PressureOrigin.station => stationHpa,
    PressureOrigin.none => null,
  };
}
