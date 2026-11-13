import Foundation

protocol WatchLibraryRepository: Sendable {
    func load() async throws -> WatchLibraryDocument
    func save(_ document: WatchLibraryDocument) async throws
}

/// Disk I/O is serialized off the main actor; atomic replacement preserves the last good file on failure.
actor WatchLibraryRepositoryImpl: WatchLibraryRepository {
    private let fileURL: URL

    init(fileURL: URL = URL.applicationSupportDirectory
        .appendingPathComponent("WatchlistLibrary/library.json")) {
        self.fileURL = fileURL
    }

    func load() async throws -> WatchLibraryDocument {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return WatchLibraryDocument() }
        let document = try JSONDecoder().decode(WatchLibraryDocument.self, from: Data(contentsOf: fileURL))
        guard document.version == 1 else { throw WatchLibraryError.unsupportedVersion }
        return document
    }

    func save(_ document: WatchLibraryDocument) async throws {
        try FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true
        )
        try JSONEncoder().encode(document).write(to: fileURL, options: .atomic)
    }
}
