#!/usr/bin/env bash
# Conventional Commits check: type(scope): summary. Aim for a subject under
# 72 characters; the hard limit is 100 (commitlint default).
# Merge commits are exempt.
set -euo pipefail
file="${1:?commit message file}"
subject="$(head -n1 "$file")"
if [[ "$subject" =~ ^Merge ]]; then exit 0; fi
pattern='^(feat|fix|refactor|test|docs|chore|build|ci|perf)(\([a-z0-9-]+\))?!?: .+'
if [[ ! "$subject" =~ $pattern ]]; then
  echo "commit message must match: type(scope): summary" >&2
  echo "types: feat fix refactor test docs chore build ci perf" >&2
  echo "got: $subject" >&2
  exit 1
fi
if (( ${#subject} > 100 )); then
  echo "commit subject must be at most 100 characters (got ${#subject})" >&2
  exit 1
fi
