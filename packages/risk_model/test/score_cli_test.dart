import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('prints usage without arguments', () async {
    final r = await Process.run('dart', ['run', 'bin/score.dart']);
    expect(r.exitCode, 64);
    expect(r.stderr, contains('usage'));
  });

  test('scores a fixture', () async {
    final r = await Process.run('dart', [
      'run',
      'bin/score.dart',
      'test/fixtures/users/steady.json',
    ]);
    expect(r.exitCode, 0, reason: '${r.stderr}');
    final out = (jsonDecode(r.stdout as String) as Map).cast<String, Object?>();
    expect(out['name'], 'steady');
    expect(out['results'], isNotEmpty);
  });

  test('writes expected outputs into a copy', () async {
    final tmp = Directory.systemTemp.createTempSync('risk_model');
    addTearDown(() => tmp.deleteSync(recursive: true));
    final copy = File('${tmp.path}/f.json')
      ..writeAsStringSync(
        jsonEncode({
          'name': 'tmp',
          'days': [
            {'date': '2026-01-01', 'stress': 5},
          ],
        }),
      );
    final r = await Process.run('dart', [
      'run',
      'bin/score.dart',
      '--write-expected',
      copy.path,
    ]);
    expect(r.exitCode, 0, reason: '${r.stderr}');
    final written = (jsonDecode(copy.readAsStringSync()) as Map)
        .cast<String, Object?>();
    expect((written['expected']! as List).length, 1);
    expect(written['modelVersion'], isNotNull);
  });
}
