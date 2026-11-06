import 'package:risk_model/risk_model.dart';
import 'package:test/test.dart';

void main() {
  test('population thresholds and boundaries', () {
    const t = LevelThresholds.population();
    expect(t.levelFor(0), RiskLevel.low);
    expect(t.levelFor(34.9), RiskLevel.low);
    expect(t.levelFor(35), RiskLevel.moderate);
    expect(t.levelFor(59.9), RiskLevel.moderate);
    expect(t.levelFor(60), RiskLevel.high);
    expect(t.levelFor(100), RiskLevel.high);
  });

  test('json round trip', () {
    const t = LevelThresholds(moderate: 20, high: 45);
    final back = LevelThresholds.fromJson(t.toJson());
    expect(back.moderate, 20);
    expect(back.high, 45);
  });

  test('moderate must be below high', () {
    expect(
      () => LevelThresholds(moderate: 50, high: 40),
      throwsA(isA<AssertionError>()),
    );
  });

  test('RiskLevel ids', () {
    for (final l in RiskLevel.values) {
      expect(RiskLevel.fromId(l.id), l);
    }
    expect(RiskLevel.fromId('?'), RiskLevel.low);
  });
}
