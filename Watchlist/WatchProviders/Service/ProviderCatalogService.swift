import Foundation

struct ProviderCatalogRequest: NetworkRequest {
    let type: MediaType
    let region: String
    var path: String { "/watch/providers/\(type.rawValue)" }
    var requestType: RequestType { .GET }
    var urlParams: [String: String?] {
        ["api_key": APIConstants.apiKey, "language": APIConstants.language, "watch_region": region]
    }
}

struct ProviderCatalog: Sendable {
    let providers: [WatchProvider]
    let isStale: Bool
}

@MainActor
protocol ProviderCatalogService {
    func providers(region: String, force: Bool) async throws -> ProviderCatalog
}

struct ProviderCatalogEntry: Codable, Sendable {
    let providers: [WatchProvider]
    let fetchedAt: Date
}

actor ProviderCatalogCacheImpl {
    private let url: URL
    init(url: URL = URL.applicationSupportDirectory.appendingPathComponent("WatchlistProviders/catalog.json")) {
        self.url = url
    }
    func load(_ region: String) -> ProviderCatalogEntry? { read()[region] }
    func save(_ entry: ProviderCatalogEntry, region: String) throws {
        var entries = read()
        entries[region] = entry
        let recent = entries.sorted { $0.value.fetchedAt > $1.value.fetchedAt }.prefix(10)
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try JSONEncoder().encode(Dictionary(uniqueKeysWithValues: recent.map { ($0.key, $0.value) }))
            .write(to: url, options: .atomic)
    }
    private func read() -> [String: ProviderCatalogEntry] {
        guard let data = try? Data(contentsOf: url), data.count < 5_000_000 else { return [:] }
        return (try? JSONDecoder().decode([String: ProviderCatalogEntry].self, from: data)) ?? [:]
    }
}

@MainActor
struct ProviderCatalogServiceImpl: ProviderCatalogService {
    private let manager: RequestManager
    private let cache: ProviderCatalogCacheImpl
    init(manager: RequestManager = DefaultRequestManager(),
         cache: ProviderCatalogCacheImpl = ProviderCatalogCacheImpl()) {
        self.manager = manager
        self.cache = cache
    }
    func providers(region: String, force: Bool = false) async throws -> ProviderCatalog {
        let cached = await cache.load(region)
        if !force, let cached, Date.now.timeIntervalSince(cached.fetchedAt) < 86_400 {
            return ProviderCatalog(providers: cached.providers, isStale: false)
        }
        do {
            let movie: CatalogResponse = try await manager.initRequest(with: ProviderCatalogRequest(type: .movie,
                                                                                                  region: region))
            let series: CatalogResponse = try await manager.initRequest(with: ProviderCatalogRequest(type: .tv,
                                                                                                   region: region))
            var seen = Set<Int>()
            let providers = (movie.results + series.results).filter { seen.insert($0.id).inserted }
                .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            try? await cache.save(ProviderCatalogEntry(providers: providers, fetchedAt: .now), region: region)
            return ProviderCatalog(providers: providers, isStale: false)
        } catch {
            try Task.checkCancellation()
            if let cached { return ProviderCatalog(providers: cached.providers, isStale: true) }
            throw error
        }
    }
}

private struct CatalogResponse: Decodable {
    let results: [WatchProvider]
}
