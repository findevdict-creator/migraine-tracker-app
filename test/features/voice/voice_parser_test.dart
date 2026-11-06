import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/voice/domain/voice_parser.dart';

/// A phrase corpus: what people say mid-attack, and what should land on
/// the form. Each case lists only the fields it cares about.
class _Case {
  const _Case(
    this.phrase, {
    this.intensity,
    this.symptoms = const {},
    this.locations = const {},
    this.medications = const [],
  });

  final String phrase;
  final int? intensity;
  final Set<Symptom> symptoms;
  final Set<HeadLocation> locations;
  final List<VoiceMedication> medications;
}

void main() {
  const parser = VoiceParser(
    medicationNames: [
      'Ibuprofen',
      'Sumatriptan',
      'Excedrin Migraine',
      'Rizatriptan',
    ],
  );

  const corpus = <_Case>[
    _Case('pain is seven out of ten', intensity: 7),
    _Case('Pain 6/10, nausea', intensity: 6, symptoms: {Symptom.nausea}),
    _Case('intensity eight', intensity: 8),
    _Case('it is about a five', intensity: 5),
    _Case(
      'pain level is 9 and the light hurts',
      intensity: 9,
      symptoms: {Symptom.lightSensitivity},
    ),
    _Case(
      'severe headache behind my eyes',
      intensity: 8,
      locations: {HeadLocation.behindEyes},
    ),
    _Case(
      'mild, left temple',
      intensity: 3,
      locations: {HeadLocation.leftTemple},
    ),
    _Case(
      'right side of my head and my neck is stiff',
      symptoms: {Symptom.neckTension},
      locations: {HeadLocation.rightSide},
    ),
    _Case(
      'it hurts at the back of my head and my neck',
      locations: {HeadLocation.backOfHead, HeadLocation.neck},
    ),
    _Case(
      'both temples',
      locations: {HeadLocation.leftTemple, HeadLocation.rightTemple},
    ),
    _Case(
      'throbbing in my temples, sensitive to sound',
      symptoms: {Symptom.soundSensitivity},
      locations: {HeadLocation.leftTemple, HeadLocation.rightTemple},
    ),
    _Case(
      'zigzags in my vision then a headache on top of my head',
      symptoms: {Symptom.aura},
      locations: {HeadLocation.topOfHead},
    ),
    _Case(
      'I feel sick and smells bother me',
      symptoms: {Symptom.nausea, Symptom.smellSensitivity},
    ),
    _Case(
      'no nausea but light sensitivity',
      symptoms: {Symptom.lightSensitivity},
    ),
    _Case(
      'without aura this time, forehead',
      locations: {HeadLocation.forehead},
    ),
    _Case('took ibuprofen', medications: [VoiceMedication(name: 'Ibuprofen')]),
    _Case(
      'I took 400 mg of ibuprofen',
      medications: [VoiceMedication(name: 'Ibuprofen', dose: '400 mg')],
    ),
    _Case(
      'took four hundred milligrams ibuprofen, pain seven',
      intensity: 7,
      medications: [VoiceMedication(name: 'Ibuprofen', dose: '400 mg')],
    ),
    _Case(
      'sumatriptan 50 milligrams',
      medications: [VoiceMedication(name: 'Sumatriptan', dose: '50 mg')],
    ),
    _Case(
      'two tablets of excedrin migraine',
      medications: [
        VoiceMedication(name: 'Excedrin Migraine', dose: '2 tablet'),
      ],
    ),
    _Case(
      'took a rizatriptan and an ibuprofen',
      medications: [
        VoiceMedication(name: 'Rizatriptan'),
        VoiceMedication(name: 'Ibuprofen'),
      ],
    ),
    _Case("didn't take sumatriptan yet, pain is a four", intensity: 4),
    _Case(
      'Pain eight out of ten, nauseous, light and sound sensitivity, '
      'left side, took sumatriptan',
      intensity: 8,
      symptoms: {
        Symptom.nausea,
        Symptom.lightSensitivity,
        Symptom.soundSensitivity,
      },
      locations: {HeadLocation.leftSide},
      medications: [VoiceMedication(name: 'Sumatriptan')],
    ),
    _Case('started two hours ago'),
    _Case('hello'),
    _Case(''),
  ];

  for (final c in corpus) {
    test('"${c.phrase}"', () {
      final d = parser.parse(c.phrase);
      expect(d.intensity, c.intensity, reason: 'intensity');
      expect(d.symptoms, c.symptoms, reason: 'symptoms');
      expect(d.locations, c.locations, reason: 'locations');
      expect(d.medications, c.medications, reason: 'medications');
    });
  }

  test('a dose number is not read as the intensity', () {
    final d = parser.parse('took 2 tablets of ibuprofen');
    expect(d.intensity, isNull);
    expect(d.medications.single.dose, '2 tablet');
  });

  test("names are matched only from the person's own list", () {
    final d = const VoiceParser().parse('took ibuprofen');
    expect(d.medications, isEmpty);
    expect(d.isEmpty, isTrue);
  });

  test('numbers outside 0 to 10 are never the intensity', () {
    expect(parser.parse('pain is 12').intensity, isNull);
    expect(parser.parse('pain is 7.5').intensity, isNull);
  });

  test('the transcript is kept, trimmed', () {
    expect(parser.parse('  pain is seven  ').transcript, 'pain is seven');
  });

  test('copyWith can clear the intensity', () {
    final d = parser.parse('pain 5 out of 10');
    expect(d.copyWith(clearIntensity: true).intensity, isNull);
    expect(d.copyWith(symptoms: {Symptom.aura}).symptoms, {Symptom.aura});
  });
}
