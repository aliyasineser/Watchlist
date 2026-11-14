import Foundation

@MainActor
protocol SearchService {
    func search(query: String, category: SearchCategory, page: Int) async throws -> SearchPage
}

struct SearchRequest: NetworkRequest {
    let query: String
    let category: SearchCategory
    let page: Int

    var path: String { "/search/\(category.rawValue)" }
    var requestType: RequestType { .GET }
    var urlParams: [String: String?] {
        [
            "query": query,
            "page": String(page),
            "include_adult": "false",
            "language": APIConstants.language,
            "api_key": APIConstants.apiKey
        ]
    }
}

@MainActor
final class SearchServiceImpl: SearchService {
    private let requestManager: RequestManager

    init(requestManager: RequestManager = DefaultRequestManager()) {
        self.requestManager = requestManager
    }

    func search(query: String, category: SearchCategory, page: Int) async throws -> SearchPage {
        let response: SearchResponse = try await requestManager.initRequest(
            with: SearchRequest(query: query, category: category, page: page)
        )
        let results = response.results.compactMap { hit -> SearchResult? in
            let kind = hit.mediaType.flatMap(SearchCategory.init(rawValue:)) ?? category
            guard kind != .all else { return nil }
            return SearchResult(
                tmdbID: hit.id, category: kind, title: hit.title ?? hit.name ?? "Untitled",
                imagePath: hit.posterPath ?? hit.profilePath, overview: hit.overview, rating: hit.voteAverage
            )
        }
        return SearchPage(results: results, page: response.page, totalPages: response.totalPages)
    }

}

private struct SearchResponse: Decodable {
    let results: [SearchHit]
    let page: Int
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case results, page
        case totalPages = "total_pages"
    }
}

private struct SearchHit: Decodable {
    let id: Int
    let mediaType: String?
    let title: String?
    let name: String?
    let posterPath: String?
    let profilePath: String?
    let overview: String?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id, title, name, overview
        case mediaType = "media_type"
        case posterPath = "poster_path"
        case profilePath = "profile_path"
        case voteAverage = "vote_average"
    }
}
