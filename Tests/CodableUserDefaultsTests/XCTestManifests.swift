import XCTest

#if !canImport(ObjectiveC)

public func allTests() -> [XCTestCaseEntry] {
    [
        testCase(CodableUserDefaultsArrayTests.allTests),
        testCase(CodableUserDefaultsBooleanTests.allTests),
        testCase(CodableUserDefaultsDictionaryTests.allTests),
        testCase(CodableUserDefaultsDoubleTests.allTests),
        testCase(CodableUserDefaultsIntegerTests.allTests),
        testCase(CodableUserDefaultsStringTests.allTests),
        testCase(CodableUserDefaultsURLTests.allTests),
    ]
}

#endif
