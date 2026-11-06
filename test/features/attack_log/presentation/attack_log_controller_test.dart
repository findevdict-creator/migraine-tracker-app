import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_repository.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_log_controller.dart';

import '../../../support/test_database.dart';

class _FakePressure implements PressureStampSource {
  @override
  Future<PressureStamp> read() async =>
      const PressureStamp(sensorHpa: 1001.5, stationHpa: 1003);
}

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  var now = DateTime.utc(2026, 11, 6, 9, 30);
  var ids = 0;

  setUp(() {
    db = newTestDatabase();
    now = DateTime.utc(2026, 11, 6, 9, 30);
    ids = 0;
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
        idGeneratorProvider.overrideWithValue(() => 'id-${++ids}'),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  group('AttackStarter', () {
    test('creates a running attack stamped with the attack phase', () async {
      final id = await container.read(attackStarterProvider).start();
      expect(id, 'id-1');
      final attack = await container.read(attackRepositoryProvider).byId(id);
      expect(attack!.isRunning, isTrue);
      expect(attack.startedAt, now);
      expect(attack.phases, {AttackPhase.attack: now});
      expect(attack.pressureSensorHpa, isNull);
      expect(attack.pressureStationHpa, isNull);
    });

    test('returns the running attack instead of starting a second', () async {
      final starter = container.read(attackStarterProvider);
      final first = await starter.start();
      final second = await starter.start();
      expect(second, first);
      expect(await container.read(attackRepositoryProvider).count(), 1);
    });

    test('stamps pressure when a source is available', () async {
      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          clockProvider.overrideWithValue(() => now),
          pressureStampSourceProvider.overrideWithValue(_FakePressure()),
        ],
      );
      final id = await container.read(attackStarterProvider).start();
      final attack = await container.read(attackRepositoryProvider).byId(id);
      expect(attack!.pressureSensorHpa, 1001.5);
      expect(attack.pressureStationHpa, 1003);
    });
  });

  group('AttackEditor', () {
    late String id;

    setUp(() async {
      id = await container.read(attackStarterProvider).start();
      await container.read(attackEditorProvider(id).future);
    });

    AttackEditor editor() => container.read(attackEditorProvider(id).notifier);
    Future<AttackEntity> stored() async =>
        (await container.read(attackRepositoryProvider).byId(id))!;

    test('every edit is persisted immediately', () async {
      await editor().setIntensity(6);
      await editor().toggleHeadLocation(HeadLocation.forehead);
      await editor().setNotes('  bright office  ');
      final saved = await stored();
      expect(saved.intensity, 6);
      expect(saved.headLocations, {HeadLocation.forehead});
      expect(saved.notes, '  bright office  ');
    });

    test('symptom taps carry the tap time and toggle off', () async {
      await editor().toggleSymptom(Symptom.aura);
      now = now.add(const Duration(minutes: 10));
      await editor().toggleSymptom(Symptom.nausea);
      expect((await stored()).symptoms, [
        SymptomTap(symptom: Symptom.aura, at: DateTime.utc(2026, 11, 6, 9, 30)),
        SymptomTap(symptom: Symptom.nausea, at: now),
      ]);
      await editor().toggleSymptom(Symptom.aura);
      expect((await stored()).symptoms.map((s) => s.symptom), [Symptom.nausea]);
    });

    test('phases are columns on the one record', () async {
      now = now.add(const Duration(hours: 4));
      await editor().togglePhase(AttackPhase.postdrome);
      final saved = await stored();
      expect(
        saved.phases.keys,
        containsAll([AttackPhase.attack, AttackPhase.postdrome]),
      );
      expect(saved.phases[AttackPhase.postdrome], now);
      expect(await container.read(attackRepositoryProvider).count(), 1);
      await editor().togglePhase(AttackPhase.postdrome);
      expect((await stored()).phases.keys, [AttackPhase.attack]);
    });

    test('end sets endedAt once and clears finishLater', () async {
      await editor().finishLater();
      expect((await stored()).finishLater, isTrue);
      now = now.add(const Duration(hours: 2));
      await editor().end();
      final ended = (await stored()).endedAt;
      expect(ended, now);
      now = now.add(const Duration(hours: 1));
      await editor().end();
      final saved = await stored();
      expect(saved.endedAt, ended);
      expect(saved.finishLater, isFalse);
      final sub = container.listen(runningAttackProvider, (_, _) {});
      await pumpEventQueue();
      expect(container.read(runningAttackProvider).value, isNull);
      sub.close();
    });

    test('blank notes are stored as null', () async {
      await editor().setNotes('   ');
      expect((await stored()).notes, isNull);
    });
  });
}
