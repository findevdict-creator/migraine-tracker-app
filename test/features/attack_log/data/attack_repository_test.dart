import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_mapper.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';

import '../../../support/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftAttackRepository repo;
  final t0 = DateTime.utc(2026, 11, 6, 9, 30);

  setUp(() {
    db = newTestDatabase();
    repo = DriftAttackRepository(db, clock: () => t0);
  });

  tearDown(() => db.close());

  AttackEntity sample() => AttackEntity(
    id: 'a1',
    startedAt: t0,
    intensity: 7,
    headLocations: const {HeadLocation.leftTemple, HeadLocation.behindEyes},
    phases: {
      AttackPhase.prodrome: t0.subtract(const Duration(hours: 2)),
      AttackPhase.attack: t0,
    },
    symptoms: [
      SymptomTap(symptom: Symptom.aura, at: t0),
      SymptomTap(
        symptom: Symptom.nausea,
        at: t0.add(const Duration(minutes: 5)),
      ),
    ],
    notes: 'skipped lunch',
  );

  group('AttackMapper', () {
    test('round-trips every field through the row shape', () async {
      final entity = sample();
      await db.attackDao.upsert(AttackMapper.toCompanion(entity, now: t0));
      final row = await db.attackDao.byId('a1');
      expect(AttackMapper.toEntity(row!), entity);
    });

    test('drops unknown codes instead of crashing', () async {
      final entity = sample();
      await db.attackDao.upsert(AttackMapper.toCompanion(entity, now: t0));
      await db.customUpdate(
        "UPDATE attacks SET head_locations = '[\"leftTemple\",\"nope\"]', "
        "symptoms = '[{\"code\":\"gone\", "
        "\"at\":\"2026-01-01T00:00:00.000Z\"}]'",
      );
      final row = await db.attackDao.byId('a1');
      final back = AttackMapper.toEntity(row!);
      expect(back.headLocations, {HeadLocation.leftTemple});
      expect(back.symptoms, isEmpty);
    });
  });

  group('DriftAttackRepository', () {
    test('save inserts then updates, keeping createdAt', () async {
      await repo.save(sample());
      final created = (await db.attackDao.byId('a1'))!.createdAt;

      repo = DriftAttackRepository(
        db,
        clock: () => t0.add(const Duration(hours: 1)),
      );
      await repo.save(sample().copyWith(intensity: 9));
      final row = (await db.attackDao.byId('a1'))!;
      expect(row.intensity, 9);
      expect(row.createdAt, created);
      expect(row.updatedAt, t0.add(const Duration(hours: 1)));
      expect(await repo.count(), 1);
    });

    test('running and completed are split by endedAt', () async {
      await repo.save(sample());
      expect((await repo.running())?.id, 'a1');
      expect(await repo.completed(), isEmpty);

      await repo.save(
        sample().copyWith(endedAt: t0.add(const Duration(hours: 3))),
      );
      expect(await repo.running(), isNull);
      expect(
        (await repo.completed()).single.duration,
        const Duration(hours: 3),
      );
    });

    test('watchRunning emits on change', () async {
      final events = <String?>[];
      final sub = repo.watchRunning().listen((a) => events.add(a?.id));
      await pumpEventQueue();
      await repo.save(sample());
      await pumpEventQueue();
      await repo.save(sample().copyWith(endedAt: t0));
      await pumpEventQueue();
      await sub.cancel();
      expect(events, [null, 'a1', null]);
    });

    test('delete removes the attack', () async {
      await repo.save(sample());
      await repo.delete('a1');
      expect(await repo.byId('a1'), isNull);
    });
  });
}
