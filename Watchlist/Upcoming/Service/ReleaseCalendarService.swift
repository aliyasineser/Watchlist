import Foundation

@MainActor
protocol ReleaseCalendarService {
    func events(for title: SavedTitle) async throws -> [ReleaseEvent]
}

struct ReleaseRequest: NetworkRequest {
    let title: SavedTitle
    var path: String { "/\(title.mediaType.rawValue)/\(title.tmdbID)" }
    var requestType: RequestType { .GET }
    var urlParams: [String: String?] {
        ["api_key": APIConstants.apiKey, "language": APIConstants.language]
    }
}

@MainActor
struct ReleaseCalendarServiceImpl: ReleaseCalendarService {
    private let manager: RequestManager
    init(manager: RequestManager = DefaultRequestManager()) { self.manager = manager }
    func events(for title: SavedTitle) async throws -> [ReleaseEvent] {
        let response: ReleaseResponse = try await manager.initRequest(with: ReleaseRequest(title: title))
        if title.mediaType == .movie, let date = response.releaseDate {
            return [ReleaseEvent(id: title.id + "-release", titleID: title.id, title: title.title,
                                 dateISO: date, label: "Movie release")]
        }
        guard let episode = response.nextEpisode, let date = episode.airDate else { return [] }
        return [ReleaseEvent(id: title.id + "-" + episode.id, titleID: title.id, title: title.title,
                             dateISO: date, label: "S\(episode.seasonNumber) E\(episode.episodeNumber)")]
    }
}

private struct ReleaseResponse: Decodable {
    let releaseDate: String?
    let nextEpisode: EpisodeRecord?
    enum CodingKeys: String, CodingKey {
        case releaseDate = "release_date"
        case nextEpisode = "next_episode_to_air"
    }
}

struct ReleaseCacheEntry: Codable, Sendable {
    let events: [ReleaseEvent]
    let fetchedAt: Date
}

actor ReleaseCacheImpl {
    static let shared = ReleaseCacheImpl()
    private let url: URL
    init(url: URL = URL.applicationSupportDirectory.appendingPathComponent("WatchlistUpcoming/cache.json")) {
        self.url = url
    }
    func load(_ id: String) -> ReleaseCacheEntry? { read()[id] }
    func save(_ entry: ReleaseCacheEntry, id: String) throws {
        var entries = read()
        entries[id] = entry
        let recent = entries.sorted { $0.value.fetchedAt > $1.value.fetchedAt }.prefix(200)
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try JSONEncoder().encode(Dictionary(uniqueKeysWithValues: recent.map { ($0.key, $0.value) }))
            .write(to: url, options: .atomic)
    }
    private func read() -> [String: ReleaseCacheEntry] {
        guard let data = try? Data(contentsOf: url), data.count <= 20_000_000 else { return [:] }
        return (try? JSONDecoder().decode([String: ReleaseCacheEntry].self, from: data)) ?? [:]
    }
}
