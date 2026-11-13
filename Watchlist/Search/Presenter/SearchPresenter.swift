import Foundation
import Observation

@MainActor
@Observable
final class SearchPresenterImpl {
    var query = "" { didSet { invalidate() } }
    var category: SearchCategory = .all { didSet { invalidate() } }
    private(set) var results: [SearchResult] = []
    private(set) var recentQueries: [String]
    private(set) var isLoading = false
    private(set) var hasMore = false
    private(set) var error: Error?
    private var page = 0
    private var generation = 0
    private let service: SearchService
    private let history: RecentSearchStore
    private let debounce: Duration

    init(service: SearchService, history: RecentSearchStore, debounce: Duration = .milliseconds(300)) {
        self.service = service
        self.history = history
        self.debounce = debounce
        recentQueries = history.queries
    }

    var normalizedQuery: String { query.trimmingCharacters(in: .whitespacesAndNewlines) }
    var taskID: String { "\(category.rawValue):\(query)" }

    func search() async {
        generation += 1
        page = 0
        results = []
        hasMore = false
        await load(firstPage: true)
    }

    func loadMore() async {
        guard hasMore, !isLoading else { return }
        await load(firstPage: false)
    }

    func retry() async {
        if page == 0 { await search() } else { await loadMore() }
    }

    func clearHistory() {
        history.clear()
        recentQueries = []
    }

    private func invalidate() {
        generation += 1
        results = []
        error = nil
        hasMore = false
        isLoading = false
        page = 0
    }

    private func load(firstPage: Bool) async {
        guard !normalizedQuery.isEmpty, !Task.isCancelled else { return }
        let token = generation
        let searchedQuery = normalizedQuery
        let searchedCategory = category
        let nextPage = page + 1
        isLoading = true
        error = nil
        defer { if token == generation { isLoading = false } }
        do {
            if firstPage { try await Task.sleep(for: debounce) }
            let response = try await service.search(query: searchedQuery, category: searchedCategory, page: nextPage)
            try Task.checkCancellation()
            guard token == generation else { return }
            var identifiers = Set(results.map(\.id))
            results.append(contentsOf: response.results.filter { identifiers.insert($0.id).inserted })
            page = nextPage
            hasMore = response.page < min(response.totalPages, 500)
            if firstPage {
                history.remember(searchedQuery)
                recentQueries = history.queries
            }
        } catch {
            guard token == generation, !Task.isCancelled, !(error is CancellationError) else { return }
            self.error = error
        }
    }
}
