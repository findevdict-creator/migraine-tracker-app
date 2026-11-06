import 'package:meta/meta.dart';
import 'package:risk_model/src/factor.dart';
import 'package:risk_model/src/factors/factors.dart';

/// One factor's learned state. `confidence` (0 to 1) says how far the
/// personal weight has replaced the population one; phase 17 raises it
/// with the number of attacks seen.
@immutable
class FactorWeight {
  /// Counts default to zero.
  const FactorWeight({
    required this.population,
    required this.personal,
    required this.confidence,
    this.nExposures = 0,
    this.nAttacksAfter = 0,
  });

  /// The population rule alone.
  FactorWeight.population(Factor factor)
    : this(
        population: moduleFor(factor).populationWeight,
        personal: moduleFor(factor).populationWeight,
        confidence: 0,
      );

  /// Reads [toJson]; missing counts read as zero.
  factory FactorWeight.fromJson(Map<String, Object?> json) => FactorWeight(
    population: (json['population']! as num).toDouble(),
    personal: (json['personal']! as num).toDouble(),
    confidence: (json['confidence']! as num).toDouble(),
    nExposures: (json['nExposures'] as num?)?.toInt() ?? 0,
    nAttacksAfter: (json['nAttacksAfter'] as num?)?.toInt() ?? 0,
  );

  /// The population rule's weight.
  final double population;

  /// The learned weight.
  final double personal;

  /// How far [personal] replaces [population], 0 to 1.
  final double confidence;

  /// Days with exposure above zero seen so far.
  final int nExposures;

  /// Of those, days followed by an attack within the window.
  final int nAttacksAfter;

  /// The weight the load uses: population shrunk towards personal by
  /// confidence.
  double get effective => population * (1 - confidence) + personal * confidence;

  /// Storage shape.
  Map<String, Object?> toJson() => {
    'population': population,
    'personal': personal,
    'confidence': confidence,
    'nExposures': nExposures,
    'nAttacksAfter': nAttacksAfter,
  };
}

/// Weights for every factor.
@immutable
class WeightTable {
  /// Wraps a map; missing factors fall back to population.
  const WeightTable(this._weights);

  /// Population rules for all fourteen factors.
  factory WeightTable.population() => WeightTable({
    for (final f in Factor.values) f: FactorWeight.population(f),
  });

  /// Reads `{factorId: weight}`; missing factors fall back to population.
  factory WeightTable.fromJson(Map<String, Object?> json) => WeightTable({
    for (final f in Factor.values)
      f: json[f.id] == null
          ? FactorWeight.population(f)
          : FactorWeight.fromJson((json[f.id]! as Map).cast<String, Object?>()),
  });

  final Map<Factor, FactorWeight> _weights;

  /// The weight for a factor.
  FactorWeight operator [](Factor factor) =>
      _weights[factor] ?? FactorWeight.population(factor);

  /// A copy with one factor replaced.
  WeightTable copyWith(Factor factor, FactorWeight weight) =>
      WeightTable({..._weights, factor: weight});

  /// `{factorId: weight}`.
  Map<String, Object?> toJson() => {
    for (final f in Factor.values) f.id: this[f].toJson(),
  };
}
