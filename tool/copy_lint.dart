// Copy safety lint. Fails when a translation file uses wording that claims
// prediction, diagnosis or cure. The list is owned by the clinician reviewer.
//
// English phrases are checked in every file (an untranslated string is still
// shown), at the start of a word so French "mercure" (mercury) passes. Each
// language adds the word stems that mean the same in it, also matched at the
// start of a word, so Spanish "cura" catches "curar" but not "procurar".
// German "Vorhersage" is the weather forecast and is allowed; "voraussagen"
// (to foretell) is not.
//
// Usage: dart run tool/copy_lint.dart [arb-dir]
import 'dart:convert';
import 'dart:io';

const bannedPhrases = <String>['predict', 'diagnos', 'see it coming', 'cure'];

/// Per-language stems, keyed by the ARB's `@@locale` language code.
const bannedStems = <String, List<String>>{
  'es': ['predic', 'predec', 'diagnos', 'diagnós', 'diagnóst', 'cura'],
  'pt': [
    'prediz',
    'prediç',
    'predic',
    'diagnos',
    'diagnós',
    'diagnóst',
    'cura',
  ],
  'de': ['voraussag', 'diagnos', 'heilung', 'heilen', 'heilt'],
  'fr': ['prédi', 'predi', 'diagnos', 'guéri', 'gueri'],
  // Scripts without spaces between words: plain substrings.
  'hi': ['भविष्यवाणी', 'निदान'],
  'ja': ['予測', '予言', '診断', '治癒', '完治', '治す'],
};

/// Languages whose stems are matched anywhere, not only at a word start.
const _noWordBreaks = {'hi', 'ja'};

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
    final language = _language(json, path);
    final stems = [
      for (final stem in bannedStems[language] ?? const <String>[])
        if (_noWordBreaks.contains(language))
          RegExp(RegExp.escape(stem))
        else
          _atWordStart(stem),
    ];
    for (final entry in json.entries) {
      final value = entry.value;
      if (entry.key.startsWith('@') || value is! String) continue;
      final lower = value.toLowerCase();
      for (final phrase in bannedPhrases) {
        if (_atWordStart(phrase).hasMatch(lower)) {
          failures.add('$path: "${entry.key}" contains "$phrase"');
        }
      }
      for (final stem in stems) {
        if (stem.hasMatch(lower)) {
          failures.add('$path: "${entry.key}" matches "${stem.pattern}"');
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

RegExp _atWordStart(String stem) =>
    RegExp(r'(?<!\p{L})' + RegExp.escape(stem), unicode: true);

String _language(Map<String, dynamic> json, String path) {
  final locale = json['@@locale'];
  if (locale is String) return locale.split(RegExp('[_-]')).first;
  final match = RegExp(r'_([a-z]{2,3})(?:_[A-Za-z]+)?\.arb$').firstMatch(path);
  return match?.group(1) ?? 'en';
}
