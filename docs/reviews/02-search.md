# 02 — Search

Base: `feature/01-reliability`. Branch: `feature/02-search`.

A Search tab queries TMDB's multi/movie/tv/person endpoints rather than filtering
already loaded discovery cards. Queries debounce for 300 ms. SwiftUI cancels the
previous task on input/category changes, and generation checks reject late
responses even if a transport ignores cancellation. Pagination uses total_pages,
retries the failed page and deduplicates by media type plus ID.

Recent successful queries are trimmed, deduplicated case-insensitively, limited
to ten, persisted locally and clearable. Result destinations route movies, TV and
artists separately. The existing content filter excludes adult results.

Official endpoint references:
- https://developer.themoviedb.org/reference/search-multi
- https://developer.themoviedb.org/reference/search-movie
- https://developer.themoviedb.org/reference/search-tv
- https://developer.themoviedb.org/reference/search-person

Tests cover query escaping, mixed responses, ID collisions, stale responses,
cancellation, retry/terminal pagination and recent-query persistence. Run
`Scripts/test.sh`; simulator execution is still blocked in the editing sandbox.
Review only this branch's diff against reliability. Merge reliability first.
