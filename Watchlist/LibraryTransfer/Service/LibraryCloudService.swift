import CloudKit
import Foundation

protocol LibraryCloudService: Sendable {
    func exchange(_ local: WatchLibraryDocument) async throws -> WatchLibraryDocument
}

actor LibraryCloudServiceImpl: LibraryCloudService {
    private let container = CKContainer(identifier: ICloudAccountServiceImpl.containerIdentifier)
    private let account: ICloudAccountService

    init(account: ICloudAccountService = ICloudAccountServiceImpl.shared) { self.account = account }
    private let recordID = CKRecord.ID(recordName: "personal-library")

    func exchange(_ local: WatchLibraryDocument) async throws -> WatchLibraryDocument {
        let identity = try await account.validatedIdentifier()
        let database = container.privateCloudDatabase
        for _ in 0..<3 {
            try Task.checkCancellation()
            let record = try await currentRecord(in: database)
            let remote: WatchLibraryDocument
            if let asset = record["library"] as? CKAsset, let url = asset.fileURL {
                remote = try LibraryBackupCodec.decode(Data(contentsOf: url))
            } else if record.recordChangeTag == nil {
                remote = WatchLibraryDocument(importedFavorites: true)
            } else { throw LibraryTransferError.invalidBackup }
            let merged = LibraryMergeStrategyImpl().merge(local, remote)
            let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".json")
            try LibraryBackupCodec.encode(merged).write(to: url, options: .atomic)
            defer { try? FileManager.default.removeItem(at: url) }
            record["library"] = CKAsset(fileURL: url)
            do {
                guard try await account.validatedIdentifier() == identity else { throw ICloudAccountError.changed }
                _ = try await database.save(record)
                return merged
            } catch let error as CKError where error.code == .serverRecordChanged {
                continue
            }
        }
        throw LibraryTransferError.conflict
    }

    private func currentRecord(in database: CKDatabase) async throws -> CKRecord {
        do { return try await database.record(for: recordID) } catch let error as CKError {
            if error.code == .unknownItem { return CKRecord(recordType: "WatchLibrary", recordID: recordID) }
            throw error
        }
    }
}

actor LibraryBackupReaderImpl {
    func read(_ url: URL) throws -> WatchLibraryDocument {
        let access = url.startAccessingSecurityScopedResource()
        defer { if access { url.stopAccessingSecurityScopedResource() } }
        return try LibraryBackupCodec.decode(Data(contentsOf: url))
    }
}
