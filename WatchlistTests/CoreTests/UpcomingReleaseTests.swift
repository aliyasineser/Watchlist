import XCTest
@testable import Watchlist

@MainActor
final class UpcomingReleaseTests: XCTestCase {
    func testPlannerRejectsUnknownPastDistantAndDuplicateDates() throws {
        let now = try XCTUnwrap(ReleaseEvent.formatter().date(from: "2026-11-14"))
        let events = [event("1", date: "2026-11-15"), event("1", date: "2026-11-15"),
                      event("2", date: "2026-11-01"), event("3", date: "2027-11-01"),
                      event("4", date: "2026-02-31"), event("5", date: "invalid")]
        XCTAssertEqual(ReleasePlanner().upcoming(events, now: now).map(\.id), ["1"])
        let plans = ReleasePlanner().reminderPlans((1...80).map { event("\($0)", date: "2026-11-15") }, now: now)
        XCTAssertEqual(plans.count, 48)
        XCTAssertTrue(ReleasePlanner().reminderPlans(events, limit: 0, now: now).isEmpty)
    }

    func testReminderUsesNineAMInUsersTimeZoneAndSkipsPastTrigger() throws {
        let zone = try XCTUnwrap(TimeZone(identifier: "Europe/Berlin"))
        let now = try XCTUnwrap(ReleaseEvent.formatter().date(from: "2026-11-14"))
        let date = try XCTUnwrap(ReleasePlanner().reminderDate(for: event("1", date: "2026-11-15"),
                                                             now: now, timeZone: zone))
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = zone
        XCTAssertEqual(calendar.component(.hour, from: date), 9)
        XCTAssertEqual(calendar.component(.day, from: date), 15)
        XCTAssertNil(ReleasePlanner().reminderDate(for: event("1", date: "2026-11-15"),
                                                  now: date.addingTimeInterval(1), timeZone: zone))
    }

    func testReleaseServiceDecodesMovieAndSpoilerFreeTVEvent() async throws {
        let movieData = Data(#"{"release_date":"2026-12-01"}"#.utf8)
        let movieService = ReleaseCalendarServiceImpl(manager: DefaultRequestManager(
            apiManager: ReleaseAPIStub(data: movieData)
        ))
        let movie = SavedTitle(tmdbID: 1, mediaType: .movie, title: "Movie")
        let movies = try await movieService.events(for: movie)
        XCTAssertEqual(movies.first?.dateISO, "2026-12-01")
        let tvData = Data("""
        {"next_episode_to_air":{"season_number":2,"episode_number":3,"name":"Plot spoiler",
        "air_date":"2026-12-02"}}
        """.utf8)
        let tvService = ReleaseCalendarServiceImpl(
            manager: DefaultRequestManager(apiManager: ReleaseAPIStub(data: tvData))
        )
        let series = SavedTitle(tmdbID: 1, mediaType: .tv, title: "Show")
        let episodes = try await tvService.events(for: series)
        XCTAssertEqual(episodes.first?.label, "S2 E3")
        XCTAssertEqual(episodes.first?.id, "tv-1-2-3")
    }

    func testRemindersRequireOptInAndRemoveUnfollowedTitles() async throws {
        let context = try await context()
        defer { try? FileManager.default.removeItem(at: context.directory) }
        let title = context.store.entries[0].title
        try await context.cache.save(ReleaseCacheEntry(events: [futureEvent(titleID: title.id)], fetchedAt: .now),
                                     id: title.id)
        await context.reminders.reconcile(store: context.store)
        XCTAssertEqual(context.scheduler.authorizationCalls, 0)
        XCTAssertTrue(context.scheduler.events.isEmpty)
        context.scheduler.permission = false
        await context.reminders.setEnabled(true, store: context.store)
        XCTAssertFalse(context.reminders.enabled)
        XCTAssertNotNil(context.reminders.error)
        context.scheduler.permission = true
        await context.reminders.setEnabled(true, store: context.store)
        XCTAssertEqual(context.scheduler.events.count, 1)
        XCTAssertTrue(context.scheduler.hideTitles)
        await context.store.setReleaseFollowing(false, for: title)
        await context.reminders.reconcile(store: context.store)
        XCTAssertTrue(context.scheduler.events.isEmpty)
        await context.reminders.setEnabled(false, store: context.store)
        XCTAssertGreaterThan(context.scheduler.cancellations, 0)
    }

    func testUpcomingUsesCachedEventsOfflineAndPreservesFollowingThroughBackup() async throws {
        let context = try await context()
        defer { try? FileManager.default.removeItem(at: context.directory) }
        let title = context.store.entries[0].title
        try await context.cache.save(ReleaseCacheEntry(events: [futureEvent(titleID: title.id)],
                                                      fetchedAt: .distantPast), id: title.id)
        let presenter = UpcomingPresenterImpl(store: context.store, service: OfflineReleaseService(),
                                             cache: context.cache, reminders: context.reminders)
        await presenter.reset()
        XCTAssertEqual(presenter.events.count, 1)
        XCTAssertTrue(presenter.hasStaleData)
        let document = try LibraryBackupCodec.decode(LibraryBackupCodec.encode(context.store.document))
        XCTAssertEqual(document.entries.first?.followsReleases, true)
    }

    private func event(_ id: String, date: String) -> ReleaseEvent {
        ReleaseEvent(id: id, titleID: "movie-1", title: "Title", dateISO: date, label: "Movie release")
    }
    private func futureEvent(titleID: String) -> ReleaseEvent {
        let date = Date.now.addingTimeInterval(86_400 * 5)
        return ReleaseEvent(id: titleID + "-release", titleID: titleID, title: "Movie",
                            dateISO: ReleaseEvent.formatter().string(from: date), label: "Movie release")
    }
    private func context() async throws -> ReleaseTestContext {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let cache = ReleaseCacheImpl(url: directory.appendingPathComponent("cache.json"))
        let defaults = UserDefaults(suiteName: "ReleaseTests") ?? .standard
        defaults.removePersistentDomain(forName: "ReleaseTests")
        let scheduler = ReleaseSchedulerMock()
        let reminders = ReleaseRemindersImpl(scheduler: scheduler, cache: cache, defaults: defaults)
        let store = WatchLibraryStoreImpl(repository: ReleaseRepository(), artwork: ReleaseArtwork())
        await store.load()
        return ReleaseTestContext(directory: directory, cache: cache, scheduler: scheduler,
                                  reminders: reminders, store: store)
    }
}

@MainActor
private struct ReleaseTestContext {
    let directory: URL
    let cache: ReleaseCacheImpl
    let scheduler: ReleaseSchedulerMock
    let reminders: ReleaseRemindersImpl
    let store: WatchLibraryStoreImpl
}

@MainActor
private final class ReleaseSchedulerMock: ReleaseNotificationScheduler {
    var permission = true
    var authorizationCalls = 0
    var cancellations = 0
    var events: [ReleaseEvent] = []
    var hideTitles = false
    func authorize() async throws -> Bool { authorizationCalls += 1; return permission }
    func replace(events: [ReleaseEvent], hideTitles: Bool) async throws {
        self.events = events
        self.hideTitles = hideTitles
    }
    func cancel() async { cancellations += 1; events = [] }
}

private struct ReleaseAPIStub: APIManager {
    let data: Data
    func initRequest(with request: NetworkRequest) async throws -> Data { data }
}

@MainActor
private struct OfflineReleaseService: ReleaseCalendarService {
    func events(for title: SavedTitle) async throws -> [ReleaseEvent] { throw URLError(.notConnectedToInternet) }
}

private actor ReleaseRepository: WatchLibraryRepository {
    private var document: WatchLibraryDocument = {
        var entry = WatchEntry(title: SavedTitle(tmdbID: 1, mediaType: .movie, title: "Movie"), status: .wantToWatch,
                               addedAt: .now, updatedAt: .now)
        entry.followsReleases = true
        return WatchLibraryDocument(importedFavorites: true, entries: [entry])
    }()
    func load() async throws -> WatchLibraryDocument { document }
    func save(_ document: WatchLibraryDocument) async throws { self.document = document }
}

private struct ReleaseArtwork: ArtworkCache {
    func localURL(for id: String) -> URL? { nil }
    func cache(remoteURL: URL, id: String) async throws { }
    func remove(id: String) async { }
}
