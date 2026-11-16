import Foundation
import Observation

@MainActor
@Observable
final class LibraryTransferPresenterImpl {
    let store: WatchLibraryStoreImpl
    var syncEnabled: Bool { didSet { preferences.set(syncEnabled, forKey: "library.syncEnabled") } }
    private(set) var isSyncing = false
    private(set) var lastSync: Date?
    private(set) var lastSyncedRevision: Int?
    var error: Error?
    var importPreview: WatchLibraryDocument?
    private let cloud: LibraryCloudService
    private let preferences: UserDefaults

    init(store: WatchLibraryStoreImpl, cloud: LibraryCloudService, preferences: UserDefaults = .standard) {
        self.store = store
        self.cloud = cloud
        self.preferences = preferences
        syncEnabled = preferences.bool(forKey: "library.syncEnabled")
        lastSync = preferences.object(forKey: "library.lastSync") as? Date
    }

    func sync() async {
        guard syncEnabled, !isSyncing else { return }
        await store.load()
        guard store.isLoaded else { error = store.error; return }
        isSyncing = true
        error = nil
        defer { isSyncing = false }
        do {
            let original = store.document
            let merged = try await cloud.exchange(original)
            try Task.checkCancellation()
            guard await store.installDocument(merged, expected: original) else {
                throw store.error ?? LibraryTransferError.changedDuringSync
            }
            lastSyncedRevision = store.revision
            lastSync = .now
            preferences.set(lastSync, forKey: "library.lastSync")
        } catch is CancellationError { } catch {
            self.error = error
            if let accountError = error as? ICloudAccountError {
                switch accountError {
                case .changed, .confirmationRequired: syncEnabled = false
                case .unavailable: break
                }
            }
        }
    }

    func previewImport(_ url: URL) async {
        do { importPreview = try await LibraryBackupReaderImpl().read(url) } catch { self.error = error }
    }

    func mergeImport(_ incoming: WatchLibraryDocument) async {
        let original = store.document
        let merged = LibraryMergeStrategyImpl().merge(original, incoming)
        if await store.installDocument(merged, expected: original) { importPreview = nil } else { error = store.error }
    }
}
