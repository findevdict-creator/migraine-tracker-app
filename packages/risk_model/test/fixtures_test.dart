import 'dart:convert';
import 'dart:io';

import 'package:risk_model/risk_model.dart';
import 'package:test/test.dart';

import '../bin/score.dart' as score;

/// Every fixture under `test/fixtures/users` must reproduce its frozen
/// expected outputs exactly. Regenerate with
/// `dart run risk_model:score --write-expected test/fixtures/users/*.json`
/// and bump [modelVersion] when any number changes.
void main() {
  final dir = Directory('test/fixtures/users');
  final files = dir.listSync().whereType<File>().toList()
    ..sort((a, b) => a.path.compareTo(b.path));
  test('there are fixtures', () => expect(files, isNotEmpty));
  for (final file in files) {
    test(file.uri.pathSegments.last, () {
      final fixture = (jsonDecode(file.readAsStringSync()) as Map)
          .cast<String, Object?>();
      expect(fixture['modelVersion'], modelVersion);
      final results = score.scoreFixture(fixture);
      final expected = fixture['expected']! as List;
      expect(results.length, expected.length);
      for (var i = 0; i < results.length; i++) {
        expect(
          results[i].toJson(),
          (expected[i] as Map).cast<String, Object?>(),
          reason: 'day ${results[i].date}',
        );
      }
    });
  }
}
