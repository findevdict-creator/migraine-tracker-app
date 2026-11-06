// Hard-coded string lint. Fails on a string literal passed directly to a
// Text, Tooltip or SnackBar widget anywhere under lib/ except the generated
// localizations and the central config.
//
// Usage: dart run tool/string_lint.dart [lib-dir]
import 'dart:io';

final _pattern = RegExp(
  r'''(Text|Tooltip|SnackBar)\(\s*(message:\s*|content:\s*Text\(\s*)?['"]''',
);

const _exemptSegments = <String>['/l10n/', '/config/'];

void main(List<String> args) {
  final root = Directory(args.isEmpty ? 'lib' : args.first);
  final failures = <String>[];
  for (final entity in root.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    if (_exemptSegments.any(entity.path.contains)) continue;
    final lines = entity.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.contains('// string_lint: ignore')) continue;
      if (_pattern.hasMatch(line)) {
        failures.add(
          '${entity.path}:${i + 1}: hard-coded string: '
          '${line.trim()}',
        );
      }
    }
  }
  if (failures.isEmpty) {
    stdout.writeln('string_lint: ok');
    return;
  }
  failures.forEach(stderr.writeln);
  exitCode = 1;
}
