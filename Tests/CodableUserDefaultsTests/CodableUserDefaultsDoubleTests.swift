import XCTest
import Combine
@testable import CodableUserDefaults

class CodableUserDefaultsDoubleTests: XCTestCase {

    static var allTests = [
        (testDoubleSet, "testDoubleSet"),
        (testDoubleUnset, "testDoubleUnset"),
        (testDoublePublisher, "testDoublePublisher"),
        (testUnpublishedDoublePublisher, "testUnpublishedDoublePublisher"),
        (testDoubleUpdate, "testDoubleUpdate"),
    ]

    private var value: Double!

    @CodableUserDefaults<Double>(
        key: "double",
        userDefaults: .standard,
        notificationCenter: .default
    ) private var publishedDouble

    @CodableUserDefaults<Double>(
        key: "unpublishedDouble",
        userDefaults: .standard,
        notificationCenter: nil
    ) private var unpublishedDouble

    var cancellable: Cancellable!

    override func setUp() {
        value = Double.random(in: -100 ... 100)
        publishedDouble = value
        unpublishedDouble = value
        super.setUp()
    }

    override func tearDown() {
        cancellable = nil
        publishedDouble = nil
        unpublishedDouble = nil
        super.tearDown()
    }

    func testDoubleSet() {

        XCTAssertNotNil(publishedDouble, "Double nil.")
        XCTAssertEqual(publishedDouble, value, "Double not set correctly.")

        let value = UserDefaults.standard.value(forKey: "double") as? Double

        XCTAssertNotNil(value, "Double nil.")
        XCTAssertEqual(value, self.value, "Double not set correctly.")

        XCTAssertEqual(publishedDouble!, value!, "Defaults value mismatch.")
    }

    func testDoubleUnset() {

        publishedDouble = nil
        XCTAssertNil(publishedDouble, "Double not nil.")

        let value = UserDefaults.standard.value(forKey: "double") as? Double
        XCTAssertNil(value, "User default value still set.")

        XCTAssertEqual(publishedDouble, value, "Defaults value mismatch.")
    }

    func testDoublePublisher() {
        XCTAssertNotNil($publishedDouble, "Publisher nil for double.")
    }

    func testUnpublishedDoublePublisher() {
        XCTAssertNil(
            $unpublishedDouble,
            "Publisher not nil for unpublished double."
        )
    }

    func testDoubleUpdate() {
        let newValue = Double.random(in: -100 ... 100)
        cancellable = $publishedDouble!.sink { value in

            XCTAssertNotNil(value, "Updated value nil.")
            XCTAssertEqual(value!, newValue, "Double not set correctly.")

            let defaults = UserDefaults.standard
            let defaultsValue = defaults.value(forKey: "double") as? Double
            XCTAssertNotNil(defaultsValue, "Double nil.")
            XCTAssertEqual(defaultsValue!, newValue, "Double incorrectly set.")

            XCTAssertEqual(value!, defaultsValue!, "Defaults value mismatch.")
        }
        publishedDouble = newValue
    }

}
