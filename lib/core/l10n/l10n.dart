import 'package:flutter/widgets.dart';
import 'package:migraine_tracker/core/l10n/generated/app_localizations.dart';

export 'package:migraine_tracker/core/l10n/generated/app_localizations.dart';

/// Shorthand so widgets write `context.l10n.someString`.
extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
