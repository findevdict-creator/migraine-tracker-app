import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:migraine_tracker/config/app_config.dart';

/// A location rounded to the configured cell size. The only form of
/// location that ever leaves the device or is stored.
@immutable
class LocationCell {
  const LocationCell._({
    required this.lat,
    required this.lon,
    required this.key,
  });

  /// Rounds [lat] and [lon] to the cell grid. Mirrors `cellFor` in the
  /// cache function so both sides produce the same key.
  factory LocationCell.from(double lat, double lon) {
    const step = AppThresholds.locationRoundingDegrees;
    final decimals = math.max(0, (-math.log(step) / math.ln10).round());
    double round(double v) =>
        double.parse(((v / step).round() * step).toStringAsFixed(decimals));
    final rLat = round(lat.clamp(-90, 90));
    var rLon = round(lon.clamp(-180, 180));
    if (rLon == -180) rLon = 180;
    return LocationCell._(
      lat: rLat,
      lon: rLon,
      key:
          '${rLat.toStringAsFixed(decimals)},${rLon.toStringAsFixed(decimals)}',
    );
  }

  /// Parses a key such as `51.5,-0.1`.
  static LocationCell? parse(String key) {
    final parts = key.split(',');
    if (parts.length != 2) return null;
    final lat = double.tryParse(parts[0]);
    final lon = double.tryParse(parts[1]);
    if (lat == null || lon == null) return null;
    return LocationCell.from(lat, lon);
  }

  final double lat;
  final double lon;
  final String key;

  @override
  bool operator ==(Object other) => other is LocationCell && other.key == key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => key;
}

/// Where the current cell came from.
enum LocationMode { gps, manual, none }

/// A named manual location (typed city), stored rounded.
@immutable
class ManualLocation {
  const ManualLocation({required this.name, required this.cell});

  factory ManualLocation.fromJson(Map<String, Object?> json) => ManualLocation(
    name: json['name'] as String? ?? '',
    cell: LocationCell.from(
      (json['lat']! as num).toDouble(),
      (json['lon']! as num).toDouble(),
    ),
  );

  final String name;
  final LocationCell cell;

  Map<String, Object?> toJson() => {
    'name': name,
    'lat': cell.lat,
    'lon': cell.lon,
  };
}
