import CloudKit
import Foundation

protocol ICloudAccountService: Sendable {
    func snapshot() async throws -> ICloudAccountSnapshot
    func confirmAccount(_ expectedIdentifier: String) async throws
    func validatedIdentifier() async throws -> String
}

actor ICloudAccountServiceImpl: ICloudAccountService {
    static let shared = ICloudAccountServiceImpl()
    static let containerIdentifier = "iCloud.com.yeser.Watchlist"
    private let container: CKContainer
    private let preferences: UserDefaults
    private let identityKey = "library.confirmedICloudAccount"

    init(container: CKContainer = CKContainer(identifier: ICloudAccountServiceImpl.containerIdentifier),
         preferences: UserDefaults = .standard) {
        self.container = container
        self.preferences = preferences
    }
    func snapshot() async throws -> ICloudAccountSnapshot {
        let status = try await container.accountStatus()
        guard status == .available else {
            let connection: ICloudConnection
            switch status {
            case .noAccount: connection = .signedOut
            case .restricted: connection = .restricted
            default: connection = .unavailable
            }
            return ICloudAccountSnapshot(connection: connection, identifier: nil, needsConfirmation: false)
        }
        let record = try await container.userRecordID()
        let confirmed = preferences.string(forKey: identityKey)
        return ICloudAccountSnapshot(connection: .available, identifier: record.recordName,
                                     needsConfirmation: ICloudIdentityPolicy().needsConfirmation(
                                        current: record.recordName, confirmed: confirmed
                                     ))
    }
    func confirmAccount(_ expectedIdentifier: String) async throws {
        let current = try await snapshot()
        guard current.connection == .available, current.identifier == expectedIdentifier else {
            throw ICloudAccountError.changed
        }
        preferences.set(expectedIdentifier, forKey: identityKey)
    }
    func validatedIdentifier() async throws -> String {
        let current = try await snapshot()
        return try ICloudIdentityPolicy().validatedIdentifier(current)
    }
}
