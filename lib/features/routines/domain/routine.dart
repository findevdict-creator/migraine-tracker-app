import 'package:flutter/foundation.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:risk_model/risk_model.dart';

/// The self-care routines (FR-22). Content lives in the ARB; the code is
/// the stable id used in routes, settings and the illustration file name.
enum Routine {
  stretches,
  breathing,
  lowLight,
  hydration,
  caffeine,
  sleep;

  String get code => name;

  String get illustration => AppAssets.routineIllustration(code);

  static Routine? fromCode(String code) =>
      values.where((r) => r.code == code).firstOrNull;
}

/// Why a routine is suggested today.
enum SuggestionReason { highDay, neckTension, stress }

@immutable
class RoutineSuggestion {
  const RoutineSuggestion(this.routine, this.reason);

  final Routine routine;
  final SuggestionReason reason;

  @override
  bool operator ==(Object other) =>
      other is RoutineSuggestion &&
      other.routine == routine &&
      other.reason == reason;

  @override
  int get hashCode => Object.hash(routine, reason);

  @override
  String toString() => 'RoutineSuggestion(${routine.code}, ${reason.name})';
}

/// Picks today's suggestions: stretches after a high neck-tension
/// check-in, breathing after a high stress check-in, and breathing, low
/// light and water on a high day. Check-in reasons come first because they
/// are what the person told us; each routine shows once, dismissed ones
/// not at all.
abstract final class RoutineSuggester {
  static List<RoutineSuggestion> suggest({
    RiskLevel? level,
    CheckinEntity? checkin,
    Set<Routine> dismissed = const {},
    int max = AppThresholds.routineSuggestionsMax,
  }) {
    bool high(CheckinField field) =>
        (checkin?[field] ?? 0) >= AppThresholds.routineCheckinTrigger;
    final candidates = [
      if (high(CheckinField.neckTension))
        const RoutineSuggestion(
          Routine.stretches,
          SuggestionReason.neckTension,
        ),
      if (high(CheckinField.stress))
        const RoutineSuggestion(Routine.breathing, SuggestionReason.stress),
      if (level == RiskLevel.high) ...const [
        RoutineSuggestion(Routine.breathing, SuggestionReason.highDay),
        RoutineSuggestion(Routine.lowLight, SuggestionReason.highDay),
        RoutineSuggestion(Routine.hydration, SuggestionReason.highDay),
      ],
    ];
    final seen = <Routine>{...dismissed};
    return [
      for (final c in candidates)
        if (seen.add(c.routine)) c,
    ].take(max).toList();
  }
}

/// The routines dismissed for one day. A new day starts empty.
@immutable
class RoutineDismissals {
  const RoutineDismissals({required this.date, this.routines = const {}});

  const RoutineDismissals.none() : date = '', routines = const {};

  factory RoutineDismissals.fromJson(Object? json) {
    if (json is! Map) return const RoutineDismissals.none();
    final date = json['date'];
    final codes = json['codes'];
    return RoutineDismissals(
      date: date is String ? date : '',
      routines: {
        if (codes is List)
          for (final c in codes.whereType<String>()) ?Routine.fromCode(c),
      },
    );
  }

  final String date;
  final Set<Routine> routines;

  /// What is dismissed on [day]; nothing when the stored day is another.
  Set<Routine> forDate(String day) => day == date ? routines : const {};

  /// Adds [more] for [day], dropping anything stored for another day.
  RoutineDismissals add(String day, Iterable<Routine> more) =>
      RoutineDismissals(date: day, routines: {...forDate(day), ...more});

  Map<String, Object?> toJson() => {
    'date': date,
    'codes': [for (final r in routines) r.code],
  };
}
