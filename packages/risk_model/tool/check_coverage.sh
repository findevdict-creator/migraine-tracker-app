#!/usr/bin/env bash
# Runs the package tests with coverage and fails below 100% line coverage.
set -euo pipefail
cd "$(dirname "$0")/.."
rm -rf coverage
dart test --coverage=coverage >/dev/null
dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib
dart run tool/coverage_gate.dart coverage/lcov.info
