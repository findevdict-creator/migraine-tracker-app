import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show basicLocaleListResolution;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/home_widget/data/home_widget_gateway.dart';
import 'package:migraine_tracker/features/home_widget/domain/widget_snapshot.dart';
import 'package:migraine_tracker/features/notifications/application/notification_scheduler.dart';
import 'package:migraine_tracker/features/risk/application/risk_engine.dart';
import 'package:migraine_tracker/features/risk/data/risk_repository_impl.dart';

final homeWidgetSyncProvider = Provider<HomeWidgetSync>(HomeWidgetSync.new);

/// Publishes the widget once the risk refresh has run. Watched by home.
final homeWidgetRefreshProvider = FutureProvider<WidgetSnapshot?>((ref) async {
  await ref.watch(riskRefreshProvider.future);
  return await ref.read(homeWidgetSyncProvider).publishQuietly();
});

/// Builds the snapshot from the local stores and hands the rendered
/// strings to the gateway. Called on open, after background refreshes and
/// push wake-ups, and when an attack starts or ends.
class HomeWidgetSync {
  HomeWidgetSync(this._ref);

  final Ref _ref;

  Future<WidgetSnapshot> snapshot() async {
    final now = _ref.read(clockProvider)();
    final today = await _ref.read(riskRepositoryProvider).riskFor(now.dateKey);
    final running = await _ref.read(attackRepositoryProvider).running();
    final pressure = await _ref
        .read(notificationSchedulerProvider)
        .pressureForecast(now);
    return WidgetSnapshot.build(
      now: now,
      today: today,
      pressure: pressure,
      attackRunning: running != null,
    );
  }

  Future<WidgetSnapshot> publish({Locale? locale}) async {
    final snap = await snapshot();
    final resolved = locale ?? _deviceLocale();
    final l10n = lookupAppLocalizations(resolved);
    await _ref
        .read(homeWidgetGatewayProvider)
        .publish(snap.render(l10n, locale: resolved.toString()));
    return snap;
  }

  /// [publish] that logs instead of throwing; widgets are never worth a
  /// failed refresh.
  Future<WidgetSnapshot?> publishQuietly() async {
    try {
      return await publish();
    } on Object catch (error) {
      debugPrint('home widget publish failed: $error');
      return null;
    }
  }

  static Locale _deviceLocale() => basicLocaleListResolution(
    PlatformDispatcher.instance.locales,
    AppLocales.supported,
  );
}
