#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
output_dir="${WATCHLIST_RESULTS_DIR:-$(mktemp -d "${TMPDIR:-/tmp}/watchlist-tests.XXXXXX")}"
mkdir -p "$output_dir"
printf 'Test results: %s\n' "$output_dir"
if [[ -e "$output_dir/Tests.xcresult" ]]; then
  echo "Result bundle already exists; choose a fresh WATCHLIST_RESULTS_DIR." >&2
  exit 1
fi
if [[ -z "${WATCHLIST_DESTINATION:-}" ]]; then
  simulator_json=$(xcrun simctl list devices available -j 2> "$output_dir/simulator.log")
  simulator_id=$(printf '%s' "$simulator_json" | python3 -c '
import json,sys
devices=json.load(sys.stdin)["devices"]
for runtime in sorted(devices, key=lambda value: tuple(int(part) for part in value.split("iOS-")[-1].split("-") if part.isdigit()), reverse=True):
    if "iOS-" not in runtime:
        continue
    for device in devices[runtime]:
        if "iPhone" in device["name"] and device.get("isAvailable", False):
            print(device["udid"])
            sys.exit(0)
sys.exit("No available iPhone simulator. Install one in Xcode Settings > Platforms.")')
  destination="platform=iOS Simulator,id=$simulator_id"
else
  destination="$WATCHLIST_DESTINATION"
fi
xcodebuild -project Watchlist.xcodeproj -scheme Watchlist \
  -destination "$destination" -enableCodeCoverage YES \
  -resultBundlePath "$output_dir/Tests.xcresult" CODE_SIGNING_ALLOWED=NO test 2>&1 | tee "$output_dir/build.log"
xcrun xccov view --report "$output_dir/Tests.xcresult" | tee "$output_dir/coverage.txt"
xcrun xccov view --report --json "$output_dir/Tests.xcresult" > "$output_dir/coverage.json"
