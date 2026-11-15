# 12 — Choose together

Base: feature/11-custom-lists. Branch: feature/12-choose-together.

Favorites > Choose together starts an offline pass-the-phone round for 2–8 viewers.
Choose 1–20 titles from the unwatched library or a custom list (including rewatches),
optionally name viewers, then vote Interested/Skip. A viewer can undo their previous
vote before finishing their turn. A handoff screen hides voting content between
viewers, and inactive scenes show a paused screen.

Results appear only after every vote. Unanimous matches lead; when there are none,
the highest-ranked alternatives are revealed only on request. Pick for us draws only from that
eligible pool and never picks an all-skipped title. Titles removed from the library
are excluded from results. Session candidates remain snapshots so metadata changes
cannot reorder a round while someone is voting.

Votes and names live only in the destination's memory. They are not saved to the
library, exported, synced or sent to any service. Starting over clears votes. This
is a shared-phone activity, not authenticated private voting or remote sharing.
No accounts, notification permissions or network calls are needed for a round.

Tests cover partial votes, handoff, undo, unanimity, closest/all-skipped outcomes,
selection/viewer limits, reset, custom-list rewatches, deleted titles and absence
of library mutations. An offline UI scenario completes a two-viewer round and
opens a pick. Model/service code additionally passes isolated Swift typechecking;
this excludes Observation/SwiftUI macro expansion and production Core Data setup.

Run Scripts/test.sh and CI before merging. Full local Xcode build/test execution
is still blocked by sandbox SwiftPM diagnostics/CoreSimulator permissions. Static
syntax/lint checks are not a full build or runtime pass.
