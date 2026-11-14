import Foundation

struct EpisodeRecord: Codable, Equatable, Identifiable, Sendable {
    let seasonNumber: Int
    let episodeNumber: Int
    let name: String
    let airDate: String?
    var id: String { "\(seasonNumber)-\(episodeNumber)" }

    enum CodingKeys: String, CodingKey {
        case seasonNumber = "season_number"
        case episodeNumber = "episode_number"
        case name
        case airDate = "air_date"
    }

    func hasAired(on date: Date) -> Bool {
        guard let airDate else { return false }
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.isLenient = false
        guard let parsed = formatter.date(from: airDate),
              formatter.string(from: parsed) == airDate else { return false }
        return airDate <= formatter.string(from: date)
    }
}

struct EpisodeSeasonSummary: Codable, Equatable, Identifiable, Sendable {
    let seasonNumber: Int
    let name: String
    var id: Int { seasonNumber }
    enum CodingKeys: String, CodingKey {
        case seasonNumber = "season_number"
        case name
    }
}

struct EpisodeSeason: Codable, Equatable, Sendable {
    let seasonNumber: Int
    let name: String
    let episodes: [EpisodeRecord]
    enum CodingKeys: String, CodingKey {
        case seasonNumber = "season_number"
        case name, episodes
    }
}

struct SeriesProgress: Codable, Equatable, Sendable {
    var catalog: [EpisodeSeasonSummary] = []
    var seasons: [EpisodeSeason] = []
    var watchedIDs: Set<String> = []

    func nextEpisode(on date: Date) -> EpisodeRecord? {
        seasons.flatMap(\.episodes)
            .filter { $0.seasonNumber > 0 && $0.hasAired(on: date) && !watchedIDs.contains($0.id) }
            .sorted {
                ($0.seasonNumber, $0.episodeNumber) < ($1.seasonNumber, $1.episodeNumber)
            }.first
    }
}

enum EpisodeProgressError: LocalizedError {
    case unavailable, staleUndo, invalidSeason
    var errorDescription: String? {
        switch self {
        case .unavailable: "Save this TV show to your library before tracking episodes."
        case .staleUndo: "Progress changed since this action. Undo is no longer available."
        case .invalidSeason: "The service returned an unexpected season. Please try again."
        }
    }
}
