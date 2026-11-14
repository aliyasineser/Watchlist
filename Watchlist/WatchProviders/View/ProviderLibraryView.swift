import SwiftUI

struct ProviderLibraryView: View {
    @State var presenter: ProviderLibraryPresenterImpl

    var body: some View {
        List {
            Section {
                ProviderCountryPicker(preferences: presenter.preferences)
                Text("Unwatched titles included in your saved subscriptions. Checked in batches of 20.")
                    .font(.footnote).foregroundStyle(.secondary)
                if presenter.preferences.subscriptions.isEmpty {
                    Text("Open Where to watch on a title and star your subscription services first.")
                }
                if presenter.hasStaleData { Text("Some results use saved availability. Pull to check again.") }
                if presenter.failures > 0 {
                    Text("Some titles could not be checked. Pull to retry.")
                }
            }
            ForEach(presenter.entries) { entry in
                NavigationLink(entry.title.title) {
                    SavedTitleDetailView(title: entry.title, store: presenter.store)
                }
            }
            if presenter.isLoading { ProgressView("Checking your library…") }
            if presenter.hasMore && !presenter.preferences.subscriptions.isEmpty {
                Button("Check next 20 titles") { Task { await presenter.loadMore() } }
                    .disabled(presenter.isLoading)
            }
            if !presenter.isLoading && presenter.checked > 0 && presenter.entries.isEmpty {
                Text("No matches among the titles checked so far.")
            }
            Text("\(presenter.checked) titles checked · Streaming data by JustWatch")
                .font(.footnote).foregroundStyle(.secondary)
        }
        .navigationTitle("My streaming services")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: presenter.taskID) { await presenter.reset() }
        .refreshable { await presenter.reset(force: true) }
    }
}
