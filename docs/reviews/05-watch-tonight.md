# 05 — Watch tonight

Base: `feature/04-release-checks`. Branch: `feature/05-watch-tonight`.

Favorites has a Watch tonight entry point. Users filter unwatched saved titles by
movie/TV, genre and maximum running time; see a five-title shortlist with readable
reasons; or pick randomly from all matching titles. Oldest saved titles lead the
shortlist. Watched titles never appear. A filter change clears the previous pick,
and removed/watched entries cannot remain selected.

Saved metadata gains optional genres and runtime; existing JSON remains readable.
Movie runtime and typical TV episode runtime are captured on full-detail visits.
TV lengths are explicitly estimates per episode. Unknown lengths/genres are not
invented; affected titles are excluded from constrained searches with explanatory
copy. Any-length/any-genre still includes them. All suggestions work offline using
local data, with no external recommendation service or extra dependency.

Tests cover filters, unknown values, ordering, explanations, legacy decoding and
pick invalidation; an isolated UI test opens a pick offline. Source parsing,
strict app lint, project plist and whitespace checks pass. Executable tests remain
blocked locally by the sandbox; run the workflow added in branch 04 before merging.
