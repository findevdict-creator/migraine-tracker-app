// Generates the synthetic users under test/fixtures/users with a seeded
// random so the inputs are reproducible. Expected outputs are then
// frozen with `dart run risk_model:score --write-expected`.
//
//   dart run tool/make_fixtures.dart
import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main() {
  final users = <String, Map<String, Object?>>{
    'steady': _user(
      'steady',
      seed: 1,
      days: 60,
      about: 'Calm inputs, few exposures, mostly low days.',
      stressBias: -1,
      pressureSwing: 2,
      cycle: false,
    ),
    'stormy': _user(
      'stormy',
      seed: 2,
      days: 60,
      about: 'Big pressure swings and high humidity, weather driven.',
      stressBias: 0,
      pressureSwing: 7,
      cycle: false,
    ),
    'stressed': _user(
      'stressed',
      seed: 3,
      days: 60,
      about: 'High stress and poor sleep most days, cycle tracked.',
      stressBias: 2,
      pressureSwing: 3,
      cycle: true,
    ),
    'sparse': _user(
      'sparse',
      seed: 4,
      days: 30,
      about: 'Half the fields missing on most days, low coverage.',
      stressBias: 0,
      pressureSwing: 4,
      cycle: false,
      sparse: true,
    ),
    'personalised': _user(
      'personalised',
      seed: 5,
      days: 30,
      about:
          'Same inputs as stormy but with learned weights and '
          'personal thresholds.',
      stressBias: 0,
      pressureSwing: 7,
      cycle: true,
      weights: {
        'pressure_drop': {
          'population': 0.45,
          'personal': 0.9,
          'confidence': 0.8,
          'nExposures': 40,
          'nAttacksAfter': 22,
        },
        'stress': {
          'population': 0.45,
          'personal': 0.1,
          'confidence': 0.6,
          'nExposures': 30,
          'nAttacksAfter': 3,
        },
        'humidity': {
          'population': 0.2,
          'personal': 0.0,
          'confidence': 1.0,
          'nExposures': 50,
          'nAttacksAfter': 5,
        },
      },
      thresholds: {'moderate': 25, 'high': 50},
    ),
  };
  final dir = Directory('test/fixtures/users')..createSync(recursive: true);
  for (final e in users.entries) {
    File('${dir.path}/${e.key}.json').writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(e.value)}\n',
    );
  }
  stdout.writeln('wrote ${users.length} fixtures');
}

Map<String, Object?> _user(
  String name, {
  required int seed,
  required int days,
  required String about,
  required int stressBias,
  required double pressureSwing,
  required bool cycle,
  bool sparse = false,
  Map<String, Object?>? weights,
  Map<String, Object?>? thresholds,
}) {
  final rng = Random(seed);
  final start = DateTime.utc(2026, 1, 5);
  int scale(int bias) => (3 + bias + rng.nextInt(3) - 1).clamp(1, 5);
  double r(double lo, double hi) => lo + rng.nextDouble() * (hi - lo);
  double round1(double v) => (v * 10).round() / 10;
  final list = <Map<String, Object?>>[];
  for (var i = 0; i < days; i++) {
    final date = start
        .add(Duration(days: i))
        .toIso8601String()
        .substring(0, 10);
    bool keep() => !sparse || rng.nextBool();
    final cycleDay = cycle ? (i % 28) + 1 : null;
    list.add({
      'date': date,
      if (keep()) 'pressureDelta24h': round1(r(-pressureSwing, pressureSwing)),
      if (keep()) 'humidity': round1(r(35, 95)),
      if (keep()) 'temperatureSwing': round1(r(0, 9)),
      if (keep()) 'aqiUs': round1(r(10, 170)),
      if (keep()) 'pollenMax': round1(r(0, 130)),
      if (keep()) 'uvMax': round1(r(0, 10)),
      if (keep()) 'lightExposure': scale(0),
      if (keep()) 'screenExposure': scale(1),
      if (keep()) 'sleepQuality': scale(-stressBias),
      if (keep() && rng.nextInt(3) == 0) 'sleepMinutes': 240 + rng.nextInt(300),
      if (keep()) 'stress': scale(stressBias),
      if (keep()) 'neckTension': scale(stressBias ~/ 2),
      if (keep()) 'caffeine': rng.nextInt(6),
      if (keep()) 'alcohol': rng.nextInt(4) == 0 ? rng.nextInt(6) : 0,
      if (keep()) 'hydration': scale(0),
      'cycleDay': ?cycleDay,
      if (cycleDay != null) 'cycleLength': 28,
    });
  }
  return {
    'name': name,
    'about': about,
    'weights': ?weights,
    'thresholds': ?thresholds,
    'days': list,
  };
}
