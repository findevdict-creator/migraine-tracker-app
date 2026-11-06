import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/share_link/application/share_link_actions.dart';
import 'package:migraine_tracker/features/share_link/domain/share_link.dart';
import 'package:migraine_tracker/features/share_link/presentation/share_link_text.dart';

/// Every link this phone made, with "Stop sharing" on the live ones.
class ShareLinksScreen extends ConsumerWidget {
  const ShareLinksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final links = ref.watch(shareLinksProvider).value;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.shareLinksTitle)),
      body: ListView(
        key: const ValueKey('share-links-list'),
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          if (links != null && links.isEmpty)
            Text(
              l10n.shareLinksEmpty,
              key: const ValueKey('share-links-empty'),
            ),
          for (final link in links ?? const <ShareLinkEntity>[])
            _LinkCard(link: link),
        ],
      ),
    );
  }
}

class _LinkCard extends ConsumerStatefulWidget {
  const _LinkCard({required this.link});

  final ShareLinkEntity link;

  @override
  ConsumerState<_LinkCard> createState() => _LinkCardState();
}

class _LinkCardState extends ConsumerState<_LinkCard> {
  bool _busy = false;

  Future<void> _revoke() async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.shareLinkRevokeTitle),
        content: Text(l10n.shareLinkRevokeBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.settingsCancel),
          ),
          FilledButton(
            key: const ValueKey('share-link-revoke-confirm'),
            style: FilledButton.styleFrom(
              backgroundColor: context.appColors.danger,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.shareLinkRevoke),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    String text;
    try {
      await ref.read(shareLinkActionsProvider).revoke(widget.link);
      text = l10n.shareLinkRevokedDone;
    } on ShareLinkException catch (e) {
      text = shareLinkErrorText(l10n, e.error);
    }
    if (mounted) setState(() => _busy = false);
    messenger.showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final link = widget.link;
    final fmt = DateFormat.yMMMd(Localizations.localeOf(context).toString());
    final status = link.statusAt(ref.watch(clockProvider)());
    final line = switch (status) {
      ShareLinkStatus.active => l10n.shareLinkActiveUntil(
        fmt.format(link.expiresAt.toLocal()),
      ),
      ShareLinkStatus.expired => l10n.shareLinkExpiredOn(
        fmt.format(link.expiresAt.toLocal()),
      ),
      ShareLinkStatus.revoked => l10n.shareLinkRevoked,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: AppThemeTokens.space3),
      child: AppCard(
        key: ValueKey('share-link-${link.token}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(line, style: context.textStyles.titleMedium),
            Text(
              l10n.shareLinkCreatedOn(fmt.format(link.createdAt.toLocal())),
              style: context.textStyles.bodySmall,
            ),
            if (status == ShareLinkStatus.active) ...[
              const SizedBox(height: AppThemeTokens.space2),
              SelectableText(
                link.url.toString(),
                style: context.textStyles.bodySmall,
              ),
              AppButton(
                key: ValueKey('share-link-revoke-${link.token}'),
                label: l10n.shareLinkRevoke,
                variant: AppButtonVariant.text,
                onPressed: _busy ? null : _revoke,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
