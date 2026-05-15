import Foundation

/// Phase 2 placeholder for the on-device SMS parser. Kept here so the
/// Message Filter Extension target can import it without taking a hard
/// dependency on the iOS app target.
///
/// `parse` is intentionally rule-based and conservative: returns `nil`
/// when the message does not match a known bank/e-wallet pattern so the
/// extension can fall through to the system's default behavior.
public struct ParsedTransaction: Sendable, Equatable {
    public let amount: Decimal
    public let merchant: String?
    public let issuer: Issuer
    public let occurredAt: Date

    public enum Issuer: String, Sendable, Equatable {
        case bdo, gcash, maya, bpi, metrobank, securityBank, unionBank
    }

    public init(amount: Decimal, merchant: String?, issuer: Issuer, occurredAt: Date) {
        self.amount = amount
        self.merchant = merchant
        self.issuer = issuer
        self.occurredAt = occurredAt
    }
}

public enum SMSParser {
    /// Phase 2 will replace this with proper per-issuer regex parsers.
    public static func parse(_ message: String, sender: String, now: Date = Date()) -> ParsedTransaction? {
        _ = message
        _ = sender
        _ = now
        return nil
    }
}
