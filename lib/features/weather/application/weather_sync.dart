import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/weather/data/weather_repository_impl.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';
import 'package:migraine_tracker/features/weather/domain/location_cell.dart';
import 'package:migraine_tracker/features/weather/domain/weather_payload.dart';
import 'package:migraine_tracker/features/weather/domain/weather_repository.dart';

/// Result of one refresh attempt.
@immutable
class WeatherSyncResult {
  const WeatherSyncResult({
    required this.cell,
    required this.mode,
    required this.fetched,
    this.error,
  });

  const WeatherSyncResult.noLocation()
    : cell = null,
      mode = LocationMode.none,
      fetched = false,
      error = null;

  final LocationCell? cell;
  final LocationMode mode;

  /// True when new data was fetched; false when the cache was fresh or the
  /// fetch failed (see [error]).
  final bool fetched;
  final String? error;
}

/// The cell currently in use and how it was obtained.
@immutable
class WeatherLocation {
  const WeatherLocation({required this.cell, required this.mode, this.name});

  final LocationCell? cell;
  final LocationMode mode;

  /// City name for manual locations.
  final String? name;
}

final weatherSyncProvider = Provider<WeatherSync>(WeatherSync.new);

/// Resolves the cell, refreshes the local weather store when stale,
/// prunes old hours. Safe to call often: it returns early while fresh.
class WeatherSync {
  WeatherSync(this._ref);

  final Ref _ref;

  WeatherRepository get _repo => _ref.read(weatherRepositoryProvider);
  SettingsRepository get _settings => _ref.read(settingsRepositoryProvider);
  DateTime get _now => _ref.read(clockProvider)();

  /// The current location choice: manual city if set, else GPS.
  Future<WeatherLocation> resolveLocation() async {
    final mode = await _settings.read<String>(SettingsKeys.locationMode);
    if (mode == 'manual') {
      final raw = await _settings.read<Map<String, dynamic>>(
        SettingsKeys.manualLocation,
      );
      if (raw != null) {
        final manual = ManualLocation.fromJson(raw.cast<String, Object?>());
        return WeatherLocation(
          cell: manual.cell,
          mode: LocationMode.manual,
          name: manual.name,
        );
      }
    }
    final fix = await _ref.read(locationSourceProvider).current();
    if (fix != null) {
      return WeatherLocation(
        cell: LocationCell.from(fix.lat, fix.lon),
        mode: LocationMode.gps,
      );
    }
    // No fix: fall back to the last cell so cached data stays visible.
    final last = await _settings.read<String>(SettingsKeys.weatherLastCell);
    final cell = last == null ? null : LocationCell.parse(last);
    return WeatherLocation(cell: cell, mode: LocationMode.none);
  }

  Future<void> setManualLocation(ManualLocation location) async {
    await _settings.write(SettingsKeys.manualLocation, location.toJson());
    await _settings.write(SettingsKeys.locationMode, 'manual');
  }

  Future<void> useDeviceLocation() async {
    await _settings.write(SettingsKeys.locationMode, 'gps');
  }

  /// Refreshes unless the cell was fetched within the foreground window.
  Future<WeatherSyncResult> refresh({bool force = false}) async {
    final location = await resolveLocation();
    final cell = location.cell;
    if (cell == null) return const WeatherSyncResult.noLocation();
    await _settings.write(SettingsKeys.weatherLastCell, cell.key);

    final now = _now.toUtc();
    final last = await _repo.lastFetchedAt(cell.key);
    if (!force &&
        last != null &&
        now.difference(last) < AppThresholds.weatherForegroundRefresh) {
      return WeatherSyncResult(cell: cell, mode: location.mode, fetched: false);
    }
    try {
      final raw = await _ref
          .read(weatherSourceProvider)
          .fetch(cell.lat, cell.lon);
      final payload = WeatherPayload.decode(raw);
      await _repo.upsertHours(payload.hours);
      await _repo.upsertDays(payload.days);
      await _repo.prune(
        now.subtract(const Duration(days: AppThresholds.weatherRetentionDays)),
      );
      return WeatherSyncResult(cell: cell, mode: location.mode, fetched: true);
    } on Object catch (error) {
      return WeatherSyncResult(
        cell: cell,
        mode: location.mode,
        fetched: false,
        error: error.toString(),
      );
    }
  }
}

/// Runs a refresh when first watched and exposes the outcome. Screens
/// that need weather watch this; the environment screen also offers a
/// manual retry through `ref.invalidate`.
final weatherRefreshProvider = FutureProvider<WeatherSyncResult>(
  (ref) => ref.watch(weatherSyncProvider).refresh(),
);

/// The cell in use (from the last refresh, or the stored one).
final weatherLocationProvider = FutureProvider<WeatherLocation>(
  (ref) => ref.watch(weatherSyncProvider).resolveLocation(),
);
