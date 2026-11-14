# 04 — Release checks

Base: `main` at `2ec6116`. Branch: `feature/04-release-checks`.

GitHub Actions now runs strict app-source SwiftLint and the shared Xcode unit/UI
test scheme on pull requests and pushes to main. The runner uses macOS 15 with
Xcode 26.3 explicitly selected, avoiding its older default Xcode. No package,
deployment-target or signing configuration was changed.

`Scripts/test.sh` selects the newest available iPhone runtime numerically, supports
an explicit destination/results directory, refuses to overwrite result bundles,
and captures simulator diagnostics plus build output. CI uploads xcresult and
coverage reports even when tests fail. Five pre-existing lint violations were
fixed. An offline UI scenario exercises large Dynamic Type with dark appearance,
card margins and saved detail navigation, attaching a screenshot for review.

Validation: all app sources pass strict SwiftLint; Swift syntax parsing, shell
syntax and git whitespace checks pass. A real xcodebuild was attempted but stopped
in package resolution because the sandbox denies cache writes; CoreSimulator is
also unavailable. No runtime/coverage pass is claimed. Run `Scripts/test.sh` or
let the PR workflow run before merging; use its coverage report to prioritize
remaining untested behavior, rather than inventing a coverage threshold.

Runner reference: https://github.com/actions/runner-images/blob/main/images/macos/macos-15-Readme.md
