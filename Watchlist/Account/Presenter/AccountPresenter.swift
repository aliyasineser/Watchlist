import Foundation
import Observation

@MainActor
@Observable
final class AccountPresenterImpl {
    let transfer: LibraryTransferPresenterImpl
    let providerPreferences: ProviderPreferencesImpl
    let subscriptions: SubscriptionPresenterImpl
    private(set) var account: ICloudAccountSnapshot?
    private(set) var isChecking = false
    var confirmationIdentifier: String?
    var error: Error?
    private let service: ICloudAccountService

    init(transfer: LibraryTransferPresenterImpl, service: ICloudAccountService,
         providerPreferences: ProviderPreferencesImpl, subscriptions: SubscriptionPresenterImpl) {
        self.transfer = transfer
        self.service = service
        self.providerPreferences = providerPreferences
        self.subscriptions = subscriptions
    }
    func refresh() async {
        guard !isChecking else { return }
        isChecking = true
        defer { isChecking = false }
        do {
            account = try await service.snapshot()
            if account?.needsConfirmation == true || account?.connection == .signedOut ||
                account?.connection == .restricted { transfer.syncEnabled = false }
            error = nil
        } catch {
            account = ICloudAccountSnapshot(connection: .unavailable, identifier: nil, needsConfirmation: false)
            self.error = error
        }
    }
    func setSyncEnabled(_ enabled: Bool) async {
        if !enabled { transfer.syncEnabled = false; return }
        guard !isChecking, !transfer.isSyncing else { return }
        await refresh()
        guard let account, account.connection == .available, let identifier = account.identifier else {
            error = ICloudAccountError.unavailable
            return
        }
        if account.needsConfirmation { confirmationIdentifier = identifier; return }
        transfer.syncEnabled = true
        await transfer.sync()
    }
    func confirmAndSync(_ identifier: String) async {
        confirmationIdentifier = nil
        do {
            try await service.confirmAccount(identifier)
            let current = try await service.snapshot()
            guard current.connection == .available, current.identifier == identifier, !current.needsConfirmation else {
                throw ICloudAccountError.changed
            }
            account = current
            transfer.syncEnabled = true
            await transfer.sync()
            error = nil
        } catch { self.error = error; transfer.syncEnabled = false }
    }
}
