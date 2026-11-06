// Pseudo-localization. Writes app_en_XA.arb from app_en.arb: every letter
// accented, every message wrapped in ⟦ ⟧ and padded by about a third, so
// a widget test can spot clipped text (the closing ⟧ is missing) and copy
// that skipped the translation files (plain ASCII words on screen).
//
// Placeholders and ICU plural/select syntax are kept as they are; only the
// message text inside them changes.
//
// Usage:
//   dart run tool/pseudo_arb.dart          write the file
//   dart run tool/pseudo_arb.dart --check  fail if it is out of date (CI)
import 'dart:convert';
import 'dart:io';

const _arbDir = 'lib/core/l10n/arb';
const _source = '$_arbDir/app_en.arb';
const _target = '$_arbDir/app_en_XA.arb';

const _accents = {
  'a': 'á', 'b': 'ƀ', 'c': 'ç', 'd': 'ð', 'e': 'é', 'f': 'ƒ', 'g': 'ĝ',
  'h': 'ĥ', 'i': 'î', 'j': 'ĵ', 'k': 'ķ', 'l': 'ļ', 'm': 'ɱ', 'n': 'ñ',
  'o': 'ö', 'p': 'þ', 'q': 'ǫ', 'r': 'ŕ', 's': 'š', 't': 'ţ', 'u': 'û',
  'v': 'ṽ', 'w': 'ŵ', 'x': 'ẋ', 'y': 'ý', 'z': 'ž', //
  'A': 'Å', 'B': 'Ɓ', 'C': 'Ç', 'D': 'Ð', 'E': 'É', 'F': 'Ƒ', 'G': 'Ĝ',
  'H': 'Ĥ', 'I': 'Î', 'J': 'Ĵ', 'K': 'Ķ', 'L': 'Ļ', 'M': 'Ṁ', 'N': 'Ñ',
  'O': 'Ö', 'P': 'Þ', 'Q': 'Ǫ', 'R': 'Ŕ', 'S': 'Š', 'T': 'Ţ', 'U': 'Û',
  'V': 'Ṽ', 'W': 'Ŵ', 'X': 'Ẋ', 'Y': 'Ý', 'Z': 'Ž',
};

/// Opening and closing marks around every pseudo message.
const open = '⟦';
const close = '⟧';

void main(List<String> args) {
  final source =
      jsonDecode(File(_source).readAsStringSync()) as Map<String, dynamic>;
  final out = <String, dynamic>{'@@locale': 'en_XA'};
  for (final MapEntry(:key, :value) in source.entries) {
    if (key.startsWith('@') || value is! String) continue;
    out[key] = pseudo(value);
  }
  final text = '${const JsonEncoder.withIndent('  ').convert(out)}\n';
  final file = File(_target);
  if (args.contains('--check')) {
    if (!file.existsSync() || file.readAsStringSync() != text) {
      stderr.writeln(
        'pseudo_arb: $_target is out of date; run dart run tool/pseudo_arb.dart',
      );
      exitCode = 1;
    } else {
      stdout.writeln('pseudo_arb: ok');
    }
    return;
  }
  file.writeAsStringSync(text);
  stdout.writeln('pseudo_arb: wrote $_target');
}

/// The pseudo form of one ICU message.
String pseudo(String message) {
  final body = _Message(message).transform();
  final letters = message.replaceAll(RegExp(r'\{[^{}]*\}'), '').length;
  final pad = '·' * ((letters * 0.35).ceil().clamp(1, 40));
  return '$open$body $pad$close';
}

class _Message {
  _Message(this.s);

  final String s;
  int i = 0;

  /// Text up to the end of the string or an unmatched `}`.
  String transform() {
    final out = StringBuffer();
    while (i < s.length) {
      final c = s[i];
      if (c == '}') break;
      if (c == '{') {
        out.write(_argument());
      } else {
        out.write(_accents[c] ?? c);
        i++;
      }
    }
    return out.toString();
  }

  /// `{name}` verbatim, or `{name, plural|select, sel{msg} ...}` with each
  /// msg transformed.
  String _argument() {
    final start = i;
    final head = RegExp(r'\{\s*\w+\s*(,\s*(plural|select)\s*,)?');
    final match = head.matchAsPrefix(s, i)!;
    if (match.group(1) == null) {
      final end = s.indexOf('}', i);
      i = end + 1;
      return s.substring(start, i);
    }
    final out = StringBuffer(match[0]!);
    i = match.end;
    while (i < s.length && s[i] != '}') {
      final selector = RegExp(r'\s*[=\w]+\s*').matchAsPrefix(s, i);
      if (selector == null) break;
      out.write(selector.group(0));
      i = selector.end;
      // s[i] is the `{` that opens the branch.
      i++;
      out
        ..write('{')
        ..write(transform())
        ..write('}');
      i++;
    }
    out.write('}');
    i++;
    return out.toString();
  }
}
