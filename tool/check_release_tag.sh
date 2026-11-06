#!/usr/bin/env bash
# Fails unless the release tag equals AppRelease.tagPrefix + the version in
# pubspec.yaml (phase 39): `tool/check_release_tag.sh v1.0.0`.
set -euo pipefail
tag="${1:?release tag, e.g. v1.0.0}"
prefix="$(sed -n "s/.*static const String tagPrefix = '\(.*\)';/\1/p" lib/config/app_config.dart)"
version="$(sed -n 's/^version: \([0-9][0-9.]*\)+[0-9]*$/\1/p' pubspec.yaml)"
wear="$(sed -n 's/^version: \([0-9][0-9.]*\)+[0-9]*$/\1/p' wear/pubspec.yaml)"
if [[ -z "$version" ]]; then
  echo "pubspec.yaml: version must look like 1.2.3+45" >&2
  exit 1
fi
if [[ "$tag" != "${prefix}${version}" ]]; then
  echo "tag $tag does not match pubspec.yaml version ${prefix}${version}" >&2
  exit 1
fi
if [[ "$wear" != "$version" ]]; then
  echo "wear/pubspec.yaml version $wear differs from the phone's $version" >&2
  exit 1
fi
if ! grep -q "^## \[$version\]" CHANGELOG.md; then
  echo "CHANGELOG.md has no section for [$version]" >&2
  exit 1
fi
echo "release tag $tag matches version $version"
