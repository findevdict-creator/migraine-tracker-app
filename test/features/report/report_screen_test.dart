import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/checkin/data/checkin_repository_impl.dart';
import 'package:migraine_tracker/features/export/presentation/share_files.dart';
import 'package:migraine_tracker/features/medication/data/medication_repository_impl.dart';
import 'package:migraine_tracker/features/report/application/report_service.dart';
import 'package:migraine_tracker/features/report/domain/report_model.dart';
import 'package:migraine_tracker/features/report/presentation/report_screen.dart';
import 'package:migraine_tracker/features/risk/data/risk_repository_impl.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';
import '../weather/support/weather_fakes.dart';

/// Loads and previews from the real repositories, but writes the files
/// synchronously: real file I/O never completes under fake-async pumps,
/// and the real writer is covered by report_service_test.
class _SyncWriteService extends ReportService {
  _SyncWriteService(AppDatabase db, {required this.dir, required super.clock})
    : super(
        attacks: DriftAttackRepository(db, clock: clock),
        medications: DriftMedicationRepository(db, clock: clock),
        checkins: DriftCheckinRepository(db, clock: clock),
        risk: DriftRiskRepository(db),
      );

  final Directory dir;
  final formats = <ReportFormat>[];

  @override
  Future<List<File>> write(
    ReportRange range, {
    required ReportFormat format,
    required AppLocalizations l10n,
    String? locale,
    Directory? directory,
  }) async {
    formats.add(format);
    final stem = '${range.from.dateKey}-${range.to.dateKey}';
    return [
      if (format != ReportFormat.csv)
        File('${dir.path}/$stem.pdf')..writeAsStringSync('%PDF-'),
      if (format != ReportFormat.pdf) ...[
        File('${dir.path}/$stem-attacks.csv')..writeAsStringSync('a\n1\n2\n'),
        File('${dir.path}/$stem-days.csv')..writeAsStringSync('d\n'),
      ],
    ];
  }
}

void main() {
  late AppDatabase db;
  late Directory temp;
  late _SyncWriteService service;
  final now = DateTime(2026, 11, 6, 9);
  final shared = <List<File>>[];

  setUp(() async {
    db = newTestDatabase();
    temp = await Directory.systemTemp.createTemp('report');
    shared.clear();
    service = _SyncWriteService(db, dir: temp, clock: () => now);
    final repo = DriftAttackRepository(db, clock: () => now);
    // One attack 10 days ago, one 60 days ago.
    await repo.save(
      AttackEntity(
        id: 'recent',
        startedAt: now.subtract(const Duration(days: 10)),
        endedAt: now.subtract(const Duration(days: 10, hours: -5)),
        intensity: 6,
      ),
    );
    await repo.save(
      AttackEntity(
        id: 'older',
        startedAt: now.subtract(const Duration(days: 60)),
        endedAt: now.subtract(const Duration(days: 60, hours: -2)),
        intensity: 3,
      ),
    );
  });

  tearDown(() async {
    await db.close();
    await temp.delete(recursive: true);
  });

  /// Pumps until [done] holds; the preview's database work schedules no
  /// frame, so pumpAndSettle alone returns before it is finished.
  Future<void> settleUntil(WidgetTester tester, bool Function() done) async {
    for (var i = 0; i < 400 && !done(); i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(done(), isTrue, reason: 'did not settle');
    await tester.pumpAndSettle();
  }

  Future<void> open(WidgetTester tester) async {
    await tester.pumpApp(
      database: db,
      overrides: [
        clockProvider.overrideWithValue(() => now),
        reportServiceProvider.overrideWithValue(service),
        shareFilesProvider.overrideWithValue((files, {text}) async {
          shared.add(files);
        }),
        locationSourceProvider.overrideWithValue(FakeLocationSource(null)),
        weatherSourceProvider.overrideWithValue(
          FakeWeatherSource(null)..error = Exception('offline'),
        ),
      ],
    );
    await tester.tap(find.byKey(const ValueKey('home-settings')));
    await tester.pumpAndSettle();
    await tester.scrollToKey('settings-report');
    await tester.tap(find.byKey(const ValueKey('settings-report')));
    await tester.pumpAndSettle();
    expect(find.byType(ReportScreen), findsOneWidget);
    await settleUntil(
      tester,
      () => find.byKey(const ValueKey('report-preview')).evaluate().isNotEmpty,
    );
  }

  Future<void> share(WidgetTester tester, String key) async {
    await tester.scrollToKey(key);
    await tester.tap(find.byKey(ValueKey(key)));
    await settleUntil(tester, () => shared.isNotEmpty);
  }

  testWidgets('opens from settings with the default period', (tester) async {
    await open(tester);
    expect(find.text('2 attacks'), findsOneWidget);
    expect(find.textContaining('Aug 9, 2026 to Nov 6, 2026'), findsOneWidget);
  });

  testWidgets('a shorter preset narrows the preview', (tester) async {
    await open(tester);
    await tester.tap(find.byKey(const ValueKey('report-range-30')));
    await tester.pumpAndSettle();
    await settleUntil(
      tester,
      () => find.text('1 attack').evaluate().isNotEmpty,
    );
    expect(find.textContaining('Oct 8, 2026 to Nov 6, 2026'), findsOneWidget);
  });

  testWidgets('sharing hands the files to the share sheet', (tester) async {
    await open(tester);
    await share(tester, 'report-share-csv');
    expect(service.formats, [ReportFormat.csv]);
    expect(shared.single.map((f) => f.path.split('/').last), [
      '2026-08-09-2026-11-06-attacks.csv',
      '2026-08-09-2026-11-06-days.csv',
    ]);
    expect(shared.single.first.readAsLinesSync(), hasLength(3));

    shared.clear();
    await share(tester, 'report-share-all');
    expect(service.formats.last, ReportFormat.all);
    expect(shared.single.length, 3);
    expect(shared.single.first.path, endsWith('.pdf'));

    shared.clear();
    await share(tester, 'report-share-pdf');
    expect(service.formats.last, ReportFormat.pdf);
    expect(shared.single.single.path, endsWith('.pdf'));
  });
}
