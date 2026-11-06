import 'package:risk_model/risk_model.dart';
import 'package:test/test.dart';

void main() {
  group('FactorWeight', () {
    test('population has zero confidence and effective = population', () {
      final w = FactorWeight.population(Factor.stress);
      expect(w.population, 0.45);
      expect(w.personal, 0.45);
      expect(w.confidence, 0);
      expect(w.effective, 0.45);
      expect(w.nExposures, 0);
      expect(w.nAttacksAfter, 0);
    });

    test('effective blends by confidence', () {
      const w = FactorWeight(population: 0.4, personal: 0.8, confidence: 0.5);
      expect(w.effective, closeTo(0.6, 1e-9));
      const full = FactorWeight(population: 0.4, personal: 0.8, confidence: 1);
      expect(full.effective, closeTo(0.8, 1e-9));
    });

    test('json round trip, counts default to zero', () {
      const w = FactorWeight(
        population: 0.4,
        personal: 0.7,
        confidence: 0.3,
        nExposures: 12,
        nAttacksAfter: 4,
      );
      final back = FactorWeight.fromJson(w.toJson());
      expect(back.population, 0.4);
      expect(back.personal, 0.7);
      expect(back.confidence, 0.3);
      expect(back.nExposures, 12);
      expect(back.nAttacksAfter, 4);
      final sparse = FactorWeight.fromJson(const {
        'population': 1,
        'personal': 1,
        'confidence': 0,
      });
      expect(sparse.nExposures, 0);
      expect(sparse.nAttacksAfter, 0);
    });
  });

  group('WeightTable', () {
    test('population covers every factor', () {
      final t = WeightTable.population();
      for (final f in Factor.values) {
        expect(t[f].population, moduleFor(f).populationWeight);
      }
    });

    test('a sparse table falls back to population', () {
      const t = WeightTable({});
      expect(t[Factor.pollen].effective, 0.2);
    });

    test('copyWith replaces one factor', () {
      final t = WeightTable.population().copyWith(
        Factor.alcohol,
        const FactorWeight(population: 0.35, personal: 0.9, confidence: 1),
      );
      expect(t[Factor.alcohol].effective, 0.9);
      expect(t[Factor.caffeine].effective, 0.25);
    });

    test('json round trip and missing ids', () {
      final t = WeightTable.population().copyWith(
        Factor.stress,
        const FactorWeight(population: 0.45, personal: 0.1, confidence: 0.5),
      );
      final json = t.toJson();
      expect(json.keys, Factor.values.map((f) => f.id));
      final back = WeightTable.fromJson(json);
      expect(back[Factor.stress].personal, 0.1);
      final partial = WeightTable.fromJson({'stress': json['stress']});
      expect(partial[Factor.stress].personal, 0.1);
      expect(partial[Factor.pollen].personal, 0.2);
    });
  });

  group('Factor', () {
    test('ids are unique and resolvable', () {
      final ids = Factor.values.map((f) => f.id).toSet();
      expect(ids.length, Factor.values.length);
      for (final f in Factor.values) {
        expect(Factor.fromId(f.id), f);
      }
      expect(Factor.fromId('nope'), isNull);
    });
  });
}
