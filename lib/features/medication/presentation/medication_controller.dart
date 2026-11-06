import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/medication/data/medication_repository_impl.dart';
import 'package:migraine_tracker/features/medication/domain/acute_day_counter.dart';
import 'package:migraine_tracker/features/medication/domain/medication_entity.dart';

/// This calendar month's events (local time), oldest first.
final thisMonthMedicationsProvider = StreamProvider<List<MedicationEntity>>((
  ref,
) {
  final now = ref.watch(clockProvider)();
  return ref
      .watch(medicationRepositoryProvider)
      .watchRange(
        AcuteDayCounter.monthStart(now),
        AcuteDayCounter.nextMonthStart(now),
      );
});

/// Distinct local days this month with an acute dose.
final acuteDaysThisMonthProvider = Provider<int>((ref) {
  final now = ref.watch(clockProvider)().toLocal();
  final events = ref.watch(thisMonthMedicationsProvider).value ?? const [];
  return AcuteDayCounter.daysInMonth(events, year: now.year, month: now.month);
});

/// The gentle note that applies this month, if any.
final overuseNoteProvider = Provider<OveruseNote>(
  (ref) => OveruseNote.forDays(ref.watch(acuteDaysThisMonthProvider)),
);

/// Events logged inside one attack.
final StreamProviderFamily<List<MedicationEntity>, String>
attackMedicationsProvider = StreamProvider.family(
  (ref, attackId) =>
      ref.watch(medicationRepositoryProvider).watchForAttack(attackId),
);

/// Recently used names for the suggestion list.
final recentMedicationNamesProvider = FutureProvider<List<String>>(
  (ref) => ref.watch(medicationRepositoryProvider).recentNames(),
);

final medicationLogProvider = Provider<MedicationLog>(MedicationLog.new);

/// Writes medication events. Each method is one saved change.
class MedicationLog {
  MedicationLog(this._ref);

  final Ref _ref;

  Future<MedicationEntity> add({
    required String name,
    required MedicationKind kind,
    String? dose,
    DateTime? takenAt,
    String? attackId,
  }) async {
    final event = MedicationEntity(
      id: _ref.read(idGeneratorProvider)(),
      name: name.trim(),
      dose: (dose ?? '').trim().isEmpty ? null : dose!.trim(),
      takenAt: takenAt ?? _ref.read(clockProvider)(),
      kind: kind,
      attackId: attackId,
    );
    await _ref.read(medicationRepositoryProvider).save(event);
    _ref.invalidate(recentMedicationNamesProvider);
    return event;
  }

  Future<void> update(MedicationEntity event) =>
      _ref.read(medicationRepositoryProvider).save(event);

  Future<void> setRelief(String id, Relief? relief) async {
    final repo = _ref.read(medicationRepositoryProvider);
    final event = await repo.byId(id);
    if (event == null) return;
    await repo.save(
      event.copyWith(reliefAt2h: relief, clearRelief: relief == null),
    );
  }

  Future<void> delete(String id) =>
      _ref.read(medicationRepositoryProvider).delete(id);
}
