import CodableUserDefaultsTests
import XCTest

XCTMain(
    [
        CodableUserDefaultsArrayTests.allTests(),
        CodableUserDefaultsBooleanTests.allTests(),
        CodableUserDefaultsDictionaryTests.allTests(),
        CodableUserDefaultsDoubleTests.allTests(),
        CodableUserDefaultsIntegerTests.allTests(),
        CodableUserDefaultsStringTests.allTests(),
        CodableUserDefaultsURLTests.allTests(),
    ]
)
