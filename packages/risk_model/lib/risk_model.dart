/// The on-device daily risk model (FR-9).
///
/// One module per factor turns a day's inputs into an exposure between 0
/// and 1. A weight table (population rules, later personalised) turns
/// exposures into point contributions, and the daily load combines them
/// deterministically into a 0 to 100 number with a level and drivers.
/// Nothing here touches a database, the network or Flutter.
library;

export 'src/day_inputs.dart';
export 'src/day_risk.dart';
export 'src/factor.dart';
export 'src/factor_module.dart';
export 'src/factors/factors.dart';
export 'src/load.dart';
export 'src/model_version.dart';
export 'src/thresholds.dart';
export 'src/weights.dart';
