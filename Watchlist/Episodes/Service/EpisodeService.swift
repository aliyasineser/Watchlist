import Foundation

@MainActor
protocol EpisodeService {
    func seasons(seriesID: Int) async throws -> [EpisodeSeasonSummary]
    func season(seriesID: Int, number: Int) async throws -> EpisodeSeason
}

struct EpisodeRequest: NetworkRequest {
    let seriesID: Int
    var seasonNumber: Int?
    var path: String {
        let base = "/tv/\(seriesID)"
        return seasonNumber.map { base + "/season/\($0)" } ?? base
    }
    var requestType: RequestType { .GET }
    var urlParams: [String: String?] {
        ["api_key": APIConstants.apiKey, "language": APIConstants.language]
    }
}

@MainActor
final class EpisodeServiceImpl: EpisodeService {
    private let requestManager: RequestManager
    init(requestManager: RequestManager = DefaultRequestManager()) { self.requestManager = requestManager }

    func seasons(seriesID: Int) async throws -> [EpisodeSeasonSummary] {
        let response: EpisodeCatalogResponse = try await requestManager.initRequest(
            with: EpisodeRequest(seriesID: seriesID)
        )
        var seen = Set<Int>()
        return response.seasons.filter { $0.seasonNumber >= 0 && seen.insert($0.seasonNumber).inserted }
            .sorted { $0.seasonNumber < $1.seasonNumber }
    }

    func season(seriesID: Int, number: Int) async throws -> EpisodeSeason {
        let result: EpisodeSeason = try await requestManager.initRequest(
            with: EpisodeRequest(seriesID: seriesID, seasonNumber: number)
        )
        guard result.seasonNumber == number,
              result.episodes.allSatisfy({ $0.seasonNumber == number && $0.episodeNumber > 0 }) else {
            throw EpisodeProgressError.invalidSeason
        }
        var seen = Set<String>()
        return EpisodeSeason(
            seasonNumber: number, name: result.name,
            episodes: result.episodes.filter { seen.insert($0.id).inserted }
                .sorted { $0.episodeNumber < $1.episodeNumber }
        )
    }
}

private struct EpisodeCatalogResponse: Decodable {
    let seasons: [EpisodeSeasonSummary]
}
