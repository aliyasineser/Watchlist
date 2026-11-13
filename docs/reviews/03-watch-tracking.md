# 03 — Personal watch library

Base: `feature/02-search`. Branch: `feature/03-watch-tracking`.

Movies and TV shows now have Want to watch, Watching and Watched states, optional
1–10 personal ratings, type/status filters, and sorting by date, title or rating.
Favorites remains the tab name. Artist favorites stay separate under Saved artists.
All grids retain a shared 20-point horizontal inset.

The library stores title metadata in an atomic, versioned JSON document in
Application Support. Failed saves do not publish changes. Corrupt or newer-version
files produce an error and are preserved. Existing movie/TV favorites are imported
once into Want to watch, deduplicated by media type and ID. Original Core Data
records remain intact for rollback; later library edits do not sync back to them.

Saved title pages open locally without a TMDB request. Visiting full details saves
fresh metadata. Artwork is downloaded best effort to persistent local storage;
images that have never downloaded still need a connection. Migrated records only
contain their old ID/name until full details are visited. This is local device
storage, not cloud synchronization or full offline catalog access.

Tests added: typed identity, status transitions, ratings, filters/sorting,
failed-save rollback, one-time migration, metadata preservation, disk round-trip,
corruption protection and future schema rejection. UI tests cover library margins,
type filtering and status changes using an isolated in-memory fixture.

Review on device/simulator: save a movie and a show, change status/rating, relaunch,
then disable networking and open their saved pages. Check artist favorites remain
available, and run `Scripts/test.sh` before merging. Static checks pass, but the
editing environment cannot run CoreSimulator or complete package resolution.
