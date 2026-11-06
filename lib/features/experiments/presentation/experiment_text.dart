import 'package:intl/intl.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/features/experiments/domain/experiment.dart';

extension ExperimentChangeText on ExperimentChange {
  String label(AppLocalizations l10n) => switch (this) {
    ExperimentChange.cutCaffeine => l10n.experimentChangeCutCaffeine,
    ExperimentChange.regularSleep => l10n.experimentChangeRegularSleep,
    ExperimentChange.moreWater => l10n.experimentChangeMoreWater,
    ExperimentChange.dailyStretches => l10n.experimentChangeDailyStretches,
    ExperimentChange.lessScreens => l10n.experimentChangeLessScreens,
    ExperimentChange.noAlcohol => l10n.experimentChangeNoAlcohol,
  };
}

/// Number formatting for the comparison table.
class ExperimentFormat {
  ExperimentFormat(this.l10n, String locale)
    : _one = NumberFormat.decimalPatternDigits(
        locale: locale,
        decimalDigits: 1,
      );

  final AppLocalizations l10n;
  final NumberFormat _one;

  String number(double? value) =>
      value == null ? l10n.experimentNoData : _one.format(value);

  String hours(Duration? value) => value == null
      ? l10n.experimentNoData
      : l10n.reportHoursShort(_one.format(value.inMinutes / 60));
}
