import Foundation

struct ContinueWatchingItem: Identifiable {
    let entry: WatchEntry
    let nextEpisode: EpisodeRecord?
    var id: String { entry.id }
    var subtitle: String {
        if entry.title.mediaType == .movie { return "Ready to finish?" }
        if let nextEpisode {
            return "Next: S\(nextEpisode.seasonNumber) E\(nextEpisode.episodeNumber)"
        }
        if entry.episodeProgress?.seasons.isEmpty != false { return "Download a season in Episode progress" }
        return "Caught up with downloaded episodes"
    }
    var actionTitle: String? {
        if entry.title.mediaType == .movie { return "Mark watched" }
        return nextEpisode == nil ? nil : "Mark episode watched"
    }
}

protocol ContinueWatchingStrategy {
    func items(from entries: [WatchEntry], now: Date) -> [ContinueWatchingItem]
}

struct ContinueWatchingStrategyImpl: ContinueWatchingStrategy {
    func items(from entries: [WatchEntry], now: Date) -> [ContinueWatchingItem] {
        entries.filter { $0.status == .watching }.sorted {
            $0.updatedAt == $1.updatedAt ? $0.id < $1.id : $0.updatedAt > $1.updatedAt
        }.map {
            ContinueWatchingItem(entry: $0, nextEpisode: $0.episodeProgress?.nextEpisode(on: now))
        }
    }
}
