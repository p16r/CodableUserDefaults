import XCTest
import Combine
@testable import CodableUserDefaults

final class CodableUserDefaultsIntegerTests: XCTestCase {

    static var allTests = [
        (testIntegerSet, "testIntegerSet"),
        (testIntegerUnset, "testIntegerUnset"),
        (testIntegerPublisher, "testIntegerPublisher"),
        (testUnpublishedIntegerPublisher, "testUnpublishedIntegerPublisher"),
        (testIntegerUpdate, "testIntegerUpdate"),
    ]

    @CodableUserDefaults<Int>(
        key: "integer",
        userDefaults: .standard,
        notificationCenter: .default
    ) private var publishedInteger

    @CodableUserDefaults<Int>(
        key: "unpublishedInteger",
        userDefaults: .standard,
        notificationCenter: nil
    ) private var unpublishedInteger

    var cancellable: Cancellable!

    override func setUp() {
        publishedInteger = 42
        unpublishedInteger = -42
        super.setUp()
    }

    override func tearDown() {
        cancellable = nil
        publishedInteger = nil
        unpublishedInteger = nil
        super.tearDown()
    }

    func testIntegerSet() {

        XCTAssertNotNil(publishedInteger, "Integer nil.")
        XCTAssertEqual(publishedInteger, 42, "Integer not set correctly.")

        let value = UserDefaults.standard.value(forKey: "integer") as? Int

        XCTAssertNotNil(value, "Integer nil.")
        XCTAssertEqual(value, 42, "Integer not set correctly.")

        XCTAssertEqual(publishedInteger!, value!, "Defaults value mismatch.")
    }

    func testIntegerUnset() {

        publishedInteger = nil
        XCTAssertNil(publishedInteger, "Integer not nil.")

        let value = UserDefaults.standard.value(forKey: "integer") as? Int
        XCTAssertNil(value, "User default value still set.")

        XCTAssertEqual(publishedInteger, value, "Defaults value mismatch.")
    }

    func testIntegerPublisher() {
        XCTAssertNotNil($publishedInteger, "Publisher nil for integer.")
    }

    func testUnpublishedIntegerPublisher() {
        XCTAssertNil(
            $unpublishedInteger,
            "Publisher not nil for unpublished integer."
        )
    }

    func testIntegerUpdate() {
        let newValue = 43
        cancellable = $publishedInteger!.sink { value in

            XCTAssertNotNil(value, "Updated value nil.")
            XCTAssertEqual(value!, newValue, "Integer not set correctly.")

            let defaults = UserDefaults.standard
            let defaultsValue = defaults.value(forKey: "integer") as? Int
            XCTAssertNotNil(defaultsValue, "Integer nil.")
            XCTAssertEqual(defaultsValue!, newValue, "Integer incorrectly set.")

            XCTAssertEqual(value!, defaultsValue!, "Defaults value mismatch.")
        }
        publishedInteger = newValue
    }

}
