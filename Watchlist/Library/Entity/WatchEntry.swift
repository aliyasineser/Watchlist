import Foundation

enum WatchStatus: String, Codable, CaseIterable, Identifiable, Sendable {
    case wantToWatch, watching, watched
    var id: String { rawValue }
    var title: String {
        switch self {
        case .wantToWatch: "Want to watch"
        case .watching: "Watching"
        case .watched: "Watched"
        }
    }
}

struct SavedTitle: Codable, Equatable, Sendable {
    let tmdbID: Int
    let mediaType: MediaType
    let title: String
    var posterURL: String?
    var overview: String?
    var communityRating: Double?
    var genreNames: [String]?
    var runtimeMinutes: Int?
    var id: String { "\(mediaType.rawValue)-\(tmdbID)" }

    init(tmdbID: Int, mediaType: MediaType, title: String) {
        self.tmdbID = tmdbID
        self.mediaType = mediaType
        self.title = title
    }

    init(media: WatchableDetail) {
        tmdbID = media.id
        mediaType = media is MovieDetail ? .movie : .tv
        title = media.title
        posterURL = media.posterPath == nil ? nil : media.posterUrl
        overview = media.overview
        communityRating = media.voteAverage
        genreNames = media.genres.map(\.name)
        if let movie = media as? MovieDetail {
            runtimeMinutes = movie.runtime.flatMap { $0 > 0 ? $0 : nil }
        } else if let series = media as? TvDetail {
            runtimeMinutes = series.episodeRunTime?.first { $0 > 0 }
        }
    }
}

struct WatchEntry: Codable, Identifiable, Equatable, Sendable {
    var title: SavedTitle
    var status: WatchStatus
    var personalRating: Int?
    var episodeProgress: SeriesProgress?
    let addedAt: Date
    var updatedAt: Date
    var id: String { title.id }
}

struct WatchLibraryDocument: Codable, Sendable {
    var version = 1
    var importedFavorites = false
    var entries: [WatchEntry] = []
}

enum LibrarySort: String, CaseIterable, Identifiable {
    case dateAdded = "Date added"
    case title = "Title"
    case rating = "My rating"
    var id: String { rawValue }
}

enum WatchLibraryError: LocalizedError {
    case unsupportedVersion, invalidRating, unavailable, busy
    var errorDescription: String? {
        switch self {
        case .unsupportedVersion: "This library was saved by a newer version of Watchlist. Update the app to open it."
        case .invalidRating: "Choose a rating between 1 and 10."
        case .unavailable: "Your library could not be loaded. Try opening it again before making changes."
        case .busy: "A library change is still being saved. Please try again in a moment."
        }
    }
}
