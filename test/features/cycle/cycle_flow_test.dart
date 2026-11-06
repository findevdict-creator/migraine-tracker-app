import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_repository_impl.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:migraine_tracker/features/cycle/presentation/cycle_screen.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';

void main() {
  late AppDatabase db;
  final now = DateTime(2026, 11, 6, 9);

  setUp(() => db = newTestDatabase());
  tearDown(() => db.close());

  Future<void> pump(WidgetTester tester) => tester.pumpApp(
    database: db,
    overrides: [clockProvider.overrideWithValue(() => now)],
  );

  DriftCheckinRepository checkins() =>
      DriftCheckinRepository(db, clock: () => now);

  testWidgets('hidden until enabled; nothing cycle-related on the check-in', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('checkin-card')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('checkin-cycle-info')), findsNothing);
    expect(find.byKey(const ValueKey('period-start-2026-11-06')), findsNothing);
  });

  testWidgets('enable, log a period start, see day and phase everywhere', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('home-cycle')));
    await tester.pumpAndSettle();
    expect(find.byType(CycleScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('cycle-today-card')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('cycle-toggle')));
    await tester.pumpAndSettle();
    expect(
      find.text('Log a period start to see your cycle day.'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('period-start-2026-11-06')));
    await tester.pumpAndSettle();
    expect(find.text('Cycle day 1 · Menstrual'), findsOneWidget);
    expect(find.byKey(const ValueKey('period-2026-11-06')), findsOneWidget);

    // The check-in now shows the row and stamps cycleDay on save.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('checkin-card')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('checkin-cycle-info')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('checkin-stress-3')));
    await tester.pumpAndSettle();
    expect((await checkins().byDate('2026-11-06'))!.cycleDay, 1);
  });

  testWidgets('existing check-ins are restamped when starts change', (
    tester,
  ) async {
    await checkins().save(
      const CheckinEntity(date: '2026-11-04')
          .withValue(CheckinField.stress, 2, CheckinSource.typed),
    );
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('home-cycle')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('cycle-toggle')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('period-start-2026-11-06')));
    await tester.pumpAndSettle();
    // Nov 4 is before the only start, so no cycle day.
    expect((await checkins().byDate('2026-11-04'))!.cycleDay, isNull);

    // Add an earlier start from the check-in back-fill strip.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('checkin-card')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('checkin-date-2026-11-01')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('period-start-2026-11-01')));
    await tester.pumpAndSettle();
    expect((await checkins().byDate('2026-11-04'))!.cycleDay, 4);

    // Turning tracking off clears the stamps.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('home-cycle')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('cycle-toggle')));
    await tester.pumpAndSettle();
    expect((await checkins().byDate('2026-11-04'))!.cycleDay, isNull);
    expect(await db.settingsDao.read<bool>('cycle.enabled'), isFalse);
  });

  testWidgets('a start can be removed from the list', (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('home-cycle')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('cycle-toggle')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('period-start-2026-11-06')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('period-delete-2026-11-06')));
    await tester.pumpAndSettle();
    expect(find.text('None logged yet.'), findsOneWidget);
    expect(
      await db.settingsDao.read<List<dynamic>>('cycle.periodStarts'),
      isEmpty,
    );
  });
}
