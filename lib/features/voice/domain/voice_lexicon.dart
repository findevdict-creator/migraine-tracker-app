import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';

/// Words the voice parser listens for, per language. This is parsing
/// vocabulary, not display copy: it is matched against what people say,
/// so it holds synonyms and everyday phrasings. English ships now; the
/// localization phase adds a lexicon per supported language.
class VoiceLexicon {
  const VoiceLexicon({
    required this.numberWords,
    required this.tensWords,
    required this.hundredWord,
    required this.intensityCues,
    required this.outOfTen,
    required this.intensityWords,
    required this.negators,
    required this.compoundSymptoms,
    required this.symptoms,
    required this.locations,
    required this.doseUnits,
  });

  /// English, the fallback for every language without its own lexicon.
  static const VoiceLexicon english = VoiceLexicon(
    numberWords: {
      'zero': 0,
      'none': 0,
      'one': 1,
      'two': 2,
      'three': 3,
      'four': 4,
      'five': 5,
      'six': 6,
      'seven': 7,
      'eight': 8,
      'nine': 9,
      'ten': 10,
      'eleven': 11,
      'twelve': 12,
      'thirteen': 13,
      'fourteen': 14,
      'fifteen': 15,
      'sixteen': 16,
      'seventeen': 17,
      'eighteen': 18,
      'nineteen': 19,
    },
    tensWords: {
      'twenty': 20,
      'thirty': 30,
      'forty': 40,
      'fifty': 50,
      'sixty': 60,
      'seventy': 70,
      'eighty': 80,
      'ninety': 90,
    },
    hundredWord: 'hundred',
    intensityCues: [
      'pain',
      'intensity',
      'level',
      'severity',
      'score',
      'about',
      'around',
      'rate',
      'rated',
      'is',
      'at',
    ],
    outOfTen: [
      ['out', 'of', 'ten'],
      ['out', 'of', '10'],
      ['/', '10'],
    ],
    intensityWords: {
      'mild': 3,
      'moderate': 5,
      'severe': 8,
      'excruciating': 10,
      'unbearable': 10,
    },
    negators: [
      'no',
      'not',
      'without',
      'never',
      "isn't",
      "don't",
      "didn't",
      "haven't",
      "hasn't",
      'zero',
    ],
    compoundSymptoms: {
      'light and sound sensitivity': {
        Symptom.lightSensitivity,
        Symptom.soundSensitivity,
      },
      'sound and light sensitivity': {
        Symptom.lightSensitivity,
        Symptom.soundSensitivity,
      },
      'light and noise sensitivity': {
        Symptom.lightSensitivity,
        Symptom.soundSensitivity,
      },
      'sensitive to light and sound': {
        Symptom.lightSensitivity,
        Symptom.soundSensitivity,
      },
      'sensitive to light and noise': {
        Symptom.lightSensitivity,
        Symptom.soundSensitivity,
      },
    },
    symptoms: {
      Symptom.aura: [
        'aura',
        'zigzag',
        'zigzags',
        'zig zag',
        'zig zags',
        'flashing lights',
        'blind spot',
        'visual disturbance',
        'sparkles',
      ],
      Symptom.neckTension: [
        'neck tension',
        'tense neck',
        'stiff neck',
        'neck is stiff',
        'neck is tight',
        'tight neck',
        'neck pain',
      ],
      Symptom.lightSensitivity: [
        'light sensitivity',
        'sensitive to light',
        'light sensitive',
        'light hurts',
        'light bothers me',
        'photophobia',
        'bright light',
        'lights hurt',
      ],
      Symptom.soundSensitivity: [
        'sound sensitivity',
        'sensitive to sound',
        'sensitive to noise',
        'noise hurts',
        'noise bothers me',
        'sound hurts',
        'phonophobia',
        'loud noise',
      ],
      Symptom.smellSensitivity: [
        'smell sensitivity',
        'sensitive to smell',
        'sensitive to smells',
        'smells bother me',
        'smells',
        'odours',
        'odors',
        'osmophobia',
      ],
      Symptom.nausea: [
        'nausea',
        'nauseous',
        'nauseated',
        'queasy',
        'feel sick',
        'feeling sick',
        'sick to my stomach',
        'vomiting',
        'vomited',
        'threw up',
        'throwing up',
      ],
    },
    locations: {
      HeadLocation.forehead: [
        'forehead',
        'front of my head',
        'front of the head',
        'front of head',
      ],
      HeadLocation.leftTemple: ['left temple'],
      HeadLocation.rightTemple: ['right temple'],
      HeadLocation.behindEyes: [
        'behind my eyes',
        'behind my eye',
        'behind the eyes',
        'behind the eye',
        'behind eyes',
        'behind eye',
        'behind my left eye',
        'behind my right eye',
      ],
      HeadLocation.leftSide: [
        'left side',
        'left side of my head',
        'left side of the head',
        'left half',
      ],
      HeadLocation.rightSide: [
        'right side',
        'right side of my head',
        'right side of the head',
        'right half',
      ],
      HeadLocation.topOfHead: [
        'top of my head',
        'top of the head',
        'top of head',
        'crown',
      ],
      HeadLocation.backOfHead: [
        'back of my head',
        'back of the head',
        'back of head',
        'base of my skull',
        'base of the skull',
      ],
      HeadLocation.neck: ['neck'],
    },
    doseUnits: {
      'mg': 'mg',
      'milligram': 'mg',
      'milligrams': 'mg',
      'tablet': 'tablet',
      'tablets': 'tablet',
      'pill': 'tablet',
      'pills': 'tablet',
      'capsule': 'capsule',
      'capsules': 'capsule',
    },
  );

  /// Both temples, said together.
  static const List<String> bothTemples = ['temples', 'both temples'];

  final Map<String, int> numberWords;
  final Map<String, int> tensWords;
  final String hundredWord;

  /// Words after which a number in range is the intensity.
  final List<String> intensityCues;

  /// Token sequences that, after a number, mark it as the intensity.
  final List<List<String>> outOfTen;

  /// Plain-language levels mapped onto the 0 to 10 scale.
  final Map<String, int> intensityWords;

  /// A negator up to two words before a phrase cancels it.
  final List<String> negators;

  /// One phrase naming two symptoms ("light and sound sensitivity").
  final Map<String, Set<Symptom>> compoundSymptoms;
  final Map<Symptom, List<String>> symptoms;
  final Map<HeadLocation, List<String>> locations;

  /// Spoken unit to the unit written in the dose field.
  final Map<String, String> doseUnits;

  /// The lexicon for a language code; English until others are added.
  static VoiceLexicon forLanguage(String languageCode) => english;
}
