import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/barometer/data/barometer_repository_impl.dart';
import 'package:migraine_tracker/features/barometer/data/barometer_sources.dart';
import 'package:migraine_tracker/features/barometer/domain/barometer_entities.dart';
import 'package:migraine_tracker/features/barometer/domain/barometer_repository.dart';

/// The newest sensor reading while the app is open; null until the sensor
/// has spoken, and stays null on devices without one.
///
/// Watching this also runs the sampler: one sample per
/// [AppThresholds.barometerSampleInterval] is stored for the trend, and
/// old samples are pruned.
final liveReadingProvider = StreamProvider<PressureReading?>((ref) {
  final sampler = BarometerSampler(
    ref.watch(barometerRepositoryProvider),
    clock: ref.watch(clockProvider),
  );
  final controller = StreamController<PressureReading?>()..add(null);
  final sub = ref.watch(barometerSourceProvider).readings().listen((reading) {
    controller.add(reading);
    unawaited(sampler.offer(reading));
  }, onError: (Object _) {});
  ref.onDispose(() {
    unawaited(sub.cancel());
    unawaited(controller.close());
  });
  return controller.stream;
});

/// Stores at most one reading per sample interval.
class BarometerSampler {
  BarometerSampler(this._repository, {required this.clock});

  final BarometerRepository _repository;
  final DateTime Function() clock;
  DateTime? _lastStored;
  Future<void>? _inFlight;

  Future<void> offer(PressureReading reading) async {
    final last = _lastStored;
    if (last != null &&
        reading.at.difference(last) < AppThresholds.barometerSampleInterval) {
      return;
    }
    // Serialise so a burst of events does not double-store.
    await _inFlight;
    if (_lastStored != null &&
        reading.at.difference(_lastStored!) <
            AppThresholds.barometerSampleInterval) {
      return;
    }
    _lastStored = reading.at;
    _inFlight = () async {
      await _repository.add(reading);
      await _repository.prune(
        clock().subtract(AppThresholds.barometerRetention),
      );
    }();
    await _inFlight;
  }
}
