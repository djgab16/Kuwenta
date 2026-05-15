import SwiftUI

/// Tone of voice for Kuwenta is warm Taglish. Typography is straight
/// Apple SF Pro to inherit Dynamic Type and accessibility for free.
enum KuwentaTypography {
    static let displayAmount = Font.system(.largeTitle, design: .rounded, weight: .bold)
    static let sectionTitle  = Font.system(.headline,   design: .rounded, weight: .semibold)
    static let chip          = Font.system(.subheadline, design: .rounded, weight: .medium)
    static let body          = Font.system(.body,        design: .default, weight: .regular)
    static let caption       = Font.system(.footnote,    design: .default, weight: .regular)
}
