import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/medication/data/medication_repository_impl.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';
import 'package:migraine_tracker/features/voice/data/speech_capture.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';
import '../weather/support/weather_fakes.dart';

/// Plays back a scripted transcript instead of the microphone.
class ScriptedSpeech implements SpeechCapture {
  ScriptedSpeech({this.words, this.available = true});

  final String? words;
  final bool available;
  int listens = 0;
  bool cancelled = false;

  @override
  Future<bool> initialize() async => available;

  @override
  Future<void> listen({
    required void Function(String words) onWords,
    required void Function(String? finalWords, SpeechFailure? failure) onDone,
    String? localeId,
  }) async {
    listens++;
    final w = words;
    if (w == null) {
      onDone(null, SpeechFailure.noMatch);
      return;
    }
    onWords(w);
    onDone(w, null);
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> cancel() async => cancelled = true;
}

void main() {
  late AppDatabase db;
  final now = DateTime(2026, 11, 6, 9, 30);

  setUp(() async {
    db = newTestDatabase();
    // A name the person logged before, so the parser can match it.
    await DriftMedicationRepository(db, clock: () => now).save(
      MedicationEntity(
        id: 'old',
        name: 'Ibuprofen',
        takenAt: now.subtract(const Duration(days: 3)),
        kind: MedicationKind.acute,
      ),
    );
  });
  tearDown(() => db.close());

  Future<AttackEntity> onlyAttack() async =>
      (await DriftAttackRepository(db, clock: () => now).all()).single;

  Future<void> settleUntil(WidgetTester tester, bool Function() done) async {
    for (var i = 0; i < 200 && !done(); i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(done(), isTrue, reason: 'did not settle');
    await tester.pumpAndSettle();
  }

  bool shown(String key) => find.byKey(ValueKey(key)).evaluate().isNotEmpty;

  Future<void> openVoice(WidgetTester tester, ScriptedSpeech speech) async {
    await tester.pumpApp(
      database: db,
      overrides: [
        clockProvider.overrideWithValue(() => now),
        speechCaptureProvider.overrideWithValue(speech),
        locationSourceProvider.overrideWithValue(FakeLocationSource(null)),
        weatherSourceProvider.overrideWithValue(
          FakeWeatherSource(null)..error = Exception('offline'),
        ),
      ],
    );
    await tester.tap(find.byKey(const ValueKey('start-attack')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('attack-voice')));
    await tester.pumpAndSettle();
  }

  Future<void> scrollInSheet(WidgetTester tester, Finder finder) =>
      tester.scrollUntilVisible(
        finder,
        100,
        scrollable: find
            .descendant(
              of: find.byKey(const ValueKey('voice-review')),
              matching: find.byType(Scrollable),
            )
            .first,
      );

  Future<void> tapInSheet(WidgetTester tester, String key) async {
    final finder = find.byKey(ValueKey(key));
    await tester.scrollUntilVisible(
      finder,
      100,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('voice-review')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('a sentence fills the form, edits stick, save writes all', (
    tester,
  ) async {
    await openVoice(
      tester,
      ScriptedSpeech(
        words:
            'pain seven out of ten behind my eyes, nausea, took 400 mg of '
            'ibuprofen',
      ),
    );
    await settleUntil(tester, () => shown('voice-review'));
    expect(
      find.textContaining('pain seven out of ten behind my eyes'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('voice-intensity')), findsOneWidget);
    await scrollInSheet(tester, find.text('Ibuprofen (400 mg)'));
    expect(find.text('Ibuprofen (400 mg)'), findsOneWidget);

    // Add light sensitivity by hand before saving.
    await tapInSheet(tester, 'voice-symptom-lightSensitivity');
    await tapInSheet(tester, 'voice-save');
    await settleUntil(tester, () => !shown('voice-review'));

    final attack = await onlyAttack();
    expect(attack.intensity, 7);
    expect(attack.headLocations, {HeadLocation.behindEyes});
    expect(attack.symptoms.map((s) => s.symptom).toSet(), {
      Symptom.nausea,
      Symptom.lightSensitivity,
    });
    final doses = await DriftMedicationRepository(
      db,
      clock: () => now,
    ).forAttack(attack.id);
    expect(doses.single.name, 'Ibuprofen');
    expect(doses.single.dose, '400 mg');
    expect(doses.single.kind, MedicationKind.acute);
  });

  testWidgets('cancel saves nothing', (tester) async {
    await openVoice(tester, ScriptedSpeech(words: 'pain nine, nausea'));
    await settleUntil(tester, () => shown('voice-review'));
    await tapInSheet(tester, 'voice-cancel');
    final attack = await onlyAttack();
    expect(attack.intensity, isNull);
    expect(attack.symptoms, isEmpty);
  });

  testWidgets('nothing understood: save stays off, try again listens again', (
    tester,
  ) async {
    final speech = ScriptedSpeech(words: 'hello there');
    await openVoice(tester, speech);
    await settleUntil(tester, () => shown('voice-review'));
    expect(find.byKey(const ValueKey('voice-nothing')), findsOneWidget);
    await tapInSheet(tester, 'voice-retry');
    await settleUntil(tester, () => shown('voice-review'));
    expect(speech.listens, 2);
  });

  testWidgets('no recognizer: an explanation and no retry', (tester) async {
    await openVoice(tester, ScriptedSpeech(available: false));
    await settleUntil(tester, () => shown('voice-failed'));
    expect(find.textContaining('Voice is not available'), findsOneWidget);
    expect(find.byKey(const ValueKey('voice-retry')), findsNothing);
  });

  testWidgets('heard nothing: offer to try again', (tester) async {
    await openVoice(tester, ScriptedSpeech());
    await settleUntil(tester, () => shown('voice-failed'));
    expect(find.textContaining('Nothing was heard'), findsOneWidget);
    expect(find.byKey(const ValueKey('voice-retry')), findsOneWidget);
  });
}
