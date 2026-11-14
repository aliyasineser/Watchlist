import Foundation
import Observation

@MainActor
protocol WatchTonightPresenter {
    var matches: [WatchEntry] { get }
    func pick()
}

@MainActor
@Observable
final class WatchTonightPresenterImpl: WatchTonightPresenter {
    let store: WatchLibraryStoreImpl
    var filter = WatchTonightFilter() { didSet { pickedID = nil } }
    private(set) var pickedID: String?
    private let strategy: WatchSuggestionStrategy
    private let choose: ([WatchEntry]) -> WatchEntry?

    init(
        store: WatchLibraryStoreImpl,
        strategy: WatchSuggestionStrategy = WatchSuggestionStrategyImpl(),
        choose: @escaping ([WatchEntry]) -> WatchEntry? = { $0.randomElement() }
    ) {
        self.store = store
        self.strategy = strategy
        self.choose = choose
    }

    var matches: [WatchEntry] { strategy.matches(entries: store.entries, filter: filter) }
    var shortlist: [WatchEntry] { Array(matches.prefix(5)) }
    var picked: WatchEntry? { matches.first { $0.id == pickedID } }
    var genres: [String] {
        Array(Set(store.entries.filter { $0.status != .watched }.flatMap { $0.title.genreNames ?? [] })).sorted()
    }
    var excludedForMissingMetadata: Int {
        store.entries.filter {
            $0.status != .watched && (filter.mediaType == nil || $0.title.mediaType == filter.mediaType) &&
            ((filter.maximumMinutes != nil && ($0.title.runtimeMinutes ?? 0) <= 0) ||
             (filter.genre != nil && ($0.title.genreNames ?? []).isEmpty))
        }.count
    }
    func reason(for entry: WatchEntry) -> String { strategy.reason(for: entry) }
    func pick() { pickedID = choose(matches)?.id }
}
