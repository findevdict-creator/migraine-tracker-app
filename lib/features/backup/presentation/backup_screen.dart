import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:migraine_tracker/app/router.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/account/presentation/account_controller.dart';
import 'package:migraine_tracker/features/backup/application/backup_service.dart';
import 'package:migraine_tracker/features/backup/domain/backup_store.dart';

/// The stored backup's time and size, refreshed after every action.
final FutureProvider<BackupInfo?> backupInfoProvider =
    FutureProvider.autoDispose<BackupInfo?>((ref) {
      ref.watch(accountProvider);
      return ref.watch(backupServiceProvider).info();
    });

String _problemText(AppLocalizations l10n, BackupProblem problem) =>
    switch (problem) {
      BackupProblem.signedOut => l10n.backupNeedsAccount,
      BackupProblem.noBackup => l10n.backupErrorNoBackup,
      BackupProblem.tooLarge => l10n.backupErrorTooLarge,
      BackupProblem.newerApp => l10n.backupErrorNewerApp,
      BackupProblem.wrongPassphrase => l10n.backupErrorWrongPassphrase,
      BackupProblem.damaged => l10n.backupErrorDamaged,
      BackupProblem.network => l10n.accountErrorNetwork,
      BackupProblem.pinning => l10n.backupErrorPinning,
      BackupProblem.notAllowed => l10n.backupErrorNotAllowed,
      BackupProblem.unknown => l10n.accountErrorUnknown,
    };

/// FR-23: back up and restore, encrypted on the phone.
class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  final _passphrase = TextEditingController();
  final _repeat = TextEditingController();
  bool _busy = false;
  String? _message;
  bool _messageIsError = false;

  @override
  void dispose() {
    _passphrase.dispose();
    _repeat.dispose();
    super.dispose();
  }

  String _when(DateTime at) =>
      DateFormat.yMMMd(Localizations.localeOf(context).toString())
          .add_jm()
          .format(at.toLocal());

  void _say(String text, {bool error = false}) => setState(() {
    _message = text;
    _messageIsError = error;
  });

  Future<void> _run(
    Future<void> Function(BackupService service) action,
    String done,
  ) async {
    final l10n = context.l10n;
    setState(() {
      _busy = true;
      _message = null;
    });
    String? problem;
    try {
      await action(ref.read(backupServiceProvider));
    } on BackupException catch (e) {
      problem = _problemText(l10n, e.problem);
    }
    if (!mounted) return;
    ref.invalidate(backupInfoProvider);
    setState(() => _busy = false);
    if (problem == null) {
      _passphrase.clear();
      _repeat.clear();
      _say(done);
    } else {
      _say(problem, error: true);
    }
  }

  Future<void> _backUp() async {
    final l10n = context.l10n;
    const min = AppBackup.minPassphraseLength;
    if (_passphrase.text.length < min) {
      return _say(l10n.backupErrorShort(min), error: true);
    }
    if (_repeat.text != _passphrase.text) {
      return _say(l10n.backupErrorMismatch, error: true);
    }
    final passphrase = _passphrase.text;
    await _run((s) => s.backUp(passphrase), l10n.backupDone);
  }

  Future<void> _restore(BackupInfo info) async {
    final l10n = context.l10n;
    if (_passphrase.text.isEmpty) {
      return _say(l10n.backupErrorWrongPassphrase, error: true);
    }
    final ok = await _confirm(
      key: 'backup-restore-confirm',
      title: l10n.backupRestoreTitle,
      body: l10n.backupRestoreBody(_when(info.updatedAt)),
      action: l10n.backupRestoreConfirm,
    );
    if (!ok || !mounted) return;
    final passphrase = _passphrase.text;
    await _run((s) => s.restore(passphrase), l10n.backupRestored);
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final ok = await _confirm(
      key: 'backup-delete-confirm',
      title: l10n.backupDeleteTitle,
      body: l10n.backupDeleteBody,
      action: l10n.backupDelete,
    );
    if (!ok || !mounted) return;
    await _run((s) => s.deleteBackup(), l10n.backupDeleted);
  }

  Future<bool> _confirm({
    required String key,
    required String title,
    required String body,
    required String action,
  }) async {
    final l10n = context.l10n;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.settingsCancel),
          ),
          FilledButton(
            key: ValueKey(key),
            style: FilledButton.styleFrom(
              backgroundColor: context.appColors.danger,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(action),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final signedIn = ref.watch(accountProvider).value != null;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupTitle)),
      body: ListView(
        key: const ValueKey('backup-list'),
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          Text(l10n.backupIntro, style: context.textStyles.bodyMedium),
          const SizedBox(height: AppThemeTokens.space3),
          AppCard(
            key: const ValueKey('backup-warning'),
            child: Text(l10n.backupForgetWarning),
          ),
          const SizedBox(height: AppThemeTokens.space4),
          if (!signedIn) ...[
            Text(
              l10n.backupNeedsAccount,
              key: const ValueKey('backup-needs-account'),
            ),
            const SizedBox(height: AppThemeTokens.space3),
            AppButton(
              key: const ValueKey('backup-open-account'),
              label: l10n.backupOpenAccount,
              expand: true,
              onPressed: () => context.push(AppRoutes.account),
            ),
          ] else
            ..._signedIn(l10n),
        ],
      ),
    );
  }

  List<Widget> _signedIn(AppLocalizations l10n) {
    final info = ref.watch(backupInfoProvider);
    final existing = info.value;
    final enabled = !_busy;
    return [
      Text(
        switch (info) {
          AsyncData(value: final i?) => l10n.backupLast(_when(i.updatedAt)),
          AsyncData() => l10n.backupNone,
          AsyncError() => l10n.backupStatusUnknown,
          _ => '',
        },
        key: const ValueKey('backup-status'),
        style: context.textStyles.titleMedium,
      ),
      const SizedBox(height: AppThemeTokens.space4),
      TextField(
        key: const ValueKey('backup-passphrase'),
        controller: _passphrase,
        enabled: enabled,
        obscureText: true,
        autocorrect: false,
        enableSuggestions: false,
        decoration: InputDecoration(
          labelText: l10n.backupPassphrase,
          helperText: l10n.backupPassphraseHint(AppBackup.minPassphraseLength),
          helperMaxLines: 2,
        ),
      ),
      const SizedBox(height: AppThemeTokens.space2),
      TextField(
        key: const ValueKey('backup-passphrase-repeat'),
        controller: _repeat,
        enabled: enabled,
        obscureText: true,
        autocorrect: false,
        enableSuggestions: false,
        decoration: InputDecoration(labelText: l10n.backupPassphraseRepeat),
      ),
      const SizedBox(height: AppThemeTokens.space3),
      AppButton(
        key: const ValueKey('backup-now'),
        label: l10n.backupNow,
        expand: true,
        onPressed: enabled ? _backUp : null,
      ),
      if (existing != null) ...[
        const SizedBox(height: AppThemeTokens.space2),
        AppButton(
          key: const ValueKey('backup-restore'),
          label: l10n.backupRestore,
          variant: AppButtonVariant.secondary,
          expand: true,
          onPressed: enabled ? () => _restore(existing) : null,
        ),
        AppButton(
          key: const ValueKey('backup-delete'),
          label: l10n.backupDelete,
          variant: AppButtonVariant.text,
          onPressed: enabled ? _delete : null,
        ),
      ],
      if (_busy) ...[
        const SizedBox(height: AppThemeTokens.space3),
        Text(l10n.backupWorking, key: const ValueKey('backup-busy')),
      ],
      if (_message != null) ...[
        const SizedBox(height: AppThemeTokens.space3),
        Semantics(
          liveRegion: true,
          child: Text(
            _message!,
            key: const ValueKey('backup-message'),
            style: context.textStyles.bodyMedium?.copyWith(
              color: _messageIsError ? context.appColors.danger : null,
            ),
          ),
        ),
      ],
    ];
  }
}
