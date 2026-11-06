import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_mapper.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_repository_impl.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';

import '../../support/test_database.dart';

void main() {
  late AppDatabase db;
  late DriftCheckinRepository repo;
  final t0 = DateTime.utc(2026, 11, 6, 20);

  setUp(() {
    db = newTestDatabase();
    repo = DriftCheckinRepository(db, clock: () => t0);
  });

  tearDown(() => db.close());

  CheckinEntity sample() =>
      const CheckinEntity(date: '2026-11-06')
          .withValue(CheckinField.sleepQuality, 4, CheckinSource.typed)
          .withValue(CheckinField.stress, 2, CheckinSource.typed)
          .withValue(CheckinField.neckTension, 3, CheckinSource.healthkit)
          .withValue(CheckinField.caffeine, 0, CheckinSource.typed);

  test('mapper round-trips values, sources and cycle day', () async {
    final entity = sample().copyWith(cycleDay: 12);
    await db.checkinDao.upsert(CheckinMapper.toCompanion(entity, now: t0));
    final row = (await db.checkinDao.byDate('2026-11-06'))!;
    expect(row.sources, {
      'sleepQuality': 'typed',
      'stress': 'typed',
      'neckTension': 'healthkit',
      'caffeine': 'typed',
    });
    expect(CheckinMapper.toEntity(row), entity);
  });

  test('a value without a source code defaults to typed', () async {
    await db.checkinDao.upsert(CheckinMapper.toCompanion(sample(), now: t0));
    await db.customUpdate("UPDATE checkins SET sources = '{}'");
    final back = CheckinMapper.toEntity(
      (await db.checkinDao.byDate('2026-11-06'))!,
    );
    expect(back.sources[CheckinField.stress], CheckinSource.typed);
  });

  test('save upserts by date and keeps createdAt', () async {
    await repo.save(sample());
    repo = DriftCheckinRepository(
      db,
      clock: () => t0.add(const Duration(hours: 1)),
    );
    await repo.save(
      sample().withValue(CheckinField.stress, 5, CheckinSource.typed),
    );
    final row = (await db.checkinDao.byDate('2026-11-06'))!;
    expect(row.stress, 5);
    expect(row.createdAt, t0);
    expect(row.updatedAt, t0.add(const Duration(hours: 1)));
    expect((await repo.all()).length, 1);
  });

  test('inRange and watchRange are inclusive and oldest first', () async {
    for (final d in ['2026-11-01', '2026-11-03', '2026-11-06']) {
      await repo.save(CheckinEntity(date: d));
    }
    expect(
      (await repo.inRange('2026-11-03', '2026-11-06')).map((c) => c.date),
      ['2026-11-03', '2026-11-06'],
    );
    expect(
      (await repo.watchRange('2026-10-01', '2026-11-03').first).map(
        (c) => c.date,
      ),
      ['2026-11-01', '2026-11-03'],
    );
  });

  test('entity completeness and value bounds', () {
    const empty = CheckinEntity(date: '2026-11-06');
    expect(empty.isComplete, isFalse);
    expect(sample().isComplete, isTrue);
    expect(sample().hasOptional, isTrue);
    expect(
      sample()
          .withValue(CheckinField.caffeine, null, CheckinSource.typed)
          .hasOptional,
      isFalse,
    );
    expect(
      () => empty.withValue(CheckinField.stress, 6, CheckinSource.typed),
      throwsA(isA<AssertionError>()),
    );
  });
}
