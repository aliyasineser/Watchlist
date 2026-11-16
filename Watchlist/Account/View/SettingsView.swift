import SwiftUI

struct SettingsView: View {
    @State var presenter: AccountPresenterImpl

    var body: some View {
        Form {
            localLibrarySection
            syncSection
            preferencesSection
            backupSection
        }
        .navigationTitle("Settings")
        .task { await presenter.refresh() }
        .refreshable { await presenter.refresh() }
        .confirmationDialog("Enable iCloud sync?", isPresented: Binding(
            get: { presenter.confirmationIdentifier != nil },
            set: { if !$0 { presenter.confirmationIdentifier = nil } }
        ), titleVisibility: .visible) {
            Button("Merge my library with this iCloud account") {
                if let identifier = presenter.confirmationIdentifier {
                    Task { await presenter.confirmAndSync(identifier) }
                }
            }
            Button("Not now", role: .cancel) { presenter.confirmationIdentifier = nil }
        } message: {
            Text("Your local library will merge with the iCloud account signed into this device. "
                 + "Data in a previous iCloud account stays there. You can keep using Watchlist without sync.")
        }
    }

    private var localLibrarySection: some View {
        Section {
            Label {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Saved on this device").font(.headline)
                    Text("Your library works without an account or iCloud sync.")
                        .font(.subheadline).foregroundStyle(.secondary)
                }
            } icon: {
                Image(systemName: "internaldrive").foregroundStyle(.tint)
            }
        }
    }

    private var syncSection: some View {
        Section {
            Toggle("Sync with iCloud", isOn: Binding(
                get: { presenter.transfer.syncEnabled },
                set: { value in Task { await presenter.setSyncEnabled(value) } }
            ))
            .disabled(presenter.isChecking || presenter.transfer.isSyncing)
            .accessibilityIdentifier("account.sync")

            Label(presenter.syncStatus.rawValue, systemImage: presenter.syncStatus.symbol)
                .foregroundStyle(presenter.syncStatus == .needsAttention ? Color.orange : Color.secondary)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(presenter.syncStatus.rawValue)
                .accessibilityIdentifier("settings.syncStatus")
                .accessibilityAddTraits(.updatesFrequently)
            if presenter.isChecking || presenter.transfer.isSyncing { ProgressView() }
            if presenter.account?.connection == .available, presenter.account?.needsConfirmation == false,
               let last = presenter.transfer.lastSync {
                Text("Last successful sync: \(last.formatted())")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            if let error = presenter.error ?? presenter.transfer.error {
                Text(error.localizedDescription).font(.footnote)
                Button("Review & retry sync") { Task { await presenter.retrySync() } }
                    .disabled(presenter.isChecking || presenter.transfer.isSyncing)
                    .accessibilityIdentifier("settings.retrySync")
            } else if presenter.transfer.syncEnabled {
                Button("Sync now") { Task { await presenter.retrySync() } }
                    .disabled(presenter.isChecking || presenter.transfer.isSyncing)
            }

            DisclosureGroup("How iCloud sync works") {
                Text("Keep saved titles, lists, ratings and episode progress across your Apple devices "
                     + "using the same iCloud account. Artist favorites, country and streaming preferences "
                     + "stay on this device.")
                Text("Turning sync off keeps your library on this device and leaves existing iCloud data in place.")
                Text(presenter.account?.connection.title ?? "Checking iCloud…").font(.headline)
                Text(presenter.account?.connection.description ?? "Checking your connection to iCloud.")
                Text("To change your iCloud account, open iOS Settings → Apple Account. "
                     + "No Watchlist registration is needed.")
                Button("Check iCloud connection") { Task { await presenter.refresh() } }
                    .disabled(presenter.isChecking || presenter.transfer.isSyncing)
            }
            .font(.subheadline)
        } header: {
            Text("Optional iCloud sync")
        } footer: {
            Text("Enable sync when you’re ready. Your local library stays available if iCloud is offline.")
        }
    }

    private var preferencesSection: some View {
        Section("Your viewing preferences") {
            ProviderCountryPicker(preferences: presenter.providerPreferences)
            NavigationLink {
                SubscriptionSettingsView(presenter: presenter.subscriptions)
            } label: {
                Label("My streaming services", systemImage: "play.tv")
            }
            .accessibilityIdentifier("account.services")
            Text("Country and service preferences are saved on this device.")
                .font(.footnote).foregroundStyle(.secondary)
        }
    }

    private var backupSection: some View {
        Section {
            NavigationLink {
                LibraryTransferView(presenter: presenter.transfer)
            } label: {
                Label("Backup & restore", systemImage: "externaldrive")
            }
            .accessibilityIdentifier("library.backup")
        } header: {
            Text("Your data")
        } footer: {
            Text("Export or restore a backup without enabling iCloud. "
                 + "Keep a separate copy of your library for safekeeping.")
        }
    }
}
