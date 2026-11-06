import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/util/clock.dart';
import 'package:migraine_tracker/features/account/presentation/account_controller.dart';
import 'package:migraine_tracker/features/report/application/report_content.dart';
import 'package:migraine_tracker/features/report/application/report_service.dart';
import 'package:migraine_tracker/features/report/domain/report_model.dart';
import 'package:migraine_tracker/features/share_link/data/share_link_data.dart';
import 'package:migraine_tracker/features/share_link/domain/share_link.dart';
import 'package:share_plus/share_plus.dart';

/// Links this phone made, newest first.
final shareLinksProvider = StreamProvider<List<ShareLinkEntity>>(
  (ref) => ref.watch(shareLinkMirrorProvider).watchAll(),
);

/// Hands a link to the platform share sheet. Overridden in tests.
typedef ShareText = Future<void> Function(String text);

final shareTextProvider = Provider<ShareText>(
  (_) => (text) async {
    await SharePlus.instance.share(ShareParams(text: text));
  },
);

final shareLinkActionsProvider = Provider<ShareLinkActions>(
  ShareLinkActions.new,
);

class ShareLinkActions {
  ShareLinkActions(this._ref);

  final Ref _ref;

  /// Builds the same report the PDF shows, uploads it, and remembers the
  /// link on the phone.
  Future<ShareLinkEntity> create({
    required ReportRange range,
    required bool includeQuestionnaires,
    required int days,
    required AppLocalizations l10n,
    required String locale,
  }) async {
    if (_ref.read(accountProvider).value == null) {
      throw const ShareLinkException(ShareLinkError.signedOut);
    }
    final summary = await _ref.read(reportServiceProvider).summary(range);
    final document = ReportContent(
      l10n,
      locale: locale,
    ).build(summary, includeQuestionnaires: includeQuestionnaires);
    final created = await _ref
        .read(shareLinkGatewayProvider)
        .create(days: days, document: document.toJson());
    final link = ShareLinkEntity(
      token: created.token,
      createdAt: _ref.read(clockProvider)(),
      expiresAt: created.expiresAt,
    );
    await _ref.read(shareLinkMirrorProvider).add(link);
    return link;
  }

  /// Deletes the server snapshot first; the mirror changes only after.
  Future<void> revoke(ShareLinkEntity link) async {
    await _ref.read(shareLinkGatewayProvider).revoke(link.token);
    await _ref.read(shareLinkMirrorProvider).markRevoked(link.token);
  }
}
