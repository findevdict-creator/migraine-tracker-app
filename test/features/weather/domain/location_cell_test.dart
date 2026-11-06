import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/weather/domain/location_cell.dart';

void main() {
  test('rounds to the configured 0.1 degree cell', () {
    expect(AppThresholds.locationRoundingDegrees, 0.1);
    final cell = LocationCell.from(51.5074, -0.1278);
    expect(cell.lat, 51.5);
    expect(cell.lon, -0.1);
    expect(cell.key, '51.5,-0.1');
  });

  test('rounds half away from zero and keeps one decimal in the key', () {
    expect(LocationCell.from(40.75, -73.95).key, '40.8,-74.0');
    expect(LocationCell.from(0.04, 0.04).key, '0.0,0.0');
    expect(LocationCell.from(-33.86, 151.21).key, '-33.9,151.2');
  });

  test('folds -180 onto 180 and clamps out-of-range input', () {
    expect(LocationCell.from(0, -180).key, '0.0,180.0');
    expect(LocationCell.from(0, -179.98).key, '0.0,180.0');
    expect(LocationCell.from(95, 200).key, '90.0,180.0');
  });

  test('parse round-trips a key and rejects junk', () {
    final cell = LocationCell.parse('51.5,-0.1');
    expect(cell, LocationCell.from(51.5, -0.1));
    expect(LocationCell.parse('nope'), isNull);
    expect(LocationCell.parse('1,2,3'), isNull);
  });

  test('manual location stores the rounded cell only', () {
    final manual = ManualLocation(
      name: 'London, England, United Kingdom',
      cell: LocationCell.from(51.5074, -0.1278),
    );
    final json = manual.toJson();
    expect(json, {
      'name': 'London, England, United Kingdom',
      'lat': 51.5,
      'lon': -0.1,
    });
    expect(ManualLocation.fromJson(json).cell.key, '51.5,-0.1');
  });
}
