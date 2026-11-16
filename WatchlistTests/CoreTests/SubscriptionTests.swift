import XCTest
@testable import Watchlist

@MainActor
final class SubscriptionTests: XCTestCase {
    func testCatalogUsesCountryEndpointsDeduplicatesAndCachesProviders() async throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        let api = CatalogAPIStub()
        let cache = ProviderCatalogCacheImpl(url: directory.appendingPathComponent("catalog.json"))
        let service = ProviderCatalogServiceImpl(manager: DefaultRequestManager(apiManager: api), cache: cache)
        let catalog = try await service.providers(region: "DE", force: false)
        XCTAssertEqual(catalog.providers.map(\.id), [8])
        XCTAssertEqual(api.paths, ["/watch/providers/movie", "/watch/providers/tv"])
        XCTAssertEqual(api.regions, ["DE", "DE"])
        _ = try await service.providers(region: "DE", force: false)
        XCTAssertEqual(api.paths.count, 2)
        _ = try await service.providers(region: "GB", force: false)
        XCTAssertEqual(api.paths.count, 4)
    }

    func testSelectedServicesRememberNamesAndCanBeRemovedOffline() async {
        let defaults = UserDefaults(suiteName: "SubscriptionTests") ?? .standard
        defaults.removePersistentDomain(forName: "SubscriptionTests")
        let preferences = ProviderPreferencesImpl(defaults: defaults)
        preferences.toggle(8, name: "Example service")
        let reloaded = ProviderPreferencesImpl(defaults: defaults)
        XCTAssertTrue(reloaded.subscriptions.contains(8))
        let presenter = SubscriptionPresenterImpl(preferences: reloaded, service: OfflineCatalogStub())
        await presenter.load()
        XCTAssertNotNil(presenter.error)
        XCTAssertEqual(presenter.selected.first?.name, "Example service")
        reloaded.toggle(8)
        XCTAssertTrue(presenter.selected.isEmpty)
    }
}

private final class CatalogAPIStub: APIManager {
    var paths: [String] = []
    var regions: [String?] = []
    func initRequest(with request: NetworkRequest) async throws -> Data {
        paths.append(request.path)
        regions.append(request.urlParams["watch_region"] ?? nil)
        return Data(#"{"results":[{"provider_id":8,"provider_name":"Example service","logo_path":null}]}"#.utf8)
    }
}

@MainActor
private struct OfflineCatalogStub: ProviderCatalogService {
    func providers(region: String, force: Bool) async throws -> ProviderCatalog {
        throw URLError(.notConnectedToInternet)
    }
}
