import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:migraine_tracker/app/bootstrap.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/firebase/firebase_bootstrap.dart';
import 'package:migraine_tracker/features/weather/domain/weather_repository.dart';

/// The cache function, or a source that always fails when Firebase is not
/// configured (the app then shows whatever is cached).
final weatherSourceProvider = Provider<WeatherSource>((ref) {
  final status = ref.watch(firebaseStatusProvider);
  if (!status.enabled) return const UnavailableWeatherSource();
  final config = ref.watch(appConfigProvider);
  return FunctionsWeatherSource(useEmulator: config.useEmulators);
});

final locationSourceProvider = Provider<LocationSource>(
  (_) => const GeolocatorLocationSource(),
);

final geocoderProvider = Provider<Geocoder>((_) => OpenMeteoGeocoder());

/// Calls `weatherCache` with the rounded cell. The function rounds again.
class FunctionsWeatherSource implements WeatherSource {
  FunctionsWeatherSource({required bool useEmulator}) {
    final functions = FirebaseFunctions.instanceFor(
      region: AppEnv.functionsRegion,
    );
    if (useEmulator) {
      functions.useFunctionsEmulator(AppEnv.emulatorHost, 5001);
    }
    _callable = functions.httpsCallable(
      AppEndpoints.weatherCacheFunction,
      options: HttpsCallableOptions(timeout: const Duration(seconds: 20)),
    );
  }

  late final HttpsCallable _callable;

  @override
  Future<Map<String, Object?>> fetch(double lat, double lon) async {
    final result = await _callable.call<Map<Object?, Object?>>({
      'lat': lat,
      'lon': lon,
    });
    return _deepCast(result.data);
  }

  /// Platform channels hand back `Map<Object?, Object?>`; normalise.
  static Map<String, Object?> _deepCast(Map<Object?, Object?> m) => {
    for (final e in m.entries)
      e.key! as String: switch (e.value) {
        final Map<Object?, Object?> inner => _deepCast(inner),
        final List<Object?> list => [
          for (final v in list)
            if (v is Map<Object?, Object?>) _deepCast(v) else v,
        ],
        final other => other,
      },
  };
}

/// Used when Firebase is not configured. Throws so the sync records the
/// failure and the screen shows cached data with its age.
class UnavailableWeatherSource implements WeatherSource {
  const UnavailableWeatherSource();

  @override
  Future<Map<String, Object?>> fetch(double lat, double lon) =>
      Future.error(StateError('weather source not configured'));
}

/// While-using location at coarse accuracy. Never asks for background or
/// precise permission: the cell rounding makes precision pointless.
class GeolocatorLocationSource implements LocationSource {
  const GeolocatorLocationSource();

  @override
  Future<LocationFix?> current() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
    } on Object {
      // Plugin missing (tests, desktop) or the service threw: no fix.
      return null;
    }
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 15),
        ),
      );
      return LocationFix(lat: position.latitude, lon: position.longitude);
    } on Object {
      try {
        final last = await Geolocator.getLastKnownPosition();
        return last == null
            ? null
            : LocationFix(lat: last.latitude, lon: last.longitude);
      } on Object {
        return null;
      }
    }
  }
}

/// Open-Meteo geocoding: the typed name is the only thing sent.
class OpenMeteoGeocoder implements Geocoder {
  OpenMeteoGeocoder({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<List<GeocodeResult>> search(String query) async {
    final q = query.trim();
    if (q.length < 2) return const [];
    final uri = Uri.parse(AppEndpoints.openMeteoGeocoding)
        .replace(queryParameters: {'name': q, 'count': '8', 'format': 'json'});
    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode != 200) {
      throw http.ClientException('geocoding ${response.statusCode}', uri);
    }
    final json = jsonDecode(response.body) as Map<String, Object?>;
    final results = json['results'] as List? ?? const [];
    return [
      for (final r in results.cast<Map<String, Object?>>())
        GeocodeResult(
          name: r['name'] as String? ?? '',
          admin: r['admin1'] as String?,
          country: r['country'] as String?,
          lat: (r['latitude']! as num).toDouble(),
          lon: (r['longitude']! as num).toDouble(),
        ),
    ];
  }
}
