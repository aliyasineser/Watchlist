import XCTest
@testable import Watchlist

@MainActor
final class SearchTests: XCTestCase {
    func test_requestEscapesQueryAndSelectsEndpoint() throws {
        for category in SearchCategory.allCases {
            let request = SearchRequest(query: "Amélie & Batman?", category: category, page: 2)
            let url = try XCTUnwrap(request.request().url)
            let query = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
            XCTAssertEqual(query?.first { $0.name == "query" }?.value, "Amélie & Batman?")
            XCTAssertEqual(request.path, "/search/\(category.rawValue)")
            XCTAssertEqual(query?.first { $0.name == "page" }?.value, "2")
        }
    }

    func test_mixedResponseKeepsDistinctIDsAndIgnoresUnknownTypes() async throws {
        let service = SearchServiceImpl(requestManager: DefaultRequestManager(apiManager: SearchAPIStub()))
        let page = try await service.search(query: "test", category: .all, page: 1)
        XCTAssertEqual(page.results.map(\.id), ["movie:1", "tv:1", "person:1"])
        XCTAssertEqual(page.results.map(\.title), ["Movie", "Series", "Artist"])
    }

    func test_emptyInputDoesNotSearch() async {
        let service = SearchServiceMock()
        let sut = makePresenter(service)
        sut.query = "  \n"
        await sut.search()
        XCTAssertTrue(service.pages.isEmpty)
        XCTAssertFalse(sut.isLoading)
    }

    func test_failedPaginationRetriesSamePageAndStopsAtLastPage() async {
        let service = SearchServiceMock()
        let sut = makePresenter(service)
        sut.query = "test"
        await sut.search()
        service.error = NetworkError.invalidServerResponse
        await sut.loadMore()
        XCTAssertNotNil(sut.error)
        service.error = nil
        await sut.retry()
        await sut.loadMore()
        XCTAssertEqual(service.pages, [1, 2, 2])
        XCTAssertEqual(sut.results.count, 1)
        XCTAssertFalse(sut.hasMore)
        XCTAssertNil(sut.error)
    }

    func test_changingCategoryClearsPreviousResults() async {
        let sut = makePresenter(SearchServiceMock())
        sut.query = "test"
        await sut.search()
        sut.category = .artists
        XCTAssertTrue(sut.results.isEmpty)
        XCTAssertFalse(sut.hasMore)
    }

    func test_cancelledSearchDoesNotRequestOrShowError() async {
        let service = SearchServiceMock()
        let sut = makePresenter(service)
        sut.query = "test"
        let task = Task { await sut.search() }
        task.cancel()
        await task.value
        XCTAssertTrue(service.pages.isEmpty)
        XCTAssertNil(sut.error)
    }

    func test_lateResponseCannotReplaceNewQuery() async {
        let started = expectation(description: "Old search started")
        let service = DelayedSearchService { started.fulfill() }
        let sut = SearchPresenterImpl(service: service, history: SearchHistoryMock(), debounce: .zero)
        sut.query = "old"
        let old = Task { await sut.search() }
        await fulfillment(of: [started], timeout: 2)
        sut.query = "new"
        await sut.search()
        service.pending?.resume(returning: SearchPage(results: [], page: 1, totalPages: 0))
        await old.value
        XCTAssertEqual(sut.results.first?.title, "new")
        XCTAssertFalse(sut.isLoading)
    }

    func test_historyTrimsDeduplicatesLimitsAndClears() throws {
        let suite = "SearchTests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        let store = RecentSearchStoreImpl(defaults: defaults)
        for index in 0..<12 { store.remember("Query \(index)") }
        store.remember("  QUERY 11 ")
        XCTAssertEqual(store.queries.count, 10)
        XCTAssertEqual(store.queries.first, "QUERY 11")
        XCTAssertEqual(RecentSearchStoreImpl(defaults: defaults).queries, store.queries)
        store.clear()
        XCTAssertTrue(store.queries.isEmpty)
    }

    private func makePresenter(_ service: SearchServiceMock) -> SearchPresenterImpl {
        SearchPresenterImpl(service: service, history: SearchHistoryMock(), debounce: .zero)
    }
}

@MainActor
private final class SearchServiceMock: SearchService {
    var pages: [Int] = []
    var error: Error?
    func search(query: String, category: SearchCategory, page: Int) async throws -> SearchPage {
        pages.append(page)
        if let error { throw error }
        return SearchPage(results: [searchResult(query)], page: page, totalPages: 2)
    }
}

@MainActor
private final class DelayedSearchService: SearchService {
    var pending: CheckedContinuation<SearchPage, Never>?
    let started: () -> Void
    init(started: @escaping () -> Void) { self.started = started }
    func search(query: String, category: SearchCategory, page: Int) async throws -> SearchPage {
        if query == "old" {
            return await withCheckedContinuation {
                pending = $0
                started()
            }
        }
        return SearchPage(results: [searchResult(query)], page: page, totalPages: 1)
    }
}

@MainActor
private final class SearchHistoryMock: RecentSearchStore {
    var queries: [String] = []
    func remember(_ query: String) { queries = [query] }
    func clear() { queries = [] }
}

private func searchResult(_ title: String) -> SearchResult {
    SearchResult(tmdbID: 1, category: .movies, title: title, imagePath: nil, overview: nil, rating: nil)
}

private struct SearchAPIStub: APIManager {
    func initRequest(with data: NetworkRequest) async throws -> Data {
        Data("""
        {"page":1,"total_pages":1,"results":[
          {"id":1,"media_type":"movie","title":"Movie"},
          {"id":1,"media_type":"tv","name":"Series"},
          {"id":1,"media_type":"person","name":"Artist"},
          {"id":2,"media_type":"future_type","name":"Unsupported"}
        ]}
        """.utf8)
    }
}
