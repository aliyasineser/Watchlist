import Foundation
import Observation

@MainActor
@Observable
final class WatchLibraryStoreImpl {
    static let shared = WatchLibraryStoreImpl(
        repository: WatchLibraryRepositoryImpl(), artwork: ArtworkCacheImpl(),
        importFavorites: {
            let movies = try FavoriteMovieStorage.shared.fetchMovies().map {
                SavedTitle(tmdbID: Int($0.id), mediaType: .movie, title: $0.name ?? "Untitled")
            }
            let series = try FavoriteTVSerieStorage.shared.fetchSeries().map {
                SavedTitle(tmdbID: Int($0.id), mediaType: .tv, title: $0.name ?? "Untitled")
            }
            return movies + series
        }
    )

    private(set) var entries: [WatchEntry] = []
    private(set) var isLoading = false
    private(set) var isLoaded = false
    private(set) var isSaving = false
    private(set) var artworkRevision = 0
    var error: Error?
    private var document = WatchLibraryDocument()
    private let repository: WatchLibraryRepository
    private let artwork: ArtworkCache
    private let importFavorites: () throws -> [SavedTitle]

    init(
        repository: WatchLibraryRepository, artwork: ArtworkCache,
        importFavorites: @escaping () throws -> [SavedTitle] = { [] }
    ) {
        self.repository = repository
        self.artwork = artwork
        self.importFavorites = importFavorites
    }

    func load() async {
        guard !isLoaded, !isLoading else { return }
        isLoading = true
        error = nil
        defer { isLoading = false }
        do {
            var loaded = try await repository.load()
            if !loaded.importedFavorites {
                var identifiers = Set(loaded.entries.map(\.id))
                for title in try importFavorites() where identifiers.insert(title.id).inserted {
                    loaded.entries.append(WatchEntry(
                        title: title, status: .wantToWatch, addedAt: .now, updatedAt: .now
                    ))
                }
                loaded.importedFavorites = true
                try await repository.save(loaded)
            }
            document = loaded
            entries = loaded.entries
            isLoaded = true
            retryArtwork()
        } catch {
            self.error = error
        }
    }

    func entry(for title: SavedTitle) -> WatchEntry? { entries.first { $0.id == title.id } }

    func setStatus(_ status: WatchStatus, for title: SavedTitle) async {
        await mutate { entries in
            if let index = entries.firstIndex(where: { $0.id == title.id }) {
                entries[index].status = status
                entries[index].title = title
                entries[index].updatedAt = .now
            } else {
                entries.append(WatchEntry(title: title, status: status, addedAt: .now, updatedAt: .now))
            }
        }
        if entry(for: title) != nil { cacheArtwork(title) }
    }

    func setRating(_ rating: Int?, for title: SavedTitle) async {
        await mutate { entries in
            if let rating, !(1...10).contains(rating) { throw WatchLibraryError.invalidRating }
            guard let index = entries.firstIndex(where: { $0.id == title.id }) else {
                throw WatchLibraryError.unavailable
            }
            entries[index].personalRating = rating
            entries[index].updatedAt = .now
        }
    }

    func refreshMetadata(_ title: SavedTitle) async {
        guard let existing = entry(for: title), existing.title != title else { return }
        await mutate { entries in
            guard let index = entries.firstIndex(where: { $0.id == title.id }) else { return }
            entries[index].title = title
        }
        cacheArtwork(title)
    }

    func remove(_ title: SavedTitle) async {
        await mutate { $0.removeAll { $0.id == title.id } }
        if entry(for: title) == nil { await artwork.remove(id: title.id) }
    }

    func artworkURL(for title: SavedTitle) -> String {
        _ = artworkRevision
        return artwork.localURL(for: title.id)?.absoluteString ?? title.posterURL ?? ""
    }

    func retryArtwork() {
        for entry in entries { cacheArtwork(entry.title) }
    }

    func filtered(status: WatchStatus?, type: MediaType?, sort: LibrarySort) -> [WatchEntry] {
        let filtered = entries.filter { entry in
            (status == nil || entry.status == status) && (type == nil || entry.title.mediaType == type)
        }
        return filtered.sorted { lhs, rhs in
            switch sort {
            case .dateAdded:
                return lhs.addedAt == rhs.addedAt ? lhs.id < rhs.id : lhs.addedAt > rhs.addedAt
            case .title:
                let comparison = lhs.title.title.localizedCaseInsensitiveCompare(rhs.title.title)
                return comparison == .orderedSame ? lhs.id < rhs.id : comparison == .orderedAscending
            case .rating:
                let left = lhs.personalRating ?? 0
                let right = rhs.personalRating ?? 0
                return left == right ? lhs.id < rhs.id : left > right
            }
        }
    }

    @discardableResult
    func mutate(_ change: (inout [WatchEntry]) throws -> Void) async -> Bool {
        guard isLoaded else { error = WatchLibraryError.unavailable; return false }
        guard !isSaving else { error = WatchLibraryError.busy; return false }
        isSaving = true
        error = nil
        defer { isSaving = false }
        do {
            var updated = document
            try change(&updated.entries)
            try await repository.save(updated)
            document = updated
            entries = updated.entries
            return true
        } catch {
            self.error = error
            return false
        }
    }

    private func cacheArtwork(_ title: SavedTitle) {
        guard let string = title.posterURL, let url = URL(string: string) else { return }
        Task {
            do {
                try await artwork.cache(remoteURL: url, id: title.id)
                if entry(for: title) == nil { await artwork.remove(id: title.id) }
                artworkRevision += 1
            } catch {
                // Artwork is best effort. Metadata and watch status remain saved and usable offline.
            }
        }
    }
}
