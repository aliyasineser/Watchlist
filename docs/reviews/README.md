# Stacked feature review

The first stack (01–03) is merged into `main` at `2ec6116`. The next stack starts
from that commit. Review only each branch's diff against its listed base.

| Order | Branch | Base | Review notes |
| --- | --- | --- | --- |
| 1 | `feature/04-release-checks` | `main` | [Release checks](04-release-checks.md) |
| 2 | `feature/05-watch-tonight` | `feature/04-release-checks` | [Watch tonight](05-watch-tonight.md) |
| 3 | `feature/06-episode-progress` | `feature/05-watch-tonight` | [Episode progress](06-episode-progress.md) |

The new branches are local and unmerged. Preserve commits when merging this stack
(fast-forward or merge commit); squash merging requires rebasing later branches.
After merging each branch, retarget the next PR to main.

Run `Scripts/test.sh` on each branch, or use the GitHub Actions workflow introduced
in branch 04 after pushing/opening PRs. It builds and runs unit/UI tests with
coverage, uploading xcresult, build logs and coverage reports. Configure the
`verify` check as required in repository settings if you want merges blocked by it.
No signing credentials or TMDB secret are needed for the isolated test fixtures.

Local checks: strict SwiftLint across app sources, syntax parsing across app/test
sources, project plist validation, shell syntax, and git whitespace checks.
Full build/testing is still blocked by sandbox restrictions on SwiftPM/Clang cache
writes and CoreSimulator. Static checks are not compilation or test execution.
Do not treat these branches as release-verified until the workflow passes.

Previous stack: [Reliability](01-reliability.md), [Search](02-search.md),
[Watch library](03-watch-tracking.md).
