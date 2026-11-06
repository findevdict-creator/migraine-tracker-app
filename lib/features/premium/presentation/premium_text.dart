import 'package:flutter/material.dart';
import 'package:migraine_tracker/config/app_config.dart';
import 'package:migraine_tracker/core/l10n/l10n.dart';
import 'package:migraine_tracker/features/premium/domain/premium.dart';

String premiumFeatureName(AppLocalizations l10n, PremiumFeature f) =>
    switch (f) {
      PremiumFeature.shareLink => l10n.premiumFeatureShareLink,
      PremiumFeature.experiments => l10n.premiumFeatureExperiments,
      PremiumFeature.extendedFactors => l10n.premiumFeatureExtendedFactors,
      PremiumFeature.backup => l10n.premiumFeatureBackup,
    };

String premiumFeatureHint(AppLocalizations l10n, PremiumFeature f) =>
    switch (f) {
      PremiumFeature.shareLink => l10n.premiumFeatureShareLinkHint,
      PremiumFeature.experiments => l10n.premiumFeatureExperimentsHint,
      PremiumFeature.extendedFactors => l10n.premiumFeatureExtendedFactorsHint,
      PremiumFeature.backup => l10n.premiumFeatureBackupHint,
    };

IconData premiumFeatureIcon(PremiumFeature f) => switch (f) {
  PremiumFeature.shareLink => Icons.link,
  PremiumFeature.experiments => Icons.science_outlined,
  PremiumFeature.extendedFactors => Icons.air,
  PremiumFeature.backup => Icons.cloud_upload_outlined,
};

String premiumOfferLabel(AppLocalizations l10n, PremiumOffer offer) =>
    switch (offer.period) {
      PremiumPeriod.monthly => l10n.premiumOfferMonthly(offer.priceText),
      PremiumPeriod.annual => l10n.premiumOfferAnnual(offer.priceText),
      PremiumPeriod.other => l10n.premiumOfferOther(offer.priceText),
    };

/// Null for a cancelled purchase: the person changed their mind, so
/// nothing is shown.
String? purchaseErrorText(AppLocalizations l10n, PurchaseError e) =>
    switch (e) {
      PurchaseError.cancelled => null,
      PurchaseError.notAllowed => l10n.premiumErrorNotAllowed,
      PurchaseError.pending => l10n.premiumErrorPending,
      PurchaseError.network => l10n.accountErrorNetwork,
      PurchaseError.storeProblem => l10n.premiumErrorStore,
      PurchaseError.unavailable => l10n.premiumUnavailable,
      PurchaseError.unknown => l10n.accountErrorUnknown,
    };
