import XCTest
@testable import KuwentaCore

final class KuwentaCoreTests: XCTestCase {
    func testCategoryCodesIncludeIbaPa() {
        XCTAssertTrue(CategoryCode.allCases.contains(.ibaPa))
        XCTAssertEqual(CategoryCode.ibaPa.rawValue, "iba_pa")
    }

    func testSMSParserStubReturnsNilUntilPhase2() {
        XCTAssertNil(SMSParser.parse("Anything", sender: "BDO"))
    }
}
