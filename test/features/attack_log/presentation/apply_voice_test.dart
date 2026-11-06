import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_log_controller.dart';

import '../../../support/test_database.dart';

void main() {
  late AppDatabase db;
  final now = DateTime(2026, 11, 6, 9);

  setUp(() => db = newTestDatabase());
  tearDown(() => db.close());

  test('applyVoice merges without removing or duplicating', () async {
    final repo = DriftAttackRepository(db, clock: () => now);
    await repo.save(
      AttackEntity(
        id: 'a',
        startedAt: now,
        intensity: 4,
        headLocations: const {HeadLocation.forehead},
        symptoms: [
          SymptomTap(
            symptom: Symptom.nausea,
            at: now.subtract(const Duration(minutes: 5)),
          ),
        ],
      ),
    );
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(container.dispose);
    await container.read(attackEditorProvider('a').future);
    final editor = container.read(attackEditorProvider('a').notifier);

    await editor.applyVoice(
      symptoms: {Symptom.nausea, Symptom.aura},
      locations: {HeadLocation.neck},
    );
    var a = (await repo.byId('a'))!;
    expect(a.intensity, 4, reason: 'kept when nothing was said');
    expect(a.headLocations, {HeadLocation.forehead, HeadLocation.neck});
    expect(a.symptoms.map((s) => s.symptom), [Symptom.nausea, Symptom.aura]);
    expect(
      a.symptoms.first.at.isAtSameMomentAs(
        now.subtract(const Duration(minutes: 5)),
      ),
      isTrue,
    );

    await editor.applyVoice(intensity: 8);
    a = (await repo.byId('a'))!;
    expect(a.intensity, 8);
  });
}
