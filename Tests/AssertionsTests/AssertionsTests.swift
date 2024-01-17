import XCTest

@testable import Assertions

final class AssertionsTests: XCTestCase {
    func testFail() throws {
        throw Fail("Test message")
    }
}
