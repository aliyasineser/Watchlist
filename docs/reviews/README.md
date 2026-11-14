# Stacked feature review

Review and merge in this order. Each branch was created from the previous branch;
compare each against its listed base to see only that feature.

| Order | Branch | Base | Review notes |
| --- | --- | --- | --- |
| 1 | `feature/01-reliability` | `update` | [Reliability](01-reliability.md) |
| 2 | `feature/02-search` | `feature/01-reliability` | [Search](02-search.md) |
| 3 | `feature/03-watch-tracking` | `feature/02-search` | [Watch library](03-watch-tracking.md) |

No branches have been merged. Preserve commits when merging this stack (fast-forward
or merge commit); squash merging requires rebasing later branches to avoid showing
the earlier feature's changes again. All branches are local until pushed.

On each branch, run `Scripts/test.sh` from the repository root. It builds and runs
unit/UI tests with coverage and prints the result bundle path. Simulator execution
and full build verification are pending because the editing sandbox denies
CoreSimulator access and package resolution cannot complete. Source parsing,
SwiftLint on changed app sources, project plist validation and diff checks have
passed; these do not substitute for compilation or test execution. No 100% coverage
claim is made.
