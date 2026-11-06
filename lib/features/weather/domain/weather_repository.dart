import 'package:migraine_tracker/features/weather/domain/weather_entities.dart';

/// Local store of weather hours and environment days.
abstract interface class WeatherRepository {
  Future<void> upsertHours(List<WeatherHourEntity> hours);
  Future<List<WeatherHourEntity>> hours(
    String cell,
    DateTime from,
    DateTime to,
  );
  Stream<List<WeatherHourEntity>> watchHours(
    String cell,
    DateTime from,
    DateTime to,
  );
  Future<WeatherHourEntity?> hourAt(String cell, DateTime hourUtc);
  Future<DateTime?> lastFetchedAt(String cell);

  /// Marks an hour as attached to an attack, so pruning keeps it.
  Future<void> pin(String cell, DateTime hourUtc);
  Future<int> prune(DateTime before);

  Future<void> upsertDays(List<EnvironmentDayEntity> days);
  Future<List<EnvironmentDayEntity>> days(String from, String to);
  Stream<List<EnvironmentDayEntity>> watchDays(String from, String to);
}

/// Fetches the cell payload (the cache function).
abstract interface class WeatherSource {
  Future<Map<String, Object?>> fetch(double lat, double lon);
}

/// Device location, already rounded. Null when unavailable or denied.
abstract interface class LocationSource {
  Future<LocationFix?> current();
}

class LocationFix {
  const LocationFix({required this.lat, required this.lon});

  final double lat;
  final double lon;
}

/// Typed-city lookup.
abstract interface class Geocoder {
  Future<List<GeocodeResult>> search(String query);
}

class GeocodeResult {
  const GeocodeResult({
    required this.name,
    required this.lat,
    required this.lon,
    this.admin,
    this.country,
  });

  final String name;
  final String? admin;
  final String? country;
  final double lat;
  final double lon;

  String get label =>
      [name, admin, country].nonNulls.where((s) => s.isNotEmpty).join(', ');
}
