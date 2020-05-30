import XCTest

#if !canImport(ObjectiveC)

public func allTests() -> [XCTestCaseEntry] {
    [testCase(CodableUserDefaultsTests.allTests)]
}

#endif
