# 01 — Reliability

Base: `update`. Branch: `feature/01-reliability`.

Favorite storage now throws recoverable errors; writes roll back on save failure.
The heart control reports errors without changing its displayed state on a failed write.
Startup offers a retry if the persistent store cannot open, without deleting it or
substituting an empty database. Artist requests propagate failures to presenters.

Paginated lists have a shared loading/error/empty/retry footer. Empty successful
pages end pagination; failed pages remain retryable. Reviews and similar titles
are deduplicated by ID. Detail failures offer inline retry instead of becoming
permanent spinners when an alert is dismissed.

Run `Scripts/test.sh` on the Mac to build and test using an available iPhone
simulator. Override `WATCHLIST_DESTINATION` to choose a device. The command emits
an xcresult bundle plus human-readable and JSON coverage reports in a temporary
folder printed at launch. No coverage percentage is assumed before that run.

Review: simulate offline requests, retry after restoring connectivity, reach an
empty page, and try a failed favorite save. Regression tests include terminal
pages and unavailable stores. The editing sandbox cannot access CoreSimulator;
full execution remains a required review gate, not a claimed pass.
