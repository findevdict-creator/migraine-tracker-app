import 'package:flutter/foundation.dart';

/// One hour of weather for a cell. Values in natural units (hPa, °C, %,
/// mm, km/h), decoded from the compact payload.
@immutable
class WeatherHourEntity {
  const WeatherHourEntity({
    required this.cell,
    required this.hourUtc,
    required this.fetchedAt,
    this.pressureMsl,
    this.surfacePressure,
    this.temperature,
    this.humidity,
    this.precipitation,
    this.wind,
    this.cloud,
    this.weatherCode,
    this.uv,
    this.pinned = false,
  });

  final String cell;
  final DateTime hourUtc;
  final DateTime fetchedAt;
  final double? pressureMsl;
  final double? surfacePressure;
  final double? temperature;
  final double? humidity;
  final double? precipitation;
  final double? wind;
  final double? cloud;
  final int? weatherCode;
  final double? uv;
  final bool pinned;

  /// The fields attached to attacks and check-ins at save time.
  Map<String, Object?> toSnapshot() => {
    'cell': cell,
    'hourUtc': hourUtc.toUtc().toIso8601String(),
    'pressureMsl': pressureMsl,
    'surfacePressure': surfacePressure,
    'temperature': temperature,
    'humidity': humidity,
    'precipitation': precipitation,
    'wind': wind,
    'cloud': cloud,
    'weatherCode': weatherCode,
    'uv': uv,
  };

  @override
  bool operator ==(Object other) =>
      other is WeatherHourEntity &&
      other.cell == cell &&
      other.hourUtc == hourUtc &&
      other.pressureMsl == pressureMsl &&
      other.temperature == temperature &&
      other.pinned == pinned;

  @override
  int get hashCode => Object.hash(cell, hourUtc, pressureMsl, pinned);
}

/// One day of environment factors for a cell.
@immutable
class EnvironmentDayEntity {
  const EnvironmentDayEntity({
    required this.date,
    required this.cell,
    required this.fetchedAt,
    this.aqiUs,
    this.aqiEu,
    this.pm25,
    this.pm10,
    this.ozone,
    this.pollen,
    this.uvMax,
    this.daylightMinutes,
    this.sunrise,
    this.sunset,
  });

  /// `yyyy-MM-dd` in UTC, as served by the cache.
  final String date;
  final String cell;
  final DateTime fetchedAt;
  final double? aqiUs;
  final double? aqiEu;
  final double? pm25;
  final double? pm10;
  final double? ozone;
  final Map<String, double>? pollen;
  final double? uvMax;
  final int? daylightMinutes;
  final DateTime? sunrise;
  final DateTime? sunset;

  @override
  bool operator ==(Object other) =>
      other is EnvironmentDayEntity &&
      other.date == date &&
      other.cell == cell &&
      other.aqiUs == aqiUs &&
      other.uvMax == uvMax;

  @override
  int get hashCode => Object.hash(date, cell, aqiUs, uvMax);
}
