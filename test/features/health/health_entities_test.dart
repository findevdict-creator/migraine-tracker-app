import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/health/domain/health_entities.dart';

void main() {
  test('sleep minutes map onto the 1 to 5 scale by the configured bands', () {
    expect(AppThresholds.sleepQualityMinuteBands, [300, 360, 420, 480]);
    expect(sleepQualityFromMinutes(0), 1);
    expect(sleepQualityFromMinutes(300), 1);
    expect(sleepQualityFromMinutes(301), 2);
    expect(sleepQualityFromMinutes(400), 3);
    expect(sleepQualityFromMinutes(480), 4);
    expect(sleepQualityFromMinutes(481), 5);
    expect(sleepQualityFromMinutes(600), 5);
  });

  test('consent round-trips through json and ignores unknown codes', () {
    const consent = HealthConsent({HealthType.sleep, HealthType.steps});
    expect(consent.toJson(), {'sleep': true, 'steps': true});
    final back = HealthConsent.fromJson(const {
      'sleep': true,
      'steps': false,
      'hrv': true,
      'bogus': true,
    });
    expect(back.types, {HealthType.sleep, HealthType.hrv});
    expect(back.with_(HealthType.sleep, allowed: false).types, {
      HealthType.hrv,
    });
    expect(const HealthConsent.none().any, isFalse);
  });

  test('type and store codes are the stored column values', () {
    expect(HealthType.restingHr.code, 'resting_hr');
    expect(HealthType.fromCode('menstrual_flow'), HealthType.menstrualFlow);
    expect(HealthStore.fromCode('health_connect'), HealthStore.healthConnect);
    expect(FlowLevel.spotting.isBleeding, isTrue);
    expect(FlowLevel.none.isBleeding, isFalse);
  });
}
