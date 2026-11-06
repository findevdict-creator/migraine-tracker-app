import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart' hide RiskDay;
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_repository_impl.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:migraine_tracker/features/routines/presentation/routine_screen.dart';
import 'package:migraine_tracker/features/routines/presentation/routines_screen.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';
import '../weather/support/weather_fakes.dart';

void main() {
  late AppDatabase db;
  final now = DateTime(2026, 11, 6, 9);

  setUp(() => db = newTestDatabase());
  tearDown(() => db.close());

  Future<void> settleUntil(WidgetTester tester, bool Function() done) async {
    for (var i = 0; i < 400 && !done(); i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(done(), isTrue, reason: 'did not settle');
    await tester.pumpAndSettle();
  }

  bool shown(String key) => find.byKey(ValueKey(key)).evaluate().isNotEmpty;

  Future<void> pump(WidgetTester tester) => tester.pumpApp(
    database: db,
    overrides: [
      clockProvider.overrideWithValue(() => now),
      locationSourceProvider.overrideWithValue(FakeLocationSource(null)),
      weatherSourceProvider.overrideWithValue(
        FakeWeatherSource(null)..error = Exception('offline'),
      ),
    ],
  );

  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.scrollToKey(key);
    await tester.tap(find.byKey(ValueKey(key)));
    await tester.pumpAndSettle();
  }

  Future<void> tenseCheckin() =>
      DriftCheckinRepository(db, clock: () => now).save(
        const CheckinEntity(
          date: '2026-11-06',
          values: {
            CheckinField.sleepQuality: 3,
            CheckinField.stress: 2,
            CheckinField.neckTension: 5,
          },
        ),
      );

  testWidgets('no suggestion card on a calm day', (tester) async {
    await pump(tester);
    await tester.pumpAndSettle();
    expect(shown('routine-card'), isFalse);
  });

  testWidgets('a tense-neck check-in suggests stretches; the card opens '
      'the routine and "Not today" hides it for the day', (tester) async {
    await tenseCheckin();
    await pump(tester);
    await settleUntil(tester, () => shown('routine-suggestion-stretches'));
    expect(find.text('Your check-in shows neck tension'), findsOneWidget);

    await tapKey(tester, 'routine-suggestion-stretches');
    expect(find.byType(RoutineScreen), findsOneWidget);
    expect(find.text('Gentle neck and shoulder stretches'), findsWidgets);
    await tester.scrollToKey('routine-disclaimer');
    expect(find.text(_en.wellnessDisclaimer), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tapKey(tester, 'routine-not-today');
    await settleUntil(tester, () => !shown('routine-card'));
    final stored = await SettingsRepository(db)
        .read<Map<String, dynamic>>(SettingsKeys.routinesDismissed);
    expect(stored, {
      'date': '2026-11-06',
      'codes': ['stretches'],
    });
  });

  testWidgets('settings opens the routine list with every routine', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('home-settings')));
    await tester.pumpAndSettle();
    await tapKey(tester, 'settings-routines');
    expect(find.byType(RoutinesScreen), findsOneWidget);
    for (final code in [
      'stretches',
      'breathing',
      'lowLight',
      'hydration',
      'caffeine',
      'sleep',
    ]) {
      await tester.scrollToKey('routine-$code');
      expect(shown('routine-$code'), isTrue, reason: code);
    }
    await tester.scrollToKey('routines-disclaimer');
    expect(shown('routines-disclaimer'), isTrue);
  });

  testWidgets('the breathing pacer runs six rounds, can stop, and ends '
      'with a closing line', (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('home-settings')));
    await tester.pumpAndSettle();
    await tapKey(tester, 'settings-routines');
    await tapKey(tester, 'routine-breathing');

    // Plain pumps from here: pumpAndSettle would run the animation, and
    // with it the timers, to the end.
    await tester.scrollToKey('breathing-start');
    await tester.tap(find.byKey(const ValueKey('breathing-start')));
    await tester.pump();
    expect(find.text('Breathe in'), findsOneWidget);
    expect(find.text('Round 1 of 6'), findsOneWidget);
    await tester.pump(AppThresholds.breathingIn);
    expect(find.text('Breathe out'), findsOneWidget);
    await tester.pump(AppThresholds.breathingOut);
    expect(find.text('Round 2 of 6'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('breathing-stop')));
    await tester.pump();
    expect(shown('breathing-start'), isTrue);
    expect(shown('breathing-round'), isFalse);

    await tester.tap(find.byKey(const ValueKey('breathing-start')));
    await tester.pump();
    for (var i = 0; i < AppThresholds.breathingRounds; i++) {
      await tester.pump(AppThresholds.breathingIn);
      await tester.pump(AppThresholds.breathingOut);
    }
    await tester.pumpAndSettle();
    expect(find.text('Done. Take a moment before you get up.'), findsOneWidget);
    expect(shown('breathing-start'), isTrue);
  });
}

final AppLocalizations _en = lookupAppLocalizations(AppLocales.fallback);
