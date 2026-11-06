import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/features/weather/domain/weather_entities.dart';

/// 72-hour sea-level pressure line. Past hours are drawn solid, forecast
/// hours dashed, with a marker at the current hour. Pure drawing: the
/// numbers are read out by the labels around it.
class PressureChart extends StatelessWidget {
  const PressureChart({
    required this.hours,
    required this.now,
    this.height = 160,
    super.key,
  });

  final List<WeatherHourEntity> hours;
  final DateTime now;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: PressureChartPainter(
          hours: hours,
          now: now,
          lineColor: scheme.primary,
          forecastColor: scheme.primary.withValues(alpha: 0.5),
          gridColor: scheme.outlineVariant,
          nowColor: scheme.tertiary,
          labelStyle: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

class PressureChartPainter extends CustomPainter {
  PressureChartPainter({
    required this.hours,
    required this.now,
    required this.lineColor,
    required this.forecastColor,
    required this.gridColor,
    required this.nowColor,
    this.labelStyle,
  });

  final List<WeatherHourEntity> hours;
  final DateTime now;
  final Color lineColor;
  final Color forecastColor;
  final Color gridColor;
  final Color nowColor;
  final TextStyle? labelStyle;

  static const double _labelWidth = 44;

  @override
  void paint(Canvas canvas, Size size) {
    final points = hours.where((h) => h.pressureMsl != null).toList()
      ..sort((a, b) => a.hourUtc.compareTo(b.hourUtc));
    if (points.length < 2) return;

    final first = points.first.hourUtc;
    final last = points.last.hourUtc;
    final span = last.difference(first).inMinutes.toDouble();
    var minP = points.map((p) => p.pressureMsl!).reduce(math.min);
    var maxP = points.map((p) => p.pressureMsl!).reduce(math.max);
    if (maxP - minP < 4) {
      final mid = (maxP + minP) / 2;
      minP = mid - 2;
      maxP = mid + 2;
    }
    final plot = Rect.fromLTWH(
      _labelWidth,
      AppThemeTokens.space2,
      size.width - _labelWidth,
      size.height - AppThemeTokens.space2 * 2,
    );

    double x(DateTime t) =>
        plot.left + plot.width * (t.difference(first).inMinutes / span);
    double y(double p) =>
        plot.bottom - plot.height * ((p - minP) / (maxP - minP));

    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (final p in [minP, (minP + maxP) / 2, maxP]) {
      canvas.drawLine(Offset(plot.left, y(p)), Offset(plot.right, y(p)), grid);
      _label(canvas, p.toStringAsFixed(0), Offset(0, y(p) - 6));
    }

    final nowHour = now.toUtc();
    final nowX = x(nowHour).clamp(plot.left, plot.right);
    canvas.drawLine(
      Offset(nowX, plot.top),
      Offset(nowX, plot.bottom),
      Paint()
        ..color = nowColor
        ..strokeWidth = 1.5,
    );

    final solid = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final dashed = Paint()
      ..color = forecastColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var i = 1; i < points.length; i++) {
      final a = points[i - 1];
      final b = points[i];
      final from = Offset(x(a.hourUtc), y(a.pressureMsl!));
      final to = Offset(x(b.hourUtc), y(b.pressureMsl!));
      if (b.hourUtc.isAfter(nowHour)) {
        _dash(canvas, from, to, dashed);
      } else {
        canvas.drawLine(from, to, solid);
      }
    }

    final current = points.lastWhere(
      (p) => !p.hourUtc.isAfter(nowHour),
      orElse: () => points.first,
    );
    canvas.drawCircle(
      Offset(x(current.hourUtc), y(current.pressureMsl!)),
      4,
      Paint()..color = lineColor,
    );
  }

  void _dash(Canvas canvas, Offset from, Offset to, Paint paint) {
    const dash = 4.0;
    final total = (to - from).distance;
    if (total == 0) return;
    final dir = (to - from) / total;
    var drawn = 0.0;
    while (drawn < total) {
      final end = math.min(drawn + dash, total);
      canvas.drawLine(from + dir * drawn, from + dir * end, paint);
      drawn = end + dash;
    }
  }

  void _label(Canvas canvas, String text, Offset at) {
    TextPainter(
        text: TextSpan(text: text, style: labelStyle),
        textDirection: TextDirection.ltr,
      )
      ..layout(maxWidth: _labelWidth)
      ..paint(canvas, at);
  }

  @override
  bool shouldRepaint(PressureChartPainter old) =>
      old.hours != hours || old.now != now || old.lineColor != lineColor;
}
