import Foundation

enum SearchCategory: String, CaseIterable, Identifiable {
    case all = "multi"
    case movies = "movie"
    case series = "tv"
    case artists = "person"

    var id: String { rawValue }
    var title: String {
        switch self {
        case .all: "All"
        case .movies: "Movies"
        case .series: "TV"
        case .artists: "Artists"
        }
    }
}

struct SearchResult: Identifiable, Equatable {
    let tmdbID: Int
    let category: SearchCategory
    let title: String
    let imagePath: String?
    let overview: String?
    let rating: Double?

    // A movie and a person can have the same numeric TMDB identifier.
    var id: String { "\(category.rawValue):\(tmdbID)" }
    var imageURL: String {
        guard let imagePath else { return "" }
        return APIConstants.defaultScheme + APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + imagePath
    }
}

struct SearchPage {
    let results: [SearchResult]
    let page: Int
    let totalPages: Int
}
