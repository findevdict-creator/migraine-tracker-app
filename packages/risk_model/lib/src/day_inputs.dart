import 'package:meta/meta.dart';

/// Everything known about one day, every field optional. The app fills
/// this from the weather store, the environment day, the check-in, health
/// samples and cycle tracking; fixtures fill it from JSON.
@immutable
class DayInputs {
  /// All fields but [date] are optional.
  const DayInputs({
    required this.date,
    this.pressureDelta24h,
    this.humidity,
    this.temperatureSwing,
    this.aqiUs,
    this.pollenMax,
    this.uvMax,
    this.lightExposure,
    this.screenExposure,
    this.sleepQuality,
    this.sleepMinutes,
    this.stress,
    this.neckTension,
    this.caffeine,
    this.alcohol,
    this.hydration,
    this.cycleDay,
    this.cycleLength,
  });

  /// Reads the fixture shape; unknown keys are ignored.
  factory DayInputs.fromJson(Map<String, Object?> json) => DayInputs(
    date: json['date']! as String,
    pressureDelta24h: _num(json['pressureDelta24h']),
    humidity: _num(json['humidity']),
    temperatureSwing: _num(json['temperatureSwing']),
    aqiUs: _num(json['aqiUs']),
    pollenMax: _num(json['pollenMax']),
    uvMax: _num(json['uvMax']),
    lightExposure: _int(json['lightExposure']),
    screenExposure: _int(json['screenExposure']),
    sleepQuality: _int(json['sleepQuality']),
    sleepMinutes: _int(json['sleepMinutes']),
    stress: _int(json['stress']),
    neckTension: _int(json['neckTension']),
    caffeine: _int(json['caffeine']),
    alcohol: _int(json['alcohol']),
    hydration: _int(json['hydration']),
    cycleDay: _int(json['cycleDay']),
    cycleLength: _int(json['cycleLength']),
  );

  static double? _num(Object? v) => (v as num?)?.toDouble();
  static int? _int(Object? v) => (v as num?)?.toInt();

  /// `yyyy-MM-dd`.
  final String date;

  /// Sea-level pressure change over the last 24 h, hPa (negative = drop).
  final double? pressureDelta24h;

  /// Relative humidity, percent.
  final double? humidity;

  /// Absolute change of the daily mean temperature against the day
  /// before, degrees C.
  final double? temperatureSwing;

  /// US AQI daily max.
  final double? aqiUs;

  /// Highest pollen type, grains per cubic metre.
  final double? pollenMax;

  /// UV index daily max.
  final double? uvMax;

  /// Check-in scales. 1 to 5 unless noted.
  final int? lightExposure;

  /// Screen time answer, 1 to 5.
  final int? screenExposure;

  /// Sleep quality answer, 1 (poor) to 5.
  final int? sleepQuality;

  /// Minutes asleep the night before, from health sync.
  final int? sleepMinutes;

  /// Stress answer, 1 to 5.
  final int? stress;

  /// Neck tension answer, 1 to 5.
  final int? neckTension;

  /// 0 to 5.
  final int? caffeine;

  /// 0 to 5.
  final int? alcohol;

  /// Hydration answer, 1 (low) to 5.
  final int? hydration;

  /// Day of the menstrual cycle (1 = first day of bleeding) and the
  /// cycle length, both null when cycle tracking is off.
  final int? cycleDay;

  /// Cycle length in days.
  final int? cycleLength;

  /// The fixture shape.
  Map<String, Object?> toJson() => {
    'date': date,
    'pressureDelta24h': pressureDelta24h,
    'humidity': humidity,
    'temperatureSwing': temperatureSwing,
    'aqiUs': aqiUs,
    'pollenMax': pollenMax,
    'uvMax': uvMax,
    'lightExposure': lightExposure,
    'screenExposure': screenExposure,
    'sleepQuality': sleepQuality,
    'sleepMinutes': sleepMinutes,
    'stress': stress,
    'neckTension': neckTension,
    'caffeine': caffeine,
    'alcohol': alcohol,
    'hydration': hydration,
    'cycleDay': cycleDay,
    'cycleLength': cycleLength,
  };
}
