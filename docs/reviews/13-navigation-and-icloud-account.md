# 13 — Clearer navigation and an iCloud sync settings

Base: main at 8008307. Branch: feature/13-navigation-and-icloud-account.

The account model was explicitly chosen as the existing device iCloud account,
without separate registration or Sign in with Apple app accounts. CloudKit already
persists the library in that private account. No backend, authentication token,
new capability, signing change or entitlement change is introduced here.

| Home | Primary purpose |
| --- | --- |
| Discover | Browse, Continue watching, Watch tonight, Choose together |
| Search | Search movies/TV/artists; browse popular artists |
| Library | Saved titles, custom lists, saved artists; available-on-my-services filter |
| Upcoming | Release calendar, followed titles and reminders |
| Settings | iCloud state/confirmation, sync, backup/restore, country and service selection |

Library replaces Favorites and removes its stack of tool links. Titles, Lists and
Artists have a segmented switch; poster insets remain 20 points. Its view now lives
in Library/View/LibraryView.swift with matching Xcode groups. Discover gains two
planning cards that stack for accessibility sizes; catalog failures are inline so
the local tools remain accessible. Artist browsing reuses the Search navigation
stack instead of nesting stacks. Upcoming has its own stack, and backup is a simple
Backup screen reached from Settings.

Settings uses native CloudKit account status and system-managed Apple Account
instructions, not a fake login. It shows signed-out/restricted/unavailable states,
sync progress/errors and last success. Country/service preferences remain local
and are labelled accordingly. Service selection now has a searchable country
catalog (movie/TV provider union), a daily cache for ten regions, remembered selected
names and offline removal. These are preferences, not paid subscription management.

Sync now verifies the current CloudKit identity before reading and immediately
before uploading. The confirmed opaque identifier stays only in app preferences.
First use after this upgrade, or a different iCloud account, requires explicit
confirmation in Settings before local data can merge. A changed account while the
confirmation is open is rejected. Existing automatic sync pauses when confirmation
is required. Signing out never deletes the local library. The user changes Apple
Accounts in iOS Settings. Existing CloudKit provisioning/production schema setup
from review 07 is still required; validate account switching on signed devices.

Unit tests cover account eligibility/confirmation, changed/signed-out identities,
local preservation, automatic-sync pausing, catalog routes/cache/deduplication and
remembered services. UI tests cover the five tabs, all moved routes, Library card
margins, iCloud confirmation/signed-out guidance and light/large-text dark screenshot
attachments. Both unit and UI host processes use isolated dependencies, never real
account or notification services.

Validation: Swift syntax, strict app lint, test line lengths, project reference and
whitespace checks; supplemental model/service typechecking excludes macros and
production Core Data composition. Full build/test execution and visual screenshot
review remain blocked here by sandbox Xcode/SwiftPM/CoreSimulator restrictions.
Run Scripts/test.sh/CI, inspect screenshot artifacts, and verify signed-device iCloud
flows before merging. No simulator screenshots were claimed as reviewed here.

## Follow-up: local-first settings

Backend accounts are deferred. The fifth tab is now Settings, with a gear icon and
a local-library introduction. Optional Sync with iCloud explains exactly what
syncs, what stays local and how to change the system account. The explanation is
expandable, with first-enable confirmation and a Not now action. Backup/restore
is available without enabling sync. No Sign in with Apple button is introduced.

Sync status distinguishes Off, Checking iCloud, Syncing, Waiting to sync, Up to date
and Needs attention. Up to date requires a successful exchange for the current
in-memory library revision; an old persisted timestamp is insufficient. Local
edits return the status to Waiting to sync. Errors offer Review & retry sync,
which rechecks account eligibility and requests confirmation if necessary.
Turning sync off clears old sync errors and preserves both local and cloud data.

Additional unit cases cover local-only mode, disabling sync without data loss,
local edits, transient failure/retry and prior-session timestamps. UI cases cover
Settings naming, the optional-sync explanation, confirmation, successful status,
and switching back to local-only mode. Run the updated light/dark large-text
screenshot cases before merge; runtime visual verification is still pending.
