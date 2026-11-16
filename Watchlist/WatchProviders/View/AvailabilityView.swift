import SwiftUI

struct ProviderCountryPicker: View {
    @State var preferences: ProviderPreferencesImpl
    private var countries: [String] {
        Locale.Region.isoRegions.map(\.identifier).filter { $0.count == 2 }.sorted {
            (Locale.current.localizedString(forRegionCode: $0) ?? $0) <
                (Locale.current.localizedString(forRegionCode: $1) ?? $1)
        }
    }
    var body: some View {
        Picker("Country", selection: $preferences.region) {
            ForEach(countries, id: \.self) { code in
                Text(Locale.current.localizedString(forRegionCode: code) ?? code).tag(code)
            }
        }
    }
}

struct AvailabilityView: View {
    @State var presenter: AvailabilityPresenterImpl

    var body: some View {
        List {
            Section {
                ProviderCountryPicker(preferences: presenter.preferences)
                Toggle("My subscriptions only", isOn: $presenter.subscriptionsOnly)
                Text("Tap a provider’s star to save or remove your subscription.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            if let availability = presenter.availability {
                if availability.isStale {
                    Label("Offline · showing saved availability", systemImage: "wifi.slash")
                }
                Text("Checked \(availability.fetchedAt.formatted())").font(.caption).foregroundStyle(.secondary)
                if let region = presenter.region {
                    providerSection("Subscription", items: region.flatrate)
                    if !presenter.subscriptionsOnly {
                        providerSection("Free", items: region.free)
                        providerSection("With ads", items: region.ads)
                        providerSection("Rent", items: region.rent)
                        providerSection("Buy", items: region.buy)
                    }
                    if let url = region.destination { Link("Open viewing options", destination: url) }
                } else {
                    Text("No availability reported for \(presenter.preferences.countryName).")
                }
                if presenter.subscriptionsOnly && presenter.providers(presenter.region?.flatrate).isEmpty {
                    Text("No matches for your saved subscriptions in this country.")
                }
            }
            if let error = presenter.error {
                Text(error.localizedDescription)
                Button("Try again") { Task { await presenter.load(force: true) } }
            }
            if presenter.isLoading { ProgressView("Checking availability…") }
            Section {
                if let url = URL(string: "https://www.justwatch.com") {
                    Link("Streaming data by JustWatch", destination: url)
                }
                Text("Availability can change. Verify pricing and access with the provider before subscribing.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Where to watch")
        .navigationBarTitleDisplayMode(.inline)
        .task { await presenter.load() }
        .refreshable { await presenter.load(force: true) }
    }

    @ViewBuilder
    private func providerSection(_ title: String, items: [WatchProvider]?) -> some View {
        let providers = presenter.providers(items)
        if !providers.isEmpty {
            Section(title) {
                ForEach(providers) { provider in
                    HStack {
                        Text(provider.name)
                        Spacer()
                        Button {
                            presenter.preferences.toggle(provider.id, name: provider.name)
                        } label: {
                            Image(systemName: presenter.preferences.subscriptions.contains(provider.id)
                                  ? "star.fill" : "star")
                        }
                        .accessibilityLabel("Subscription: \(provider.name)")
                    }
                }
            }
        }
    }
}
