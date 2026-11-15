import Foundation
import Observation

@MainActor
@Observable
final class UpcomingPresenterImpl {
    let store: WatchLibraryStoreImpl
    let reminders: ReleaseRemindersImpl
    private(set) var events: [ReleaseEvent] = []
    private(set) var checked = 0
    private(set) var failures = 0
    private(set) var isLoading = false
    private(set) var hasStaleData = false
    private var queue: [SavedTitle] = []
    private var generation = 0
    private var force = false
    private let service: ReleaseCalendarService
    private let cache: ReleaseCacheImpl

    init(store: WatchLibraryStoreImpl, service: ReleaseCalendarService? = nil,
         cache: ReleaseCacheImpl = .shared, reminders: ReleaseRemindersImpl? = nil) {
        self.store = store
        self.service = service ?? ReleaseCalendarServiceImpl()
        self.cache = cache
        self.reminders = reminders ?? .shared
    }
    var taskID: Int { store.revision }
    var hasMore: Bool { checked < queue.count }
    var followingCount: Int { store.entries.filter { $0.followsReleases == true }.count }

    func reset(force: Bool = false) async {
        generation += 1
        let resetToken = generation
        await store.load()
        guard resetToken == generation, !Task.isCancelled else { return }
        self.force = force
        queue = store.entries.filter { $0.followsReleases == true }.map(\.title)
        events = []
        checked = 0
        failures = 0
        hasStaleData = false
        isLoading = false
        await loadMore()
    }
    func loadMore() async {
        guard !isLoading else { return }
        let token = generation
        isLoading = true
        defer { if generation == token { isLoading = false } }
        for title in Array(queue.dropFirst(checked).prefix(20)) {
            let cached = await cache.load(title.id)
            do {
                try Task.checkCancellation()
                let fetched: [ReleaseEvent]
                if !force, let cached, Date.now.timeIntervalSince(cached.fetchedAt) < 43_200 {
                    fetched = cached.events
                } else {
                    fetched = try await service.events(for: title)
                    let combined = ReleasePlanner().upcoming(fetched + cachedFutureEpisodes(for: title))
                    try await cache.save(ReleaseCacheEntry(events: combined, fetchedAt: .now), id: title.id)
                }
                try Task.checkCancellation()
                guard token == generation else { return }
                events += fetched + cachedFutureEpisodes(for: title)
            } catch is CancellationError { return } catch {
                guard token == generation else { return }
                failures += 1
                hasStaleData = hasStaleData || cached != nil
                events += (cached?.events ?? []) + cachedFutureEpisodes(for: title)
            }
            checked += 1
        }
        events = ReleasePlanner().upcoming(events)
        await reminders.reconcile(store: store)
    }
    private func cachedFutureEpisodes(for title: SavedTitle) -> [ReleaseEvent] {
        let episodes = store.entry(for: title)?.episodeProgress?.seasons.flatMap(\.episodes) ?? []
        return episodes.compactMap { episode in
            guard episode.seasonNumber > 0, let date = episode.airDate else { return nil }
            return ReleaseEvent(id: title.id + "-" + episode.id, titleID: title.id, title: title.title,
                                dateISO: date, label: "S\(episode.seasonNumber) E\(episode.episodeNumber)")
        }
    }
}
