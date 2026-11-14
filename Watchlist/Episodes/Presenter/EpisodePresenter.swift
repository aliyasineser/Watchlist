import Foundation
import Observation

@MainActor
protocol EpisodePresenter {
    func loadCatalog(force: Bool) async
    func loadSeason(force: Bool) async
}

@MainActor
@Observable
final class EpisodePresenterImpl: EpisodePresenter {
    let title: SavedTitle
    let store: WatchLibraryStoreImpl
    var selectedSeason: Int?
    private(set) var isLoadingCatalog = false
    private(set) var isLoadingSeason = false
    private(set) var error: Error?
    private(set) var canUndo = false
    private var undoBefore: Set<String> = []
    private var undoAfter: Set<String> = []
    private var generation = 0
    private let service: EpisodeService

    init(title: SavedTitle, store: WatchLibraryStoreImpl, service: EpisodeService? = nil) {
        self.title = title
        self.store = store
        self.service = service ?? EpisodeServiceImpl()
    }

    var progress: SeriesProgress { store.entry(for: title)?.episodeProgress ?? SeriesProgress() }
    var season: EpisodeSeason? { progress.seasons.first { $0.seasonNumber == selectedSeason } }
    var isSaved: Bool { store.entry(for: title) != nil }

    func loadCatalog(force: Bool = false) async {
        guard !isLoadingCatalog else { return }
        isLoadingCatalog = true
        defer { isLoadingCatalog = false }
        await store.load()
        guard isSaved else { error = EpisodeProgressError.unavailable; return }
        if !force && !progress.catalog.isEmpty { selectInitialSeason(); return }
        error = nil
        do {
            let catalog = try await service.seasons(seriesID: title.tmdbID)
            try Task.checkCancellation()
            if await store.cacheSeasonCatalog(catalog, for: title) {
                selectInitialSeason()
            } else { error = store.error }
        } catch is CancellationError { } catch { self.error = error }
    }

    func loadSeason(force: Bool = false) async {
        generation += 1
        let request = generation
        guard let number = selectedSeason else { isLoadingSeason = false; return }
        if !force && season != nil { isLoadingSeason = false; error = nil; return }
        isLoadingSeason = true
        error = nil
        defer { if generation == request { isLoadingSeason = false } }
        do {
            let season = try await service.season(seriesID: title.tmdbID, number: number)
            try Task.checkCancellation()
            guard request == generation else { return }
            if !(await store.cacheSeason(season, for: title)) { error = store.error }
        } catch is CancellationError { } catch {
            if request == generation { self.error = error }
        }
    }

    func setWatched(ids: Set<String>, watched: Bool) async {
        let before = progress.watchedIDs
        if await store.changeEpisodes(for: title, ids: ids, watched: watched) {
            undoBefore = before
            undoAfter = progress.watchedIDs
            canUndo = undoBefore != undoAfter
            error = nil
        } else { error = store.error }
    }

    func undo() async {
        guard canUndo else { return }
        if await store.restoreEpisodes(for: title, before: undoBefore, expected: undoAfter) {
            canUndo = false
            error = nil
        } else { error = store.error }
    }

    private func selectInitialSeason() {
        if let selectedSeason, progress.catalog.contains(where: { $0.seasonNumber == selectedSeason }) { return }
        selectedSeason = progress.catalog.first { $0.seasonNumber > 0 }?.seasonNumber
            ?? progress.catalog.first?.seasonNumber
    }
}
