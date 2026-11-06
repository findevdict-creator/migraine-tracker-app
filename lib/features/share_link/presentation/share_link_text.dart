import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/features/share_link/domain/share_link.dart';

String shareLinkErrorText(AppLocalizations l10n, ShareLinkError error) =>
    switch (error) {
      ShareLinkError.signedOut => l10n.shareLinkErrorSignedOut,
      ShareLinkError.unavailable => l10n.shareLinkErrorUnavailable,
      ShareLinkError.network => l10n.accountErrorNetwork,
      ShareLinkError.unknown => l10n.accountErrorUnknown,
    };
