import XCTest
import Combine
@testable import CodableUserDefaults

class CodableUserDefaultsStringTests: XCTestCase {

    static var allTests = [
        (testStringSet, "testStringSet"),
        (testStringUnset, "testStringUnset"),
        (testStringPublisher, "testStringPublisher"),
        (testUnpublishedStringPublisher, "testUnpublishedStringPublisher"),
        (testStringUpdate, "testStringUpdate"),
    ]

    @CodableUserDefaults<String>(
        key: "string",
        userDefaults: .standard,
        notificationCenter: .default
    ) private var publishedString

    @CodableUserDefaults<String>(
        key: "unpublishedString",
        userDefaults: .standard,
        notificationCenter: nil
    ) private var unpublishedString

    var cancellable: Cancellable!

    override func setUp() {
        publishedString = "hello"
        unpublishedString = "world"
        super.setUp()
    }

    override func tearDown() {
        cancellable = nil
        publishedString = nil
        unpublishedString = nil
        super.tearDown()
    }

    func testStringSet() {

        XCTAssertNotNil(publishedString, "String nil.")
        XCTAssertEqual(publishedString, "hello", "String not set correctly.")

        let value = UserDefaults.standard.value(forKey: "string") as? String

        XCTAssertNotNil(value, "String nil.")
        XCTAssertEqual(value, "hello", "String not set correctly.")

        XCTAssertEqual(publishedString!, value!, "Defaults value mismatch.")
    }

    func testStringUnset() {

        publishedString = nil
        XCTAssertNil(publishedString, "String not nil.")

        let value = UserDefaults.standard.value(forKey: "string") as? String
        XCTAssertNil(value, "User default value still set.")

        XCTAssertEqual(publishedString, value, "Defaults value mismatch.")
    }

    func testStringPublisher() {
        XCTAssertNotNil($publishedString, "Publisher nil for string.")
    }

    func testUnpublishedStringPublisher() {
        XCTAssertNil(
            $unpublishedString,
            "Publisher not nil for unpublished string."
        )
    }

    func testStringUpdate() {
        let newValue = "HELLO"
        cancellable = $publishedString!.sink { value in

            XCTAssertNotNil(value, "Updated value nil.")
            XCTAssertEqual(value!, newValue, "String not set correctly.")

            let defaults = UserDefaults.standard
            let defaultsValue = defaults.value(forKey: "string") as? String
            XCTAssertNotNil(defaultsValue, "String nil.")
            XCTAssertEqual(defaultsValue!, newValue, "String incorrectly set.")

            XCTAssertEqual(value!, defaultsValue!, "Defaults value mismatch.")
        }
        publishedString = newValue
    }

}
