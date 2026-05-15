import Foundation

/// Month math centralized so dashboards, summaries, and Phase 4 budgets all
/// agree on what "this month" means. Honours the user's preferred month start
/// day (defaults to 1) so future "sahod-aligned" budgets can flip it.
enum MonthHelpers {
    static let monthStartDayKey = "ph.kuwenta.settings.monthStartDay"

    static var monthStartDay: Int {
        let stored = UserDefaults.standard.integer(forKey: monthStartDayKey)
        return stored == 0 ? 1 : stored
    }

    static func currentMonthInterval(now: Date = Date(), calendar: Calendar = .current) -> (start: Date, end: Date) {
        var startComponents = calendar.dateComponents([.year, .month], from: now)
        startComponents.day = monthStartDay

        let candidateStart = calendar.date(from: startComponents) ?? now
        let start: Date
        if candidateStart > now {
            // Today is before this month's pay-period boundary, so we're
            // still inside last month's window.
            start = calendar.date(byAdding: .month, value: -1, to: candidateStart) ?? candidateStart
        } else {
            start = candidateStart
        }
        let end = calendar.date(byAdding: .month, value: 1, to: start) ?? now
        return (start, end)
    }

    static func friendlyMonthLabel(now: Date = Date(), calendar: Calendar = .current) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: now)
    }
}
