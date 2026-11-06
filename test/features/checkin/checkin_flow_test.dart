import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_repository_impl.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:migraine_tracker/features/checkin/presentation/checkin_screen.dart';
import 'package:migraine_tracker/features/home/presentation/home_screen.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';

void main() {
  late AppDatabase db;
  final now = DateTime(2026, 11, 6, 21, 15);

  setUp(() => db = newTestDatabase());
  tearDown(() => db.close());

  Future<void> pump(WidgetTester tester) => tester.pumpApp(
    database: db,
    overrides: [clockProvider.overrideWithValue(() => now)],
  );

  Future<CheckinEntity?> stored(String date) =>
      DriftCheckinRepository(db, clock: () => now).byDate(date);

  testWidgets('three taps complete today and the home card updates', (
    tester,
  ) async {
    await pump(tester);
    expect(find.text('Three taps, about 10 seconds'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('checkin-card')));
    await tester.pumpAndSettle();
    expect(find.byType(CheckinScreen), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('checkin-sleepQuality-4')));
    await tester.tap(find.byKey(const ValueKey('checkin-stress-2')));
    await tester.tap(find.byKey(const ValueKey('checkin-neckTension-3')));
    await tester.pumpAndSettle();
    expect(
      find.text('Done for this day. Tap a number to change it.'),
      findsOneWidget,
    );

    final checkin = (await stored('2026-11-06'))!;
    expect(checkin.isComplete, isTrue);
    expect(checkin[CheckinField.sleepQuality], 4);

    await tester.scrollToKey('checkin-done');
    await tester.tap(find.byKey(const ValueKey('checkin-done')));
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('Done for today'), findsOneWidget);
  });

  testWidgets('optional row is hidden until asked for and persists', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('checkin-card')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('checkin-caffeine-0')), findsNothing);
    await tester.scrollToKey('checkin-more');
    await tester.tap(find.byKey(const ValueKey('checkin-more')));
    await tester.pumpAndSettle();
    await tester.scrollToKey('checkin-caffeine-0');
    await tester.tap(find.byKey(const ValueKey('checkin-caffeine-0')));
    await tester.pumpAndSettle();
    expect((await stored('2026-11-06'))![CheckinField.caffeine], 0);
  });

  testWidgets('back-fill strip opens an earlier day', (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('checkin-card')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('checkin-date-2026-11-07')), findsNothing);
    expect(
      find.byKey(const ValueKey('checkin-date-2026-10-31')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('checkin-date-2026-11-04')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('checkin-stress-5')));
    await tester.pumpAndSettle();
    expect((await stored('2026-11-04'))![CheckinField.stress], 5);
    expect(await stored('2026-11-06'), isNull);
  });

  testWidgets('reminder time can be picked from the app bar', (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('checkin-card')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('checkin-reminder')));
    await tester.pumpAndSettle();
    expect(find.text('Daily check-in reminder'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(await db.settingsDao.read<String>('checkin.reminderTime'), '20:00');
  });
}
