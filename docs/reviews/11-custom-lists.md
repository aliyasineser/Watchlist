# 11 — Custom lists

Base: feature/10-continue-watching. Branch: feature/11-custom-lists.

Favorites > Custom lists creates named collections with notes. Saved titles can
belong to several lists. Each membership has its own note, and Edit enables manual
ordering. Saved details offer Add to lists. Removing a membership never removes
the saved title. Deleting lists leaves titles intact; removing a title from the
library confirms that its memberships/notes will also be removed.

Lists share the atomic library document and therefore export, import and sync with
it. List deletions use tombstones; simultaneous edits to the same list use its
latest complete edit, with deterministic ties. Other lists merge independently.
A stale editor cannot overwrite a newer list/note. Invalid names/notes/moves or a
failed write leave the previous data intact.

Creating the first list upgrades the document to schema 2. New builds read both
schema 1 and 2; older builds reject schema 2 rather than silently stripping lists.
A schema-1 import merges into the current library without removing existing lists.
The iCloud schema still uses the existing Asset field; no extra container or record
type is needed. Back up before changing app versions.

Tests cover duplicate/multiple memberships, per-list notes, reorder, persisted
reload/backup, invalid/stale edits, failed saves, list deletion and orphan cleanup,
sync/deletion convergence and schema-1 compatibility. An offline UI scenario
creates a list and adds a saved title. Static checks and supplemental model/service
typechecks pass; executable Xcode tests remain a required local/CI review gate.
