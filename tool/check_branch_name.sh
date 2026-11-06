#!/usr/bin/env bash
# Branch name check: NN-feat-slug or NN-fix-slug. A fix branch must have a
# matching feat branch with the same number somewhere in the remote history.
set -euo pipefail
branch="${1:?branch name}"
pattern='^[0-9]{2}-(feat|fix)-[a-z0-9]+(-[a-z0-9]+)*$'
if [[ ! "$branch" =~ $pattern ]]; then
  echo "branch name '$branch' must match NN-feat-slug or NN-fix-slug" >&2
  exit 1
fi
number="${branch:0:2}"
kind="${branch:3:3}"
if [[ "$kind" == "fix" ]]; then
  if ! git ls-remote --heads origin "${number}-feat-*" | grep -q . \
     && ! git log --oneline --all | grep -Eq "from ${number}-feat-|${number}-feat-"; then
    echo "fix branch '$branch' has no matching ${number}-feat-* branch" >&2
    exit 1
  fi
fi
echo "branch name ok: $branch"
