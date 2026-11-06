import 'package:flutter/material.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// "About the data": where each number comes from, its licence and its
/// coverage, plus what leaves the device. The list is
/// [AppDataSources.entries] in the central config.
class AboutDataScreen extends StatelessWidget {
  const AboutDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutDataTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          Text(l10n.aboutDataIntro, style: context.textStyles.bodyMedium),
          const SizedBox(height: AppThemeTokens.space4),
          SectionHeader(title: l10n.aboutDataSources),
          for (final source in AppDataSources.entries)
            ListTile(
              key: ValueKey('source-${source.id}'),
              contentPadding: EdgeInsets.zero,
              title: Text(source.name),
              subtitle: Text(
                source.licence == null
                    ? source.coverage
                    : l10n.aboutDataLicence(source.coverage, source.licence!),
              ),
              trailing: source.url == null
                  ? null
                  : const Icon(Icons.open_in_new, size: 18),
              onTap: source.url == null
                  ? null
                  : () => launchUrl(
                      Uri.parse(source.url!),
                      mode: LaunchMode.externalApplication,
                    ),
            ),
          const SizedBox(height: AppThemeTokens.space4),
          SectionHeader(title: l10n.aboutDataPrivacy),
          Text(l10n.aboutDataPrivacyBody, style: context.textStyles.bodyMedium),
          const SizedBox(height: AppThemeTokens.space4),
          SectionHeader(title: l10n.aboutDataLimits),
          Text(l10n.aboutDataLimitsBody, style: context.textStyles.bodyMedium),
        ],
      ),
    );
  }
}
