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
    private(set) var catalogError: Error?
    private(set) var seasonError: Error?
    private(set) var actionError: Error?
    var error: Error? { catalogError ?? seasonError }
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
        guard isSaved else {
            catalogError = store.error
            return
        }
        if !force && !progress.catalog.isEmpty { selectInitialSeason(); return }
        catalogError = nil
        do {
            let catalog = try await service.seasons(seriesID: title.tmdbID)
            try Task.checkCancellation()
            if await store.cacheSeasonCatalog(catalog, for: title) {
                selectInitialSeason()
            } else { catalogError = store.error }
        } catch is CancellationError { } catch { catalogError = error }
    }

    func loadSeason(force: Bool = false) async {
        generation += 1
        let request = generation
        guard let number = selectedSeason, isSaved else {
            isLoadingSeason = false
            seasonError = nil
            return
        }
        if !force && season != nil { isLoadingSeason = false; seasonError = nil; return }
        isLoadingSeason = true
        seasonError = nil
        defer {
            if generation == request { isLoadingSeason = false }
        }
        do {
            let season = try await service.season(seriesID: title.tmdbID, number: number)
            try Task.checkCancellation()
            guard request == generation, selectedSeason == number else { return }
            if !(await store.cacheSeason(season, for: title)) { seasonError = store.error }
        } catch is CancellationError { } catch {
            if request == generation, selectedSeason == number { seasonError = error }
        }
    }

    func setWatched(ids: Set<String>, watched: Bool) async {
        let before = progress.watchedIDs
        if await store.changeEpisodes(for: title, ids: ids, watched: watched) {
            undoBefore = before
            undoAfter = progress.watchedIDs
            canUndo = undoBefore != undoAfter
            actionError = nil
        } else { actionError = store.error }
    }

    func undo() async {
        guard canUndo else { return }
        if await store.restoreEpisodes(for: title, before: undoBefore, expected: undoAfter) {
            canUndo = false
            actionError = nil
        } else { actionError = store.error }
    }

    func saveAndStartTracking() async {
        await store.setStatus(.watching, for: title)
        actionError = store.error
        if isSaved { await loadCatalog() }
    }

    func dismissActionError() { actionError = nil }

    func retry() async {
        if catalogError != nil || progress.catalog.isEmpty { await loadCatalog(force: true) }
        if seasonError != nil || season == nil { await loadSeason(force: true) }
    }

    func refresh() async {
        await loadCatalog(force: true)
        if catalogError == nil { await loadSeason(force: true) }
    }

    private func selectInitialSeason() {
        if let selectedSeason, progress.catalog.contains(where: { $0.seasonNumber == selectedSeason }) { return }
        selectedSeason = progress.catalog.first { $0.seasonNumber > 0 }?.seasonNumber
            ?? progress.catalog.first?.seasonNumber
    }
}
