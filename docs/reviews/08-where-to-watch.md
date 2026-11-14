# 08 — Where to watch

Base: `feature/07-library-backup-sync`.

Movie/TV details and saved title pages link to country-specific subscription,
free/ad-supported, rental and purchase options. Users choose their country and
star services they subscribe to. These preferences are local to the device.
Viewing options open the TMDB-supplied destination; provider APIs do not supply
direct playback links. JustWatch attribution appears beside the availability data.

Favorites > My streaming services checks unwatched titles against saved
subscription services in explicit batches of 20, with a Load next action. Rentals,
purchases and free offers are not treated as subscription access. Results are
cached for one day (100 titles maximum), deduplicated while in flight and persisted
for offline use. Offline fallbacks are labelled stale. Pull to refresh checks
again. Missing regional data means unknown/no reported offers, not a guarantee
that the title is unavailable. No prices are guessed.

Tests cover endpoint routing, region/offer decoding, subscription matching, URL
validation, stale offline cache and bounded library batches. Static checks pass;
execute Scripts/test.sh/CI and verify country changes, empty offers, expired cache
and links on device before merging. The local sandbox still blocks full Xcode
package resolution and CoreSimulator execution.

Official endpoints and attribution requirements:
- https://developer.themoviedb.org/reference/movie-watch-providers
- https://developer.themoviedb.org/reference/tv-series-watch-providers
