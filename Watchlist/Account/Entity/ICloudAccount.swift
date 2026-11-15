import Foundation

enum ICloudConnection: Equatable, Sendable {
    case available, signedOut, restricted, unavailable
    var title: String {
        switch self {
        case .available: "iCloud connected"
        case .signedOut: "Sign in to iCloud"
        case .restricted: "iCloud access restricted"
        case .unavailable: "iCloud unavailable"
        }
    }
    var description: String {
        switch self {
        case .available: "Use the iCloud account signed into this device to keep your library across devices."
        case .signedOut: "Open iOS Settings and sign in to your Apple Account, then return here."
        case .restricted: "This device’s account restrictions prevent iCloud access."
        case .unavailable: "Check your connection and iCloud settings, then try again."
        }
    }
}

struct ICloudAccountSnapshot: Sendable {
    let connection: ICloudConnection
    let identifier: String?
    let needsConfirmation: Bool
}

enum ICloudAccountError: LocalizedError {
    case unavailable, confirmationRequired, changed
    var errorDescription: String? {
        switch self {
        case .unavailable: "iCloud is unavailable. Check your Apple Account in iOS Settings and try again."
        case .confirmationRequired:
            "Sync is paused. Confirm the current iCloud account in the Account tab before syncing."
        case .changed: "The iCloud account changed. Review the current account in Settings, then confirm it again."
        }
    }
}

struct ICloudIdentityPolicy {
    func needsConfirmation(current: String, confirmed: String?) -> Bool { current != confirmed }
    func validatedIdentifier(_ snapshot: ICloudAccountSnapshot) throws -> String {
        guard snapshot.connection == .available, let identifier = snapshot.identifier else {
            throw ICloudAccountError.unavailable
        }
        guard !snapshot.needsConfirmation else { throw ICloudAccountError.confirmationRequired }
        return identifier
    }
}
