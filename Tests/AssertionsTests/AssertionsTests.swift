import XCTest

@testable import Assertions

struct TestError: Error, Equatable {
    var payload = Int.random(in: 0..<100)
}

struct TestStruct: Equatable {
    struct InnerStruct: Equatable {
        let intValue: Int
        let floatValue = 4.0
    }
    
    let innerValue: InnerStruct
    let outerValue = 4
    
    init(_ intValue: Int) {
        self.innerValue = .init(intValue: intValue)
    }
}

struct UnequalInt: Equatable {
    let value: Int
    
    init(_ value: Int) {
        self.value = value
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        false
    }
}

final class AssertionsTests: XCTestCase {

    func testAssert() throws {
        do {
            try assert({ true }())
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assert({ false }())
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("Assertion failed", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assert(
                { false }(),
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
    }
    
    func testAssertTrue() throws {
        do {
            try assertTrue(true)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertTrue(false)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("Expression is not true", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertTrue(
                false,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
    }
    
    func testAssertTrueExpression() throws {
        do {
            try assertTrue { true }
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertTrue { false }
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("Expression is not true", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertTrue(
                { false },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
        
        let testError = TestError()
        
        do {
            try assertTrue(
                { throw testError },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? TestError else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testError, error)
        }
    }
    
    func testAssertFalse() throws {
        do {
            try assertFalse(false)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertFalse(true)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("Expression is not false", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertFalse(
                true,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
    }
    
    func testAssertFalseExpression() throws {
        do {
            try assertFalse { false }
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertFalse { true }
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("Expression is not false", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertFalse(
                { true },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
        
        let testError = TestError()
        
        do {
            try assertFalse(
                { throw testError },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? TestError else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testError, error)
        }
    }

    func testAssertEqual() throws {
        do {
            try assertEqual(TestStruct(5), TestStruct(5))
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertEqual(TestStruct(5), TestStruct(4))
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            Values are not equal

              TestStruct(
                innerValue: TestStruct.InnerStruct(
            −     intValue: 5,
            +     intValue: 4,
                  floatValue: 4.0
                ),
                outerValue: 4
              )
            """, error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertEqual(
                TestStruct(5), TestStruct(4),
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            \(testMessage)

              TestStruct(
                innerValue: TestStruct.InnerStruct(
            −     intValue: 5,
            +     intValue: 4,
                  floatValue: 4.0
                ),
                outerValue: 4
              )
            """, error.debugDescription)
        }
    }
    
    func testAssertEqualNoDifference() throws {
        do {
            try assertEqual(UnequalInt(5), UnequalInt(5))
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            Values are not equal

              // Not equal but no difference detected:
            − UnequalInt(value: 5)
            + UnequalInt(value: 5)
            """, error.debugDescription)
        }
    }
    
    func testAssertEqualExpression() throws {
        do {
            try assertEqual({ 5 }, { 5 })
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertEqual({ 5 }, { 4 })
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            Values are not equal

            − 5
            + 4
            """, error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertEqual(
                { 5 }, { 4 },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            \(testMessage)

            − 5
            + 4
            """, error.debugDescription)
        }
        
        let testError = TestError()
        
        do {
            try assertEqual(
                { 5 }, { throw testError },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? TestError else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testError, error)
        }
    }
    
    func testAssertNotEqual() throws {
        do {
            try assertNotEqual(5, 4)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
                
        do {
            try assertNotEqual(5, 5)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("5 is the same as 5", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertNotEqual(
                5, 5,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
    }
    
    func testAssertNotEqualExpression() throws {
        do {
            try assertNotEqual({ 5 }, { 4 })
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertNotEqual({ 5 }, { 5 })
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("5 is the same as 5", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertNotEqual(
                { 5 }, { 5 },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
        
        let testError = TestError()
        
        do {
            try assertNotEqual(
                { 5 }, { throw testError },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? TestError else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testError, error)
        }
    }
    
    func testAssertApproximatelyEqualFloat() throws {
        do {
            try assertEqual(4.0, 4.0, accuracy: 1.0)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertEqual(4.0, 6.0, accuracy: 1.0)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            Values are not approximately equal

            4.0 != 6.0 +/- 1.0
            """, error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertEqual(
                4.0, 6.0, accuracy: 1.0,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            \(testMessage)
            
            4.0 != 6.0 +/- 1.0
            """, error.debugDescription)
        }
    }
    
    func testAssertApproximatelyEqualFloatExpression() throws {
        do {
            try assertEqual({ 4.0 }, { 4.0 }, accuracy: 1.0)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertEqual({ 4.0 }, { 6.0 }, accuracy: 1.0)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            Values are not approximately equal

            4.0 != 6.0 +/- 1.0
            """, error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertEqual(
                { 4.0 }, { 6.0 }, accuracy: 1.0,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            \(testMessage)
            
            4.0 != 6.0 +/- 1.0
            """, error.debugDescription)
        }
        
        let testError = TestError()
        
        do {
            try assertEqual(
                { 4.0 }, { throw testError }, accuracy: 1.0,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? TestError else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testError, error)
        }
    }
    
    func testAssertNotApproximatelyEqualFloat() throws {
        do {
            try assertNotEqual(4.0, 6.0, accuracy: 1.0)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertNotEqual(4.0, 4.0, accuracy: 1.0)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            Values are approximately equal

            4.0 == 4.0 +/- 1.0
            """, error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertNotEqual(
                4.0, 4.0, accuracy: 1.0,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            \(testMessage)
            
            4.0 == 4.0 +/- 1.0
            """, error.debugDescription)
        }
    }
    
    func testAssertNotApproximatelyEqualFloatExpression() throws {
        do {
            try assertNotEqual({ 4.0 }, { 6.0 }, accuracy: 1.0)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertNotEqual({ 4.0 }, { 4.0 }, accuracy: 1.0)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            Values are approximately equal

            4.0 == 4.0 +/- 1.0
            """, error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertNotEqual(
                { 4.0 }, { 4.0 }, accuracy: 1.0,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            \(testMessage)
            
            4.0 == 4.0 +/- 1.0
            """, error.debugDescription)
        }
        
        let testError = TestError()
        
        do {
            try assertNotEqual(
                { 4.0 }, { throw testError }, accuracy: 1.0,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? TestError else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testError, error)
        }
    }
    
    func testAssertApproximatelyEqualNumeric() throws {
        do {
            try assertEqual(4, 4, accuracy: 1)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertEqual(4, 6, accuracy: 1)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            Values are not approximately equal

            4 != 6 +/- 1
            """, error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertEqual(
                4, 6, accuracy: 1,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            \(testMessage)
            
            4 != 6 +/- 1
            """, error.debugDescription)
        }
    }
    
    func testAssertApproximatelyEqualNumericExpression() throws {
        do {
            try assertEqual({ 4 }, { 4 }, accuracy: 1)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertEqual({ 4 }, { 6 }, accuracy: 1)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            Values are not approximately equal

            4 != 6 +/- 1
            """, error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertEqual(
                { 4 }, { 6 }, accuracy: 1,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            \(testMessage)
            
            4 != 6 +/- 1
            """, error.debugDescription)
        }
        
        let testError = TestError()
        
        do {
            try assertEqual(
                { 4 }, { throw testError }, accuracy: 1,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? TestError else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testError, error)
        }
    }
    
    func testAssertNotApproximatelyEqualNumeric() throws {
        do {
            try assertNotEqual(4, 6, accuracy: 1)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertNotEqual(4, 4, accuracy: 1)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            Values are approximately equal

            4 == 4 +/- 1
            """, error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertNotEqual(
                4, 4, accuracy: 1,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            \(testMessage)
            
            4 == 4 +/- 1
            """, error.debugDescription)
        }
    }
    
    func testAssertNotApproximatelyEqualNumericExpression() throws {
        do {
            try assertNotEqual({ 4 }, { 6 }, accuracy: 1)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertNotEqual({ 4 }, { 4 }, accuracy: 1)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            Values are approximately equal

            4 == 4 +/- 1
            """, error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertNotEqual(
                { 4 }, { 4 }, accuracy: 1,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            \(testMessage)
            
            4 == 4 +/- 1
            """, error.debugDescription)
        }
        
        let testError = TestError()
        
        do {
            try assertNotEqual(
                { 4 }, { throw testError }, accuracy: 1,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? TestError else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testError, error)
        }
    }
    
    func testAssertGreaterThan() throws {
        do {
            try assertGreaterThan(5, 4)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertGreaterThan(4, 5)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("4 is not greater than 5", error.debugDescription)
        }
        
        do {
            try assertGreaterThan(4, 4)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("4 is not greater than 4", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertGreaterThan(
                4, 5,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
    }
    
    func testAssertGreaterThanExpression() throws {
        do {
            try assertGreaterThan({ 5 }, { 4 })
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertGreaterThan({ 4 }, { 5 })
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("4 is not greater than 5", error.debugDescription)
        }
        
        do {
            try assertGreaterThan({ 4 }, { 4 })
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("4 is not greater than 4", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertGreaterThan(
                { 4 }, { 5 },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
        
        let testError = TestError()
        
        do {
            try assertGreaterThan(
                { 4 }, { throw testError },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? TestError else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testError, error)
        }
    }
    
    func testAssertGreaterThanOrEqual() throws {
        do {
            try assertGreaterThanOrEqual(5, 4)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertGreaterThanOrEqual(4, 4)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertGreaterThanOrEqual(4, 5)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("4 is not greater than or equal to 5", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertGreaterThanOrEqual(
                4, 5,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
    }
    
    func testAssertGreaterThanOrEqualExpression() throws {
        do {
            try assertGreaterThanOrEqual({ 5 }, { 4 })
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertGreaterThanOrEqual({ 4 }, { 4 })
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertGreaterThanOrEqual({ 4 }, { 5 })
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("4 is not greater than or equal to 5", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertGreaterThanOrEqual(
                { 4 }, { 5 },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
        
        let testError = TestError()
        
        do {
            try assertGreaterThanOrEqual(
                { 4 }, { throw testError },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? TestError else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testError, error)
        }
    }
    
    func testAssertLessThan() throws {
        do {
            try assertLessThan(4, 5)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertLessThan(5, 4)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("5 is not less than 4", error.debugDescription)
        }
        
        do {
            try assertLessThan(4, 4)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("4 is not less than 4", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertLessThan(
                5, 4,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
    }
    
    func testAssertLessThanExpression() throws {
        do {
            try assertLessThan({ 4 }, { 5 })
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertLessThan({ 5 }, { 4 })
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("5 is not less than 4", error.debugDescription)
        }
        
        do {
            try assertLessThan({ 4 }, { 4 })
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("4 is not less than 4", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertLessThan(
                { 5 }, { 4 },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
        
        let testError = TestError()
        
        do {
            try assertLessThan(
                { 4 }, { throw testError },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? TestError else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testError, error)
        }
    }
    
    func testAssertLessThanOrEqual() throws {
        do {
            try assertLessThanOrEqual(4, 5)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertLessThanOrEqual(4, 4)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertLessThanOrEqual(5, 4)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("5 is not less than or equal to 4", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertLessThanOrEqual(
                5, 4,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
    }
    
    func testAssertLessThanOrEqualExpression() throws {
        do {
            try assertLessThanOrEqual({ 4 }, { 5 })
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertLessThanOrEqual({ 4 }, { 4 })
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertLessThanOrEqual({ 5 }, { 4 })
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("5 is not less than or equal to 4", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertLessThanOrEqual(
                { 5 }, { 4 },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
        
        let testError = TestError()
        
        do {
            try assertLessThanOrEqual(
                { 4 }, { throw testError },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? TestError else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testError, error)
        }
    }
    
    func testAssertIdentical() throws {
        let object = NSObject()
        let otherObject = NSObject()
    
        do {
            try assertIdentical(object, object)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertIdentical(object, otherObject)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("\(object) is not identical to \(otherObject)", error.debugDescription)
        }
        
        do {
            try assertIdentical(nil, otherObject)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("nil is not identical to \(otherObject)", error.debugDescription)
        }
        
        
        
        do {
            try assertIdentical(object, nil)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("\(object) is not identical to nil", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertIdentical(
                object, otherObject,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }

            XCTAssertEqual(testMessage, error.debugDescription)
        }
    }
    
    func testAssertIdenticalExpression() throws {
        let object = NSObject()
        let otherObject = NSObject()
        
        do {
            try assertIdentical({ object }, { object })
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertIdentical({ object }, { otherObject })
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("\(object) is not identical to \(otherObject)", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertIdentical(
                { object }, { otherObject },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
        
        let testError = TestError()
        
        do {
            try assertIdentical(
                { object }, { throw testError },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? TestError else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testError, error)
        }
    }
    
    func testAssertNotIdentical() throws {
        let object = NSObject()
        let otherObject = NSObject()
    
        do {
            try assertNotIdentical(object, otherObject)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertNotIdentical(object, object)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("\(object) is identical to \(object)", error.debugDescription)
        }
        
        do {
            try assertNotIdentical(nil, nil)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("nil is identical to nil", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertNotIdentical(
                object, object,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }

            XCTAssertEqual(testMessage, error.debugDescription)
        }
    }
    
    func testAssertNotIdenticalExpression() throws {
        let object = NSObject()
        let otherObject = NSObject()
        
        do {
            try assertNotIdentical({ object }, { otherObject })
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertNotIdentical({ object }, { object })
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("\(object) is identical to \(object)", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertNotIdentical(
                { object }, { object },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
        
        let testError = TestError()
        
        do {
            try assertNotIdentical(
                { object }, { throw testError },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? TestError else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testError, error)
        }
    }
    
    func testAssertNil() throws {
        do {
            try assertNil(nil)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertNil(5)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("5 is not nil", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertNil(
                5,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }

            XCTAssertEqual(testMessage, error.debugDescription)
        }
    }
    
    func testAssertNilExpression() throws {
        do {
            try assertNil { nil }
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertNil { 5 as Int? }
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("5 is not nil", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertNil(
                { 5 as Int? },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
        
        let testError = TestError()
        
        do {
            try assertNil(
                { throw testError },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? TestError else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testError, error)
        }
    }
    
    func testAssertNotNil() throws {
        do {
            try assertNotNil(5)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertNotNil(nil)
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("Value is nil", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertNotNil(
                nil,
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }

            XCTAssertEqual(testMessage, error.debugDescription)
        }
    }
    
    func testAssertNotNilExpression() throws {
        do {
            try assertNotNil { 5 as Int? }
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertNotNil { nil }
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("Value is nil", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertNotNil(
                { nil },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
        
        let testError = TestError()
        
        do {
            try assertNotNil(
                { throw testError },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? TestError else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testError, error)
        }
    }
    
    func testAssertNoThrow() throws {
        let expectedResult = Int.random(in: 0..<100)
        
        do {
            let result = try assertNoThrow { expectedResult }
            XCTAssertEqual(expectedResult, result)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        let testError = TestError()
        
        do {
            try assertNoThrow { throw testError }
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("Expression threw error: \(testError)", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertNoThrow(
                { throw testError },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
    }
    
    func testAssertThrowsError() throws {
        let testError = TestError()
        
        do {
            var handledError: (any Error)? = nil
            
            try assertThrowsError {
                throw testError
            } errorHandler: { error in
                handledError = error
            }
            
            XCTAssertEqual(handledError as? TestError, testError)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertThrowsError {
                throw testError
            }
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertThrowsError { 5 }
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("Expression did not throw an error", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertThrowsError(
                { "" },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
    }
    
    func testAssertThrowsExpectedError() throws {
        let testError = TestError()
        let otherError = TestError(payload: testError.payload + 1)
        
        do {
            try assertThrowsError(expectedError: testError) {
                throw testError
            }
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try assertThrowsError(expectedError: testError) {
                throw otherError
            }
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            Values are not equal

            − TestError(payload: \(otherError.payload))
            + TestError(payload: \(testError.payload))
            """, error.debugDescription)
        }
        
        do {
            try assertThrowsError(expectedError: testError) { 5 }
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("Expression did not throw an error", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try assertThrowsError(
                expectedError: testError,
                { "" },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
    }
    
    func testAssertThrowsErrorAsync() async throws {
        let testError = TestError()
        
        do {
            var handledError: (any Error)? = nil
            
            try await assertThrowsError { () async throws in
                throw testError
            } errorHandler: { error async in
                handledError = error
            }
            
            XCTAssertEqual(handledError as? TestError, testError)
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try await assertThrowsError { () async throws in
                throw testError
            }
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try await assertThrowsError { () async throws in 5 }
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("Expression did not throw an error", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try await assertThrowsError(
                { () async throws in "" },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
    }
    
    func testAssertThrowsExpectedErrorAsync() async throws {
        let testError = TestError()
        let otherError = TestError(payload: testError.payload + 1)
        
        do {
            try await assertThrowsError(expectedError: testError) { () async throws in
                throw testError
            }
        } catch {
            XCTFail("Did not expect a throw")
            return
        }
        
        do {
            try await assertThrowsError(expectedError: testError) { () async throws in
                throw otherError
            }
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("""
            Values are not equal

            − TestError(payload: \(otherError.payload))
            + TestError(payload: \(testError.payload))
            """, error.debugDescription)
        }
        
        do {
            try await assertThrowsError(expectedError: testError) { () async throws in 5 }
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual("Expression did not throw an error", error.debugDescription)
        }
        
        let testMessage = "Test Message"
        
        do {
            try await assertThrowsError(
                expectedError: testError,
                { () async throws in "" },
                { testMessage }()
            )
            XCTFail("Expected a throw")
        } catch {
            guard let error = error as? Fail else {
                XCTFail("Expected a `Fail` error")
                return
            }
            
            XCTAssertEqual(testMessage, error.debugDescription)
        }
    }
}
