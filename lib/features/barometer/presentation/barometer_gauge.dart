import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:migraine_tracker/config/app_config.dart';

/// Half-ring gauge from [AppThresholds.barometerGaugeMinHpa] to
/// [AppThresholds.barometerGaugeMaxHpa]. Null draws the empty ring.
class BarometerGauge extends StatelessWidget {
  const BarometerGauge({required this.hpa, this.size = 220, super.key});

  final double? hpa;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: size,
      height: size / 2 + AppThemeTokens.space4,
      child: CustomPaint(
        painter: BarometerGaugePainter(
          hpa: hpa,
          trackColor: scheme.surfaceContainerHighest,
          fillColor: scheme.primary,
          needleColor: scheme.tertiary,
        ),
      ),
    );
  }
}

class BarometerGaugePainter extends CustomPainter {
  BarometerGaugePainter({
    required this.hpa,
    required this.trackColor,
    required this.fillColor,
    required this.needleColor,
  });

  final double? hpa;
  final Color trackColor;
  final Color fillColor;
  final Color needleColor;

  static const double _stroke = 14;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = Offset(size.width / 2, size.height - AppThemeTokens.space4);
    final radius = math.min(size.width / 2, size.height) - _stroke;
    final rect = Rect.fromCircle(center: centre, radius: radius);
    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, math.pi, math.pi, false, track);

    final value = hpa;
    if (value == null) return;
    const min = AppThresholds.barometerGaugeMinHpa;
    const max = AppThresholds.barometerGaugeMaxHpa;
    final t = ((value - min) / (max - min)).clamp(0.0, 1.0);
    canvas.drawArc(
      rect,
      math.pi,
      math.pi * t,
      false,
      Paint()
        ..color = fillColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = _stroke
        ..strokeCap = StrokeCap.round,
    );
    final angle = math.pi + math.pi * t;
    final tip = centre + Offset(math.cos(angle), math.sin(angle)) * radius;
    canvas
      ..drawLine(
        centre,
        tip,
        Paint()
          ..color = needleColor
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round,
      )
      ..drawCircle(centre, 6, Paint()..color = needleColor);
  }

  @override
  bool shouldRepaint(BarometerGaugePainter old) =>
      old.hpa != hpa || old.fillColor != fillColor;
}

/// Small sparkline of the last 24 h of samples.
class PressureSparkline extends StatelessWidget {
  const PressureSparkline({required this.values, this.height = 64, super.key});

  final List<double> values;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: CustomPaint(
      painter: _SparklinePainter(
        values: values,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    var min = values.reduce(math.min);
    var max = values.reduce(math.max);
    if (max - min < 2) {
      final mid = (max + min) / 2;
      min = mid - 1;
      max = mid + 1;
    }
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height - size.height * (values[i] - min) / (max - min);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.values != values || old.color != color;
}
