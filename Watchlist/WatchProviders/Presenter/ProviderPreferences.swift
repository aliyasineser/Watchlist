import Foundation
import Observation

@MainActor
@Observable
final class ProviderPreferencesImpl {
    static let shared = ProviderPreferencesImpl()
    var region: String { didSet { defaults.set(region, forKey: "providers.region") } }
    var subscriptions: Set<Int> { didSet { defaults.set(subscriptions.sorted(), forKey: "providers.subscriptions") } }
    private(set) var providerNames: [String: String]
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        region = defaults.string(forKey: "providers.region") ?? Locale.current.region?.identifier ?? "US"
        subscriptions = Set(defaults.array(forKey: "providers.subscriptions") as? [Int] ?? [])
        providerNames = defaults.dictionary(forKey: "providers.names") as? [String: String] ?? [:]
    }
    var taskID: String { region + subscriptions.sorted().map(String.init).joined(separator: ",") }
    var countryName: String { Locale.current.localizedString(forRegionCode: region) ?? region }
    func toggle(_ id: Int, name: String? = nil) {
        if let name { providerNames[String(id)] = name; defaults.set(providerNames, forKey: "providers.names") }
        if !subscriptions.insert(id).inserted { subscriptions.remove(id) }
    }
    func remember(_ providers: [WatchProvider]) {
        for provider in providers { providerNames[String(provider.id)] = provider.name }
        defaults.set(providerNames, forKey: "providers.names")
    }
}

@MainActor
@Observable
final class AvailabilityPresenterImpl {
    let title: SavedTitle
    let preferences: ProviderPreferencesImpl
    private(set) var availability: WatchAvailability?
    private(set) var isLoading = false
    private(set) var error: Error?
    var subscriptionsOnly = false
    private let service: WatchProviderService

    init(title: SavedTitle, preferences: ProviderPreferencesImpl? = nil, service: WatchProviderService? = nil) {
        self.title = title
        self.preferences = preferences ?? .shared
        self.service = service ?? WatchProviderServiceImpl.shared
    }
    var region: ProviderRegion? { availability?.region(preferences.region) }
    func providers(_ items: [WatchProvider]?) -> [WatchProvider] {
        var seen = Set<Int>()
        return (items ?? []).filter {
            (!subscriptionsOnly || preferences.subscriptions.contains($0.id)) && seen.insert($0.id).inserted
        }
    }
    func load(force: Bool = false) async {
        guard !isLoading else { return }
        isLoading = true
        error = nil
        defer { isLoading = false }
        do { availability = try await service.availability(for: title, force: force) } catch is CancellationError {
        } catch { self.error = error }
    }
}
