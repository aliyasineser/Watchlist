import Foundation

struct ReleaseEvent: Codable, Identifiable, Equatable, Sendable {
    let id: String
    let titleID: String
    let title: String
    let dateISO: String
    let label: String

    var date: Date? {
        let formatter = Self.formatter()
        guard let value = formatter.date(from: dateISO), formatter.string(from: value) == dateISO else { return nil }
        return value
    }
    static func formatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.isLenient = false
        return formatter
    }
}

struct ReleasePlanner {
    func upcoming(_ events: [ReleaseEvent], now: Date = .now) -> [ReleaseEvent] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0) ?? .gmt
        let start = calendar.startOfDay(for: now)
        let end = calendar.date(byAdding: .day, value: 90, to: start) ?? start
        var seen = Set<String>()
        return events.filter {
            guard let date = $0.date else { return false }
            return date >= start && date <= end && seen.insert($0.id).inserted
        }.sorted { $0.dateISO == $1.dateISO ? $0.id < $1.id : $0.dateISO < $1.dateISO }
    }

    func reminderPlans(
        _ events: [ReleaseEvent], limit: Int = 48, now: Date = .now, timeZone: TimeZone = .current
    ) -> [(ReleaseEvent, Date)] {
        Array(upcoming(events, now: now).compactMap { event in
            reminderDate(for: event, now: now, timeZone: timeZone).map { (event, $0) }
        }.prefix(min(48, max(0, limit))))
    }

    func reminderDate(for event: ReleaseEvent, now: Date = .now, timeZone: TimeZone = .current) -> Date? {
        guard event.date != nil else { return nil }
        let parts = event.dateISO.split(separator: "-").compactMap { Int($0) }
        guard parts.count == 3 else { return nil }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        let components = DateComponents(timeZone: timeZone, year: parts[0], month: parts[1], day: parts[2], hour: 9)
        guard let date = calendar.date(from: components), date > now else { return nil }
        return date
    }
}

enum ReleaseReminderError: LocalizedError {
    case permissionDenied
    var errorDescription: String? {
        "Notifications are disabled for Watchlist. Enable them in iOS Settings to receive release reminders."
    }
}
