import Foundation

protocol ArtworkCache: Sendable {
    func localURL(for id: String) -> URL?
    func cache(remoteURL: URL, id: String) async throws
    func remove(id: String) async
}

actor ArtworkCacheImpl: ArtworkCache {
    private nonisolated let directory: URL
    private let session: URLSession

    init(
        directory: URL = URL.applicationSupportDirectory.appendingPathComponent("WatchlistArtwork"),
        session: URLSession = .shared
    ) {
        self.directory = directory
        self.session = session
    }

    nonisolated func localURL(for id: String) -> URL? {
        let url = directory.appendingPathComponent(id + ".image")
        return FileManager.default.fileExists(atPath: url.path) ? url : nil
    }

    func cache(remoteURL: URL, id: String) async throws {
        guard remoteURL.scheme == "https", remoteURL.host == "image.tmdb.org" else { return }
        guard localURL(for: id) == nil else { return }
        let request = URLRequest(url: remoteURL, timeoutInterval: 15)
        let (data, response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse,
              (200..<300).contains(response.statusCode),
              response.mimeType?.hasPrefix("image/") == true,
              !data.isEmpty, data.count <= 8_000_000 else { throw URLError(.badServerResponse) }
        try Task.checkCancellation()
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        try data.write(to: directory.appendingPathComponent(id + ".image"), options: .atomic)
    }

    func remove(id: String) async {
        if let url = localURL(for: id) { try? FileManager.default.removeItem(at: url) }
    }
}
