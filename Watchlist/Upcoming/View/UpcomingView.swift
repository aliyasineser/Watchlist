import SwiftUI

struct ReleaseFollowControl: View {
    let title: SavedTitle
    @State var store: WatchLibraryStoreImpl
    var body: some View {
        let following = store.entry(for: title)?.followsReleases == true
        Button {
            Task { await store.setReleaseFollowing(!following, for: title) }
        } label: {
            Label(following ? "Following releases" : "Follow upcoming releases",
                  systemImage: following ? "calendar.badge.checkmark" : "calendar.badge.plus")
        }
        .disabled(store.entry(for: title) == nil || store.isSaving)
    }
}

struct UpcomingView: View {
    @State var presenter: UpcomingPresenterImpl
    private var days: [String] { Array(Set(presenter.events.map(\.dateISO))).sorted() }
    var body: some View {
        List {
            Section {
                NavigationLink("Manage followed titles") { followingList }
                Text("Next 90 days · Known catalog dates may vary by region. Pull to refresh.")
                    .font(.footnote).foregroundStyle(.secondary)
                Text("TV entries include the next announced episode and future episodes in downloaded seasons.")
                    .font(.footnote).foregroundStyle(.secondary)
                if presenter.followingCount == 0 {
                    Text("Follow saved titles to see upcoming releases here.")
                }
                if presenter.hasStaleData { Text("Offline · showing saved dates. Dates may have changed.") }
                if presenter.failures > 0 { Text("Some titles could not be refreshed. Pull to retry.") }
            }
            reminderSettings
            ForEach(days, id: \.self) { day in
                Section(day) {
                    ForEach(presenter.events.filter { $0.dateISO == day }) { event in
                        if let entry = presenter.store.entries.first(where: { $0.id == event.titleID }) {
                            NavigationLink {
                                SavedTitleDetailView(title: entry.title, store: presenter.store)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(event.title).font(.headline)
                                    Text(event.label).font(.subheadline).foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            if presenter.isLoading { ProgressView("Checking releases…") }
            if presenter.hasMore {
                Button("Check next 20 followed titles") { Task { await presenter.loadMore() } }
                    .disabled(presenter.isLoading)
            } else if !presenter.isLoading && presenter.followingCount > 0 && presenter.events.isEmpty {
                Text("No upcoming dates are known for the titles checked.")
            }
        }
        .navigationTitle("Upcoming")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: presenter.taskID) { await presenter.reset() }
        .refreshable { await presenter.reset(force: true) }
    }

    private var reminderSettings: some View {
        Section("Release reminders") {
            Toggle("Remind me on release day", isOn: Binding(
                get: { presenter.reminders.enabled },
                set: { value in Task { await presenter.reminders.setEnabled(value, store: presenter.store) } }
            ))
            .disabled(presenter.reminders.isUpdating)
            Toggle("Hide titles in notifications", isOn: Binding(
                get: { presenter.reminders.hideTitles },
                set: { presenter.reminders.hideTitles = $0 }
            ))
                .onChange(of: presenter.reminders.hideTitles) { _, _ in
                    Task { await presenter.reminders.reconcile(store: presenter.store) }
                }
            Text("At 9 AM local time on known release dates. Refresh Upcoming to update dates. "
                 + "Up to 48 reminders are scheduled; no plot details are included.")
                .font(.footnote).foregroundStyle(.secondary)
            if let error = presenter.reminders.error { Text(error.localizedDescription).foregroundStyle(.secondary) }
        }
    }
    private var followingList: some View {
        List(presenter.store.entries) { entry in
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.title.title).font(.headline)
                ReleaseFollowControl(title: entry.title, store: presenter.store)
            }
        }
        .navigationTitle("Followed titles")
        .errorAlert(error: Binding(
            get: { presenter.store.error },
            set: { presenter.store.error = $0 }
        ))
    }
}
