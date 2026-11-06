import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/features/risk/presentation/risk_text.dart';
import 'package:risk_model/risk_model.dart';

/// One segment of the meter: a factor's share of the load.
@immutable
class LoadSegment {
  const LoadSegment({
    required this.factor,
    required this.points,
    required this.share,
  });

  final Factor factor;

  /// The factor's own points (0 to 100).
  final double points;

  /// The factor's share of the day's load, in load units, so all shares
  /// add up to the load. Points scale down when several factors stack
  /// because the load combines them without exceeding 100.
  final double share;

  Color get color => AppThemeTokens.factorPalette[factor.index];
}

/// Splits a load among its contributions in proportion to their points.
List<LoadSegment> loadSegments(double load, List<Contribution> contributions) {
  final positive = contributions.where((c) => c.points > 0).toList();
  final total = positive.fold<double>(0, (a, c) => a + c.points);
  if (total == 0 || load <= 0) return const [];
  return [
    for (final c in positive)
      LoadSegment(
        factor: c.factor,
        points: c.points,
        share: load * c.points / total,
      ),
  ];
}

/// FR-10: a stacked bar from 0 to 100 with one named segment per factor
/// and marks where Moderate and High start. The marks come from the
/// thresholds in use, so they move as the model re-weights. Segments are
/// tappable; [onSegmentTap] receives the factor, and the legend rows
/// below the bar are the same tap targets at full size.
class LoadMeter extends StatelessWidget {
  const LoadMeter({
    required this.load,
    required this.contributions,
    required this.thresholds,
    this.onSegmentTap,
    this.showLegend = true,
    this.compact = false,
    super.key,
  });

  final double load;
  final List<Contribution> contributions;
  final LevelThresholds thresholds;
  final ValueChanged<LoadSegment>? onSegmentTap;

  /// Lists every segment with its name and points under the bar.
  final bool showLegend;

  /// Thinner bar and no title, for the home card.
  final bool compact;

  /// Flex factors are integers; a tenth of a load unit is enough.
  static int _flex(double units) => (units.clamp(0, 100) * 10).round();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final segments = loadSegments(load, contributions);
    final colors = context.appColors;
    final height = compact ? 14.0 : 22.0;
    final semantics = segments.isEmpty
        ? l10n.loadMeterEmpty
        : segments
              .map(
                (s) => l10n.loadSegmentDetail(
                  factorLabel(l10n, s.factor),
                  s.points.toStringAsFixed(0),
                ),
              )
              .join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!compact)
          Padding(
            padding: const EdgeInsets.only(bottom: AppThemeTokens.space1),
            child: Text(
              l10n.loadMeterTitle,
              style: context.textStyles.titleSmall,
            ),
          ),
        Semantics(
          label: l10n.loadMeterSemantics(load.toStringAsFixed(0), semantics),
          child: SizedBox(
            height: height,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppThemeTokens.radiusSmall,
                    ),
                    child: ColoredBox(
                      color: context.theme.colorScheme.surfaceContainerHighest,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final (i, s) in segments.indexed)
                            Expanded(
                              flex: _flex(s.share),
                              child: _SegmentTap(
                                key: ValueKey('load-segment-$i'),
                                onTap: onSegmentTap == null
                                    ? null
                                    : () => onSegmentTap!(s),
                                child: ColoredBox(color: s.color),
                              ),
                            ),
                          Expanded(
                            flex: _flex(100 - load),
                            child: const SizedBox.expand(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _Tick(
                  markKey: const ValueKey('load-mark-moderate'),
                  at: thresholds.moderate,
                  color: colors.riskModerate,
                ),
                _Tick(
                  markKey: const ValueKey('load-mark-high'),
                  at: thresholds.high,
                  color: colors.riskHigh,
                ),
              ],
            ),
          ),
        ),
        if (!compact)
          Padding(
            padding: const EdgeInsets.only(top: AppThemeTokens.space1),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: l10n.loadThresholdModerate(
                      thresholds.moderate.toStringAsFixed(0),
                    ),
                    style: TextStyle(color: colors.riskModerate),
                  ),
                  const TextSpan(text: '   '),
                  TextSpan(
                    text: l10n.loadThresholdHigh(
                      thresholds.high.toStringAsFixed(0),
                    ),
                    style: TextStyle(color: colors.riskHigh),
                  ),
                ],
              ),
              key: const ValueKey('load-thresholds'),
              style: context.textStyles.labelSmall,
            ),
          ),
        if (showLegend && segments.isNotEmpty) ...[
          const SizedBox(height: AppThemeTokens.space2),
          for (final (i, s) in segments.indexed)
            InkWell(
              key: ValueKey('load-legend-$i'),
              onTap: onSegmentTap == null ? null : () => onSegmentTap!(s),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AppThemeTokens.minTapTarget,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: s.color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: AppThemeTokens.space2),
                    Expanded(
                      child: Text(
                        factorLabel(l10n, s.factor),
                        style: context.textStyles.bodyMedium,
                      ),
                    ),
                    Text(
                      s.points.toStringAsFixed(0),
                      style: context.textStyles.labelLarge,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ],
    );
  }
}

/// A threshold mark at [at] percent of the bar's width.
class _Tick extends StatelessWidget {
  const _Tick({required this.at, required this.color, this.markKey});

  final double at;
  final Color color;

  /// Key on the mark itself, so tests can read its position.
  final Key? markKey;

  @override
  Widget build(BuildContext context) => Align(
    alignment: FractionalOffset(at / 100, 0),
    child: Container(key: markKey, width: 2, color: color),
  );
}

/// A tap target that claims the pointer at once, so a segment inside a
/// tappable card (the home card is one big InkWell) opens its detail
/// instead of the card.
class _SegmentTap extends StatelessWidget {
  const _SegmentTap({required this.child, required this.onTap, super.key});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (onTap == null) return child;
    return RawGestureDetector(
      behavior: HitTestBehavior.opaque,
      gestures: {
        _EagerTapRecognizer:
            GestureRecognizerFactoryWithHandlers<_EagerTapRecognizer>(
              _EagerTapRecognizer.new,
              (r) => r.onTap = onTap,
            ),
      },
      child: child,
    );
  }
}

class _EagerTapRecognizer extends TapGestureRecognizer {
  @override
  void addAllowedPointer(PointerDownEvent event) {
    super.addAllowedPointer(event);
    resolve(GestureDisposition.accepted);
  }
}
