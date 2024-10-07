import CustomDump
import XCTest

public struct Fail: Error, CustomDebugStringConvertible {
    public init(
        _ message: String
    ) {
        self.debugDescription = message
    }
        
    public let debugDescription: String
}

public func assert(
    _ expression: @autoclosure () throws -> Bool,
    _ message: @autoclosure () -> String? = nil
) throws {
    if try !expression() {
        throw Fail(message() ?? "Assertion failed")
    }
}

public func assertTrue(
    _ value: Bool,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assert(value, {
        message() ?? "Expression is not true"
    }())
}

public func assertTrue(
    _ expression: () throws -> Bool,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assertTrue(
        expression(),
        message()
    )
}

public func assertFalse(
    _ value: Bool,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assert(!value, {
        message() ?? "Expression is not false"
    }())
}

public func assertFalse(
    _ expression: () throws -> Bool,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assertFalse(
        expression(),
        message()
    )
}

public func assertEqual<T: Equatable>(
    _ value1: T,
    _ value2: T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assertEqual(
        { value1 },
        { value2 },
        message()
    )
}

public func assertEqual<T: Equatable>(
    _ expression1: () throws -> T,
    _ expression2: () throws -> T,
    _ message: @autoclosure () -> String? = nil
) throws {
    let value1 = try expression1()
    let value2 = try expression2()
    
    try assert(value1 == value2, {
        let format = DiffFormat.proportional
        let difference = diff(value1, value2, format: format)!
         
        let message =
        """
        \(message() ?? "Values are not equal")
        
        \(difference)
        """
        
        return message
    }())
}

public func assertEqual<T: FloatingPoint>(
    _ value1: T,
    _ value2: T,
    accuracy: T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assert(abs(value1 - value2) <= accuracy, {
        """
        \(message() ?? "Values are not approximately equal")
        
        \(value1) != \(value2) +/- \(accuracy)
        """
    }())
}

public func assertEqual<T: FloatingPoint>(
    _ expression1: () throws -> T,
    _ expression2: () throws -> T,
    accuracy: T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assertEqual(
        expression1(),
        expression2(),
        accuracy: accuracy,
        message()
    )
}

public func assertEqual<T: Numeric>(
    _ value1: T,
    _ value2: T,
    accuracy: T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assert((value1 - value2).magnitude <= accuracy.magnitude, {
        """
        \(message() ?? "Values are not approximately equal")
        
        \(value1) != \(value2) +/- \(accuracy)
        """
    }())
}

public func assertEqual<T: Numeric>(
    _ expression1: () throws -> T,
    _ expression2: () throws -> T,
    accuracy: T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assertEqual(
        expression1(),
        expression2(),
        accuracy: accuracy,
        message()
    )
}

public func assertGreaterThan<T: Comparable>(
    _ value1: T,
    _ value2: T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assert(value1 > value2, {
        message() ?? "\(value1) is not greater than \(value2)"
    }())
}

public func assertGreaterThan<T: Comparable>(
    _ expression1: () throws -> T,
    _ expression2: () throws -> T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assertGreaterThan(
        expression1(),
        expression2(),
        message()
    )
}

public func assertGreaterThanOrEqual<T: Comparable>(
    _ value1: T,
    _ value2: T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assert(value1 > value2, {
        message() ?? "\(value1) is not greater than or equal to \(value2)"
    }())
}

public func assertGreaterThanOrEqual<T: Comparable>(
    _ expression1: () throws -> T,
    _ expression2: () throws -> T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assertGreaterThanOrEqual(
        expression1(),
        expression2(),
        message()
    )
}

public func assertIdentical(
    _ value1: AnyObject?,
    _ value2: AnyObject?,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assert(value1 === value2, {
        message() ?? "\(String(describing: value1)) is not identical to \(String(describing: value2))"
    }())
}

public func assertIdentical(
    _ expression1: () throws -> AnyObject?,
    _ expression2: () throws -> AnyObject?,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assertIdentical(
        expression1(),
        expression2(),
        message()
    )
}

public func assertLessThan<T: Comparable>(
    _ value1: T,
    _ value2: T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assert(value1 < value2, {
        message() ?? "\(value1) is not greater than \(value2)"
    }())
}

public func assertLessThan<T: Comparable>(
    _ expression1: () throws -> T,
    _ expression2: () throws -> T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assertLessThan(
        expression1(),
        expression2(),
        message()
    )
}

public func assertLessThanOrEqual<T: Comparable>(
    _ value1: T,
    _ value2: T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assert(value1 <= value2, {
        message() ?? "\(value1) is not greater than or equal to \(value2)"
    }())
}

public func assertLessThanOrEqual<T: Comparable>(
    _ expression1: () throws -> T,
    _ expression2: () throws -> T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assertLessThanOrEqual(
        expression1(),
        expression2(),
        message()
    )
}

public func assertNil(
    _ expression: Any?,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assert(expression == nil, {
        message() ?? "\(expression!) is not nil"
    }())
}

public func assertNil(
    _ expression: () throws -> Any?,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assertNil(
        expression(),
        message()
    )
}

@discardableResult
public func assertNoThrow<T>(
    _ expression: () throws -> T,
    _ message: @autoclosure () -> String? = nil
) throws -> T {
    do {
        return try expression()
    } catch {
        throw Fail(message() ?? "Expression threw error: \(error)")
    }
}

public func assertNotEqual<T: Equatable>(
    _ value1: T,
    _ value2: T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assert(value1 != value2, {
        message() ?? "\(value1) is the same as \(value2)"
    }())
}

public func assertNotEqual<T: Equatable>(
    _ expression1: () throws -> T,
    _ expression2: () throws -> T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assertNotEqual(
        expression1(),
        expression2(),
        message()
    )
}

public func assertNotEqual<T: FloatingPoint>(
    _ value1: T,
    _ value2: T,
    accuracy: T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assert(abs(value1 - value2) > accuracy, {
        """
        \(message() ?? "Values are approximately equal")
        
        \(value1) == \(value2) +/- \(accuracy)
        """
    }())
}

public func assertNotEqual<T: FloatingPoint>(
    _ expression1: () throws -> T,
    _ expression2: () throws -> T,
    accuracy: T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assertNotEqual(
        expression1(),
        expression2(),
        accuracy: accuracy,
        message()
    )
}

public func assertNotEqual<T: Numeric>(
    _ value1: T,
    _ value2: T,
    accuracy: T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assert((value1 - value2).magnitude > accuracy.magnitude, {
        """
        \(message() ?? "Values are approximately equal")
        
        \(value1) == \(value2) +/- \(accuracy)
        """
    }())
}

public func assertNotEqual<T: Numeric>(
    _ expression1: () throws -> T,
    _ expression2: () throws -> T,
    accuracy: T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assertNotEqual(
        expression1(),
        expression2(),
        accuracy: accuracy,
        message()
    )
}

public func assertNotIdentical(
    _ value1: AnyObject?,
    _ value2: AnyObject?,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assert(value1 !== value2, {
        message() ?? "\(String(describing: value1)) is identical to \(String(describing: value2))"
    }())
}

public func assertNotIdentical(
    _ expression1: () throws -> AnyObject?,
    _ expression2: () throws -> AnyObject?,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assertNotIdentical(
        expression1(),
        expression2(),
        message()
    )
}

public func assertNotNil(
    _ expression: Any?,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assert(expression != nil, {
        message() ?? "\(expression!) is nil"
    }())
}

public func assertNotNil(
    _ expression: () throws -> Any?,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assertNotNil(
        expression(),
        message()
    )
}

public func assertThrowsError<T>(
    _ expression: () throws -> T,
    _ message: @autoclosure () -> String? = nil,
    errorHandler: (_ error: Error) throws -> Void = { _ in }
) throws {
    do {
        _ = try expression()
    } catch {
        try errorHandler(error)
        return
    }
    
    throw Fail(message() ?? "Expression did not throw an error")
}

public func assertThrowsError<T, E: Error & Equatable>(
    expectedError: E,
    _ expression: () throws -> T,
    _ message: @autoclosure () -> String? = nil
) throws {
    try assertThrowsError(expression, message()) { error in
        try assertEqual(error as? E, expectedError)
    }
}

public func assertThrowsError<T>(
    _ expression: () async throws -> T,
    _ message: @autoclosure () -> String? = nil,
    errorHandler: (_ error: Error) async throws -> Void = { _ in }
) async throws {
    do {
        _ = try await expression()
    } catch {
        try await errorHandler(error)
        return
    }
    
    throw Fail(message() ?? "Expression did not throw an error")
}

public func assertThrowsError<T, E: Error & Equatable>(
    expectedError: E,
    _ expression: () async throws -> T,
    _ message: @autoclosure () -> String? = nil
) async throws {
    try await assertThrowsError(expression, message()) { (error) async throws -> Void in
        try assertEqual(error as? E, expectedError)
    }
}

