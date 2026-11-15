import XCTest
@testable import Watchlist

@MainActor
final class LibraryTransferTests: XCTestCase {
    func testLatestEditsAndDeletionsConverge() throws {
        let old = entry(status: .watching, time: 10)
        let latest = entry(status: .watched, time: 20)
        let local = WatchLibraryDocument(importedFavorites: true, entries: [old])
        let remote = WatchLibraryDocument(importedFavorites: true, entries: [latest])
        let strategy = LibraryMergeStrategyImpl()
        XCTAssertEqual(strategy.merge(local, remote).entries.first?.status, .watched)
        XCTAssertEqual(strategy.merge(local, remote), strategy.merge(remote, local))
        var deletion = WatchLibraryDocument(importedFavorites: true)
        deletion.deletedTitles = [old.id: Date(timeIntervalSince1970: 30)]
        XCTAssertTrue(strategy.merge(remote, deletion).entries.isEmpty)
        let readded = WatchLibraryDocument(entries: [entry(status: .watching, time: 40)])
        XCTAssertEqual(strategy.merge(readded, deletion).entries.count, 1)
    }

    func testEqualTimestampMergeIsDeterministicAndKeepsNewestMetadata() {
        var left = entry(status: .watching, time: 10)
        var right = entry(status: .watched, time: 10)
        left.title.posterURL = "https://image.tmdb.org/new.jpg"
        left.title.metadataFetchedAt = Date(timeIntervalSince1970: 20)
        right.title.metadataFetchedAt = Date(timeIntervalSince1970: 15)
        let strategy = LibraryMergeStrategyImpl()
        let first = strategy.merge(.init(entries: [left]), .init(entries: [right]))
        let second = strategy.merge(.init(entries: [right]), .init(entries: [left]))
        XCTAssertEqual(first, second)
        XCTAssertEqual(first.entries.first?.title.posterURL, left.title.posterURL)
    }

    func testBackupRoundTripAndValidation() throws {
        let document = WatchLibraryDocument(importedFavorites: true, entries: [entry(status: .watched, time: 20)])
        XCTAssertEqual(try LibraryBackupCodec.decode(LibraryBackupCodec.encode(document)), document)
        var duplicate = document
        duplicate.entries.append(duplicate.entries[0])
        XCTAssertThrowsError(try LibraryBackupCodec.decode(LibraryBackupCodec.encode(duplicate)))
        var future = document
        future.version = 2
        XCTAssertThrowsError(try LibraryBackupCodec.decode(LibraryBackupCodec.encode(future)))
        XCTAssertThrowsError(try LibraryBackupCodec.decode(Data("invalid".utf8)))
    }

    func testStaleSyncSnapshotCannotOverwriteNewLocalEdit() async {
        let store = WatchLibraryStoreImpl(repository: TransferRepository(), artwork: TransferArtwork())
        await store.load()
        let title = entry(status: .watching, time: 10).title
        await store.setStatus(.watching, for: title)
        let original = store.document
        await store.setStatus(.watched, for: title)
        let installed = await store.installDocument(original, expected: original)
        XCTAssertFalse(installed)
        XCTAssertEqual(store.entry(for: title)?.status, .watched)
        await store.remove(title)
        XCTAssertNotNil(store.document.deletedTitles?[title.id])
    }

    func testImportUsesConfirmedSnapshotAfterDialogDismissal() async throws {
        let store = WatchLibraryStoreImpl(repository: TransferRepository(), artwork: TransferArtwork())
        await store.load()
        let defaults = UserDefaults(suiteName: "TransferImportTests") ?? .standard
        defaults.removePersistentDomain(forName: "TransferImportTests")
        let presenter = LibraryTransferPresenterImpl(store: store, cloud: TransferCloudMock(), preferences: defaults)
        let backup = WatchLibraryDocument(importedFavorites: true, entries: [entry(status: .watched, time: 20)])
        presenter.importPreview = backup
        let confirmed = try XCTUnwrap(presenter.importPreview)
        presenter.importPreview = nil
        await presenter.mergeImport(confirmed)
        XCTAssertEqual(store.entries.first?.status, .watched)
    }

    private func entry(status: WatchStatus, time: TimeInterval) -> WatchEntry {
        WatchEntry(title: SavedTitle(tmdbID: 1, mediaType: .movie, title: "Movie"), status: status,
                   addedAt: Date(timeIntervalSince1970: 1), updatedAt: Date(timeIntervalSince1970: time))
    }
}

private actor TransferRepository: WatchLibraryRepository {
    private var document = WatchLibraryDocument(importedFavorites: true)
    func load() async throws -> WatchLibraryDocument { document }
    func save(_ document: WatchLibraryDocument) async throws { self.document = document }
}

private struct TransferArtwork: ArtworkCache {
    func localURL(for id: String) -> URL? { nil }
    func cache(remoteURL: URL, id: String) async throws { }
    func remove(id: String) async { }
}

private struct TransferCloudMock: LibraryCloudService {
    func exchange(_ local: WatchLibraryDocument) async throws -> WatchLibraryDocument { local }
}
