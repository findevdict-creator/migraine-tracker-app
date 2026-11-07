import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/db/app_database.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/account/data/firebase_auth_gateway.dart';
import 'package:migraine_tracker/features/account/domain/account.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';
import 'package:migraine_tracker/features/share_link/application/share_link_actions.dart';
import 'package:migraine_tracker/features/share_link/data/share_link_data.dart';
import 'package:migraine_tracker/features/share_link/domain/share_link.dart';
import 'package:migraine_tracker/features/share_link/presentation/share_links_screen.dart';
import 'package:migraine_tracker/features/weather/data/weather_sources.dart';

import '../../support/pump_app.dart';
import '../../support/test_database.dart';
import '../account/account_screen_test.dart' show FakeAuthGateway;
import '../weather/support/weather_fakes.dart';

/// Plays the server: hands out tokens and records what it was sent.
class FakeShareLinkGateway implements ShareLinkGateway {
  FakeShareLinkGateway(this.now);

  final DateTime now;
  final created = <({int days, Map<String, Object?> document})>[];
  final revoked = <String>[];
  ShareLinkException? failWith;

  @override
  bool get available => true;

  @override
  Future<({String token, DateTime expiresAt})> create({
    required int days,
    required Map<String, Object?> document,
  }) async {
    if (failWith != null) throw failWith!;
    created.add((days: days, document: document));
    return (
      token: 'AbCdEfGhIjKlMnOpQrStU${created.length}',
      expiresAt: now.add(Duration(days: days)),
    );
  }

  @override
  Future<void> revoke(String token) async {
    if (failWith != null) throw failWith!;
    revoked.add(token);
  }
}

void main() {
  late AppDatabase db;
  late FakeShareLinkGateway server;
  late List<String> sharedTexts;
  final now = DateTime(2026, 11, 6, 9, 30);

  setUp(() async {
    db = newTestDatabase();
    server = FakeShareLinkGateway(now);
    sharedTexts = [];
    await DriftAttackRepository(db, clock: () => now).save(
      AttackEntity(
        id: 'a1',
        startedAt: DateTime(2026, 11, 1, 8),
        endedAt: DateTime(2026, 11, 1, 14),
        intensity: 7,
        notes: 'private words',
      ),
    );
  });
  tearDown(() => db.close());

  bool shown(String key) => find.byKey(ValueKey(key)).evaluate().isNotEmpty;

  Future<void> settleUntil(WidgetTester tester, bool Function() done) async {
    for (var i = 0; i < 400 && !done(); i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(done(), isTrue, reason: 'did not settle');
    await tester.pumpAndSettle();
  }

  Future<void> pump(WidgetTester tester, {bool signedIn = true}) =>
      tester.pumpApp(
        database: db,
        overrides: [
          clockProvider.overrideWithValue(() => now),
          authGatewayProvider.overrideWithValue(
            FakeAuthGateway(
              current: signedIn
                  ? const AccountUser(
                      uid: 'u1',
                      email: 'me@example.com',
                      method: SignInMethod.email,
                    )
                  : null,
            ),
          ),
          shareLinkGatewayProvider.overrideWithValue(server),
          shareTextProvider.overrideWithValue((text) async {
            sharedTexts.add(text);
          }),
          locationSourceProvider.overrideWithValue(FakeLocationSource(null)),
          weatherSourceProvider.overrideWithValue(
            FakeWeatherSource(null)..error = Exception('offline'),
          ),
        ],
      );

  Future<void> openSettingsTile(WidgetTester tester, String key) async {
    await tester.tap(find.byKey(const ValueKey('home-settings')));
    await tester.pumpAndSettle();
    await tester.scrollToKey(key);
    await tester.tap(find.byKey(ValueKey(key)));
    await tester.pumpAndSettle();
  }

  Future<void> openSheet(WidgetTester tester) async {
    await openSettingsTile(tester, 'settings-report');
    await settleUntil(tester, () => shown('report-preview'));
    await tester.scrollToKey('report-share-link');
    await tester.tap(find.byKey(const ValueKey('report-share-link')));
    await tester.pumpAndSettle();
    expect(shown('share-link-sheet'), isTrue);
  }

  testWidgets('create a 30-day link from the report: the server gets the '
      'report document, the phone keeps the link', (tester) async {
    await pump(tester);
    await openSheet(tester);
    expect(find.textContaining('not your diary'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('share-days-30')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('share-link-create')));
    await settleUntil(tester, () => shown('share-link-ready'));

    final sent = server.created.single;
    expect(sent.days, 30);
    expect(sent.document['v'], 1);
    expect(sent.document['title'], 'Aurawell report');
    expect(sent.document.toString(), isNot(contains('private words')));

    final url = AppShareLinks.url('AbCdEfGhIjKlMnOpQrStU1').toString();
    expect(find.text(url), findsOneWidget);
    expect(find.textContaining('Shared until Dec 6, 2026'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('share-link-share')));
    await tester.pump();
    expect(sharedTexts, ['My migraine report: $url']);

    final mirror = await tester.runAsync(
      () => ShareLinkMirror(db).watchAll().first,
    );
    expect(mirror!.single.token, 'AbCdEfGhIjKlMnOpQrStU1');
  });

  testWidgets('signed out, the sheet explains that a link needs an account', (
    tester,
  ) async {
    await pump(tester, signedIn: false);
    await openSheet(tester);
    expect(shown('share-link-needs-account'), isTrue);
    expect(shown('share-link-create'), isFalse);
  });

  testWidgets('a server error is explained and nothing is kept', (
    tester,
  ) async {
    server.failWith = const ShareLinkException(ShareLinkError.network);
    await pump(tester);
    await openSheet(tester);
    await tester.tap(find.byKey(const ValueKey('share-link-create')));
    await settleUntil(tester, () => shown('share-link-error'));
    expect(find.textContaining('No connection'), findsOneWidget);
    final mirror = await tester.runAsync(
      () => ShareLinkMirror(db).watchAll().first,
    );
    expect(mirror, isEmpty);
  });

  testWidgets('shared links: stop sharing an active link; expired and '
      'stopped links show their state', (tester) async {
    final mirror = ShareLinkMirror(db);
    await mirror.add(
      ShareLinkEntity(
        token: 'live-token-0000000000a',
        createdAt: now.subtract(const Duration(days: 1)),
        expiresAt: now.add(const Duration(days: 6)),
      ),
    );
    await mirror.add(
      ShareLinkEntity(
        token: 'old-token-00000000000b',
        createdAt: now.subtract(const Duration(days: 40)),
        expiresAt: now.subtract(const Duration(days: 10)),
      ),
    );
    await pump(tester);
    await openSettingsTile(tester, 'settings-share-links');
    expect(find.byType(ShareLinksScreen), findsOneWidget);
    await settleUntil(tester, () => shown('share-link-live-token-0000000000a'));
    expect(find.text('Shared until Nov 12, 2026'), findsOneWidget);
    expect(find.text('Expired Oct 27, 2026'), findsOneWidget);
    expect(shown('share-link-revoke-old-token-00000000000b'), isFalse);

    await tester.tap(
      find.byKey(const ValueKey('share-link-revoke-live-token-0000000000a')),
    );
    await tester.pumpAndSettle();
    expect(find.text('Stop sharing this report?'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('share-link-revoke-confirm')));
    await settleUntil(
      tester,
      () => find.text('Sharing stopped').evaluate().isNotEmpty,
    );
    expect(server.revoked, ['live-token-0000000000a']);
    expect(find.textContaining('The link no longer works'), findsOneWidget);
  });

  test('a link is active until its expiry, and revoked wins', () {
    final link = ShareLinkEntity(
      token: 't',
      createdAt: now,
      expiresAt: now.add(const Duration(days: 7)),
    );
    expect(link.statusAt(now), ShareLinkStatus.active);
    expect(
      link.statusAt(now.add(const Duration(days: 7))),
      ShareLinkStatus.expired,
    );
    expect(
      ShareLinkEntity(
        token: 't',
        createdAt: now,
        expiresAt: now.add(const Duration(days: 7)),
        revoked: true,
      ).statusAt(now),
      ShareLinkStatus.revoked,
    );
    expect(link.url.path, '${AppShareLinks.pathPrefix}t');
  });
}
