import Foundation

extension WatchLibraryStoreImpl {
    func setReleaseFollowing(_ enabled: Bool, for title: SavedTitle) async {
        await mutate { entries in
            guard let index = entries.firstIndex(where: { $0.id == title.id }) else {
                throw EpisodeProgressError.unavailable
            }
            entries[index].followsReleases = enabled
            entries[index].updatedAt = .now
        }
    }
}
