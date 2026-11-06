## Branch
NN-feat-slug or NN-fix-slug, cut from: <branch>
Base at open: <branch>  (must be the previous feature branch, or the feature a fix targets)

## What and why
One paragraph. Requirement IDs covered: FR-x. Link to the plan row and any ADR.

## Acceptance criteria
- [ ] <criterion from the requirements doc> — test: `path/to/test.dart`

## Screenshots or recording
Before / after, light and dark, 100% and 200% text scale where UI changed.

## Manual checks
- [ ] One-handed attack walkthrough on a real phone (attack-screen PRs)
- [ ] Screen-reader pass on new screens
- [ ] Airplane-mode pass (any PR touching network or cache)

## Risk and rollback
What breaks if this is wrong, and how to revert (feature flag, migration down, config).

## Checklist
- [ ] Tests added for every criterion above, none skipped
- [ ] No hard-coded strings, copy lint passes
- [ ] No health data in logs, crash payloads or analytics
- [ ] Parity checklist and CHANGELOG-relevant commit types updated
