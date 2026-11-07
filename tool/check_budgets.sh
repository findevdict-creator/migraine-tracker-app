#!/usr/bin/env bash
# Checks that every Firebase project has a Cloud Billing budget with the
# configured amount and alert thresholds (phase 39). Values come from
# AppRelease.monthlyBudgetUsd and budgetAlertShares in app_config.dart.
#
#   BILLING_ACCOUNT=XXXXXX-XXXXXX-XXXXXX tool/check_budgets.sh aurawell-staging aurawell-prod
#
# Needs gcloud signed in with billing.budgets.list on the billing account.
set -euo pipefail
account="${BILLING_ACCOUNT:?set BILLING_ACCOUNT to the billing account id}"
amount="$(sed -n 's/.*static const int monthlyBudgetUsd = \([0-9]*\);/\1/p' lib/config/app_config.dart)"
shares="$(sed -n 's/.*static const List<double> budgetAlertShares = \[\(.*\)\];/\1/p' lib/config/app_config.dart | tr -d ' ')"
[[ $# -gt 0 ]] || { echo "name the projects to check" >&2; exit 2; }

budgets="$(gcloud billing budgets list --billing-account="$account" --format=json)"
status=0
for project in "$@"; do
  number="$(gcloud projects describe "$project" --format='value(projectNumber)')"
  match="$(jq --arg p "projects/$number" --arg amt "$amount" --arg shares "$shares" '
    [ .[]
      | select((.budgetFilter.projects // []) | index($p))
      | select(.amount.specifiedAmount.units == $amt)
      | select(([.thresholdRules[].thresholdPercent | tostring] | sort)
               == ($shares | split(",") | map(tonumber | tostring) | sort))
    ] | length' <<<"$budgets")"
  if [[ "$match" -ge 1 ]]; then
    echo "ok   $project: \$$amount budget with alerts at $shares"
  else
    echo "MISSING $project: no \$$amount budget with alerts at $shares" >&2
    status=1
  fi
done
exit $status
