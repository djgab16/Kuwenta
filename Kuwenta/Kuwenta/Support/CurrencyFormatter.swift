import Foundation

/// PHP currency formatter, sensitive to the user's current locale for digit
/// grouping but always pinned to peso for symbol/code.
enum CurrencyFormatter {
    static let php: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "PHP"
        formatter.currencySymbol = "₱"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter
    }()

    static func string(from amount: Decimal) -> String {
        php.string(from: amount as NSDecimalNumber) ?? "₱0"
    }

    /// Compact form for chips: "₱1.2k", "₱58k", "₱1.5M".
    static func compact(_ amount: Decimal) -> String {
        let value = NSDecimalNumber(decimal: amount).doubleValue
        let absValue = abs(value)
        if absValue >= 1_000_000 {
            return String(format: "₱%.1fM", value / 1_000_000)
        } else if absValue >= 1_000 {
            return String(format: "₱%.1fk", value / 1_000)
        } else {
            return string(from: amount)
        }
    }
}
