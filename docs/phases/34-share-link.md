# Phase 34: Clinician share link

Branch: `34-feat-share-link`, cut from `33-feat-encrypted-backup`.
Requirement IDs: FR-21.

## What was done

### One report, two renderings

The report's wording used to live inside the PDF code. It now lives in
`ReportContent`, which turns a report summary into a `ReportDocument`.
That document is plain text in blocks: headings, hints, paragraphs,
headline numbers, tables, two-column lists and month calendars.

- The PDF draws that document. The PDF output is unchanged.
- The share page draws the same document.

So a link shows exactly what the PDF shows, in the phone's language, and
the server only ever sees finished summary text. It never sees the
attack log, notes or check-ins.

### In the app

- **"Share as a web link"** on the Doctor report screen opens a sheet
  for the period and options already chosen.
  - It explains that anyone with the link can read the report until it
    expires, that it is the same summary as the PDF and not the diary,
    and that sharing can be stopped at any time.
  - The person picks 7 or 30 days (`AppThresholds.shareLinkDays`) and
    taps Create link.
  - The sheet then shows the link, the end date, Share (the system
    share sheet) and Copy.
  - Signed out, the sheet says a link needs an account and offers the
    account screen. The PDF and CSV still work without one.
- **Shared links** at `/share-links`, from settings, lists every link the
  phone made.
  - Each link shows "Shared until", "Expired" or "Sharing stopped".
  - Live links have "Stop sharing", with a confirmation. The server
    snapshot is deleted first, and only then is the phone's record
    marked.
- The phone keeps its own record of links in the existing `share_links`
  table, which was created in phase 2.

### On the server (`functions/src/share/`)

- **`createShareLink({ days, document })`** needs a signed-in account
  and App Check.
  - It accepts only the allowed lifetimes and a version 1 report
    document under 256 KB.
  - It stores `share_snapshots/{token}` with the owner, the document,
    the creation time and `expiresAt`.
  - The token is 16 random bytes from Node's `crypto`, which is 128
    bits, written as 22 URL-safe characters.
- **`revokeShareLink({ token })`** deletes the snapshot. Only the owner
  may, and revoking twice is fine.
- **`shareLinkView`** serves `GET /api/share/{token}` through the Hosting
  rewrite.
  - It returns the document while the link is live.
  - It returns 410 once the link has expired, and deletes the snapshot.
  - It returns 404 for an unknown or malformed token.
  - Responses are `no-store`, `noindex` and `no-referrer`.
- **`shareLinkSweep`** runs daily and deletes expired snapshots, in case
  the Firestore TTL policy lags.
- **Account deletion** already removes the account's snapshots, through
  phase 32's purge.
- **Rules**: `share_snapshots` stays closed to clients. Only the
  functions read and write it.

### The page (`hosting/share.html`, `share.js`, `share.css`)

- `/s/{token}` is rewritten to the static page. The page fetches
  `/api/share/{token}` and draws the blocks.
- Every string is set with `textContent`. A test fails the build if the
  script ever uses `innerHTML` or similar.
- Headers on the page:
  - A strict Content Security Policy: same-origin script, style and
    fetch only, no frames.
  - `no-referrer`, `noindex` and `no-store`.
- Plain messages for an expired link, a stopped link, an incomplete
  link and a load error.
- It works on phones and desktops, follows dark mode, and prints.

## Configuration

| Where | Setting | Value |
| --- | --- | --- |
| `lib/config/app_config.dart` | `AppThresholds.shareLinkDays` | 7, 30 |
| | `AppShareLinks.pathPrefix` | `/s/` |
| | `AppEnv.shareBaseUrl` (`SHARE_BASE_URL`) | empty means `https://{project}.web.app` |
| | `AppEndpoints.createShareLinkFunction`, `revokeShareLinkFunction` | function names |
| | `AppFeatureFlags.shareLinkAvailable` | true |
| `functions/src/config.ts` | `shareLink.tokenBytes` | 16 |
| | `shareLink.allowedDays` | 7, 30, must match the app |
| | `shareLink.maxDocumentBytes`, `documentVersion` | 256 KB, 1 |
| | `shareLink.sweepSchedule`, `sweepBatch` | daily, 400 |
| `firebase.json` | `hosting.rewrites`, `hosting.headers` | page and API routes, security headers |

## Tests

- `test/features/report/report_document_test.dart`:
  - The document has every section in order, 13 calendar months for a
    year, and six headline numbers.
  - It survives JSON unchanged.
  - It holds no free-text notes.
  - The PDF draws it.
  - Questionnaires can be left out.
  - Calendar days carry the same shade for the PDF and the page.
- `test/features/share_link/share_link_flow_test.dart`:
  - Creating a 30-day link from the report sends a version 1 document
    without the note text. The sheet shows the link and "Shared until
    Dec 6, 2026". Share hands over "My migraine report: {link}", and
    the phone keeps the link.
  - Signed out, the sheet explains that a link needs an account.
  - A server error is explained, and nothing is kept.
  - Shared links shows live and expired links. Stop sharing confirms,
    calls the server, and shows "Sharing stopped".
  - Link status rules.
- `functions/test/share.test.ts`:
  - Tokens are 16 random bytes in 22 URL-safe characters, never repeat
    in 1,000 draws, and malformed ones are refused.
  - Only 7 or 30 days and a version 1 document are accepted, and an
    oversized snapshot is refused.
  - The stored record holds only the owner, the document and the two
    times.
  - A link is served until it expires, then answers 410 and is deleted.
  - Revoke works only for the owner, at once, and twice.
  - The sweep removes only expired snapshots, across batches.
  - `firebase.json` routes the page and the API.
  - The page never parses text as HTML.
- `functions/test/share.emu.test.ts`, on the Firestore emulator in CI:
  - Create, open and revoke on the real Admin SDK.
  - Expiry, and the sweep clearing the rest.
- The page was also drawn in Chromium against a year of fixture data,
  at desktop and phone widths, and for the expired and incomplete
  cases. There was no horizontal scroll and no policy error.
- Full app suite: 445 tests. Functions: 48 tests.

## Acceptance criteria

- [x] A 7 or 30 day read-only web link with the same content as the
      report.
- [x] Random 128-bit token.
- [x] Static Hosting page.
- [x] Revoke from the app deletes the server record.
- [x] The server holds only the report snapshot and deletes it on
      expiry.
- [x] Local `share_links` mirror.
- [x] The link works end to end, on the emulator, with expiry and revoke
      tests.

## Manual checks

These need a deployed staging project with a signed-in account.

1. Open Doctor report, tap "Share as a web link", choose 7 days and
   tap Create link. Open the link on a laptop. The page matches the PDF.
2. Open Settings, then Shared links. The link shows "Shared until".
   Tap Stop sharing. Reload the page, which now says the report is no
   longer shared.
3. In the console, set a snapshot's `expiresAt` to the past and reload
   the page. It says the link has expired, and the document is gone.

## Risk and rollback

- The PDF code was reorganised around the shared document. Its output
  is the same, and the existing PDF tests pass.
- Four new functions, plus Hosting rewrites and headers. Reverting
  removes them, and existing links stop working.
- The page's own messages are in English. The report inside follows
  the phone's language. Translating the page is part of phase 37.

## What M must fill in

- Deploy Hosting along with the functions.
- Optional: set `SHARE_BASE_URL` to a custom domain.
- Enable the Firestore TTL policy on `share_snapshots.expiresAt`.
