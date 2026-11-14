# 06 — TV episode progress

Base: `feature/05-watch-tonight`. Branch: `feature/06-episode-progress`.

TV detail pages and saved TV titles link to Episode progress. Users download a
season, toggle aired episodes, mark all aired episodes in that season watched,
and undo the latest action. Progress counts and the next unwatched aired episode
use downloaded seasons; specials do not enter the next-episode queue. Future,
unknown and invalid air dates cannot be bulk-marked or suggested. Air dates are
calendar dates interpreted in UTC, not an exact regional streaming release time.

Season catalogs, episode metadata and watched IDs persist in the same atomic
library document. The new field is optional, so older saved entries still decode.
Downloaded seasons open without a network request; refresh is explicit and failed
requests retain cached data. Refreshing metadata preserves watched flags, ratings
and overall title status. Overall Want to watch/Watching/Watched remains a manual
choice; catching up with downloaded episodes does not mark an entire show finished.
Undo checks the expected state before writing, preventing loss of newer edits.
Older app builds can read the document but may discard new fields when saving;
avoid rolling back app versions against your only copy of the library.

Tests cover next-episode ordering, specials/air dates, bulk marking/undo, stale undo,
refresh preservation, disk round-trip, old JSON, failed writes, offline loading,
request routes and failed-request retry. UI fixtures include a saved season for
network-independent check-off/undo testing. No notifications or background polling
are enabled; release reminders remain a later opt-in enhancement.

Validation: all app sources pass strict SwiftLint; all Swift sources parse; project
plist, shell syntax and whitespace checks pass. Build/test execution and measured
coverage remain pending: local Xcode package-cache writes and CoreSimulator access
are denied by this sandbox. Review the CI artifacts before merging.

API reference: https://developer.themoviedb.org/reference/tv-season-details
