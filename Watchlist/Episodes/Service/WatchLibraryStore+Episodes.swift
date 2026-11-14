import Foundation

extension WatchLibraryStoreImpl {
    func cacheSeasonCatalog(_ catalog: [EpisodeSeasonSummary], for title: SavedTitle) async -> Bool {
        await updateProgress(for: title) { $0.catalog = catalog }
    }

    func cacheSeason(_ season: EpisodeSeason, for title: SavedTitle) async -> Bool {
        await updateProgress(for: title) { progress in
            progress.seasons.removeAll { $0.seasonNumber == season.seasonNumber }
            progress.seasons.append(season)
        }
    }

    func changeEpisodes(
        for title: SavedTitle, ids: Set<String>, watched: Bool, now: Date = .now
    ) async -> Bool {
        await updateProgress(for: title) { progress in
            let eligible = Set(progress.seasons.flatMap(\.episodes).filter { $0.hasAired(on: now) }.map(\.id))
            if watched {
                progress.watchedIDs.formUnion(ids.intersection(eligible))
            } else {
                progress.watchedIDs.subtract(ids)
            }
        }
    }

    func restoreEpisodes(for title: SavedTitle, before: Set<String>, expected: Set<String>) async -> Bool {
        await updateProgress(for: title) { progress in
            guard progress.watchedIDs == expected else { throw EpisodeProgressError.staleUndo }
            progress.watchedIDs = before
        }
    }

    private func updateProgress(
        for title: SavedTitle, change: (inout SeriesProgress) throws -> Void
    ) async -> Bool {
        await mutate { entries in
            guard title.mediaType == .tv, let index = entries.firstIndex(where: { $0.id == title.id }) else {
                throw EpisodeProgressError.unavailable
            }
            var progress = entries[index].episodeProgress ?? SeriesProgress()
            try change(&progress)
            entries[index].episodeProgress = progress
            entries[index].updatedAt = .now
        }
    }
}
