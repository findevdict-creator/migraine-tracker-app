# Contributing

## Branching rules

- Feature branches are `NN-feat-slug`, fix branches `NN-fix-slug`, where `NN`
  is the two-digit number from the implementation plan and `slug` is two to
  four lowercase kebab-case words. No other branch names exist.
- Each new feature branch is cut from the tip of the previous feature branch,
  never from `main`. The PR for `NN` targets `NN-1` while that is open; GitHub
  retargets it to `main` when `NN-1` merges (delete-on-merge must be on).
- `main` only receives merged pull requests, with merge commits (squash and
  rebase merges are disabled so the stack stays consistent).
- A fix branch carries the number of the feature it fixes and targets that
  feature branch, or the current head feature branch if the feature is already
  on `main`.
- Production hotfix after a store release (the one exception): cut
  `NN-fix-slug` from `main`, PR base `main`, then merge `main` into the head
  feature branch the same day.
- Never rebase a branch that has an open PR. Bring upstream changes down with
  `git merge`.

## Commit messages

Conventional Commits, scope is the feature slug without its number:

```
feat(attack-log): add head map tap targets
fix(weather-feed): show forecast age when offline (11)
```

Types: `feat fix refactor test docs chore build ci perf`. Subject under 72
characters, imperative mood. Enforced by `tool/check_commit_msg.sh` in the
commit-msg hook and in CI.

## Local setup

1. Install the Flutter version in `.fvmrc` (`fvm install` or a manual install).
2. `flutter pub get && flutter gen-l10n`.
3. Install the hooks: `lefthook install` (requires
   [lefthook](https://github.com/evilmartians/lefthook) and
   [gitleaks](https://github.com/gitleaks/gitleaks) on your PATH).
4. Run the app: `flutter run -t lib/main_dev.dart --flavor dev --dart-define-from-file=env/dev.json`.

## Pull requests

- One PR per branch, title in commit format: `feat(attack-log): attack mode log (05)`.
- Fill every section of the PR template or strike it through with a reason.
- Draft until CI is green and the self-review is done.
- Tests for every acceptance criterion; no test skipped or quarantined.
- No hard-coded strings; copy lint and string lint pass.
- No health data in logs, crash payloads or analytics.
- Every configurable value comes from `lib/config/app_config.dart`.
- Each phase adds `docs/phases/NN-slug.md` describing what was done.

## Review

Every PR gets a review before merge (a self-review the next day with the
checklist counts). The reviewer checks, in order: acceptance criteria have
tests; privacy rules hold; copy stays on the wellness side; the branch and
base follow the rules; the change is as small as the feature allows.
