import 'package:migraine_tracker/features/barometer/domain/barometer_entities.dart';

/// The device barometer. Emits nothing on devices without one.
abstract interface class BarometerSource {
  Stream<PressureReading> readings();
}

class NoBarometer implements BarometerSource {
  const NoBarometer();

  @override
  Stream<PressureReading> readings() => const Stream.empty();
}
