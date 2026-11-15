import Foundation

extension WatchLibraryStoreImpl {
    var customLists: [CustomWatchList] {
        (document.lists ?? []).sorted {
            $0.updatedAt == $1.updatedAt ? $0.id < $1.id : $0.updatedAt > $1.updatedAt
        }
    }
    func customList(_ id: String) -> CustomWatchList? { document.lists?.first { $0.id == id } }

    func saveList(id: String?, name: String, notes: String, expected: Date? = nil) async -> Bool {
        await mutateDocument { document in
            let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !name.isEmpty, name.count <= 80, notes.count <= 2_000 else { throw CustomListError.invalidList }
            var lists = document.lists ?? []
            if let id {
                guard let index = lists.firstIndex(where: { $0.id == id }) else { throw CustomListError.missingList }
                guard lists[index].updatedAt == expected else { throw CustomListError.changed }
                lists[index].name = name
                lists[index].notes = notes
                lists[index].updatedAt = .now
            } else {
                lists.append(CustomWatchList(id: UUID().uuidString, name: name, notes: notes,
                                             createdAt: .now, updatedAt: .now))
            }
            document.lists = lists
        }
    }

    func deleteLists(_ ids: Set<String>) async {
        await mutateDocument { $0.lists?.removeAll { ids.contains($0.id) } }
    }

    func setListMembership(_ included: Bool, titleID: String, listID: String) async {
        await editList(listID) { list, document in
            guard document.entries.contains(where: { $0.id == titleID }) else { throw CustomListError.missingTitle }
            if included {
                if !list.items.contains(where: { $0.titleID == titleID }) {
                    list.items.append(CustomListItem(titleID: titleID))
                }
            } else { list.items.removeAll { $0.titleID == titleID } }
        }
    }

    func setListItemNote(_ notes: String, titleID: String, listID: String, expected: String) async -> Bool {
        await editList(listID) { list, _ in
            guard notes.count <= 2_000 else { throw CustomListError.invalidList }
            guard let index = list.items.firstIndex(where: { $0.titleID == titleID }) else {
                throw CustomListError.missingTitle
            }
            guard list.items[index].notes == expected else { throw CustomListError.changed }
            list.items[index].notes = notes
        }
    }

    func moveListItems(_ listID: String, from: IndexSet, to destination: Int, expected: [String]) async {
        await editList(listID) { list, _ in
            guard list.items.map(\.titleID) == expected else { throw CustomListError.changed }
            let order = try CustomListStrategy().reordered(expected, from: from, to: destination)
            let byID = Dictionary(uniqueKeysWithValues: list.items.map { ($0.titleID, $0) })
            list.items = order.compactMap { byID[$0] }
        }
    }

    @discardableResult
    private func editList(
        _ id: String, change: (inout CustomWatchList, WatchLibraryDocument) throws -> Void
    ) async -> Bool {
        await mutateDocument { document in
            guard var list = document.lists?.first(where: { $0.id == id }),
                  let index = document.lists?.firstIndex(where: { $0.id == id }) else {
                throw CustomListError.missingList
            }
            try change(&list, document)
            list.updatedAt = .now
            document.lists?[index] = list
        }
    }
}
