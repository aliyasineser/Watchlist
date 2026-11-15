import Foundation

struct WatchProvider: Codable, Identifiable, Equatable, Sendable {
    let id: Int
    let name: String
    let logoPath: String?
    enum CodingKeys: String, CodingKey {
        case id = "provider_id"
        case name = "provider_name"
        case logoPath = "logo_path"
    }
}

struct ProviderRegion: Codable, Sendable {
    let link: String?
    let flatrate: [WatchProvider]?
    let free: [WatchProvider]?
    let ads: [WatchProvider]?
    let rent: [WatchProvider]?
    let buy: [WatchProvider]?

    var destination: URL? {
        guard let link, let url = URL(string: link), url.scheme == "https",
              url.host == "www.themoviedb.org" || url.host == "themoviedb.org" else { return nil }
        return url
    }
}

struct ProviderResponse: Codable, Sendable {
    let results: [String: ProviderRegion]
}

struct WatchAvailability: Sendable {
    let response: ProviderResponse
    let fetchedAt: Date
    let isStale: Bool
    func region(_ code: String) -> ProviderRegion? { response.results[code] }
    func included(in subscriptions: Set<Int>, region: String) -> Bool {
        response.results[region]?.flatrate?.contains { subscriptions.contains($0.id) } ?? false
    }
}
