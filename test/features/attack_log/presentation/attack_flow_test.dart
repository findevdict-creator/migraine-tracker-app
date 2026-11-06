import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_screen.dart';
import 'package:migraine_tracker/features/attack_log/presentation/head_map.dart';
import 'package:migraine_tracker/features/home/presentation/home_screen.dart';

import '../../../support/pump_app.dart';
import '../../../support/test_database.dart';

void main() {
  late AppDatabase db;
  var now = DateTime(2026, 11, 6, 9, 30);

  setUp(() {
    db = newTestDatabase();
    now = DateTime(2026, 11, 6, 9, 30);
  });

  tearDown(() => db.close());

  Future<void> pump(WidgetTester tester) => tester.pumpApp(
    database: db,
    overrides: [clockProvider.overrideWithValue(() => now)],
  );

  Future<AttackEntity> onlyAttack() async =>
      (await DriftAttackRepository(db, clock: () => now).all()).single;

  testWidgets('one tap starts an attack and opens the attack screen', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('start-attack')));
    await tester.pumpAndSettle();

    expect(find.byType(AttackScreen), findsOneWidget);
    final context = tester.element(find.byType(HeadMap));
    expect(context.isAttackTheme, isTrue);
    expect(Theme.of(context).scaffoldBackgroundColor, const Color(0xFF000000));
    expect((await onlyAttack()).isRunning, isTrue);
  });

  testWidgets('intensity, head map, symptoms and phases persist', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('start-attack')));
    await tester.pumpAndSettle();

    final slider = find.descendant(
      of: find.byKey(const ValueKey('attack-intensity')),
      matching: find.byType(Slider),
    );
    await tester.drag(slider, const Offset(400, 0));
    await tester.pumpAndSettle();

    await tester.scrollToKey('head-leftTemple');
    await tester.tap(find.byKey(const ValueKey('head-leftTemple')));
    await tester.pumpAndSettle();

    await tester.scrollToKey('symptom-aura');
    await tester.tap(find.byKey(const ValueKey('symptom-aura')));
    now = now.add(const Duration(minutes: 15));
    await tester.tap(find.byKey(const ValueKey('symptom-nausea')));
    await tester.pumpAndSettle();

    await tester.scrollToKey('phase-postdrome');
    await tester.tap(find.byKey(const ValueKey('phase-postdrome')));
    await tester.pumpAndSettle();

    final attack = await onlyAttack();
    expect(attack.intensity, 10);
    expect(attack.headLocations, {HeadLocation.leftTemple});
    expect(attack.symptoms.map((s) => s.symptom), [
      Symptom.aura,
      Symptom.nausea,
    ]);
    expect(
      attack.symptoms.last.at.difference(attack.symptoms.first.at),
      const Duration(minutes: 15),
    );
    expect(
      attack.phases.keys,
      containsAll([AttackPhase.attack, AttackPhase.postdrome]),
    );
    expect(attack.isRunning, isTrue);
  });

  testWidgets('end attack closes the record and returns home', (tester) async {
    await pump(tester);
    await tester.tap(find.byKey(const ValueKey('start-attack')));
    await tester.pumpAndSettle();

    await tester.scrollToKey('attack-notes');
    await tester.enterText(
      find.byKey(const ValueKey('attack-notes')),
      'long day',
    );
    now = now.add(const Duration(hours: 3));
    await tester.scrollToKey('attack-end');
    await tester.tap(find.byKey(const ValueKey('attack-end')));
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    final attack = await onlyAttack();
    expect(attack.duration, const Duration(hours: 3));
    expect(attack.notes, 'long day');
    expect(find.byKey(const ValueKey('start-attack')), findsOneWidget);
  });

  testWidgets(
    'finish later keeps the attack running and home offers to continue',
    (tester) async {
      await pump(tester);
      await tester.tap(find.byKey(const ValueKey('start-attack')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('attack-finish-later')));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      final attack = await onlyAttack();
      expect(attack.isRunning, isTrue);
      expect(attack.finishLater, isTrue);

      // The same tap reopens the running attack rather than starting another.
      await tester.tap(find.byKey(const ValueKey('start-attack')));
      await tester.pumpAndSettle();
      expect(find.byType(AttackScreen), findsOneWidget);
      expect(await DriftAttackRepository(db, clock: () => now).count(), 1);
    },
  );

  testWidgets('head map regions are announced as buttons', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpLocalized(
      HeadMap(selected: const {HeadLocation.neck}, onToggle: (_) {}),
    );
    expect(
      tester.getSemantics(find.byKey(const ValueKey('head-neck'))),
      matchesSemantics(
        label: 'Neck',
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
        hasTapAction: true,
        hasFocusAction: true,
        isFocusable: true,
      ),
    );
    handle.dispose();
  });
}
