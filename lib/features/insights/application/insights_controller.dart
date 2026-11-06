import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/features/insights/domain/factor_insight.dart';
import 'package:migraine_tracker/features/risk/application/risk_engine.dart';

/// Insights from the learned weights, live. Null weights (no learning
/// run yet) put every factor under "not enough data".
final factorInsightsProvider = Provider<AsyncValue<List<FactorInsight>>>(
  (ref) => ref.watch(riskWeightsProvider).whenData(factorInsights),
);

/// True once a learning run has stored weights.
final hasLearnedProvider = Provider<bool>(
  (ref) => ref.watch(riskWeightsProvider).value != null,
);
