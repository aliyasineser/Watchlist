import Foundation
import Observation

@MainActor
@Observable
final class ReleaseRemindersImpl {
    static let shared = ReleaseRemindersImpl(scheduler: ReleaseNotificationSchedulerImpl())
    private(set) var enabled: Bool { didSet { defaults.set(enabled, forKey: "reminders.enabled") } }
    var hideTitles: Bool { didSet { defaults.set(hideTitles, forKey: "reminders.hideTitles") } }
    private(set) var isUpdating = false
    var error: Error?
    private let scheduler: ReleaseNotificationScheduler
    private let cache: ReleaseCacheImpl
    private let defaults: UserDefaults
    private var updateAgain = false
    private var permissionGeneration = 0

    init(scheduler: ReleaseNotificationScheduler, cache: ReleaseCacheImpl = .shared,
         defaults: UserDefaults = .standard) {
        self.scheduler = scheduler
        self.cache = cache
        self.defaults = defaults
        enabled = defaults.bool(forKey: "reminders.enabled")
        hideTitles = defaults.object(forKey: "reminders.hideTitles") == nil ||
            defaults.bool(forKey: "reminders.hideTitles")
    }
    func setEnabled(_ value: Bool, store: WatchLibraryStoreImpl) async {
        permissionGeneration += 1
        let token = permissionGeneration
        error = nil
        if !value { enabled = false; await scheduler.cancel(); return }
        do {
            let allowed = try await scheduler.authorize()
            guard token == permissionGeneration else { return }
            guard allowed else { throw ReleaseReminderError.permissionDenied }
            enabled = true
            await reconcile(store: store)
        } catch {
            if token == permissionGeneration { enabled = false; self.error = error }
        }
    }
    func reconcile(store: WatchLibraryStoreImpl) async {
        guard enabled, store.isLoaded else { return }
        if isUpdating { updateAgain = true; return }
        isUpdating = true
        defer { isUpdating = false }
        repeat {
            updateAgain = false
            let revision = store.revision
            var events: [ReleaseEvent] = []
            for entry in store.entries where entry.followsReleases == true {
                if let cached = await cache.load(entry.id) { events += cached.events }
            }
            if store.revision != revision { updateAgain = true; continue }
            guard enabled else { await scheduler.cancel(); return }
            do {
                try await scheduler.replace(events: events, hideTitles: hideTitles)
                error = nil
            } catch { self.error = error }
            if !enabled { await scheduler.cancel() }
        } while updateAgain && enabled
    }
}
