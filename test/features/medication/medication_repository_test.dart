import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/medication/data/medication_repository_impl.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';

import '../../support/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftMedicationRepository repo;
  final t0 = DateTime.utc(2026, 11, 6, 9);

  setUp(() {
    db = newTestDatabase();
    repo = DriftMedicationRepository(db, clock: () => t0);
  });

  tearDown(() => db.close());

  MedicationEntity sample({String id = 'm1', String? attackId}) =>
      MedicationEntity(
        id: id,
        attackId: attackId,
        name: 'Ibuprofen',
        dose: '400 mg',
        takenAt: t0,
        kind: MedicationKind.acute,
        reliefAt2h: Relief.partial,
      );

  test('round-trips every field', () async {
    await repo.save(sample());
    expect(await repo.byId('m1'), sample());
  });

  test('save updates in place and keeps createdAt', () async {
    await repo.save(sample());
    final created = (await db.medicationDao.byId('m1'))!.createdAt;
    repo = DriftMedicationRepository(
      db,
      clock: () => t0.add(const Duration(hours: 3)),
    );
    await repo.save(sample().copyWith(reliefAt2h: Relief.full));
    final row = (await db.medicationDao.byId('m1'))!;
    expect(row.reliefAt2h, 2);
    expect(row.createdAt, created);
    expect((await repo.all()).length, 1);
  });

  test('events follow their attack and survive its deletion', () async {
    final attacks = DriftAttackRepository(db, clock: () => t0);
    await attacks.save(AttackEntity(id: 'a1', startedAt: t0));
    await repo.save(sample(attackId: 'a1'));
    await repo.save(sample(id: 'm2'));
    expect((await repo.forAttack('a1')).map((e) => e.id), ['m1']);
    expect((await repo.watchForAttack('a1').first).length, 1);

    await attacks.delete('a1');
    final orphan = await repo.byId('m1');
    expect(orphan, isNotNull);
    expect(orphan!.attackId, isNull);
  });

  test('recentNames is distinct and most recent first', () async {
    await repo.save(sample(id: 'a').copyWith(name: 'Old', takenAt: t0));
    await repo.save(
      sample(id: 'b')
          .copyWith(name: 'New', takenAt: t0.add(const Duration(days: 1))),
    );
    await repo.save(
      sample(id: 'c')
          .copyWith(name: 'Old', takenAt: t0.add(const Duration(days: 2))),
    );
    expect(await repo.recentNames(), ['Old', 'New']);
  });

  test('inRange and watchRange are half-open', () async {
    await repo.save(sample(id: 'a').copyWith(takenAt: t0));
    await repo.save(
      sample(id: 'b').copyWith(takenAt: t0.add(const Duration(days: 1))),
    );
    final r = await repo.inRange(t0, t0.add(const Duration(days: 1)));
    expect(r.map((e) => e.id), ['a']);
    final w = await repo.watchRange(t0, t0.add(const Duration(days: 2))).first;
    expect(w.map((e) => e.id), ['a', 'b']);
  });
}
