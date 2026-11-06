import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/core/theme/app_colors.dart';
import 'package:migraine_tracker/core/widgets/widgets.dart';
import 'package:migraine_tracker/features/account/data/firebase_auth_gateway.dart';
import 'package:migraine_tracker/features/account/domain/account.dart';
import 'package:migraine_tracker/features/account/presentation/account_controller.dart';

/// Optional sign-in (FR-23). Signed out is a complete state: the screen
/// says so first, and nothing else in the app asks for an account.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final user = ref.watch(accountProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.accountTitle)),
      body: ListView(
        key: const ValueKey('account-list'),
        padding: const EdgeInsets.all(AppThemeTokens.space4),
        children: [
          ...switch (user) {
            AsyncData(value: final u?) => [_SignedIn(user: u)],
            AsyncData() || AsyncError() => [const _SignedOut()],
            _ => const <Widget>[],
          },
        ],
      ),
    );
  }
}

String? _errorText(AppLocalizations l10n, AccountError error) =>
    switch (error) {
      AccountError.cancelled => null,
      AccountError.wrongCredentials => l10n.accountErrorWrongCredentials,
      AccountError.emailInUse => l10n.accountErrorEmailInUse,
      AccountError.weakPassword => l10n.accountErrorWeakPassword,
      AccountError.invalidEmail => l10n.accountErrorInvalidEmail,
      AccountError.network => l10n.accountErrorNetwork,
      AccountError.needsRecentSignIn => l10n.accountErrorRecentSignIn,
      AccountError.unavailable => l10n.accountUnavailable,
      AccountError.unknown => l10n.accountErrorUnknown,
    };

class _SignedOut extends ConsumerStatefulWidget {
  const _SignedOut();

  @override
  ConsumerState<_SignedOut> createState() => _SignedOutState();
}

class _SignedOutState extends ConsumerState<_SignedOut> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _message;
  bool _messageIsError = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool get _showApple =>
      AppAccounts.appleEnabled &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  Future<void> _run(
    Future<void> Function(AuthGateway gateway) action, {
    String? success,
  }) async {
    final l10n = context.l10n;
    setState(() {
      _busy = true;
      _message = null;
    });
    var message = success;
    var isError = false;
    try {
      await action(ref.read(authGatewayProvider));
    } on AccountException catch (e) {
      message = _errorText(l10n, e.error);
      isError = true;
    }
    if (!mounted) return;
    setState(() {
      _busy = false;
      _message = message;
      _messageIsError = isError;
    });
  }

  /// Checks the form before anything leaves the phone.
  bool _formOk({required bool creating}) {
    final l10n = context.l10n;
    String? problem;
    if (!AccountForm.validEmail(_email.text)) {
      problem = l10n.accountErrorInvalidEmail;
    } else if (creating && !AccountForm.validPassword(_password.text)) {
      problem = l10n.accountErrorWeakPassword;
    }
    if (problem != null) {
      setState(() {
        _message = problem;
        _messageIsError = true;
      });
    }
    return problem == null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final available = ref.watch(authGatewayProvider).available;
    final enabled = available && !_busy;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.accountIntro,
          key: const ValueKey('account-intro'),
          style: context.textStyles.bodyMedium,
        ),
        const SizedBox(height: AppThemeTokens.space4),
        if (!available)
          AppCard(
            key: const ValueKey('account-unavailable'),
            child: Text(l10n.accountUnavailable),
          ),
        if (available && _showApple) ...[
          AppButton(
            key: const ValueKey('account-apple'),
            label: l10n.accountApple,
            icon: Icons.apple,
            expand: true,
            onPressed: enabled ? () => _run((g) => g.signInWithApple()) : null,
          ),
          const SizedBox(height: AppThemeTokens.space2),
        ],
        if (available && AppAccounts.googleEnabled) ...[
          AppButton(
            key: const ValueKey('account-google'),
            label: l10n.accountGoogle,
            variant: AppButtonVariant.secondary,
            expand: true,
            onPressed: enabled ? () => _run((g) => g.signInWithGoogle()) : null,
          ),
          const SizedBox(height: AppThemeTokens.space4),
        ],
        if (available && AppAccounts.emailEnabled) ...[
          SectionHeader(title: l10n.accountOrEmail),
          TextField(
            key: const ValueKey('account-email'),
            controller: _email,
            enabled: enabled,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            autocorrect: false,
            decoration: InputDecoration(labelText: l10n.accountEmail),
          ),
          const SizedBox(height: AppThemeTokens.space2),
          TextField(
            key: const ValueKey('account-password'),
            controller: _password,
            enabled: enabled,
            obscureText: true,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              labelText: l10n.accountPassword,
              helperText: l10n.accountPasswordHint(
                AppAccounts.minPasswordLength,
              ),
            ),
          ),
          const SizedBox(height: AppThemeTokens.space3),
          AppButton(
            key: const ValueKey('account-sign-in'),
            label: l10n.accountSignIn,
            expand: true,
            onPressed: enabled
                ? () async {
                    if (!_formOk(creating: false)) return;
                    await _run(
                      (g) => g.signInWithEmail(_email.text, _password.text),
                    );
                  }
                : null,
          ),
          const SizedBox(height: AppThemeTokens.space2),
          AppButton(
            key: const ValueKey('account-create'),
            label: l10n.accountCreate,
            variant: AppButtonVariant.secondary,
            expand: true,
            onPressed: enabled
                ? () async {
                    if (!_formOk(creating: true)) return;
                    await _run(
                      (g) => g.createAccount(_email.text, _password.text),
                    );
                  }
                : null,
          ),
          AppButton(
            key: const ValueKey('account-forgot'),
            label: l10n.accountForgot,
            variant: AppButtonVariant.text,
            onPressed: enabled
                ? () async {
                    if (!AccountForm.validEmail(_email.text)) {
                      _formOk(creating: false);
                      return;
                    }
                    await _run(
                      (g) => g.sendPasswordReset(_email.text),
                      success: l10n.accountResetSent,
                    );
                  }
                : null,
          ),
        ],
        if (_message != null) ...[
          const SizedBox(height: AppThemeTokens.space3),
          Semantics(
            liveRegion: true,
            child: Text(
              _message!,
              key: const ValueKey('account-message'),
              style: context.textStyles.bodyMedium?.copyWith(
                color: _messageIsError ? context.appColors.danger : null,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _SignedIn extends ConsumerStatefulWidget {
  const _SignedIn({required this.user});

  final AccountUser user;

  @override
  ConsumerState<_SignedIn> createState() => _SignedInState();
}

class _SignedInState extends ConsumerState<_SignedIn> {
  bool _busy = false;
  String? _error;

  String _who(AppLocalizations l10n) {
    final email = widget.user.email;
    if (email != null && email.isNotEmpty) return l10n.accountSignedInAs(email);
    final method = switch (widget.user.method) {
      SignInMethod.apple => l10n.accountMethodApple,
      SignInMethod.google => l10n.accountMethodGoogle,
      SignInMethod.email || null => l10n.accountMethodEmail,
    };
    return l10n.accountSignedInWith(method);
  }

  Future<void> _signOut() async {
    setState(() => _busy = true);
    await ref.read(authGatewayProvider).signOut();
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final needsPassword = widget.user.method == SignInMethod.email;
    // Null when kept; otherwise the typed password (empty when not asked).
    final typed = await showDialog<String>(
      context: context,
      builder: (_) => _DeleteDialog(needsPassword: needsPassword),
    );
    if (typed == null || !mounted) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(authGatewayProvider)
          .deleteAccount(password: needsPassword ? typed : null);
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.accountDeleted(AppAccounts.purgeWithinHours)),
        ),
      );
    } on AccountException catch (e) {
      if (mounted) setState(() => _error = _errorText(l10n, e.error));
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          key: const ValueKey('account-signed-in'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_who(l10n), style: context.textStyles.titleMedium),
              const SizedBox(height: AppThemeTokens.space2),
              Text(
                l10n.accountSignedInNote,
                style: context.textStyles.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppThemeTokens.space4),
        AppButton(
          key: const ValueKey('account-sign-out'),
          label: l10n.accountSignOut,
          variant: AppButtonVariant.secondary,
          expand: true,
          onPressed: _busy ? null : _signOut,
        ),
        const SizedBox(height: AppThemeTokens.space2),
        AppButton(
          key: const ValueKey('account-delete'),
          label: l10n.accountDelete,
          variant: AppButtonVariant.text,
          onPressed: _busy ? null : _delete,
        ),
        if (_error != null)
          Semantics(
            liveRegion: true,
            child: Text(
              _error!,
              key: const ValueKey('account-message'),
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.appColors.danger,
              ),
            ),
          ),
      ],
    );
  }
}

class _DeleteDialog extends StatefulWidget {
  const _DeleteDialog({required this.needsPassword});

  final bool needsPassword;

  @override
  State<_DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<_DeleteDialog> {
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      key: const ValueKey('account-delete-dialog'),
      title: Text(l10n.accountDeleteTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.accountDeleteBody(AppAccounts.purgeWithinHours)),
          if (AppFeatureFlags.premiumAvailable) ...[
            const SizedBox(height: AppThemeTokens.space2),
            Text(
              l10n.accountDeleteSubscription,
              key: const ValueKey('account-delete-subscription'),
            ),
          ],
          if (widget.needsPassword)
            TextField(
              key: const ValueKey('account-delete-password'),
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.accountDeletePassword,
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.accountDeleteCancel),
        ),
        FilledButton(
          key: const ValueKey('account-delete-confirm'),
          style: FilledButton.styleFrom(
            backgroundColor: context.appColors.danger,
          ),
          onPressed: () => Navigator.of(context).pop(_password.text),
          child: Text(l10n.accountDelete),
        ),
      ],
    );
  }
}
