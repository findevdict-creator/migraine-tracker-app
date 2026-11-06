import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_repository.dart';
import 'package:migraine_tracker/features/health/application/health_sync.dart';
import 'package:migraine_tracker/features/weather/application/weather_snapshot.dart';

/// The attack that is running right now, or null.
final runningAttackProvider = StreamProvider<AttackEntity?>(
  (ref) => ref.watch(attackRepositoryProvider).watchRunning(),
);

/// All attacks, newest first.
final attacksProvider = StreamProvider<List<AttackEntity>>(
  (ref) => ref.watch(attackRepositoryProvider).watchAll(),
);

/// Starts attacks. One tap: if an attack is already running its id is
/// returned so the user lands on it instead of creating a second one.
final attackStarterProvider = Provider<AttackStarter>(
  (ref) => AttackStarter(
    ref.watch(attackRepositoryProvider),
    pressure: ref.watch(pressureStampSourceProvider),
    weather: ref.watch(weatherSnapshotProvider),
    clock: ref.watch(clockProvider),
    newId: ref.watch(idGeneratorProvider),
  ),
);

class AttackStarter {
  AttackStarter(
    this._repository, {
    required this.pressure,
    required this.weather,
    required this.clock,
    required this.newId,
  });

  final AttackRepository _repository;
  final PressureStampSource pressure;
  final WeatherSnapshot weather;
  final DateTime Function() clock;
  final String Function() newId;

  /// Returns the id of the running attack, creating one if needed.
  Future<String> start() async {
    final running = await _repository.running();
    if (running != null) return running.id;
    final now = clock();
    final stamp = await pressure.read();
    // Pinned so pruning keeps the hour this attack points at.
    final snapshot = await weather.at(now, pin: true);
    final attack = AttackEntity(
      id: newId(),
      startedAt: now,
      phases: {AttackPhase.attack: now},
      pressureSensorHpa: stamp.sensorHpa,
      pressureStationHpa: stamp.stationHpa,
      weather: snapshot,
    );
    await _repository.save(attack);
    return attack.id;
  }
}

/// Edits one attack. Every change is written straight to the database so a
/// crash or a swipe-away mid-attack keeps what was entered.
final AsyncNotifierProviderFamily<AttackEditor, AttackEntity, String>
attackEditorProvider = AsyncNotifierProvider.family(AttackEditor.new);

class AttackEditor extends AsyncNotifier<AttackEntity> {
  AttackEditor(this.attackId);

  final String attackId;

  AttackRepository get _repository => ref.read(attackRepositoryProvider);
  DateTime get _now => ref.read(clockProvider)();

  @override
  Future<AttackEntity> build() async {
    final attack = await _repository.byId(attackId);
    if (attack == null) {
      throw StateError('Attack $attackId does not exist');
    }
    return attack;
  }

  Future<void> _update(AttackEntity Function(AttackEntity) change) async {
    final current = state.value;
    if (current == null) return;
    final next = change(current);
    state = AsyncData(next);
    await _repository.save(next);
  }

  Future<void> setIntensity(int value) =>
      _update((a) => a.copyWith(intensity: value));

  Future<void> toggleHeadLocation(HeadLocation location) => _update((a) {
    final next = {...a.headLocations};
    if (!next.remove(location)) next.add(location);
    return a.copyWith(headLocations: next);
  });

  /// Adds a tap with the current time, or removes the symptom entirely when
  /// it is already present.
  Future<void> toggleSymptom(Symptom symptom) => _update((a) {
    if (a.hasSymptom(symptom)) {
      return a.copyWith(
        symptoms: a.symptoms.where((t) => t.symptom != symptom).toList(),
      );
    }
    return a.copyWith(
      symptoms: [
        ...a.symptoms,
        SymptomTap(symptom: symptom, at: _now),
      ],
    );
  });

  /// Stamps a phase with the current time, or clears it when already set.
  Future<void> togglePhase(AttackPhase phase) => _update((a) {
    final next = {...a.phases};
    if (next.containsKey(phase)) {
      next.remove(phase);
    } else {
      next[phase] = _now;
    }
    return a.copyWith(phases: next);
  });

  Future<void> setNotes(String notes) =>
      _update((a) => a.copyWith(notes: notes.trim().isEmpty ? null : notes));

  /// Ends the attack now. Idempotent. Writes the headache event to the
  /// health store when the person opted in (phase 14).
  Future<void> end() async {
    final wasRunning = state.value?.isRunning ?? false;
    await _update(
      (a) => a.copyWith(endedAt: a.endedAt ?? _now, finishLater: false),
    );
    final ended = state.value;
    if (wasRunning && ended != null) {
      await ref.read(healthSyncProvider).exportAttack(ended);
    }
  }

  /// Keeps the attack running but marks it so the home screen can nudge the
  /// user to come back and fill in the details.
  Future<void> finishLater() => _update((a) => a.copyWith(finishLater: true));
}
