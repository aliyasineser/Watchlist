import Foundation

@MainActor
protocol SavedTitleMetadataService {
    func fetch(_ title: SavedTitle) async throws -> SavedTitle
}

struct SavedTitleMetadataRequest: NetworkRequest {
    let title: SavedTitle
    var path: String { "/\(title.mediaType.rawValue)/\(title.tmdbID)" }
    var requestType: RequestType { .GET }
    var urlParams: [String: String?] {
        ["api_key": APIConstants.apiKey, "language": APIConstants.language]
    }
}

@MainActor
struct SavedTitleMetadataServiceImpl: SavedTitleMetadataService {
    private let requestManager: RequestManager
    init(requestManager: RequestManager = DefaultRequestManager()) { self.requestManager = requestManager }

    func fetch(_ title: SavedTitle) async throws -> SavedTitle {
        let request = SavedTitleMetadataRequest(title: title)
        switch title.mediaType {
        case .movie:
            let movie: MovieDetail = try await requestManager.initRequest(with: request)
            return SavedTitle(media: movie)
        case .tv:
            let series: TvDetail = try await requestManager.initRequest(with: request)
            return SavedTitle(media: series)
        }
    }
}

@MainActor
final class SavedTitleMetadataLoaderImpl {
    private let service: SavedTitleMetadataService
    private let gate = MetadataRequestGate(limit: 2)
    private let now: () -> Date
    private var inFlight: Set<String> = []
    private var failures: [String: Date] = [:]

    init(service: SavedTitleMetadataService, now: @escaping () -> Date = { .now }) {
        self.service = service
        self.now = now
    }

    func resetFailures() { failures.removeAll() }

    func fetchIfNeeded(_ title: SavedTitle) async -> SavedTitle? {
        guard title.posterURL?.isEmpty != false,
              title.metadataFetchedAt.map({ now().timeIntervalSince($0) >= 86_400 }) ?? true,
              failures[title.id].map({ now().timeIntervalSince($0) >= 60 }) ?? true,
              inFlight.insert(title.id).inserted else { return nil }
        defer { inFlight.remove(title.id) }
        do {
            try await gate.acquire()
            defer { gate.release() }
            try Task.checkCancellation()
            var result = try await service.fetch(title)
            try Task.checkCancellation()
            guard result.id == title.id else { throw URLError(.badServerResponse) }
            result.metadataFetchedAt = now()
            failures[title.id] = nil
            return result
        } catch is CancellationError {
            return nil
        } catch {
            if !Task.isCancelled { failures[title.id] = now() }
            return nil
        }
    }
}

/// Waiters suspend rather than polling, and cancelled offscreen cards leave the queue.
@MainActor
private final class MetadataRequestGate {
    private var available: Int
    private var waiters: [(UUID, CheckedContinuation<Void, Error>)] = []

    init(limit: Int) { available = limit }

    func acquire() async throws {
        try Task.checkCancellation()
        if available > 0 { available -= 1; return }
        let id = UUID()
        try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { continuation in
                if Task.isCancelled { continuation.resume(throwing: CancellationError()) } else {
                    waiters.append((id, continuation))
                }
            }
        } onCancel: {
            Task { @MainActor in self.cancel(id) }
        }
    }

    func release() {
        if waiters.isEmpty { available += 1 } else { waiters.removeFirst().1.resume() }
    }

    private func cancel(_ id: UUID) {
        guard let index = waiters.firstIndex(where: { $0.0 == id }) else { return }
        waiters.remove(at: index).1.resume(throwing: CancellationError())
    }
}
