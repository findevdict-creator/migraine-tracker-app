import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/core/l10n/device_locale.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/units/units.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/home_widget/data/home_widget_gateway.dart';
import 'package:migraine_tracker/features/home_widget/domain/widget_snapshot.dart';
import 'package:migraine_tracker/features/notifications/application/notification_scheduler.dart';
import 'package:migraine_tracker/features/risk/application/risk_engine.dart';
import 'package:migraine_tracker/features/risk/data/risk_repository_impl.dart';
import 'package:migraine_tracker/features/watch/application/watch_sync.dart';

final homeWidgetSyncProvider = Provider<HomeWidgetSync>(HomeWidgetSync.new);

/// Publishes the widget once the risk refresh has run. Watched by home.
final homeWidgetRefreshProvider = FutureProvider<WidgetSnapshot?>((ref) async {
  await ref.watch(riskRefreshProvider.future);
  return await ref.read(homeWidgetSyncProvider).publishQuietly();
});

/// Builds the snapshot from the local stores and hands the rendered
/// strings to the home widget and the watch (phase 27). Called on open,
/// after background refreshes and push wake-ups, and when an attack starts
/// or ends.
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

  /// Writes the widget strings. Throws when the widget host fails.
  Future<WidgetSnapshot> publish({Locale? locale}) async {
    final snap = await snapshot();
    final resolved = locale ?? _ref.read<Locale>(deviceLocaleProvider);
    await _publishWidget(
      snap,
      lookupAppLocalizations(resolved),
      resolved,
      await _units(),
    );
    return snap;
  }

  Future<void> _publishWidget(
    WidgetSnapshot snap,
    AppLocalizations l10n,
    Locale locale,
    Units units,
  ) => _ref
      .read(homeWidgetGatewayProvider)
      .publish(snap.render(l10n, locale: locale.toString(), units: units));

  Future<Units> _units() => Units.read(
    _ref.read(settingsRepositoryProvider),
    _ref.read(deviceRegionProvider),
  );

  /// Sends the snapshot to the home widget and the watch, each on its own:
  /// one failing never stops the other, and neither is worth a failed
  /// refresh, so failures only log. Null when the snapshot itself failed.
  ///
  /// Often not awaited, so it stops quietly when its provider is disposed
  /// part-way (the app closing, or a test finishing).
  Future<WidgetSnapshot?> publishQuietly() async {
    final WidgetSnapshot snap;
    final Locale locale;
    final Units units;
    try {
      snap = await snapshot();
      if (!_ref.mounted) return null;
      locale = _ref.read(deviceLocaleProvider);
      units = await _units();
      if (!_ref.mounted) return null;
    } on Object catch (error) {
      debugPrint('glance snapshot failed: $error');
      return null;
    }
    final l10n = lookupAppLocalizations(locale);
    try {
      await _publishWidget(snap, l10n, locale, units);
    } on Object catch (error) {
      debugPrint('home widget publish failed: $error');
    }
    try {
      await _ref
          .read(watchSyncProvider)
          .publish(snap, l10n, locale, units: units);
    } on Object catch (error) {
      debugPrint('watch publish failed: $error');
    }
    return snap;
  }
}
