import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart' hide RiskDay;
import 'package:migraine_tracker/core/db/database_provider.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/attack_log/presentation/attack_screen.dart';
import 'package:migraine_tracker/features/home_widget/application/home_widget_sync.dart';
import 'package:migraine_tracker/features/home_widget/data/home_widget_gateway.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';
import '../weather/support/weather_fakes.dart';

/// Records what the app publishes and plays back widget taps.
class FakeWidgetGateway implements HomeWidgetGateway {
  FakeWidgetGateway({this.initial});

  final Uri? initial;
  final published = <Map<String, String>>[];
  final _taps = StreamController<Uri?>.broadcast();

  void tap(Uri uri) => _taps.add(uri);

  @override
  Future<void> publish(Map<String, String> data) async => published.add(data);

  @override
  Future<Uri?> initialLaunch() async => initial;

  @override
  Stream<Uri?> get launches => _taps.stream;
}

void main() {
  late AppDatabase db;
  final now = DateTime(2026, 11, 6, 9, 30);

  setUp(() => db = newTestDatabase());
  tearDown(() => db.close());

  Future<void> settleUntil(WidgetTester tester, bool Function() done) async {
    for (var i = 0; i < 400 && !done(); i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(done(), isTrue, reason: 'did not settle');
    await tester.pumpAndSettle();
  }

  Future<void> pump(WidgetTester tester, FakeWidgetGateway gateway) =>
      tester.pumpApp(
        database: db,
        overrides: [
          clockProvider.overrideWithValue(() => now),
          homeWidgetGatewayProvider.overrideWithValue(gateway),
          locationSourceProvider.overrideWithValue(FakeLocationSource(null)),
          weatherSourceProvider.overrideWithValue(
            FakeWeatherSource(null)..error = Exception('offline'),
          ),
        ],
      );

  Future<List<AttackEntity>> attacks() =>
      DriftAttackRepository(db, clock: () => now).all();

  testWidgets('opening the app publishes the widget strings', (tester) async {
    final gateway = FakeWidgetGateway();
    await pump(tester, gateway);
    await settleUntil(tester, () => gateway.published.isNotEmpty);
    final data = gateway.published.last;
    expect(
      data.keys,
      containsAll(<String>[
        AppHomeWidgets.keyLevelLabel,
        AppHomeWidgets.keyPressure,
        AppHomeWidgets.keyStartLabel,
      ]),
    );
    expect(data[AppHomeWidgets.keyStartLabel], 'Start attack');
    expect(data[AppHomeWidgets.keyPressure], 'No pressure forecast yet');
  });

  testWidgets('the start button starts an attack and opens it', (tester) async {
    final gateway = FakeWidgetGateway();
    await pump(tester, gateway);
    gateway.tap(AppHomeWidgets.startAttackUri);
    await settleUntil(
      tester,
      () => find.byType(AttackScreen).evaluate().isNotEmpty,
    );
    final all = await attacks();
    expect(all.single.isRunning, isTrue);
    // The widget now offers to open the running attack.
    await settleUntil(
      tester,
      () => gateway.published.any(
        (d) => d[AppHomeWidgets.keyStartLabel] == 'Open attack',
      ),
    );
  });

  testWidgets('a cold start from the button with an attack running opens '
      'that attack instead of starting another', (tester) async {
    await DriftAttackRepository(db, clock: () => now).save(
      AttackEntity(
        id: 'running',
        startedAt: now.subtract(const Duration(hours: 1)),
      ),
    );
    final gateway = FakeWidgetGateway(initial: AppHomeWidgets.startAttackUri);
    await pump(tester, gateway);
    await settleUntil(
      tester,
      () => find.byType(AttackScreen).evaluate().isNotEmpty,
    );
    expect((await attacks()).map((a) => a.id), ['running']);
  });

  testWidgets('a plain widget tap only opens the app', (tester) async {
    final gateway = FakeWidgetGateway();
    await pump(tester, gateway);
    gateway.tap(Uri.parse('migrainetracker://widget'));
    await tester.pumpAndSettle();
    expect(find.byType(AttackScreen), findsNothing);
    expect(await attacks(), isEmpty);
  });

  test('a failing gateway never breaks the refresh', () async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
        homeWidgetGatewayProvider.overrideWithValue(_ThrowingGateway()),
      ],
    );
    addTearDown(container.dispose);
    expect(
      await container.read(homeWidgetSyncProvider).publishQuietly(),
      isNull,
    );
  });
}

class _ThrowingGateway extends NoHomeWidgetGateway {
  @override
  Future<void> publish(Map<String, String> data) =>
      Future.error(Exception('no widget host'));
}
