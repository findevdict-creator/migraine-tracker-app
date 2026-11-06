import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/barometer/domain/barometer_entities.dart';
import 'package:migraine_tracker/features/barometer/domain/barometer_source.dart';
import 'package:sensors_plus/sensors_plus.dart';

final barometerSourceProvider = Provider<BarometerSource>(
  (ref) => SensorBarometer(clock: ref.watch(clockProvider)),
);

/// True once the services binding exists; plain Dart tests and isolates
/// without one cannot reach platform channels.
bool get _bindingReady {
  try {
    ServicesBinding.instance;
    return true;
    // The only signal Flutter offers is the error the getter throws.
    // ignore: avoid_catching_errors
  } on FlutterError {
    return false;
  }
}

/// The platform barometer through `sensors_plus`. A missing sensor or a
/// missing plugin ends the stream quietly, which the UI shows as "from
/// nearest station".
class SensorBarometer implements BarometerSource {
  SensorBarometer({required this.clock});

  final DateTime Function() clock;

  @override
  Stream<PressureReading> readings() {
    if (!_bindingReady) return const Stream.empty();
    try {
      return barometerEventStream(samplingPeriod: SensorInterval.uiInterval)
          .map((e) => PressureReading(at: clock(), hpa: e.pressure))
          .handleError((Object _) {});
    } on Object {
      return const Stream.empty();
    }
  }
}
