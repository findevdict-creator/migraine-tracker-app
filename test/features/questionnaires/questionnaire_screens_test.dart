import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/notifications/data/local_notification_gateway.dart';
import 'package:migraine_tracker/features/questionnaires/data/questionnaire_repository_impl.dart';
import 'package:migraine_tracker/features/questionnaires/domain/questionnaire.dart';
import 'package:migraine_tracker/features/questionnaires/presentation/questionnaires_screen.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';
import '../notifications/support/fake_gateway.dart';
import '../weather/support/weather_fakes.dart';

void main() {
  late AppDatabase db;
  late RecordingGateway gateway;
  final now = DateTime(2026, 11, 6, 9);

  setUp(() {
    db = newTestDatabase();
    gateway = RecordingGateway();
  });
  tearDown(() => db.close());

  Future<void> settleUntil(WidgetTester tester, bool Function() done) async {
    for (var i = 0; i < 400 && !done(); i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(done(), isTrue, reason: 'did not settle');
    await tester.pumpAndSettle();
  }

  bool shown(String key) => find.byKey(ValueKey(key)).evaluate().isNotEmpty;

  Future<void> open(WidgetTester tester) async {
    await tester.pumpApp(
      database: db,
      overrides: [
        clockProvider.overrideWithValue(() => now),
        notificationGatewayProvider.overrideWithValue(gateway),
        locationSourceProvider.overrideWithValue(FakeLocationSource(null)),
        weatherSourceProvider.overrideWithValue(
          FakeWeatherSource(null)..error = Exception('offline'),
        ),
      ],
    );
    await tester.tap(find.byKey(const ValueKey('home-settings')));
    await tester.pumpAndSettle();
    await tester.scrollToKey('settings-questionnaires');
    await tester.tap(find.byKey(const ValueKey('settings-questionnaires')));
    await tester.pumpAndSettle();
    expect(find.byType(QuestionnairesScreen), findsOneWidget);
    await settleUntil(tester, () => shown('questionnaire-latest-hit6'));
  }

  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.scrollToKey(key);
    await tester.tap(find.byKey(ValueKey(key)));
    await tester.pumpAndSettle();
  }

  testWidgets('HIT-6: answer six questions, see the score and band', (
    tester,
  ) async {
    await open(tester);
    expect(find.text('Not filled in yet'), findsNWidgets(2));
    await tapKey(tester, 'questionnaire-start-hit6');

    final save = find.byKey(const ValueKey('questionnaire-save'));
    for (final item in Hit6.items) {
      await tapKey(tester, 'hit6-$item-sometimes');
    }
    await tester.scrollToKey('questionnaire-save');
    expect(
      tester
          .widget<FilledButton>(
            find.descendant(of: save, matching: find.byType(FilledButton)),
          )
          .onPressed,
      isNotNull,
    );
    await tester.tap(save);
    await settleUntil(tester, () => shown('questionnaire-result'));
    expect(find.text('Your score: 60'), findsOneWidget);
    expect(find.text('Severe impact'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('questionnaire-result-done')));
    await settleUntil(
      tester,
      () => find.textContaining('Last score 60').evaluate().isNotEmpty,
    );
    expect(
      find.byKey(const ValueKey('questionnaire-due-hit6')),
      findsOneWidget,
    );
    expect(find.text('Next round Feb 4, 2027'), findsOneWidget);

    final stored = await DriftQuestionnaireRepository(db).all();
    expect(stored.single.score, 60);
  });

  testWidgets('MIDAS: save stays off until the five day counts are in', (
    tester,
  ) async {
    await open(tester);
    await tapKey(tester, 'questionnaire-start-midas');
    // The hint sits above the save button at the end of a lazy list.
    Future<bool> incomplete() async {
      await tester.scrollToKey('questionnaire-save');
      return shown('questionnaire-incomplete');
    }

    expect(await incomplete(), isTrue);

    final days = {'q1': '0', 'q2': '4', 'q3': '2', 'q4': '6'};
    for (final e in days.entries) {
      await tester.scrollToKey('midas-${e.key}');
      await tester.enterText(find.byKey(ValueKey('midas-${e.key}')), e.value);
      await tester.pumpAndSettle();
    }
    expect(await incomplete(), isTrue);
    await tester.scrollToKey('midas-q5');
    await tester.enterText(find.byKey(const ValueKey('midas-q5')), '3');
    await tester.pumpAndSettle();
    expect(await incomplete(), isFalse);

    await tapKey(tester, 'questionnaire-save');
    await settleUntil(tester, () => shown('questionnaire-result'));
    expect(find.text('Your score: 15'), findsOneWidget);
    expect(find.text('Grade III: moderate disability'), findsOneWidget);
  });

  testWidgets('history of two or more rounds draws the chart', (tester) async {
    final repo = DriftQuestionnaireRepository(db);
    for (final (i, points) in [13, 10, 8].indexed) {
      await repo.save(
        QuestionnaireResponse.scored(
          id: 'h$i',
          kind: QuestionnaireKind.hit6,
          completedAt: DateTime(2026, 2 + i * 3),
          answers: {for (final item in Hit6.items) item: points},
        ),
      );
    }
    await open(tester);
    expect(find.textContaining('Last score 48'), findsOneWidget);
    expect(find.text('Little or no impact'), findsOneWidget);
    expect(find.text('Due now'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('3 scores from .* latest 48')),
      findsOneWidget,
    );
  });
}
