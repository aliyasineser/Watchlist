import Foundation

struct CustomListItem: Codable, Identifiable, Equatable, Sendable {
    let titleID: String
    var notes: String = ""
    var id: String { titleID }
}

struct CustomWatchList: Codable, Identifiable, Equatable, Sendable {
    let id: String
    var name: String
    var notes: String
    var items: [CustomListItem] = []
    let createdAt: Date
    var updatedAt: Date
}

struct CustomListStrategy {
    func validate(_ lists: [CustomWatchList], titleIDs: Set<String>) throws {
        var ids = Set<String>()
        for list in lists {
            guard UUID(uuidString: list.id) != nil, ids.insert(list.id).inserted,
                  !list.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                  list.name.count <= 80, list.notes.count <= 2_000 else { throw CustomListError.invalidList }
            var members = Set<String>()
            for item in list.items {
                guard titleIDs.contains(item.titleID), members.insert(item.titleID).inserted,
                      item.notes.count <= 2_000 else { throw CustomListError.invalidList }
            }
        }
    }

    func merged(_ local: [CustomWatchList], _ remote: [CustomWatchList], deleted: [String: Date],
                titles: Set<String>, deletedTitles: [String: Date]) -> [CustomWatchList] {
        var merged: [String: CustomWatchList] = [:]
        for list in local + remote {
            if let existing = merged[list.id] {
                merged[list.id] = latest(existing, list)
            } else { merged[list.id] = list }
        }
        return merged.values.filter { (deleted[$0.id] ?? .distantPast) < $0.updatedAt }.map { list in
            var clean = list
            for item in list.items where !titles.contains(item.titleID) {
                clean.updatedAt = max(clean.updatedAt, deletedTitles[item.titleID] ?? clean.updatedAt)
            }
            clean.items.removeAll { !titles.contains($0.titleID) }
            return clean
        }.sorted { $0.id < $1.id }
    }

    func reordered(_ ids: [String], from: IndexSet, to destination: Int) throws -> [String] {
        guard (0...ids.count).contains(destination), from.allSatisfy({ ids.indices.contains($0) }) else {
            throw CustomListError.invalidMove
        }
        let moving = from.sorted().map { ids[$0] }
        var remaining = ids.enumerated().filter { !from.contains($0.offset) }.map(\.element)
        remaining.insert(contentsOf: moving, at: destination - from.filter { $0 < destination }.count)
        return remaining
    }

    private func latest(_ left: CustomWatchList, _ right: CustomWatchList) -> CustomWatchList {
        if left.updatedAt != right.updatedAt { return left.updatedAt > right.updatedAt ? left : right }
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let lhs = (try? encoder.encode(left)) ?? Data()
        let rhs = (try? encoder.encode(right)) ?? Data()
        return lhs.lexicographicallyPrecedes(rhs) ? right : left
    }
}

enum CustomListError: LocalizedError {
    case invalidList, missingList, missingTitle, changed, invalidMove
    var errorDescription: String? {
        switch self {
        case .invalidList: "Use a list name of 1–80 characters and notes of at most 2,000 characters."
        case .missingList: "This list no longer exists."
        case .missingTitle: "Save this title to your library before adding it to a list."
        case .changed: "This list changed while you were editing. Reopen it and try again."
        case .invalidMove: "The list order changed. Please try moving the title again."
        }
    }
}
