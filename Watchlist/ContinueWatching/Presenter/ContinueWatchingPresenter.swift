import Foundation
import Observation

@MainActor
@Observable
final class ContinueWatchingPresenterImpl {
    let store: WatchLibraryStoreImpl
    var error: Error?
    private(set) var canUndo = false
    private var before: WatchEntry?
    private var after: WatchEntry?
    private let strategy: ContinueWatchingStrategy
    private let now: () -> Date

    init(store: WatchLibraryStoreImpl, strategy: ContinueWatchingStrategy = ContinueWatchingStrategyImpl(),
         now: @escaping () -> Date = { .now }) {
        self.store = store
        self.strategy = strategy
        self.now = now
    }
    var items: [ContinueWatchingItem] { strategy.items(from: store.entries, now: now()) }

    func markWatched(_ id: String) async {
        guard let item = items.first(where: { $0.id == id }), item.actionTitle != nil else { return }
        let original = item.entry
        var committed: WatchEntry?
        let saved = await store.mutate { entries in
            guard let index = entries.firstIndex(where: { $0.id == id }), entries[index] == original else {
                throw EpisodeProgressError.staleUndo
            }
            if let episode = item.nextEpisode {
                entries[index].episodeProgress?.watchedIDs.insert(episode.id)
            } else if original.title.mediaType == .movie {
                entries[index].status = .watched
            }
            entries[index].updatedAt = self.now()
            committed = entries[index]
        }
        if saved {
            before = original
            after = committed
            canUndo = true
            error = nil
        } else { error = store.error }
    }

    func undo() async {
        guard canUndo, let before, let after else { return }
        let restored = await store.mutate { entries in
            guard let index = entries.firstIndex(where: { $0.id == after.id }), entries[index] == after else {
                throw EpisodeProgressError.staleUndo
            }
            // Preserve metadata and other fields; update the edit time so sync propagates the undo.
            entries[index].status = before.status
            entries[index].episodeProgress = before.episodeProgress
            entries[index].updatedAt = self.now()
        }
        if restored { canUndo = false; error = nil } else {
            error = store.error
            if case .some(.staleUndo) = store.error as? EpisodeProgressError { canUndo = false }
        }
    }
}
