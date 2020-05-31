import XCTest

#if !canImport(ObjectiveC)

public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(CodableUserDefaultsIntegerTests.allTests),
        testCase(CodableUserDefaultsStringTests.allTests),
    ]
}

#endif
