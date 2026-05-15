import Foundation

/// Hex tokens for the Kuwenta palette. Mirrors what the iOS app loads from
/// its asset catalog so widgets, watch, and extensions can reference the
/// same brand without depending on the app bundle's resources.
public enum BrandTokens {
    public static let primaryPurpleHex = "#534AB7"
    public static let accentCoralHex   = "#D85A30"
    public static let successGreenHex  = "#1D9E75"
    public static let warningAmberHex  = "#EF9F27"
    public static let dangerRedHex     = "#A32D2D"
}

/// Stable category codes shared across targets so a SMS parser
/// classification matches what the app stores.
public enum CategoryCode: String, CaseIterable, Sendable {
    case kainan, transpo, groceries, bills, utilities
    case subscriptions, padala, baon, libre, pamasko, ipon
    case ibaPa = "iba_pa"

    public var displayName: String {
        switch self {
        case .kainan:        return "Kainan"
        case .transpo:       return "Transpo"
        case .groceries:     return "Groceries"
        case .bills:         return "Bills"
        case .utilities:     return "Utilities"
        case .subscriptions: return "Subscriptions"
        case .padala:        return "Padala"
        case .baon:          return "Baon"
        case .libre:         return "Libre"
        case .pamasko:       return "Pamasko"
        case .ipon:          return "Ipon"
        case .ibaPa:         return "Iba pa"
        }
    }
}
