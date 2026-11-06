import 'package:flutter/material.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/features/attack_log/domain/attack_entity.dart';

/// Front-view head map. Regions are tappable and announced to screen
/// readers; the drawing is a [CustomPainter] so it needs no asset.
class HeadMap extends StatelessWidget {
  const HeadMap({
    required this.selected,
    required this.onToggle,
    this.size = 280,
    super.key,
  });

  final Set<HeadLocation> selected;
  final ValueChanged<HeadLocation> onToggle;
  final double size;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = context.theme.colorScheme;
    final accent = context.isAttackTheme
        ? context.appColors.attackAccent
        : scheme.primary;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: HeadMapPainter(
                selected: selected,
                outline: scheme.onSurface,
                fill: accent,
              ),
            ),
          ),
          for (final region in HeadLocation.values)
            _RegionTarget(
              region: region,
              size: size,
              selected: selected.contains(region),
              label: headLocationLabel(l10n, region),
              onTap: () => onToggle(region),
            ),
        ],
      ),
    );
  }
}

/// Where each region sits on a unit square (0..1), and its hit radius.
class HeadRegionSpec {
  const HeadRegionSpec(this.dx, this.dy, this.radius);

  final double dx;
  final double dy;
  final double radius;
}

const Map<HeadLocation, HeadRegionSpec> headRegionSpecs = {
  HeadLocation.topOfHead: HeadRegionSpec(0.5, 0.14, 0.11),
  HeadLocation.forehead: HeadRegionSpec(0.5, 0.32, 0.12),
  HeadLocation.leftTemple: HeadRegionSpec(0.27, 0.40, 0.09),
  HeadLocation.rightTemple: HeadRegionSpec(0.73, 0.40, 0.09),
  HeadLocation.behindEyes: HeadRegionSpec(0.5, 0.50, 0.10),
  HeadLocation.leftSide: HeadRegionSpec(0.22, 0.58, 0.09),
  HeadLocation.rightSide: HeadRegionSpec(0.78, 0.58, 0.09),
  HeadLocation.backOfHead: HeadRegionSpec(0.5, 0.70, 0.10),
  HeadLocation.neck: HeadRegionSpec(0.5, 0.90, 0.09),
};

String headLocationLabel(AppLocalizations l10n, HeadLocation location) =>
    switch (location) {
      HeadLocation.forehead => l10n.headForehead,
      HeadLocation.leftTemple => l10n.headLeftTemple,
      HeadLocation.rightTemple => l10n.headRightTemple,
      HeadLocation.behindEyes => l10n.headBehindEyes,
      HeadLocation.leftSide => l10n.headLeftSide,
      HeadLocation.rightSide => l10n.headRightSide,
      HeadLocation.topOfHead => l10n.headTopOfHead,
      HeadLocation.backOfHead => l10n.headBackOfHead,
      HeadLocation.neck => l10n.headNeck,
    };

class _RegionTarget extends StatelessWidget {
  const _RegionTarget({
    required this.region,
    required this.size,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final HeadLocation region;
  final double size;
  final bool selected;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spec = headRegionSpecs[region]!;
    final diameter = (spec.radius * 2 * size).clamp(
      AppThemeTokens.minTapTarget,
      size,
    );
    return Positioned(
      left: spec.dx * size - diameter / 2,
      top: spec.dy * size - diameter / 2,
      width: diameter,
      height: diameter,
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            key: ValueKey('head-${region.name}'),
            customBorder: const CircleBorder(),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}

/// Draws the head outline and fills the selected regions.
class HeadMapPainter extends CustomPainter {
  const HeadMapPainter({
    required this.selected,
    required this.outline,
    required this.fill,
  });

  final Set<HeadLocation> selected;
  final Color outline;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = Paint()
      ..color = outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Neck, ears, head.
    canvas
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.38, h * 0.74, w * 0.24, h * 0.24),
          Radius.circular(w * 0.06),
        ),
        stroke,
      )
      ..drawOval(
        Rect.fromCenter(
          center: Offset(w * 0.17, h * 0.5),
          width: w * 0.1,
          height: h * 0.18,
        ),
        stroke,
      )
      ..drawOval(
        Rect.fromCenter(
          center: Offset(w * 0.83, h * 0.5),
          width: w * 0.1,
          height: h * 0.18,
        ),
        stroke,
      )
      ..drawOval(
        Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.46),
          width: w * 0.62,
          height: h * 0.78,
        ),
        stroke,
      );
    _paintRegions(canvas, size);
  }

  void _paintRegions(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    // Region guides and selections.
    final guide = Paint()
      ..color = outline.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final selectedFill = Paint()
      ..color = fill.withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;
    for (final entry in headRegionSpecs.entries) {
      final c = Offset(entry.value.dx * w, entry.value.dy * h);
      final r = entry.value.radius * w;
      if (selected.contains(entry.key)) {
        canvas.drawCircle(c, r, selectedFill);
      }
      canvas.drawCircle(c, r, guide);
    }
  }

  @override
  bool shouldRepaint(HeadMapPainter oldDelegate) =>
      oldDelegate.selected != selected ||
      oldDelegate.outline != outline ||
      oldDelegate.fill != fill;
}
