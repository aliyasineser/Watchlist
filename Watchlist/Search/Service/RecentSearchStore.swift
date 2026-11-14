import Foundation

@MainActor
protocol RecentSearchStore {
    var queries: [String] { get }
    func remember(_ query: String)
    func clear()
}

@MainActor
final class RecentSearchStoreImpl: RecentSearchStore {
    private let defaults: UserDefaults
    private let key = "watchlist.recentSearches"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    var queries: [String] { Array((defaults.stringArray(forKey: key) ?? []).prefix(10)) }

    func remember(_ query: String) {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return }
        let rest = queries.filter { $0.caseInsensitiveCompare(query) != .orderedSame }
        defaults.set(Array(([query] + rest).prefix(10)), forKey: key)
    }

    func clear() { defaults.removeObject(forKey: key) }
}
