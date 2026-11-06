// Scores a fixture file and prints the outputs as JSON.
//
//   dart run risk_model:score test/fixtures/users/steady.json
//   dart run risk_model:score --write-expected test/fixtures/users/*.json
//
// A fixture is `{ "name": ..., "weights": {...}?, "thresholds": {...}?,
// "days": [DayInputs...], "expected": [DayRisk...] }`. With
// `--write-expected` the expected block is rewritten from the current
// model; the model version must be bumped when that changes an output.
import 'dart:convert';
import 'dart:io';

import 'package:risk_model/risk_model.dart';

void main(List<String> args) {
  final write = args.contains('--write-expected');
  final paths = args.where((a) => !a.startsWith('--')).toList();
  if (paths.isEmpty) {
    stderr.writeln('usage: score [--write-expected] <fixture.json>...');
    exitCode = 64;
    return;
  }
  for (final path in paths) {
    final file = File(path);
    final fixture = (jsonDecode(file.readAsStringSync()) as Map)
        .cast<String, Object?>();
    final results = scoreFixture(fixture);
    if (write) {
      fixture['expected'] = [for (final r in results) r.toJson()];
      fixture['modelVersion'] = modelVersion;
      file.writeAsStringSync(
        '${const JsonEncoder.withIndent('  ').convert(fixture)}\n',
      );
      stdout.writeln('wrote ${results.length} days to $path');
    } else {
      stdout.writeln(
        const JsonEncoder.withIndent('  ').convert({
          'name': fixture['name'],
          'modelVersion': modelVersion,
          'results': [for (final r in results) r.toJson()],
        }),
      );
    }
  }
}

/// Runs the model over a fixture's days with its weights and thresholds.
List<DayRisk> scoreFixture(Map<String, Object?> fixture) {
  final weights = fixture['weights'] == null
      ? null
      : WeightTable.fromJson(
          (fixture['weights']! as Map).cast<String, Object?>(),
        );
  final thresholds = fixture['thresholds'] == null
      ? const LevelThresholds.population()
      : LevelThresholds.fromJson(
          (fixture['thresholds']! as Map).cast<String, Object?>(),
        );
  final load = DailyLoad(weights: weights, thresholds: thresholds);
  return [
    for (final d in fixture['days']! as List)
      load.compute(DayInputs.fromJson((d as Map).cast<String, Object?>())),
  ];
}
