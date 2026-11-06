// Copy safety lint. Fails when a translation file uses wording that claims
// prediction, diagnosis or cure. The list is owned by the clinician reviewer.
//
// Usage: dart run tool/copy_lint.dart [arb-dir]
import 'dart:convert';
import 'dart:io';

const bannedPhrases = <String>['predict', 'diagnos', 'see it coming', 'cure'];

void main(List<String> args) {
  final dir = Directory(args.isEmpty ? 'lib/core/l10n/arb' : args.first);
  if (!dir.existsSync()) {
    stderr.writeln('copy_lint: directory not found: ${dir.path}');
    exit(2);
  }
  final failures = <String>[];
  final arbFiles = dir.listSync().whereType<File>().where(
    (f) => f.path.endsWith('.arb'),
  );
  for (final file in arbFiles) {
    final path = file.path;
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    for (final entry in json.entries) {
      final value = entry.value;
      if (entry.key.startsWith('@') || value is! String) continue;
      final lower = value.toLowerCase();
      for (final phrase in bannedPhrases) {
        if (lower.contains(phrase)) {
          failures.add('$path: "${entry.key}" contains "$phrase"');
        }
      }
    }
  }
  if (failures.isEmpty) {
    stdout.writeln('copy_lint: ok');
    return;
  }
  failures.forEach(stderr.writeln);
  exitCode = 1;
}
