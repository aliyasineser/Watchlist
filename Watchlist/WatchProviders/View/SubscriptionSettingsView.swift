import SwiftUI

struct SubscriptionSettingsView: View {
    @State var presenter: SubscriptionPresenterImpl
    var body: some View {
        List {
            Section {
                Text("Select the services you already subscribe to. This doesn’t create or manage a paid subscription.")
                    .font(.footnote).foregroundStyle(.secondary)
                Text("Catalog for \(presenter.preferences.countryName)").font(.subheadline)
                if presenter.isStale { Text("Offline · showing saved services").foregroundStyle(.secondary) }
            }
            if !presenter.selected.isEmpty {
                Section("Your services") { ForEach(presenter.selected) { providerRow($0) } }
            }
            Section("Available services") {
                ForEach(presenter.visible.filter { !presenter.preferences.subscriptions.contains($0.id) }) {
                    providerRow($0)
                }
                if presenter.isLoading { ProgressView("Loading services…") }
                if let error = presenter.error {
                    Text(error.localizedDescription).foregroundStyle(.secondary)
                    Button("Try again") { Task { await presenter.load(force: true) } }
                }
            }
            if let url = URL(string: "https://www.justwatch.com") {
                Link("Provider data by JustWatch", destination: url).font(.footnote)
            }
        }
        .navigationTitle("My streaming services")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $presenter.query, prompt: "Find a service")
        .task(id: presenter.preferences.region) { await presenter.load() }
        .refreshable { await presenter.load(force: true) }
    }
    private func providerRow(_ provider: WatchProvider) -> some View {
        Toggle(provider.name, isOn: Binding(
            get: { presenter.preferences.subscriptions.contains(provider.id) },
            set: { value in
                if value != presenter.preferences.subscriptions.contains(provider.id) {
                    presenter.preferences.toggle(provider.id, name: provider.name)
                }
            }
        ))
        .accessibilityIdentifier("subscription.\(provider.id)")
    }
}
