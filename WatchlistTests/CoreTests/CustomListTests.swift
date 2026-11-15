import XCTest
@testable import Watchlist

@MainActor
final class CustomListTests: XCTestCase {
    func testMembershipNotesAndManualOrderPersistAcrossReload() async throws {
        let repository = ListsRepository()
        let store = makeStore(repository)
        await store.load()
        let created = await store.saveList(id: nil, name: "  Weekend  ", notes: "With friends")
        XCTAssertTrue(created)
        let listID = try XCTUnwrap(store.customLists.first?.id)
        XCTAssertEqual(store.customLists.first?.name, "Weekend")
        XCTAssertEqual(store.document.version, 2)
        for id in ["movie-1", "tv-1", "movie-2", "movie-1"] {
            await store.setListMembership(true, titleID: id, listID: listID)
        }
        XCTAssertEqual(store.customList(listID)?.items.count, 3)
        _ = await store.setListItemNote("Watch together", titleID: "movie-1", listID: listID, expected: "")
        await store.moveListItems(listID, from: IndexSet(integer: 0), to: 3,
                                  expected: ["movie-1", "tv-1", "movie-2"])
        let reloaded = makeStore(repository)
        await reloaded.load()
        XCTAssertEqual(reloaded.customList(listID)?.items.map(\.titleID), ["tv-1", "movie-2", "movie-1"])
        XCTAssertEqual(reloaded.customList(listID)?.items.last?.notes, "Watch together")
        let decoded = try LibraryBackupCodec.decode(LibraryBackupCodec.encode(reloaded.document))
        XCTAssertEqual(decoded.lists, reloaded.document.lists)
    }

    func testTitleCanBelongToMultipleListsAndLibraryRemovalCleansBoth() async throws {
        let store = makeStore(ListsRepository())
        await store.load()
        for name in ["Friends", "Sci-fi"] { _ = await store.saveList(id: nil, name: name, notes: "") }
        let listIDs = store.customLists.map(\.id)
        for id in listIDs { await store.setListMembership(true, titleID: "movie-1", listID: id) }
        XCTAssertEqual(store.customLists.filter { !$0.items.isEmpty }.count, 2)
        let movie = try XCTUnwrap(store.entries.first { $0.id == "movie-1" })
        await store.remove(movie.title)
        XCTAssertTrue(store.customLists.allSatisfy { $0.items.isEmpty })
        await store.deleteLists(Set(listIDs))
        XCTAssertEqual(store.entries.count, 2)
        XCTAssertTrue(store.customLists.isEmpty)
        XCTAssertEqual(store.document.deletedLists?.count, 2)
    }

    func testInvalidAndStaleChangesAndFailedSavePreserveLists() async throws {
        let repository = ListsRepository()
        let store = makeStore(repository)
        await store.load()
        let invalid = await store.saveList(id: nil, name: "  ", notes: "")
        XCTAssertFalse(invalid)
        _ = await store.saveList(id: nil, name: "Queue", notes: "")
        let original = try XCTUnwrap(store.customLists.first)
        let stale = await store.saveList(id: original.id, name: "Changed", notes: "", expected: .distantPast)
        XCTAssertFalse(stale)
        await store.setListMembership(true, titleID: "missing", listID: original.id)
        XCTAssertTrue(store.customLists[0].items.isEmpty)
        await repository.failSaves()
        await store.setListMembership(true, titleID: "movie-1", listID: original.id)
        XCTAssertEqual(store.customLists[0], original)
        XCTAssertNotNil(store.error)
    }

    func testMergePreservesListsAndDeletionAndOldDocumentsRemainReadable() throws {
        let title = ListsRepository.title(1, type: .movie)
        let entry = WatchEntry(title: title, status: .watching, addedAt: .distantPast, updatedAt: .now)
        let list = CustomWatchList(
            id: UUID().uuidString, name: "Queue", notes: "", items: [CustomListItem(titleID: title.id)],
            createdAt: .distantPast, updatedAt: Date(timeIntervalSince1970: 10)
        )
        let local = WatchLibraryDocument(version: 2, importedFavorites: true, entries: [entry], lists: [list])
        var deleted = WatchLibraryDocument(version: 2, importedFavorites: true, entries: [entry], lists: [])
        deleted.deletedLists = [list.id: Date(timeIntervalSince1970: 20)]
        let strategy = LibraryMergeStrategyImpl()
        XCTAssertTrue(strategy.merge(local, deleted).lists?.isEmpty == true)
        XCTAssertEqual(strategy.merge(local, deleted), strategy.merge(deleted, local))
        let old = WatchLibraryDocument(importedFavorites: true, entries: [entry])
        XCTAssertNil(try LibraryBackupCodec.decode(LibraryBackupCodec.encode(old)).lists)
        XCTAssertEqual(strategy.merge(old, local).lists?.first?.items.first?.titleID, title.id)
    }

    func testMoveHandlesMultipleIndicesAndRejectsInvalidOffsets() throws {
        let strategy = CustomListStrategy()
        XCTAssertEqual(try strategy.reordered(["a", "b", "c", "d"], from: IndexSet([0, 2]), to: 4),
                       ["b", "d", "a", "c"])
        XCTAssertThrowsError(try strategy.reordered(["a"], from: IndexSet(integer: 2), to: 0))
    }

    private func makeStore(_ repository: ListsRepository) -> WatchLibraryStoreImpl {
        WatchLibraryStoreImpl(repository: repository, artwork: ListsArtwork())
    }
}

private actor ListsRepository: WatchLibraryRepository {
    private var document = WatchLibraryDocument(importedFavorites: true, entries: [
        WatchEntry(title: ListsRepository.title(1, type: .movie), status: .wantToWatch,
                   addedAt: .distantPast, updatedAt: .distantPast),
        WatchEntry(title: ListsRepository.title(1, type: .tv), status: .wantToWatch,
                   addedAt: .distantPast, updatedAt: .distantPast),
        WatchEntry(title: ListsRepository.title(2, type: .movie), status: .wantToWatch,
                   addedAt: .distantPast, updatedAt: .distantPast)
    ])
    private var fail = false
    static func title(_ id: Int, type: MediaType) -> SavedTitle {
        SavedTitle(tmdbID: id, mediaType: type, title: "Title \(id)")
    }
    func load() async throws -> WatchLibraryDocument { document }
    func failSaves() { fail = true }
    func save(_ document: WatchLibraryDocument) async throws {
        if fail { throw CocoaError(.fileWriteNoPermission) }
        self.document = document
    }
}

private struct ListsArtwork: ArtworkCache {
    func localURL(for id: String) -> URL? { nil }
    func cache(remoteURL: URL, id: String) async throws { }
    func remove(id: String) async { }
}
