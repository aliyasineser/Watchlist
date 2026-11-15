import Foundation
import Observation

@MainActor
@Observable
final class SubscriptionPresenterImpl {
    let preferences: ProviderPreferencesImpl
    var query = ""
    private(set) var providers: [WatchProvider] = []
    private(set) var isLoading = false
    private(set) var isStale = false
    private(set) var error: Error?
    private var generation = 0
    private let service: ProviderCatalogService

    init(preferences: ProviderPreferencesImpl, service: ProviderCatalogService) {
        self.preferences = preferences
        self.service = service
    }
    var visible: [WatchProvider] {
        providers.filter { query.isEmpty || $0.name.localizedCaseInsensitiveContains(query) }
    }
    var selected: [WatchProvider] {
        preferences.subscriptions.sorted().map {
            WatchProvider(id: $0, name: preferences.providerNames[String($0)] ?? "Service \($0)", logoPath: nil)
        }
    }
    func load(force: Bool = false) async {
        generation += 1
        let token = generation
        let region = preferences.region
        isLoading = true
        error = nil
        providers = []
        defer { if token == generation { isLoading = false } }
        do {
            let catalog = try await service.providers(region: region, force: force)
            try Task.checkCancellation()
            guard token == generation, region == preferences.region else { return }
            providers = catalog.providers
            preferences.remember(catalog.providers)
            isStale = catalog.isStale
        } catch is CancellationError { } catch { if token == generation { self.error = error } }
    }
}
