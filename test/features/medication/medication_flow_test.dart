import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/medication/data/medication_repository_impl.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';
import 'package:migraine_tracker/features/medication/presentation/medication_log_screen.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';

void main() {
  late AppDatabase db;
  var now = DateTime(2026, 11, 6, 9);

  setUp(() {
    db = newTestDatabase();
    now = DateTime(2026, 11, 6, 9);
  });
  tearDown(() => db.close());

  Future<void> pump(WidgetTester tester) => tester.pumpApp(
    database: db,
    overrides: [clockProvider.overrideWithValue(() => now)],
  );

  DriftMedicationRepository repo() =>
      DriftMedicationRepository(db, clock: () => now);

  Future<void> seedAcuteDays(int days) async {
    for (var d = 1; d <= days; d++) {
      await repo().save(
        MedicationEntity(
          id: 'seed-$d',
          name: 'Seed',
          takenAt: DateTime(2026, 11, d, 8),
          kind: MedicationKind.acute,
        ),
      );
    }
  }

  testWidgets('standalone log: add a dose with name, dose and kind', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('home-medications')));
    await tester.pumpAndSettle();
    expect(find.byType(MedicationLogScreen), findsOneWidget);
    expect(find.text('No doses logged this month.'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('med-add')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('med-name')),
      'Sumatriptan',
    );
    await tester.enterText(find.byKey(const ValueKey('med-dose')), '50 mg');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('med-save')));
    await tester.pumpAndSettle();

    final all = await repo().all();
    expect(all.single.name, 'Sumatriptan');
    expect(all.single.dose, '50 mg');
    expect(all.single.kind, MedicationKind.acute);
    expect(all.single.attackId, isNull);
    expect(find.text('Sumatriptan'), findsOneWidget);
    expect(find.text('1 acute-medication day this month'), findsOneWidget);
  });

  testWidgets('suggestions offer recent names; preventive kind is stored', (
    tester,
  ) async {
    await repo().save(
      MedicationEntity(
        id: 'p',
        name: 'Propranolol',
        takenAt: now.subtract(const Duration(days: 1)),
        kind: MedicationKind.preventive,
      ),
    );
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('home-medications')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('med-add')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('med-suggest-Propranolol')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Preventive'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('med-save')));
    await tester.pumpAndSettle();
    final all = await repo().all();
    expect(all.length, 2);
    expect(all.first.name, 'Propranolol');
    expect(all.first.kind, MedicationKind.preventive);
    expect(find.text('No acute-medication days this month'), findsOneWidget);
  });

  testWidgets('inside an attack the dose is linked and relief is asked', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('start-attack')));
    await tester.pumpAndSettle();
    await tester.scrollToKey('attack-add-medication');
    await tester.tap(find.byKey(const ValueKey('attack-add-medication')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const ValueKey('med-name')), 'Ibuprofen');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('med-save')));
    await tester.pumpAndSettle();

    final event = (await repo().all()).single;
    expect(event.attackId, isNotNull);
    expect(find.byKey(ValueKey('med-tile-${event.id}')), findsOneWidget);
    expect(
      find.byKey(ValueKey('med-relief-${event.id}-partial')),
      findsNothing,
    );

    // Two hours later the relief question appears and stores the answer.
    now = now.add(const Duration(hours: 2, minutes: 1));
    await tester.tap(find.byKey(const ValueKey('attack-finish-later')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('start-attack')));
    await tester.pumpAndSettle();
    await tester.scrollToKey('med-relief-${event.id}-partial');
    await tester.tap(find.byKey(ValueKey('med-relief-${event.id}-partial')));
    await tester.pumpAndSettle();
    expect((await repo().byId(event.id))!.reliefAt2h, Relief.partial);
  });

  testWidgets('overuse notes appear at the config thresholds', (tester) async {
    await seedAcuteDays(AppThresholds.medicationOveruseFirstNote - 1);
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('home-medications')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('overuse-note')), findsNothing);

    await repo().save(
      MedicationEntity(
        id: 'tenth',
        name: 'Seed',
        takenAt: DateTime(2026, 11, 20, 8),
        kind: MedicationKind.acute,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('overuse-note')), findsOneWidget);
    expect(find.textContaining('may be worth a conversation'), findsOneWidget);
    expect(find.byKey(const ValueKey('overuse-link')), findsOneWidget);

    await seedAcuteDays(AppThresholds.medicationOveruseSecondNote);
    await tester.pumpAndSettle();
    expect(find.textContaining('talking to your clinician'), findsOneWidget);
  });

  testWidgets('delete removes a dose', (tester) async {
    await repo().save(
      MedicationEntity(
        id: 'd1',
        name: 'Aspirin',
        takenAt: now,
        kind: MedicationKind.acute,
      ),
    );
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('home-medications')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('med-delete-d1')));
    await tester.pumpAndSettle();
    expect(await repo().all(), isEmpty);
    expect(find.text('No doses logged this month.'), findsOneWidget);
  });
}
