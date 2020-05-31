import XCTest

#if !canImport(ObjectiveC)

public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(CodableUserDefaultsArrayTests.allTests),
        testCase(CodableUserDefaultsBooleanTests.allTests),
        testCase(CodableUserDefaultsDoubleTests.allTests),
        testCase(CodableUserDefaultsIntegerTests.allTests),
        testCase(CodableUserDefaultsStringTests.allTests),
    ]
}

#endif
