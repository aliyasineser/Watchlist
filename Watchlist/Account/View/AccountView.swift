import SwiftUI

struct AccountView: View {
    @State var presenter: AccountPresenterImpl
    var body: some View {
        Form {
            Section {
                HStack(spacing: 16) {
                    Image(systemName: "icloud.fill")
                        .font(.largeTitle).foregroundStyle(.tint)
                        .frame(width: 56, height: 56)
                        .background(Color.accentColor.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
                    VStack(alignment: .leading, spacing: 6) {
                        Text(presenter.account?.connection.title ?? "Checking iCloud…").font(.headline)
                        Text("Your Apple Account, managed by iOS").font(.caption).foregroundStyle(.secondary)
                    }
                }
                Text(presenter.account?.connection.description ?? "Checking your connection to iCloud.")
                    .font(.subheadline).foregroundStyle(.secondary)
                if presenter.isChecking { ProgressView() }
                Button("Check iCloud connection") { Task { await presenter.refresh() } }
                    .disabled(presenter.isChecking)
                if let error = presenter.error { Text(error.localizedDescription).font(.footnote) }
            }
            Section("Library sync") {
                Toggle("Keep my library in iCloud", isOn: Binding(
                    get: { presenter.transfer.syncEnabled },
                    set: { value in Task { await presenter.setSyncEnabled(value) } }
                ))
                .disabled(presenter.isChecking || presenter.transfer.isSyncing)
                .accessibilityIdentifier("account.sync")
                Text("Titles, lists, ratings and episode progress are saved on this device. "
                     + "Enable sync to keep them with this device’s iCloud account too.")
                    .font(.footnote).foregroundStyle(.secondary)
                if presenter.account?.needsConfirmation == true {
                    Text("Confirm this iCloud account before merging your local library.")
                        .font(.footnote).foregroundStyle(.secondary)
                } else if presenter.account?.connection == .available, let last = presenter.transfer.lastSync {
                    Text("Last synced \(last.formatted())").font(.footnote).foregroundStyle(.secondary)
                }
                Button(presenter.transfer.isSyncing ? "Syncing…" : "Sync now") {
                    Task { await presenter.transfer.sync() }
                }
                .disabled(!presenter.transfer.syncEnabled || presenter.transfer.isSyncing ||
                          presenter.account?.connection != .available || presenter.account?.needsConfirmation == true)
                if let error = presenter.transfer.error { Text(error.localizedDescription).foregroundStyle(.secondary) }
            }
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
            Section("Your data") {
                NavigationLink {
                    LibraryTransferView(presenter: presenter.transfer)
                } label: {
                    Label("Backup & restore", systemImage: "externaldrive")
                }
                .accessibilityIdentifier("library.backup")
                Text("No separate registration is needed. To change or sign out of iCloud, "
                     + "use Apple Account in iOS Settings. Your local library stays on this device.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Account")
        .task { await presenter.refresh() }
        .refreshable { await presenter.refresh() }
        .confirmationDialog("Use the current iCloud account?", isPresented: Binding(
            get: { presenter.confirmationIdentifier != nil },
            set: { if !$0 { presenter.confirmationIdentifier = nil } }
        ), titleVisibility: .visible) {
            Button("Merge my library with this iCloud account") {
                if let identifier = presenter.confirmationIdentifier {
                    Task { await presenter.confirmAndSync(identifier) }
                }
            }
        } message: {
            Text("Local titles and lists will merge with this account. "
                 + "Anything stored in a previous iCloud account stays there.")
        }
    }
}
