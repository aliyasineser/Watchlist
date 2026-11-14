#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [[ -z "${WATCHLIST_DESTINATION:-}" ]]; then
  simulator_json=$(xcrun simctl list devices available -j)
  simulator_id=$(printf '%s' "$simulator_json" | python3 -c '
import json,sys
devices=json.load(sys.stdin)["devices"]
for runtime in sorted(devices, reverse=True):
    for device in devices[runtime]:
        if "iPhone" in device["name"]:
            print(device["udid"])
            sys.exit(0)
sys.exit("No available iPhone simulator. Install one in Xcode Settings > Platforms.")')
  destination="platform=iOS Simulator,id=$simulator_id"
else
  destination="$WATCHLIST_DESTINATION"
fi
output_dir=$(mktemp -d "${TMPDIR:-/tmp}/watchlist-tests.XXXXXX")
printf 'Test results: %s\n' "$output_dir"
xcodebuild -project Watchlist.xcodeproj -scheme Watchlist \
  -destination "$destination" -enableCodeCoverage YES \
  -resultBundlePath "$output_dir/Tests.xcresult" test | tee "$output_dir/build.log"
xcrun xccov view --report "$output_dir/Tests.xcresult" | tee "$output_dir/coverage.txt"
xcrun xccov view --report --json "$output_dir/Tests.xcresult" > "$output_dir/coverage.json"
