# Stacked feature review

Main at `a1cb59f` includes features 01–09 and their fixes. The new stack starts from
that merged commit. Compare each branch against its listed base to review one
feature at a time, then merge in this order.

| Order | Branch | Base | Review notes |
| --- | --- | --- | --- |
| 1 | `feature/10-continue-watching` | `main` | [Continue watching](10-continue-watching.md) |
| 2 | `feature/11-custom-lists` | `feature/10-continue-watching` | [Custom lists](11-custom-lists.md) |
| 3 | `feature/12-choose-together` | `feature/11-custom-lists` | [Choose together](12-choose-together.md) |

These new branches are local and unmerged. Preserve commits using fast-forward or
merge commits; squash merging requires rebasing subsequent branches. Retarget the
next PR after merging its base. No dependencies, signing settings or entitlements
changed in this stack. Xcode groups match the folders on disk.

Review offline Continue watching check-off/undo first, then list membership/notes/
order, and finally a complete pass-the-phone round including no-match outcomes.
List creation upgrades the library to schema 2; new builds accept schema 1 and 2.
Older builds reject schema 2 instead of stripping list data. Back up before testing
migrations or downgrading. Lists join the existing export/import/iCloud flow; votes
do not. The existing iCloud provisioning requirements still apply.

Run `Scripts/test.sh` on each branch, or open PRs for the existing GitHub Actions
workflow. Inspect xcresult, logs and coverage artifacts. Local static checks cover
all Swift syntax, strict app lint, new test line lengths, project paths and git
whitespace. Supplemental model/service typechecks exclude macro expansion and
Core Data composition. Full Xcode build and simulator tests remain blocked by
sandbox cache/CoreSimulator restrictions; no runtime pass or coverage is claimed.

Previous reviews: [Reliability](01-reliability.md), [Search](02-search.md),
[Watch library](03-watch-tracking.md), [Release checks](04-release-checks.md),
[Watch tonight](05-watch-tonight.md), [Episode progress](06-episode-progress.md),
[Backup/sync](07-library-backup-sync.md), [Providers](08-where-to-watch.md),
[Upcoming](09-upcoming-reminders.md).
