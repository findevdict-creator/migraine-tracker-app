#!/usr/bin/env bash
# Conventional Commits check: type(scope): summary, summary under 72 chars.
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
if (( ${#subject} > 72 )); then
  echo "commit subject must be under 72 characters (got ${#subject})" >&2
  exit 1
fi
