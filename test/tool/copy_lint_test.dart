import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('copy_lint', () {
    late Directory tmp;

    setUp(() {
      tmp = Directory.systemTemp.createTempSync('copy_lint');
    });

    tearDown(() => tmp.deleteSync(recursive: true));

    Future<ProcessResult> run() => Process.run('dart', [
      'run',
      'tool/copy_lint.dart',
      tmp.path,
    ], workingDirectory: Directory.current.path);

    test('passes clean copy', () async {
      File('${tmp.path}/app_en.arb')
          .writeAsStringSync('{"a": "Your risk level today is Low."}');
      final result = await run();
      expect(result.exitCode, 0, reason: result.stderr.toString());
    });

    test('fails on banned wording', () async {
      File('${tmp.path}/app_en.arb')
          .writeAsStringSync('{"a": "We predict your next attack."}');
      final result = await run();
      expect(result.exitCode, 1);
      expect(result.stderr.toString(), contains('predict'));
    });

    test('ships with clean ARB files', () async {
      final result = await Process.run('dart', [
        'run',
        'tool/copy_lint.dart',
      ], workingDirectory: Directory.current.path);
      expect(result.exitCode, 0, reason: result.stderr.toString());
    });
  });
}
