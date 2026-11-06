import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/units/units.dart';
import 'package:migraine_tracker/core/widgets/risk_level_badge.dart';
import 'package:migraine_tracker/features/notifications/domain/notification_planner.dart';
import 'package:migraine_tracker/features/risk/domain/risk_entities.dart';
import 'package:migraine_tracker/features/risk/presentation/risk_text.dart';
import 'package:risk_model/risk_model.dart';

enum PressureTrend { falling, steady, rising }

/// What the home-screen widgets show. Built from the local stores, then
/// rendered into ready-to-show strings so the native widgets carry no
/// copy of their own.
@immutable
class WidgetSnapshot {
  const WidgetSnapshot({
    required this.updatedAt,
    this.level,
    this.driver,
    this.trend,
    this.delta24h,
    this.attackRunning = false,
  });

  /// Pure: today's stored risk, the forecast points ahead (first one is
  /// the current hour) and whether an attack is running.
  factory WidgetSnapshot.build({
    required DateTime now,
    RiskDayEntity? today,
    List<PressureForecastPoint> pressure = const [],
    bool attackRunning = false,
  }) {
    final points = [...pressure]
      ..sort((a, b) => a.hourLocal.compareTo(b.hourLocal));
    final current = points
        .where(
          (p) =>
              !p.hourLocal.isBefore(now.subtract(const Duration(minutes: 59))),
        )
        .firstOrNull;
    final delta = current?.delta24h;
    return WidgetSnapshot(
      updatedAt: now,
      level: today?.level,
      driver: today?.drivers().firstOrNull?.factor,
      delta24h: delta,
      trend: delta == null ? null : trendOf(delta),
      attackRunning: attackRunning,
    );
  }

  static PressureTrend trendOf(double delta24h) {
    if (delta24h <= -AppThresholds.widgetPressureSteadyHpa) {
      return PressureTrend.falling;
    }
    if (delta24h >= AppThresholds.widgetPressureSteadyHpa) {
      return PressureTrend.rising;
    }
    return PressureTrend.steady;
  }

  final DateTime updatedAt;
  final RiskLevel? level;
  final Factor? driver;
  final PressureTrend? trend;
  final double? delta24h;
  final bool attackRunning;

  /// The strings the native widgets display, keyed by [AppHomeWidgets].
  Map<String, String> render(
    AppLocalizations l10n, {
    String? locale,
    Units units = const Units(),
  }) {
    final level = this.level;
    final driver = this.driver;
    final delta = delta24h;
    final hpa = delta == null ? '' : units.pressureText(l10n, delta.abs());
    return {
      AppHomeWidgets.keyLevel: level?.id ?? '',
      AppHomeWidgets.keyLevelLabel: level == null
          ? l10n.widgetNoLevel
          : l10n.widgetLevel(level.label(l10n)),
      AppHomeWidgets.keyHeadline: driver == null
          ? l10n.widgetNoDriver
          : l10n.widgetDriver(factorLabel(l10n, driver)),
      AppHomeWidgets.keyPressure: switch (trend) {
        null => l10n.widgetPressureUnknown,
        PressureTrend.falling => l10n.widgetPressureFalling(hpa),
        PressureTrend.steady => l10n.widgetPressureSteady,
        PressureTrend.rising => l10n.widgetPressureRising(hpa),
      },
      AppHomeWidgets.keyUpdated: l10n.widgetUpdated(
        DateFormat.Hm(locale).format(updatedAt),
      ),
      AppHomeWidgets.keyStartLabel: attackRunning
          ? l10n.widgetOpenAttack
          : l10n.widgetStartAttack,
      AppHomeWidgets.keyRunning: attackRunning ? '1' : '0',
    };
  }
}

/// What a widget tap asks for.
enum WidgetAction { startAttack, open }

abstract final class WidgetLink {
  /// Null for a link that is not from the widget at all.
  static WidgetAction? parse(Uri? uri) {
    if (uri == null) return null;
    if (uri.scheme != AppIdentity.deepLinkScheme) return null;
    if (uri.host == AppHomeWidgets.startAttackHost &&
        uri.path == AppHomeWidgets.startAttackPath) {
      return WidgetAction.startAttack;
    }
    return WidgetAction.open;
  }
}
