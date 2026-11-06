import 'package:flutter/material.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';

/// Integer slider with the current value shown large beside it, used for
/// pain intensity (0 to 10) and the 1 to 5 check-in scales.
class AppIntensitySlider extends StatelessWidget {
  const AppIntensitySlider({
    required this.value,
    required this.onChanged,
    required this.semanticLabel,
    this.min = 0,
    this.max = 10,
    this.lowLabel,
    this.highLabel,
    super.key,
  });

  final int? value;
  final ValueChanged<int> onChanged;
  final String semanticLabel;
  final int min;
  final int max;
  final String? lowLabel;
  final String? highLabel;

  @override
  Widget build(BuildContext context) {
    final current = value ?? min;
    final textStyles = context.textStyles;
    return Semantics(
      label: semanticLabel,
      value: value?.toString(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: current.toDouble(),
                  min: min.toDouble(),
                  max: max.toDouble(),
                  divisions: max - min,
                  label: current.toString(),
                  onChanged: (v) => onChanged(v.round()),
                ),
              ),
              SizedBox(
                width: AppThemeTokens.attackTapTarget,
                child: Text(
                  value?.toString() ?? '–', // string_lint: ignore
                  textAlign: TextAlign.center,
                  style: textStyles.headlineMedium,
                ),
              ),
            ],
          ),
          if (lowLabel != null || highLabel != null)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppThemeTokens.space4,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lowLabel ?? '', style: textStyles.bodyMedium),
                  Text(highLabel ?? '', style: textStyles.bodyMedium),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
