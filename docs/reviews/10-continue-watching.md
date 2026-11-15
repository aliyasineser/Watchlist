# 10 — Continue watching

Base: main at a1cb59f. Branch: feature/10-continue-watching.

Discover opens with saved Watching titles, ordered by latest activity. Movies can
be marked watched directly; shows display the next aired unwatched episode from
downloaded seasons. Specials and unknown/future dates are excluded. Missing season
data prompts the user to download it in Episode progress. The section works offline
and links to saved details; it never guesses an episode or downloads entire shows.

One-tap episode completion retains the overall Watching status and personal rating.
Undo restores the latest action only and refuses to overwrite newer edits. Failed
saves leave progress unchanged. All changes use the existing atomic library store,
backup and sync flow. A completed movie disappears from the shelf; Undo stays visible.

Tests cover selection, episode completion, movie completion, undo/stale undo and
save failure, with an offline UI navigation/check-off scenario. Static lint, syntax
and project validation pass. Simulator execution/build remain subject to the local
sandbox restrictions documented in prior reviews; run Scripts/test.sh/CI before merge.
