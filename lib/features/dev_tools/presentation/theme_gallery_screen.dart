import 'package:flutter/material.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/theme/app_theme.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';

/// Developer screen showing every core widget in the light, dark and attack
/// themes. Only routed when `AppFeatureFlags.showDevTools` is on.
class ThemeGalleryScreen extends StatelessWidget {
  const ThemeGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.devThemeGalleryTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          _ThemedSection(title: l10n.devThemeLight, theme: AppTheme.light()),
          _ThemedSection(title: l10n.devThemeDark, theme: AppTheme.dark()),
          _ThemedSection(title: l10n.devThemeAttack, theme: AppTheme.attack()),
        ],
      ),
    );
  }
}

class _ThemedSection extends StatelessWidget {
  const _ThemedSection({required this.title, required this.theme});

  final String title;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme,
      child: Builder(
        builder: (context) => Container(
          color: theme.scaffoldBackgroundColor,
          padding: const EdgeInsets.all(AppThemeTokens.space4),
          margin: const EdgeInsets.only(bottom: AppThemeTokens.space4),
          child: ThemeGalleryContent(title: title),
        ),
      ),
    );
  }
}

/// The widget set rendered by the gallery and by the golden tests.
class ThemeGalleryContent extends StatelessWidget {
  const ThemeGalleryContent({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: title),
        Text(l10n.devSampleBody, style: context.textStyles.bodyLarge),
        const SizedBox(height: AppThemeTokens.space3),
        Wrap(
          spacing: AppThemeTokens.space2,
          runSpacing: AppThemeTokens.space2,
          children: [
            AppButton(label: l10n.devSamplePrimary, onPressed: () {}),
            AppButton(
              label: l10n.devSampleSecondary,
              variant: AppButtonVariant.secondary,
              onPressed: () {},
            ),
            AppButton(
              label: l10n.devSampleText,
              variant: AppButtonVariant.text,
              onPressed: () {},
            ),
            AppButton(label: l10n.devSampleDisabled, onPressed: null),
          ],
        ),
        const SizedBox(height: AppThemeTokens.space3),
        Wrap(
          spacing: AppThemeTokens.space2,
          runSpacing: AppThemeTokens.space2,
          children: [
            AppChoiceChip(
              label: l10n.devSampleChipOn,
              selected: true,
              onSelected: (_) {},
            ),
            AppChoiceChip(
              label: l10n.devSampleChipOff,
              selected: false,
              onSelected: (_) {},
            ),
            AppChoiceChip(
              label: l10n.devSampleChipIcon,
              icon: Icons.bolt,
              selected: true,
              onSelected: (_) {},
            ),
          ],
        ),
        const SizedBox(height: AppThemeTokens.space3),
        AppIntensitySlider(
          value: 7,
          onChanged: (_) {},
          semanticLabel: l10n.devSampleSlider,
          lowLabel: l10n.devSampleSliderLow,
          highLabel: l10n.devSampleSliderHigh,
        ),
        const SizedBox(height: AppThemeTokens.space3),
        AppCard(
          child: Row(
            children: [
              Expanded(child: Text(l10n.devSampleCard)),
              const RiskLevelBadge(level: RiskLevel.moderate),
            ],
          ),
        ),
        const SizedBox(height: AppThemeTokens.space3),
        const Wrap(
          spacing: AppThemeTokens.space2,
          children: [
            RiskLevelBadge(level: RiskLevel.low),
            RiskLevelBadge(level: RiskLevel.moderate),
            RiskLevelBadge(level: RiskLevel.high),
            RiskLevelBadge(level: RiskLevel.high, large: true),
          ],
        ),
      ],
    );
  }
}
