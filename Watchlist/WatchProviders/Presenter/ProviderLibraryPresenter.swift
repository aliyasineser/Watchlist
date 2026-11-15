import Foundation
import Observation

@MainActor
@Observable
final class ProviderLibraryPresenterImpl {
    let store: WatchLibraryStoreImpl
    let preferences: ProviderPreferencesImpl
    private(set) var isLoading = false
    private(set) var checked = 0
    private(set) var failures = 0
    private(set) var hasStaleData = false
    private var queue: [SavedTitle] = []
    private var matches: Set<String> = []
    private var generation = 0
    private var forceRequests = false
    private let service: WatchProviderService

    init(store: WatchLibraryStoreImpl, preferences: ProviderPreferencesImpl? = nil,
         service: WatchProviderService? = nil) {
        self.store = store
        self.preferences = preferences ?? .shared
        self.service = service ?? WatchProviderServiceImpl.shared
    }
    var entries: [WatchEntry] { store.entries.filter { matches.contains($0.id) && $0.status != .watched } }
    var hasMore: Bool { checked < queue.count }
    var taskID: String { preferences.taskID + "-\(store.revision)" }

    func reset(force: Bool = false) async {
        forceRequests = force
        generation += 1
        let resetToken = generation
        await store.load()
        guard resetToken == generation, !Task.isCancelled else { return }
        queue = store.filtered(status: nil, type: nil, sort: .dateAdded)
            .filter { $0.status != .watched }.map(\.title)
        matches = []
        checked = 0
        failures = 0
        hasStaleData = false
        isLoading = false
        await loadMore()
    }

    func loadMore() async {
        guard !isLoading, !preferences.subscriptions.isEmpty else { return }
        let token = generation
        let region = preferences.region
        let subscriptions = preferences.subscriptions
        let batch = Array(queue.dropFirst(checked).prefix(20))
        isLoading = true
        defer { if generation == token { isLoading = false } }
        for title in batch {
            do {
                try Task.checkCancellation()
                let result = try await service.availability(for: title, force: forceRequests)
                guard token == generation, region == preferences.region,
                      subscriptions == preferences.subscriptions else { return }
                if result.included(in: subscriptions, region: region) { matches.insert(title.id) }
                hasStaleData = hasStaleData || result.isStale
            } catch is CancellationError { return } catch {
                guard token == generation else { return }
                failures += 1
            }
            checked += 1
        }
    }
}
