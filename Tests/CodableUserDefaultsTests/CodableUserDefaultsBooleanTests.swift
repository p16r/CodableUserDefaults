import XCTest
import Combine
@testable import CodableUserDefaults

class CodableUserDefaultsBoolTests: XCTestCase {

    static var allTests = [
        (testBooleanSet, "testBooleanSet"),
        (testBooleanUnset, "testBooleanUnset"),
        (testBooleanPublisher, "testBooleanPublisher"),
        (testUnpublishedBooleanPublisher, "testUnpublishedBooleanPublisher"),
        (testBooleanUpdate, "testBooleanUpdate"),
    ]

    private var value: Bool!

    @CodableUserDefaults<Bool>(
        key: "boolean",
        userDefaults: .standard,
        notificationCenter: .default
    ) private var publishedBoolean

    @CodableUserDefaults<Bool>(
        key: "unpublishedBoolean",
        userDefaults: .standard,
        notificationCenter: nil
    ) private var unpublishedBoolean

    var cancellable: Cancellable!

    override func setUp() {
        value = Bool.random()
        publishedBoolean = value
        unpublishedBoolean = value
        super.setUp()
    }

    override func tearDown() {
        cancellable = nil
        publishedBoolean = nil
        unpublishedBoolean = nil
        super.tearDown()
    }

    func testBooleanSet() {

        XCTAssertNotNil(publishedBoolean, "Boolean nil.")
        XCTAssertEqual(publishedBoolean, value, "Boolean not set correctly.")

        let value = UserDefaults.standard.value(forKey: "boolean") as? Bool

        XCTAssertNotNil(value, "Boolean nil.")
        XCTAssertEqual(value, self.value, "Boolean not set correctly.")

        XCTAssertEqual(publishedBoolean!, value!, "Defaults value mismatch.")
    }

    func testBooleanUnset() {

        publishedBoolean = nil
        XCTAssertNil(publishedBoolean, "Boolean not nil.")

        let value = UserDefaults.standard.value(forKey: "boolean") as? Bool
        XCTAssertNil(value, "User default value still set.")

        XCTAssertEqual(publishedBoolean, value, "Defaults value mismatch.")
    }

    func testBooleanPublisher() {
        XCTAssertNotNil($publishedBoolean, "Publisher nil for boolean.")
    }

    func testUnpublishedBooleanPublisher() {
        XCTAssertNil(
            $unpublishedBoolean,
            "Publisher not nil for unpublished boolean."
        )
    }

    func testBooleanUpdate() {
        let newValue = !value
        cancellable = $publishedBoolean!.sink { value in

            XCTAssertNotNil(value, "Updated value nil.")
            XCTAssertEqual(value!, newValue, "Boolean not set correctly.")

            let defaults = UserDefaults.standard
            let defaultsValue = defaults.value(forKey: "boolean") as? Bool
            XCTAssertNotNil(defaultsValue, "Boolean nil.")
            XCTAssertEqual(defaultsValue!, newValue, "Boolean incorrectly set.")

            XCTAssertEqual(value!, defaultsValue!, "Defaults value mismatch.")
        }
        publishedBoolean = newValue
    }

}
