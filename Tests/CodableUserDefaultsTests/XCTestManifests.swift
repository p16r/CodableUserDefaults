import XCTest

#if !canImport(ObjectiveC)

public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(CodableUserDefaultsBooleanTests.allTests),
        testCase(CodableUserDefaultsIntegerTests.allTests),
        testCase(CodableUserDefaultsStringTests.allTests),
    ]
}

#endif
