import Foundation

@MainActor
protocol WatchProviderService {
    func availability(for title: SavedTitle, force: Bool) async throws -> WatchAvailability
}

struct WatchProviderRequest: NetworkRequest {
    let title: SavedTitle
    var path: String { "/\(title.mediaType.rawValue)/\(title.tmdbID)/watch/providers" }
    var requestType: RequestType { .GET }
    var urlParams: [String: String?] { ["api_key": APIConstants.apiKey] }
}

struct ProviderCacheEntry: Codable, Sendable {
    let response: ProviderResponse
    let fetchedAt: Date
}

actor ProviderCacheImpl {
    private let url: URL
    init(url: URL = URL.applicationSupportDirectory.appendingPathComponent("WatchlistProviders/cache.json")) {
        self.url = url
    }
    func load(_ id: String) -> ProviderCacheEntry? { read()[id] }
    func save(_ entry: ProviderCacheEntry, id: String) throws {
        var entries = read()
        entries[id] = entry
        let recent = entries.sorted { $0.value.fetchedAt > $1.value.fetchedAt }.prefix(100)
        let bounded = Dictionary(uniqueKeysWithValues: recent.map { ($0.key, $0.value) })
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try JSONEncoder().encode(bounded).write(to: url, options: .atomic)
    }
    private func read() -> [String: ProviderCacheEntry] {
        guard let data = try? Data(contentsOf: url), data.count <= 20_000_000 else { return [:] }
        return (try? JSONDecoder().decode([String: ProviderCacheEntry].self, from: data)) ?? [:]
    }
}

@MainActor
final class WatchProviderServiceImpl: WatchProviderService {
    static let shared = WatchProviderServiceImpl()
    private let manager: RequestManager
    private let cache: ProviderCacheImpl
    private var requests: [String: Task<ProviderResponse, Error>] = [:]

    init(manager: RequestManager = DefaultRequestManager(), cache: ProviderCacheImpl = ProviderCacheImpl()) {
        self.manager = manager
        self.cache = cache
    }

    func availability(for title: SavedTitle, force: Bool = false) async throws -> WatchAvailability {
        let cached = await cache.load(title.id)
        if !force, let cached, Date.now.timeIntervalSince(cached.fetchedAt) < 86_400 {
            return WatchAvailability(response: cached.response, fetchedAt: cached.fetchedAt, isStale: false)
        }
        let request: Task<ProviderResponse, Error>
        if let existing = requests[title.id] { request = existing } else {
            request = Task { try await manager.initRequest(with: WatchProviderRequest(title: title)) }
            requests[title.id] = request
        }
        defer { requests[title.id] = nil }
        do {
            let response = try await request.value
            try Task.checkCancellation()
            let entry = ProviderCacheEntry(response: response, fetchedAt: .now)
            try? await cache.save(entry, id: title.id)
            return WatchAvailability(response: response, fetchedAt: entry.fetchedAt, isStale: false)
        } catch {
            try Task.checkCancellation()
            if let cached {
                return WatchAvailability(response: cached.response, fetchedAt: cached.fetchedAt, isStale: true)
            }
            throw error
        }
    }
}
