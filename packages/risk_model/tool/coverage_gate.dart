// Fails unless every line under lib/ is covered. Run after
// `dart test --coverage=coverage` and
// `dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib`.
import 'dart:io';

void main(List<String> args) {
  final path = args.isEmpty ? 'coverage/lcov.info' : args.first;
  final lines = File(path).readAsLinesSync();
  var found = 0;
  var hit = 0;
  String? file;
  final misses = <String>[];
  for (final line in lines) {
    if (line.startsWith('SF:')) file = line.substring(3);
    if (line.startsWith('DA:')) {
      final parts = line.substring(3).split(',');
      found++;
      if (int.parse(parts[1]) > 0) {
        hit++;
      } else {
        misses.add('$file:${parts[0]}');
      }
    }
  }
  final pct = found == 0 ? 0.0 : 100 * hit / found;
  stdout.writeln(
    'risk_model line coverage: $hit/$found '
    '(${pct.toStringAsFixed(1)}%)',
  );
  if (hit != found) {
    stderr.writeln('uncovered lines:\n  ${misses.join('\n  ')}');
    exitCode = 1;
  }
}
