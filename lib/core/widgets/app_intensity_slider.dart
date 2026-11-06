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
    final ends = [?lowLabel, ?highLabel].join(' – ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              // One node for screen readers: "Pain intensity, 7, 0 is ...
              // to 10 is ...", with swipe up and down to change it.
              child: MergeSemantics(
                child: Semantics(
                  label: semanticLabel,
                  hint: ends.isEmpty ? null : ends,
                  child: Slider(
                    value: current.toDouble(),
                    min: min.toDouble(),
                    max: max.toDouble(),
                    divisions: max - min,
                    label: current.toString(),
                    // The scale's own number, not the default percentage.
                    semanticFormatterCallback: (v) => v.round().toString(),
                    onChanged: (v) => onChanged(v.round()),
                  ),
                ),
              ),
            ),
            // The big number repeats the slider's value for sighted users.
            ExcludeSemantics(
              child: SizedBox(
                width: AppThemeTokens.attackTapTarget,
                child: Text(
                  value?.toString() ?? '–', // string_lint: ignore
                  textAlign: TextAlign.center,
                  style: textStyles.headlineMedium,
                ),
              ),
            ),
          ],
        ),
        if (lowLabel != null || highLabel != null)
          ExcludeSemantics(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppThemeTokens.space4,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(lowLabel ?? '', style: textStyles.bodyMedium),
                  ),
                  const SizedBox(width: AppThemeTokens.space2),
                  Expanded(
                    child: Text(
                      highLabel ?? '',
                      textAlign: TextAlign.end,
                      style: textStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
