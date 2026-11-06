import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_screen.dart';

import '../../../support/pump_app.dart';
import '../../../support/test_database.dart';

void main() {
  late AppDatabase db;
  final now = DateTime(2026, 11, 6, 9, 30);

  setUp(() => db = newTestDatabase());
  tearDown(() => db.close());

  Future<void> seed(List<int> hours) async {
    final repo = DriftAttackRepository(db, clock: () => now);
    for (var i = 0; i < hours.length; i++) {
      final start = DateTime(2026, 10, 1 + i, 8);
      await repo.save(
        AttackEntity(
          id: 'past$i',
          startedAt: start,
          endedAt: start.add(Duration(hours: hours[i])),
        ),
      );
    }
  }

  Future<void> startAttack(WidgetTester tester) async {
    await tester.pumpApp(
      database: db,
      overrides: [clockProvider.overrideWithValue(() => now)],
    );
    await tester.tap(find.byKey(const ValueKey('start-attack')));
    await tester.pumpAndSettle();
    expect(find.byType(AttackScreen), findsOneWidget);
  }

  testWidgets('the running attack shows a range and its sample size', (
    tester,
  ) async {
    await seed([3, 4, 5, 6, 8]);
    await startAttack(tester);
    expect(find.text('Typically 4 to 6 h'), findsOneWidget);
    expect(
      find.text(
        'Based on 5 past attacks of similar intensity without '
        'medication',
      ),
      findsOneWidget,
    );
  });

  testWidgets('nothing shows with fewer than five completed attacks', (
    tester,
  ) async {
    await seed([3, 4, 5, 6]);
    await startAttack(tester);
    expect(
      find.byKey(const ValueKey('attack-duration-estimate')),
      findsNothing,
    );
  });
}
