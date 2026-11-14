import Foundation

struct WatchTonightFilter {
    var genre: String?
    var maximumMinutes: Int?
    var mediaType: MediaType?
}

protocol WatchSuggestionStrategy {
    func matches(entries: [WatchEntry], filter: WatchTonightFilter) -> [WatchEntry]
    func reason(for entry: WatchEntry) -> String
}

/// Prioritize the oldest saved unwatched titles, so the queue keeps moving.
struct WatchSuggestionStrategyImpl: WatchSuggestionStrategy {
    func matches(entries: [WatchEntry], filter: WatchTonightFilter) -> [WatchEntry] {
        entries.filter { entry in
            guard entry.status != .watched else { return false }
            if let type = filter.mediaType, entry.title.mediaType != type { return false }
            if let genre = filter.genre, !(entry.title.genreNames ?? []).contains(genre) { return false }
            if let limit = filter.maximumMinutes {
                guard let runtime = entry.title.runtimeMinutes, runtime > 0, runtime <= limit else { return false }
            }
            return true
        }.sorted {
            $0.addedAt == $1.addedAt ? $0.id < $1.id : $0.addedAt < $1.addedAt
        }
    }

    func reason(for entry: WatchEntry) -> String {
        var parts = [entry.status == .watching ? "Continue watching" : "From your watchlist"]
        if let runtime = entry.title.runtimeMinutes, runtime > 0 {
            parts.append(entry.title.mediaType == .tv ? "About \(runtime) min per episode" : "\(runtime) min")
        }
        if let genre = entry.title.genreNames?.first { parts.append(genre) }
        return parts.joined(separator: " · ")
    }
}
