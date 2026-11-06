import 'package:flutter/foundation.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/voice/domain/voice_lexicon.dart';

/// A medication heard in the transcript, matched to one of the person's
/// own names, with a dose when one was said next to it.
@immutable
class VoiceMedication {
  const VoiceMedication({required this.name, this.dose});

  final String name;
  final String? dose;

  @override
  bool operator ==(Object other) =>
      other is VoiceMedication && other.name == name && other.dose == dose;

  @override
  int get hashCode => Object.hash(name, dose);

  @override
  String toString() => dose == null ? name : '$name ($dose)';
}

/// What the parser understood. Nothing is saved until the person confirms
/// it on the form.
@immutable
class VoiceDraft {
  const VoiceDraft({
    required this.transcript,
    this.intensity,
    this.symptoms = const {},
    this.locations = const {},
    this.medications = const [],
  });

  final String transcript;
  final int? intensity;
  final Set<Symptom> symptoms;
  final Set<HeadLocation> locations;
  final List<VoiceMedication> medications;

  bool get isEmpty =>
      intensity == null &&
      symptoms.isEmpty &&
      locations.isEmpty &&
      medications.isEmpty;

  VoiceDraft copyWith({
    int? intensity,
    bool clearIntensity = false,
    Set<Symptom>? symptoms,
    Set<HeadLocation>? locations,
    List<VoiceMedication>? medications,
  }) => VoiceDraft(
    transcript: transcript,
    intensity: clearIntensity ? null : (intensity ?? this.intensity),
    symptoms: symptoms ?? this.symptoms,
    locations: locations ?? this.locations,
    medications: medications ?? this.medications,
  );
}

/// FR-3: turns a spoken sentence into attack fields. Pure: the same
/// transcript, names and lexicon give the same draft.
class VoiceParser {
  const VoiceParser({
    this.lexicon = VoiceLexicon.english,
    this.medicationNames = const [],
  });

  final VoiceLexicon lexicon;

  /// The person's own medication names, as logged before.
  final List<String> medicationNames;

  static final RegExp _token = RegExp(r"\d+(?:[.,]\d+)?|[a-z']+|/");

  static List<String> tokenize(String text) => [
    for (final m in _token.allMatches(text.toLowerCase()))
      m.group(0)!.replaceAll(',', '.'),
  ];

  VoiceDraft parse(String transcript) {
    final tokens = tokenize(transcript);
    final used = List<bool>.filled(tokens.length, false);

    final medications = _medications(tokens, used);
    // Group compound phrases by the symptoms they name: equal const sets
    // are one instance, so a map keyed by phrase-to-set would collapse.
    final compounds = <Set<Symptom>, List<String>>{};
    for (final e in lexicon.compoundSymptoms.entries) {
      compounds.putIfAbsent(e.value, () => []).add(e.key);
    }
    final symptoms = {
      for (final set in _phrases<Set<Symptom>>(tokens, used, compounds)) ...set,
      ..._phrases<Symptom>(tokens, used, lexicon.symptoms),
    };
    final locations = _locations(tokens, used);
    final intensity = _intensity(tokens, used);
    return VoiceDraft(
      transcript: transcript.trim(),
      intensity: intensity,
      symptoms: symptoms,
      locations: locations,
      medications: medications,
    );
  }

  // Phrase matching.

  /// Every key whose phrase appears un-negated, longest phrases first so
  /// "neck tension" wins over the location "neck". Matched tokens are
  /// marked as used, negated ones too, so they are not read twice.
  Set<T> _phrases<T>(
    List<String> tokens,
    List<bool> used,
    Map<T, List<String>> table,
  ) {
    final entries = [
      for (final e in table.entries)
        for (final phrase in e.value) (e.key, tokenize(phrase)),
    ]..sort((a, b) => b.$2.length.compareTo(a.$2.length));
    final found = <T>{};
    for (final (key, phrase) in entries) {
      for (var i = 0; i + phrase.length <= tokens.length; i++) {
        if (!_matchesAt(tokens, used, phrase, i)) continue;
        for (var j = i; j < i + phrase.length; j++) {
          used[j] = true;
        }
        if (!_negated(tokens, i)) found.add(key);
      }
    }
    return found;
  }

  bool _matchesAt(
    List<String> tokens,
    List<bool> used,
    List<String> phrase,
    int at,
  ) {
    for (var j = 0; j < phrase.length; j++) {
      if (used[at + j] || !_same(tokens[at + j], phrase[j])) return false;
    }
    return true;
  }

  /// Equal, or equal up to a plural "s".
  static bool _same(String heard, String expected) =>
      heard == expected || heard == '${expected}s' || '${heard}s' == expected;

  bool _negated(List<String> tokens, int at) {
    for (var k = at - 1; k >= 0 && k >= at - 2; k--) {
      if (lexicon.negators.contains(tokens[k])) return true;
    }
    return false;
  }

  Set<HeadLocation> _locations(List<String> tokens, List<bool> used) {
    final found = <HeadLocation>{};
    for (final both in VoiceLexicon.bothTemples) {
      final phrase = tokenize(both);
      for (var i = 0; i + phrase.length <= tokens.length; i++) {
        if (!_matchesAt(tokens, used, phrase, i)) continue;
        if (phrase.length == 1 && tokens[i] != 'temples') continue;
        for (var j = i; j < i + phrase.length; j++) {
          used[j] = true;
        }
        if (!_negated(tokens, i)) {
          found.addAll({HeadLocation.leftTemple, HeadLocation.rightTemple});
        }
      }
    }
    return found..addAll(_phrases(tokens, used, lexicon.locations));
  }

  // Medications.

  List<VoiceMedication> _medications(List<String> tokens, List<bool> used) {
    final names = [
      for (final n in medicationNames.toSet())
        if (tokenize(n).isNotEmpty) (n, tokenize(n)),
    ]..sort((a, b) => b.$2.length.compareTo(a.$2.length));
    final out = <(int, VoiceMedication)>[];
    for (final (name, phrase) in names) {
      for (var i = 0; i + phrase.length <= tokens.length; i++) {
        if (!_matchesAt(tokens, used, phrase, i)) continue;
        for (var j = i; j < i + phrase.length; j++) {
          used[j] = true;
        }
        if (_negated(tokens, i)) continue;
        final dose = _dose(tokens, used, i, i + phrase.length);
        final med = VoiceMedication(name: name, dose: dose);
        if (!out.any((o) => o.$2 == med)) out.add((i, med));
      }
    }
    out.sort((a, b) => a.$1.compareTo(b.$1));
    return [for (final (_, m) in out) m];
  }

  /// A number and a unit within three words before the name ("400 mg of
  /// ibuprofen", "two tablets of") or right after it ("ibuprofen 400
  /// milligrams").
  String? _dose(List<String> tokens, List<bool> used, int start, int end) {
    String? tryAt(int unitAt) {
      if (unitAt < 1 || unitAt >= tokens.length || used[unitAt]) return null;
      final unit = lexicon.doseUnits[tokens[unitAt]];
      if (unit == null) return null;
      final number = _numberEndingAt(tokens, unitAt - 1);
      if (number == null) return null;
      for (var j = number.$2; j <= unitAt; j++) {
        used[j] = true;
      }
      final value = _format(number.$1);
      return unit == 'mg' ? '$value mg' : '$value $unit';
    }

    for (var k = start - 1; k >= 0 && k >= start - 3; k--) {
      final d = tryAt(k);
      if (d != null) return d;
    }
    for (var k = end + 1; k < tokens.length && k <= end + 2; k++) {
      final d = tryAt(k);
      if (d != null) return d;
    }
    return null;
  }

  static String _format(num n) =>
      n == n.roundToDouble() ? n.toInt().toString() : n.toString();

  // Numbers.

  /// The value of a single token: digits or a number word below twenty.
  num? _simple(String token) =>
      num.tryParse(token) ?? lexicon.numberWords[token];

  /// The number whose last token is [end], read backwards over number
  /// words ("four hundred", "twenty five"). Returns the value and the
  /// index of its first token.
  (num, int)? _numberEndingAt(List<String> tokens, int end) {
    if (end < 0) return null;
    final single = num.tryParse(tokens[end]);
    if (single != null) return (single, end);
    var start = end;
    while (start > 0 && _isNumberWord(tokens[start - 1])) {
      start--;
    }
    if (!_isNumberWord(tokens[end])) return null;
    final value = _wordsValue(tokens.sublist(start, end + 1));
    return value == null ? null : (value, start);
  }

  bool _isNumberWord(String t) =>
      lexicon.numberWords.containsKey(t) ||
      lexicon.tensWords.containsKey(t) ||
      t == lexicon.hundredWord;

  int? _wordsValue(List<String> words) {
    var total = 0;
    var current = 0;
    var any = false;
    for (final w in words) {
      if (lexicon.numberWords[w] case final v?) {
        current += v;
        any = true;
      } else if (lexicon.tensWords[w] case final v?) {
        current += v;
        any = true;
      } else if (w == lexicon.hundredWord) {
        current = (current == 0 ? 1 : current) * 100;
        total += current;
        current = 0;
        any = true;
      } else {
        return null;
      }
    }
    return any ? total + current : null;
  }

  /// A 0 to 10 number that is clearly the intensity: followed by "out of
  /// ten", or within three words after a cue ("pain is a seven"). Falls
  /// back to the plain-language levels ("severe").
  int? _intensity(List<String> tokens, List<bool> used) {
    for (var i = 0; i < tokens.length; i++) {
      if (used[i]) continue;
      final v = _simple(tokens[i]);
      if (v == null || v < 0 || v > 10 || v != v.roundToDouble()) continue;
      if (_followedByOutOfTen(tokens, i + 1)) return v.toInt();
    }
    for (var i = 0; i < tokens.length; i++) {
      if (used[i]) continue;
      final v = _simple(tokens[i]);
      if (v == null || v < 0 || v > 10 || v != v.roundToDouble()) continue;
      for (var k = i - 1; k >= 0 && k >= i - 3; k--) {
        if (lexicon.intensityCues.contains(tokens[k])) return v.toInt();
      }
    }
    for (var i = 0; i < tokens.length; i++) {
      if (used[i]) continue;
      if (lexicon.intensityWords[tokens[i]] case final v?) return v;
    }
    return null;
  }

  bool _followedByOutOfTen(List<String> tokens, int at) {
    for (final seq in lexicon.outOfTen) {
      if (at + seq.length > tokens.length) continue;
      var ok = true;
      for (var j = 0; j < seq.length; j++) {
        if (tokens[at + j] != seq[j]) {
          ok = false;
          break;
        }
      }
      if (ok) return true;
    }
    return false;
  }
}
