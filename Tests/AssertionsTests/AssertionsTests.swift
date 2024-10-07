import XCTest

@testable import Assertions

struct TestError: Error, Equatable {
    let payload = Int.random(in: 0..<100)
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
}
