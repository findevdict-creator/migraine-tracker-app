import 'package:flutter/foundation.dart';
import 'package:migraine_tracker/features/weather/domain/weather_entities.dart';

/// Pressure change over the last 3, 6, 12 and 24 hours, in hPa. Positive
/// means rising. Null where the series has no value at either end.
@immutable
class PressureDeltas {
  const PressureDeltas({this.h3, this.h6, this.h12, this.h24, this.current});

  /// Computes the deltas at [now] from an hourly series (any order).
  factory PressureDeltas.from(Iterable<WeatherHourEntity> hours, DateTime now) {
    final byHour = <DateTime, double>{
      for (final h in hours)
        if (h.pressureMsl != null) h.hourUtc.toUtc(): h.pressureMsl!,
    };
    final nowHour = DateTime.utc(
      now.toUtc().year,
      now.toUtc().month,
      now.toUtc().day,
      now.toUtc().hour,
    );
    final current = byHour[nowHour];
    double? delta(int hoursBack) {
      final then = byHour[nowHour.subtract(Duration(hours: hoursBack))];
      if (current == null || then == null) return null;
      return double.parse((current - then).toStringAsFixed(1));
    }

    return PressureDeltas(
      current: current,
      h3: delta(3),
      h6: delta(6),
      h12: delta(12),
      h24: delta(24),
    );
  }

  final double? current;
  final double? h3;
  final double? h6;
  final double? h12;
  final double? h24;

  Map<String, double?> toJson() => {
    'pressureNow': current,
    'delta3h': h3,
    'delta6h': h6,
    'delta12h': h12,
    'delta24h': h24,
  };

  /// Largest absolute change among the windows, for the trend indicator.
  double? get strongest => [h3, h6, h12, h24].nonNulls.fold<double?>(
    null,
    (a, b) => a == null || b.abs() > a.abs() ? b : a,
  );
}
