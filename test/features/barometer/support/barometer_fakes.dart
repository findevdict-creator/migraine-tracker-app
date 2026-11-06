import 'dart:async';

import 'package:migraine_tracker/features/barometer/domain/barometer_entities.dart';
import 'package:migraine_tracker/features/barometer/domain/barometer_source.dart';

/// A barometer the test drives by hand.
class FakeBarometer implements BarometerSource {
  final _controller = StreamController<PressureReading>.broadcast();

  void emit(PressureReading reading) => _controller.add(reading);

  Future<void> close() => _controller.close();

  @override
  Stream<PressureReading> readings() => _controller.stream;
}
