# Stacked feature review

The next stack starts from `feature/06-episode-progress` at `ebe6e8c`. Remote main
currently contains 04 and 05; merge 06 before merging 07. Each new branch includes
the preceding feature. Compare each branch against its listed base.

| Order | Branch | Base | Review notes |
| --- | --- | --- | --- |
| 1 | `feature/07-library-backup-sync` | `feature/06-episode-progress` | [Backup and sync](07-library-backup-sync.md) |
| 2 | `feature/08-where-to-watch` | `feature/07-library-backup-sync` | [Where to watch](08-where-to-watch.md) |
| 3 | `feature/09-upcoming-reminders` | `feature/08-where-to-watch` | [Upcoming and reminders](09-upcoming-reminders.md) |

These new branches are local and unmerged. Preserve commits with fast-forward or
merge commits. Squash merging requires rebasing the subsequent branches. Retarget
the next PR after merging its base. No dependency versions or bundle IDs changed.
iCloud entitlements were added for the explicitly requested sync feature; see
branch 07 for Apple Developer provisioning and production schema requirements.

Run `Scripts/test.sh` on each branch or open PRs to run the existing GitHub Actions
workflow. Inspect xcresult, build logs and coverage artifacts. Local checks include
strict app lint, Swift syntax parsing, project/entitlement validation and whitespace
checks. Full Xcode builds and simulator execution remain blocked by sandbox cache
permissions/CoreSimulator access. No runtime pass or coverage percentage is claimed.

On device, review backup import/export first, then two-device sync conflict/delete
behavior; region/subscription changes and stale provider data; and finally reminder
permission, time zones, cancellation and date changes. Artist favorites remain
local and are explicitly excluded from the transfer UI. Artwork is cached locally.

Previous reviews: [Reliability](01-reliability.md), [Search](02-search.md),
[Watch library](03-watch-tracking.md), [Release checks](04-release-checks.md),
[Watch tonight](05-watch-tonight.md), [Episode progress](06-episode-progress.md).
