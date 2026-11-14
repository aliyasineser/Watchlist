import Foundation
import UserNotifications

@MainActor
protocol ReleaseNotificationScheduler {
    func authorize() async throws -> Bool
    func replace(events: [ReleaseEvent], hideTitles: Bool) async throws
    func cancel() async
}

@MainActor
struct ReleaseNotificationSchedulerImpl: ReleaseNotificationScheduler {
    private let center = UNUserNotificationCenter.current()
    private let prefix = "watchlist.release."
    func authorize() async throws -> Bool {
        try await center.requestAuthorization(options: [.alert, .sound])
    }
    func cancel() async {
        let pending = await center.pendingNotificationRequests()
        center.removePendingNotificationRequests(withIdentifiers: pending.filter { $0.identifier.hasPrefix(prefix) }
            .map(\.identifier))
    }
    func replace(events: [ReleaseEvent], hideTitles: Bool) async throws {
        let settings = await center.notificationSettings()
        guard settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional else {
            await cancel()
            throw ReleaseReminderError.permissionDenied
        }
        let pending = await center.pendingNotificationRequests()
        let otherCount = pending.filter { !$0.identifier.hasPrefix(prefix) }.count
        await cancel()
        let limit = min(48, max(0, 64 - otherCount))
        let future = ReleasePlanner().reminderPlans(events, limit: limit)
        for (event, date) in future {
            try Task.checkCancellation()
            let content = UNMutableNotificationContent()
            content.title = hideTitles ? "A release you follow is coming up" : event.title
            content.body = "A catalog release is listed for today. Open Watchlist to check the details."
            content.sound = .default
            var calendar = Calendar(identifier: .gregorian)
            calendar.timeZone = .current
            var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
            components.calendar = calendar
            components.timeZone = .current
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: prefix + event.id, content: content, trigger: trigger)
            try await center.add(request)
        }
    }
}
