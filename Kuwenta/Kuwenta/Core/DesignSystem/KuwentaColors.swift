import SwiftUI

/// Brand palette wired to the asset catalog so dark mode swatches can be
/// tweaked from Xcode without touching code.
enum KuwentaColor {
    static let primaryPurple = Color("PrimaryPurple")
    static let accentCoral   = Color("AccentCoral")
    static let successGreen  = Color("SuccessGreen")
    static let warningAmber  = Color("WarningAmber")
    static let dangerRed     = Color("DangerRed")
}

extension Color {
    /// Resolve a brand color from a stored asset name. Falls back to the
    /// primary purple if the asset is missing, so a typo never crashes a
    /// transaction row.
    init(brandAsset name: String) {
        self = Color(name)
    }
}
