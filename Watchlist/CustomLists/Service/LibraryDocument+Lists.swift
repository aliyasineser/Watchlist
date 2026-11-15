import Foundation

extension WatchLibraryDocument {
    mutating func prepareForSave(previous: WatchLibraryDocument) {
        let remaining = Set(entries.map(\.id))
        var deleted = deletedTitles ?? [:]
        for entry in previous.entries where !remaining.contains(entry.id) { deleted[entry.id] = .now }
        for entry in entries { deleted[entry.id] = nil }
        deletedTitles = deleted
        cleanLists(titleIDs: remaining, previous: previous.lists ?? [])
    }

    private mutating func cleanLists(titleIDs: Set<String>, previous: [CustomWatchList]) {
        guard var lists else { return }
        for index in lists.indices {
            let original = lists[index].items
            lists[index].items.removeAll { !titleIDs.contains($0.titleID) }
            if lists[index].items != original { lists[index].updatedAt = .now }
        }
        let remaining = Set(lists.map(\.id))
        var deleted = deletedLists ?? [:]
        for list in previous where !remaining.contains(list.id) { deleted[list.id] = .now }
        for list in lists { deleted[list.id] = nil }
        self.lists = lists
        deletedLists = deleted
        version = 2
    }
}
