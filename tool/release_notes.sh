#!/usr/bin/env bash
# Prints the CHANGELOG.md section for a version (phase 39), for the GitHub
# release and the TestFlight "what to test" text: `tool/release_notes.sh 1.0.0`.
set -euo pipefail
version="${1:?version, e.g. 1.0.0}"
awk -v v="$version" '
  $0 ~ "^## \\[" v "\\]" { on = 1; next }
  on && /^## \[/ { exit }
  on { print }
' CHANGELOG.md | sed '/./,$!d'
