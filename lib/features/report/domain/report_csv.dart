import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/checkin/domain/checkin_entity.dart';
import 'package:migraine_tracker/features/export/domain/data_export.dart';
import 'package:migraine_tracker/features/report/domain/report_model.dart';

/// The two spreadsheet views of a report: one row per attack and one row
/// per day of the range. Column names are stable identifiers, not copy.
abstract final class ReportCsv {
  static const attackColumns = [
    'started_at',
    'ended_at',
    'duration_minutes',
    'intensity',
    'head_locations',
    'symptoms',
    'phases',
    'medications',
    'pressure_delta_24h_hpa',
    'notes',
  ];

  static const dayColumns = [
    'date',
    'attacks',
    'max_intensity',
    'acute_doses',
    'preventive_doses',
    'sleep_quality',
    'stress',
    'neck_tension',
    'caffeine',
    'hydration',
    'alcohol',
    'light_exposure',
    'screen_exposure',
    'cycle_day',
    'pressure_delta_24h_hpa',
  ];

  static String attacks(ReportInputs inputs) {
    final attacks =
        inputs.attacks.where((a) => inputs.range.contains(a.startedAt)).toList()
          ..sort((a, b) => a.startedAt.compareTo(b.startedAt));
    final rows = <List<Object?>>[
      for (final a in attacks)
        [
          a.startedAt.toLocal().toIso8601String(),
          a.endedAt?.toLocal().toIso8601String(),
          a.duration?.inMinutes,
          a.intensity,
          (a.headLocations.map((l) => l.name).toList()..sort()).join(';'),
          (a.symptoms.map((s) => s.symptom.name).toSet().toList()..sort()).join(
            ';',
          ),
          [
            for (final e in a.phases.entries)
              '${e.key.name}@${e.value.toLocal().toIso8601String()}',
          ].join(';'),
          [
            for (final m in inputs.medications)
              if (m.attackId == a.id) m.name,
          ].join(';'),
          a.weather?['delta24h'],
          a.notes,
        ],
    ];
    return Csv.encode(attackColumns, rows);
  }

  static String days(ReportInputs inputs) {
    final range = inputs.range;
    final checkins = {for (final c in inputs.checkins) c.date: c};
    final rows = <List<Object?>>[];
    for (var i = 0; i < range.days; i++) {
      final day = range.from.add(Duration(days: i));
      final key = day.dateKey;
      final attacks = inputs.attacks
          .where((a) => a.startedAt.toLocal().dateKey == key)
          .toList();
      final doses = inputs.medications
          .where((m) => m.takenAt.toLocal().dateKey == key)
          .toList();
      final c = checkins[key];
      final intensities = attacks.map((a) => a.intensity).nonNulls.toList();
      rows.add([
        key,
        attacks.length,
        if (intensities.isEmpty)
          null
        else
          intensities.reduce((a, b) => a > b ? a : b),
        doses.where((d) => d.isAcute).length,
        doses.where((d) => !d.isAcute).length,
        ...[for (final field in _checkinOrder) c?.values[field]],
        c?.cycleDay,
        c?.weather?['delta24h'],
      ]);
    }
    return Csv.encode(dayColumns, rows);
  }
}

const List<CheckinField> _checkinOrder = [
  CheckinField.sleepQuality,
  CheckinField.stress,
  CheckinField.neckTension,
  CheckinField.caffeine,
  CheckinField.hydration,
  CheckinField.alcohol,
  CheckinField.lightExposure,
  CheckinField.screenExposure,
];
