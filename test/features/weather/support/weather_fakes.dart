import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/weather/domain/weather_repository.dart';

/// A `weatherCache` payload (format v1) mirroring `compactPayload` in the
/// functions project: 48 past hours plus 48 forecast hours of pressure,
/// delta-encoded tenths of hPa, and two environment days.
Map<String, Object?> weatherPayload({
  required DateTime now,
  String cell = '51.5,-0.1',
  double basePressure = 1013,
  double hourlyStep = 0.5,
  int pastHours = 48,
  int forecastHours = 48,
}) {
  final nowHour = now.utcHour;
  final hourStart = nowHour.subtract(Duration(hours: pastHours));
  final total = pastHours + forecastHours;
  // Pressure rises by [hourlyStep] each hour: index i -> base + i * step.
  final pressureTenths = [
    for (var i = 0; i < total; i++)
      ((basePressure + i * hourlyStep) * 10).round(),
  ];
  List<Object?> delta(List<int> values) => [
    for (var i = 0; i < values.length; i++)
      if (i == 0) values[i] else values[i] - values[i - 1],
  ];
  final tempTenths = [for (var i = 0; i < forecastHours; i++) 100 + i];
  return {
    'v': 1,
    'cell': cell,
    'fetchedAt': now.toUtc().toIso8601String(),
    'hourStart': hourStart.toIso8601String(),
    'p': delta(pressureTenths),
    'fxStart': nowHour.toIso8601String(),
    'fx': {
      'sp': delta([for (var i = 0; i < forecastHours; i++) 10100 + i]),
      't': delta(tempTenths),
      'h': [for (var i = 0; i < forecastHours; i++) 60],
      'pr': [for (var i = 0; i < forecastHours; i++) 0],
      'w': [for (var i = 0; i < forecastHours; i++) 12],
      'c': [for (var i = 0; i < forecastHours; i++) 40],
      'wc': [for (var i = 0; i < forecastHours; i++) 2],
      'uv': [
        for (var i = 0; i < forecastHours; i++)
          if (i.isEven) 15 else null,
      ],
    },
    'days': [
      {
        'd': nowHour.dateKeyUtc,
        'aqiUs': 42,
        'aqiEu': 30,
        'pm25': 85,
        'pm10': 120,
        'o3': 600,
        'uvMax': 45,
        'dl': 540,
        'sr': '${nowHour.dateKeyUtc}T07:12',
        'ss': '${nowHour.dateKeyUtc}T16:20',
        'pollen': {'grass': 3, 'birch': null},
      },
      {
        'd': nowHour.add(const Duration(days: 1)).dateKeyUtc,
        'aqiUs': 50,
        'aqiEu': null,
        'pm25': null,
        'pm10': null,
        'o3': null,
        'uvMax': 30,
        'dl': 538,
        'sr': null,
        'ss': null,
      },
    ],
    'source': 'open-meteo',
  };
}

extension on DateTime {
  String get dateKeyUtc => toUtc().toIso8601String().substring(0, 10);
}

/// Records calls and returns the configured payload, or throws.
class FakeWeatherSource implements WeatherSource {
  FakeWeatherSource(this.payload);

  Map<String, Object?>? payload;
  Exception? error;
  final calls = <(double, double)>[];

  @override
  Future<Map<String, Object?>> fetch(double lat, double lon) async {
    calls.add((lat, lon));
    if (error != null) throw error!;
    return payload!;
  }
}

class FakeLocationSource implements LocationSource {
  FakeLocationSource(this.fix);

  LocationFix? fix;

  @override
  Future<LocationFix?> current() async => fix;
}

class FakeGeocoder implements Geocoder {
  FakeGeocoder(this.results);

  final List<GeocodeResult> results;
  final queries = <String>[];
  Exception? error;

  @override
  Future<List<GeocodeResult>> search(String query) async {
    queries.add(query);
    if (error != null) throw error!;
    return results;
  }
}
