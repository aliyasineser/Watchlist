import Foundation

struct LibraryBackupCodec {
    static func encode(_ document: WatchLibraryDocument) throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]
        let data = try encoder.encode(document)
        guard data.count <= 20_000_000 else { throw LibraryTransferError.tooLarge }
        return data
    }

    static func decode(_ data: Data) throws -> WatchLibraryDocument {
        guard data.count <= 20_000_000 else { throw LibraryTransferError.tooLarge }
        var document = try JSONDecoder().decode(WatchLibraryDocument.self, from: data)
        guard (1...2).contains(document.version) else { throw WatchLibraryError.unsupportedVersion }
        var ids = Set<String>()
        for entry in document.entries {
            guard entry.title.tmdbID > 0, !entry.title.title.isEmpty,
                  ids.insert(entry.id).inserted,
                  entry.personalRating.map({ (1...10).contains($0) }) ?? true else {
                throw LibraryTransferError.invalidBackup
            }
        }
        try CustomListStrategy().validate(document.lists ?? [], titleIDs: ids)
        if document.lists != nil || document.deletedLists != nil { document.version = 2 }
        document.importedFavorites = true
        return document
    }
}

protocol LibraryMergeStrategy {
    func merge(_ local: WatchLibraryDocument, _ remote: WatchLibraryDocument) -> WatchLibraryDocument
}

/// The latest title edit wins; delete timestamps prevent another device resurrecting removed titles.
struct LibraryMergeStrategyImpl: LibraryMergeStrategy {
    func merge(_ local: WatchLibraryDocument, _ remote: WatchLibraryDocument) -> WatchLibraryDocument {
        var result = WatchLibraryDocument(importedFavorites: true)
        let deleted = (local.deletedTitles ?? [:]).merging(remote.deletedTitles ?? [:], uniquingKeysWith: max)
        result.deletedTitles = deleted
        var entries: [String: WatchEntry] = [:]
        for entry in local.entries + remote.entries {
            if let existing = entries[entry.id] {
                let winner = choose(existing, entry)
                var merged = winner
                if (existing.title.metadataFetchedAt ?? .distantPast) >
                    (entry.title.metadataFetchedAt ?? .distantPast) {
                    merged.title = existing.title
                } else if (entry.title.metadataFetchedAt ?? .distantPast) >
                    (existing.title.metadataFetchedAt ?? .distantPast) { merged.title = entry.title }
                entries[entry.id] = merged
            } else { entries[entry.id] = entry }
        }
        result.entries = entries.values.filter { (deleted[$0.id] ?? .distantPast) < $0.updatedAt }
            .sorted { $0.id < $1.id }
        result.version = max(local.version, remote.version)
        if local.lists != nil || remote.lists != nil || local.deletedLists != nil || remote.deletedLists != nil {
            let deletedLists = (local.deletedLists ?? [:]).merging(remote.deletedLists ?? [:], uniquingKeysWith: max)
            result.deletedLists = deletedLists
            result.lists = CustomListStrategy().merged(local.lists ?? [], remote.lists ?? [], deleted: deletedLists,
                                                       titles: Set(result.entries.map(\.id)), deletedTitles: deleted)
            result.version = 2
        }
        return result
    }

    private func choose(_ left: WatchEntry, _ right: WatchEntry) -> WatchEntry {
        if left.updatedAt != right.updatedAt { return left.updatedAt > right.updatedAt ? left : right }
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        // A deterministic tie break makes both devices converge even when timestamps match.
        let lhs = (try? encoder.encode(left)) ?? Data()
        let rhs = (try? encoder.encode(right)) ?? Data()
        return lhs.lexicographicallyPrecedes(rhs) ? right : left
    }
}

enum LibraryTransferError: LocalizedError {
    case tooLarge, invalidBackup, accountUnavailable, changedDuringSync, conflict
    var errorDescription: String? {
        switch self {
        case .tooLarge: "This backup is larger than the supported 20 MB limit."
        case .invalidBackup: "This file is not a valid Watchlist library backup."
        case .accountUnavailable: "Sign in to iCloud and enable iCloud access for Watchlist, then try again."
        case .changedDuringSync: "Your library changed during sync. Your changes are safe; sync again."
        case .conflict: "Another device is updating your library. Please sync again in a moment."
        }
    }
}
