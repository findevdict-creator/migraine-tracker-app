import 'package:migraine_tracker/features/weather/domain/weather_entities.dart';

/// Inverse of the cache function's `deltaEncode`: the first non-null value
/// is absolute, each later value adds to the previous decoded value.
List<int?> deltaDecode(List<Object?> values) {
  int? previous;
  return [
    for (final v in values)
      if (v == null)
        null
      else
        previous = previous == null
            ? (v as num).toInt()
            : previous + (v as num).toInt(),
  ];
}

/// Decodes the `weatherCache` payload (format `v: 1`) into entities.
class WeatherPayload {
  WeatherPayload._({
    required this.hours,
    required this.days,
    required this.fetchedAt,
    required this.cell,
  });

  /// Throws [FormatException] on an unknown format version.
  factory WeatherPayload.decode(Map<String, Object?> json) {
    if (json['v'] != 1) {
      throw FormatException('Unsupported weather payload v${json['v']}');
    }
    final cell = json['cell']! as String;
    final fetchedAt = DateTime.parse(json['fetchedAt']! as String).toUtc();
    final hourStart = DateTime.parse(json['hourStart']! as String).toUtc();
    final fxStart = DateTime.parse(json['fxStart']! as String).toUtc();
    final p = deltaDecode(json['p']! as List);
    final fx = (json['fx']! as Map).cast<String, Object?>();
    final sp = deltaDecode(fx['sp']! as List);
    final t = deltaDecode(fx['t']! as List);
    final h = (fx['h']! as List).cast<num?>();
    final pr = (fx['pr']! as List).cast<num?>();
    final w = (fx['w']! as List).cast<num?>();
    final c = (fx['c']! as List).cast<num?>();
    final wc = (fx['wc']! as List).cast<num?>();
    final uv = (fx['uv']! as List).cast<num?>();
    final fxOffset = fxStart.difference(hourStart).inHours;

    double? tenths(num? v) => v == null ? null : v / 10;
    double? whole(num? v) => v?.toDouble();

    final hours = <WeatherHourEntity>[];
    for (var i = 0; i < p.length; i++) {
      final fxIndex = i - fxOffset;
      final inFx = fxIndex >= 0 && fxIndex < sp.length;
      hours.add(
        WeatherHourEntity(
          cell: cell,
          hourUtc: hourStart.add(Duration(hours: i)),
          fetchedAt: fetchedAt,
          pressureMsl: tenths(p[i]),
          surfacePressure: inFx ? tenths(sp[fxIndex]) : null,
          temperature: inFx ? tenths(t[fxIndex]) : null,
          humidity: inFx ? whole(h[fxIndex]) : null,
          precipitation: inFx ? tenths(pr[fxIndex]) : null,
          wind: inFx ? whole(w[fxIndex]) : null,
          cloud: inFx ? whole(c[fxIndex]) : null,
          weatherCode: inFx ? wc[fxIndex]?.toInt() : null,
          uv: inFx ? tenths(uv[fxIndex]) : null,
        ),
      );
    }

    final days = <EnvironmentDayEntity>[
      for (final raw in (json['days'] as List? ?? const []))
        _day(cell, fetchedAt, (raw as Map).cast<String, Object?>()),
    ];
    return WeatherPayload._(
      hours: hours,
      days: days,
      fetchedAt: fetchedAt,
      cell: cell,
    );
  }

  static EnvironmentDayEntity _day(
    String cell,
    DateTime fetchedAt,
    Map<String, Object?> d,
  ) {
    double? tenths(Object? v) => v == null ? null : (v as num) / 10;
    double? whole(Object? v) => (v as num?)?.toDouble();
    DateTime? time(Object? v) =>
        v == null ? null : DateTime.parse('${v as String}:00Z').toUtc();
    final pollenRaw = d['pollen'];
    return EnvironmentDayEntity(
      date: d['d']! as String,
      cell: cell,
      fetchedAt: fetchedAt,
      aqiUs: whole(d['aqiUs']),
      aqiEu: whole(d['aqiEu']),
      pm25: tenths(d['pm25']),
      pm10: tenths(d['pm10']),
      ozone: tenths(d['o3']),
      uvMax: tenths(d['uvMax']),
      daylightMinutes: (d['dl'] as num?)?.toInt(),
      sunrise: time(d['sr']),
      sunset: time(d['ss']),
      pollen: pollenRaw is Map
          ? {
              for (final e in pollenRaw.entries)
                if (e.value != null)
                  e.key as String: (e.value as num).toDouble(),
            }
          : null,
    );
  }

  final List<WeatherHourEntity> hours;
  final List<EnvironmentDayEntity> days;
  final DateTime fetchedAt;
  final String cell;
}
