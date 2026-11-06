import 'package:flutter/material.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/features/questionnaires/domain/questionnaire.dart';

/// The last few scores of one instrument as a line over the band
/// thresholds. Reads its colours from the theme, reports its content
/// through [semanticLabel].
class ScoreChart extends StatelessWidget {
  const ScoreChart({
    required this.kind,
    required this.responses,
    required this.semanticLabel,
    super.key,
  });

  final QuestionnaireKind kind;

  /// Oldest first; only the last [AppThresholds.questionnaireChartPoints]
  /// are drawn.
  final List<QuestionnaireResponse> responses;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final shown = responses.length > AppThresholds.questionnaireChartPoints
        ? responses.sublist(
            responses.length - AppThresholds.questionnaireChartPoints,
          )
        : responses;
    return Semantics(
      label: semanticLabel,
      child: ExcludeSemantics(
        child: SizedBox(
          height: 96,
          child: CustomPaint(
            painter: _ScorePainter(
              kind: kind,
              scores: [for (final r in shown) r.score],
              line: Theme.of(context).colorScheme.primary,
              grid: Theme.of(context).colorScheme.outlineVariant,
              bands: [
                context.appColors.success,
                context.appColors.riskLow,
                context.appColors.riskModerate,
                context.appColors.riskHigh,
              ],
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class _ScorePainter extends CustomPainter {
  const _ScorePainter({
    required this.kind,
    required this.scores,
    required this.line,
    required this.grid,
    required this.bands,
  });

  final QuestionnaireKind kind;
  final List<int> scores;
  final Color line;
  final Color grid;
  final List<Color> bands;

  /// Upper edge of each band but the last, in score units.
  List<int> get _thresholds => switch (kind) {
    QuestionnaireKind.midas => const [5, 10, 20],
    QuestionnaireKind.hit6 => const [49, 55, 59],
  };

  /// Chart ceiling: MIDAS scores can run to 450, but a ceiling of 40
  /// keeps the four grades readable; anything above is clamped.
  int get _ceiling => switch (kind) {
    QuestionnaireKind.midas => 40,
    QuestionnaireKind.hit6 => Hit6.maxScore,
  };

  double _y(int score, Size size) {
    final min = kind.minScore;
    final span = _ceiling - min;
    final v = (score.clamp(min, _ceiling) - min) / span;
    return size.height - v * size.height;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var top = 0.0;
    final edges = [..._thresholds.map((t) => _y(t, size)), size.height];
    for (var i = bands.length - 1; i >= 0; i--) {
      final bottom = edges.length > i ? edges[i] : size.height;
      canvas.drawRect(
        Rect.fromLTRB(0, top, size.width, bottom),
        Paint()..color = bands[i].withValues(alpha: 0.18),
      );
      top = bottom;
    }
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (final e in edges.take(_thresholds.length)) {
      canvas.drawLine(Offset(0, e), Offset(size.width, e), gridPaint);
    }
    if (scores.isEmpty) return;
    final step = scores.length == 1 ? 0.0 : size.width / (scores.length - 1);
    final points = [
      for (final (i, s) in scores.indexed)
        Offset(scores.length == 1 ? size.width / 2 : i * step, _y(s, size)),
    ];
    final linePaint = Paint()
      ..color = line
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, linePaint);
    for (final p in points) {
      canvas.drawCircle(p, 4, Paint()..color = line);
    }
  }

  @override
  bool shouldRepaint(_ScorePainter old) =>
      old.kind != kind ||
      old.line != line ||
      old.grid != grid ||
      !_same(old.scores, scores);

  static bool _same(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
