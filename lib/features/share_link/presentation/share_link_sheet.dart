import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/account/presentation/account_controller.dart';
import 'package:migraine_tracker/features/premium/application/premium_controller.dart';
import 'package:migraine_tracker/features/premium/presentation/premium_lock.dart';
import 'package:migraine_tracker/features/report/domain/report_model.dart';
import 'package:migraine_tracker/features/share_link/application/share_link_actions.dart';
import 'package:migraine_tracker/features/share_link/domain/share_link.dart';
import 'package:migraine_tracker/features/share_link/presentation/share_link_text.dart';

/// Creates a clinician link for the report the person is looking at.
Future<void> showShareLinkSheet(
  BuildContext context, {
  required ReportRange range,
  required bool includeQuestionnaires,
}) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => _ShareLinkSheet(
    range: range,
    includeQuestionnaires: includeQuestionnaires,
  ),
);

class _ShareLinkSheet extends ConsumerStatefulWidget {
  const _ShareLinkSheet({
    required this.range,
    required this.includeQuestionnaires,
  });

  final ReportRange range;
  final bool includeQuestionnaires;

  @override
  ConsumerState<_ShareLinkSheet> createState() => _ShareLinkSheetState();
}

class _ShareLinkSheetState extends ConsumerState<_ShareLinkSheet> {
  int _days = AppThresholds.shareLinkDays.first;
  bool _busy = false;
  ShareLinkEntity? _link;
  String? _error;

  Future<void> _create() async {
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final link = await ref
          .read(shareLinkActionsProvider)
          .create(
            range: widget.range,
            includeQuestionnaires: widget.includeQuestionnaires,
            days: _days,
            l10n: l10n,
            locale: locale,
          );
      if (mounted) setState(() => _link = link);
    } on ShareLinkException catch (e) {
      if (mounted) setState(() => _error = shareLinkErrorText(l10n, e.error));
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final signedIn = ref.watch(accountProvider).value != null;
    final link = _link;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppThemeTokens.space4,
          0,
          AppThemeTokens.space4,
          AppThemeTokens.space4,
        ),
        child: Column(
          key: const ValueKey('share-link-sheet'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.shareLinkTitle, style: context.textStyles.titleLarge),
            const SizedBox(height: AppThemeTokens.space2),
            Text(l10n.shareLinkExplain, style: context.textStyles.bodyMedium),
            const SizedBox(height: AppThemeTokens.space4),
            if (!signedIn) ...[
              Text(
                l10n.shareLinkNeedsAccount,
                key: const ValueKey('share-link-needs-account'),
              ),
              const SizedBox(height: AppThemeTokens.space3),
              AppButton(
                key: const ValueKey('share-link-open-account'),
                label: l10n.backupOpenAccount,
                expand: true,
                onPressed: () async {
                  final router = GoRouter.of(context);
                  Navigator.of(context).pop();
                  await router.push<void>(AppRoutes.account);
                },
              ),
            ] else if (link == null &&
                !ref
                    .watch(premiumProvider)
                    .allows(PremiumFeature.shareLink)) ...[
              PremiumLockCard(
                feature: PremiumFeature.shareLink,
                note: l10n.premiumLockShareLinkNote,
                beforeOpen: () => Navigator.of(context).pop(),
              ),
            ] else if (link == null) ...[
              Wrap(
                spacing: AppThemeTokens.space2,
                children: [
                  for (final days in AppThresholds.shareLinkDays)
                    AppChoiceChip(
                      key: ValueKey('share-days-$days'),
                      label: l10n.shareLinkDuration(days),
                      selected: _days == days,
                      onSelected: _busy
                          ? null
                          : (_) => setState(() => _days = days),
                    ),
                ],
              ),
              const SizedBox(height: AppThemeTokens.space3),
              AppButton(
                key: const ValueKey('share-link-create'),
                label: _busy ? l10n.shareLinkWorking : l10n.shareLinkCreate,
                expand: true,
                onPressed: _busy ? null : _create,
              ),
            ] else
              _Ready(link: link),
            if (_error != null) ...[
              const SizedBox(height: AppThemeTokens.space3),
              Semantics(
                liveRegion: true,
                child: Text(
                  _error!,
                  key: const ValueKey('share-link-error'),
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: context.appColors.danger,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Ready extends ConsumerWidget {
  const _Ready({required this.link});

  final ShareLinkEntity link;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final until = DateFormat.yMMMd(Localizations.localeOf(context).toString())
        .format(link.expiresAt.toLocal());
    final url = link.url.toString();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          liveRegion: true,
          child: Text(
            l10n.shareLinkReady(until),
            key: const ValueKey('share-link-ready'),
            style: context.textStyles.titleMedium,
          ),
        ),
        const SizedBox(height: AppThemeTokens.space2),
        AppCard(
          child: SelectableText(url, key: const ValueKey('share-link-url')),
        ),
        const SizedBox(height: AppThemeTokens.space3),
        AppButton(
          key: const ValueKey('share-link-share'),
          label: l10n.shareLinkShare,
          icon: Icons.ios_share,
          expand: true,
          onPressed: () =>
              ref.read(shareTextProvider)(l10n.shareLinkMessage(url)),
        ),
        const SizedBox(height: AppThemeTokens.space2),
        AppButton(
          key: const ValueKey('share-link-copy'),
          label: l10n.shareLinkCopy,
          variant: AppButtonVariant.secondary,
          expand: true,
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            await Clipboard.setData(ClipboardData(text: url));
            messenger.showSnackBar(
              SnackBar(content: Text(l10n.shareLinkCopied)),
            );
          },
        ),
      ],
    );
  }
}
