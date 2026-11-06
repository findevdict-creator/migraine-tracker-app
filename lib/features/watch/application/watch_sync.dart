import 'dart:ui' show Color, Locale;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/settings/settings_keys.dart';
import 'package:migraine_tracker/core/settings/settings_repository.dart';
import 'package:migraine_tracker/core/units/units.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/attack_log/data/attack_repository_impl.dart';
import 'package:migraine_tracker/features/home_widget/domain/widget_snapshot.dart';
import 'package:migraine_tracker/features/watch/data/watch_link.dart';
import 'package:risk_model/risk_model.dart';
import 'package:watch_protocol/watch_protocol.dart';

final watchSyncProvider = Provider<WatchSync>(WatchSync.new);

/// Builds the state the watch shows from the same snapshot as the home
/// widget, plus the running attack and the acknowledged command ids.
class WatchSync {
  WatchSync(this._ref);

  final Ref _ref;

  Future<WatchState?> publish(
    WidgetSnapshot snapshot,
    AppLocalizations l10n,
    Locale locale, {
    Units units = const Units(),
  }) async {
    if (!AppFeatureFlags.watchAvailable) return null;
    final state = await build(snapshot, l10n, locale, units: units);
    await _ref
        .read(watchLinkProvider)
        .pushState(WatchWire.wrap(state.toJson()));
    return state;
  }

  Future<WatchState> build(
    WidgetSnapshot snapshot,
    AppLocalizations l10n,
    Locale locale, {
    Units units = const Units(),
  }) async {
    final text = snapshot.render(l10n, locale: locale.toString(), units: units);
    final running = await _ref.read(attackRepositoryProvider).running();
    final ledger = await _ref.read(watchLedgerStoreProvider).read();
    final level = snapshot.level;
    return WatchState(
      sentAt: _ref.read(clockProvider)().toUtc(),
      level: text[AppHomeWidgets.keyLevel] ?? '',
      levelLabel: text[AppHomeWidgets.keyLevelLabel] ?? '',
      headline: text[AppHomeWidgets.keyHeadline] ?? '',
      pressure: text[AppHomeWidgets.keyPressure] ?? '',
      updated: text[AppHomeWidgets.keyUpdated] ?? '',
      // Watches draw on black, so the dark-theme colours apply.
      levelColor: level == null ? null : _darkColor(level).toARGB32(),
      accentColor: AppThemeTokens.seed.toARGB32(),
      attack: running == null
          ? null
          : WatchAttack(
              startedAt: running.startedAt,
              intensity: running.intensity,
            ),
      labels: watchLabels(l10n),
      acks: ledger.acks,
    );
  }

  static Map<String, String> watchLabels(AppLocalizations l10n) => {
    WatchLabels.start: l10n.watchStart,
    WatchLabels.stop: l10n.watchStop,
    WatchLabels.intensity: l10n.watchIntensity,
    // The watch fills in the time itself.
    WatchLabels.since: l10n.watchSince('{time}'),
    WatchLabels.pending: l10n.watchPending,
    WatchLabels.noPhone: l10n.watchNoPhone,
  };

  static Color _darkColor(RiskLevel level) => switch (level) {
    RiskLevel.low => AppThemeTokens.riskLowDark,
    RiskLevel.moderate => AppThemeTokens.riskModerateDark,
    RiskLevel.high => AppThemeTokens.riskHighDark,
  };
}

final watchLedgerStoreProvider = Provider<WatchLedgerStore>(
  (ref) => WatchLedgerStore(ref.watch(settingsRepositoryProvider)),
);

/// Persists the ids of applied watch commands in settings.
class WatchLedgerStore {
  const WatchLedgerStore(this._settings);

  final SettingsRepository _settings;

  Future<CommandLedger> read() async {
    final raw = await _settings.read<List<dynamic>>(SettingsKeys.watchLedger);
    return CommandLedger(raw?.whereType<String>().toList() ?? const []);
  }

  Future<void> write(CommandLedger ledger) =>
      _settings.write(SettingsKeys.watchLedger, ledger.ids);
}
