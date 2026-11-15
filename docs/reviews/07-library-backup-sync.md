# 07 — Library backup and private iCloud sync

Base: `feature/06-episode-progress` (`ebe6e8c`); 06 is not yet merged to main.

Favorites > Backup & sync exports/imports a versioned JSON library and offers
opt-in private CloudKit sync. Backups include movies, shows, ratings, episode
progress and deletion timestamps; artist favorites and artwork files stay local.
Imports validate schema, IDs, duplicate entries and rating ranges and show a merge
confirmation. A backup does not replace the entire library: absent titles stay.

The latest complete title edit wins conflicts. Metadata uses its own fetch time;
tombstones preserve deletions across devices. Equal-time edits use a deterministic
tie break. Watched episode IDs encode in stable order. A local edit during sync
prevents installing an obsolete snapshot; the user can sync again. Remote record
change-tag conflicts refetch and merge up to three times. Asset storage avoids the
small inline record limit; backups are limited to 20 MB. Keep device clocks accurate.

Sync runs after changes/activation when opted in, with a two-second debounce.
The transfer screen displays sync errors and last-success time. Turning it off
keeps local data. Test dependencies never access CloudKit. No push subscription,
background fetch or remote notifications are required; other-device changes arrive
on activation or Sync now.

Provisioning required for device validation: enable iCloud/CloudKit for app ID
`com.yeser.Watchlist` and container `iCloud.com.yeser.Watchlist` using the existing
team; refresh signing profiles. The entitlement file is configured for both app
build configurations. In CloudKit development, create the WatchLibrary record type
with an Asset field `library`; deploy that schema to production before TestFlight.
This repository change does not create the Apple Developer container remotely.
Verify two-device add/edit/delete, offline recovery, iCloud sign-out and a fresh
install. A sync is not a substitute for an exported backup.

Unit tests cover backup validation/round-trip, merge convergence/deletions,
metadata conflict handling and rejecting obsolete sync snapshots. Static lint,
Swift parsing and project/entitlement checks pass. Full Xcode build and simulator
execution remain blocked by the editing sandbox's cache/CoreSimulator restrictions;
run Scripts/test.sh and review CI before merging. Cloud provisioning and two-device
checks remain explicit release gates.
