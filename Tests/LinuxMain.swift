import CodableUserDefaultsTests
import XCTest

XCTMain(
    [
        CodableUserDefaultsArrayTests.allTests(),
        CodableUserDefaultsBooleanTests.allTests(),
        CodableUserDefaultsDoubleTests.allTests(),
        CodableUserDefaultsIntegerTests.allTests(),
        CodableUserDefaultsStringTests.allTests(),
    ]
)
