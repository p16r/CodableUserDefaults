import CodableUserDefaultsTests
import XCTest

XCTMain(
    [
        CodableUserDefaultsBooleanTests.allTests(),
        CodableUserDefaultsIntegerTests.allTests(),
        CodableUserDefaultsStringTests.allTests(),
    ]
)
