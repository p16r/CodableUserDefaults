import CodableUserDefaultsTests
import XCTest

XCTMain(
    [
        CodableUserDefaultsBooleanTests.allTests(),
        CodableUserDefaultsDoubleTests.allTests(),
        CodableUserDefaultsIntegerTests.allTests(),
        CodableUserDefaultsStringTests.allTests(),
    ]
)
