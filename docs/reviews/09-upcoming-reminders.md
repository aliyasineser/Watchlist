# 09 — Upcoming calendar and opt-in release reminders

Base: `feature/08-where-to-watch`.

Saved/full title pages offer Follow upcoming releases after saving the title.
Favorites > Upcoming lists known dates in the next 90 days, grouped by day, with
follow management. Movie events use TMDB's catalog release date; TV uses the next
announced episode plus future episodes from downloaded seasons. These are not
regional streaming-release guarantees. Episode names/plot details are omitted.

The calendar checks followed titles in batches of 20 and caches up to 200 titles
for 12 hours. Pull to refresh requests fresh dates; cached dates remain available
offline with a stale label. Missing dates remain unknown. Follow state is part of
the library backup/sync document and is optional for backward compatibility.

Notification permission is requested only when the user enables reminders.
Reminders are local, at 9 AM in the user's time zone on a known release day;
past triggers are skipped. Titles are hidden by default, and no plot details are
sent. Scheduling is bounded to 48 requests while respecting unrelated pending
notifications and the system's total budget. Turning reminders off cancels them.
Deleting/unfollowing titles reconciles pending reminders; app activation updates
time-zone scheduling. Calendar refresh updates known dates. There is no background
polling/push service, so open Upcoming periodically to learn changed/new dates.
Follow choices can sync, but notification permission and settings stay device-local.

Tests cover date validation, 90-day filtering, deduplication, time zones/past
triggers, reminder budget, movie/TV decoding, opt-in/denial, unfollow cancellation,
backup round-trip and offline cache. UI smoke tests navigate the three tools using
isolated dependencies without network or notification permission prompts.

Static checks: full app strict SwiftLint, all-source Swift parsing, test fixture
line-length checks, project/entitlement validation and whitespace checks. Model and
service code was additionally typechecked in isolation, excluding Observation macro
expansion and Core Data composition. This is not a full app build. Xcode build and
simulator tests remain blocked by sandbox cache/CoreSimulator restrictions; run CI
and verify permission denial, settings changes, rescheduling and two-device sync
on signed devices before merging/releasing.
