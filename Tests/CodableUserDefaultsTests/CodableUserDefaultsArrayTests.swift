import XCTest
import Combine
@testable import CodableUserDefaults

class CodableUserDefaultsArrayTests: XCTestCase {

    static var allTests = [
        (testArraySet, "testArraySet"),
        (testArrayUnset, "testArrayUnset"),
        (testArrayPublisher, "testArrayPublisher"),
        (testUnpublishedArrayPublisher, "testUnpublishedArrayPublisher"),
        (testArrayUpdate, "testArrayUpdate"),
    ]

    private var value: [Int]!

    @CodableUserDefaults<[Int]>(
        key: "array",
        userDefaults: .standard,
        notificationCenter: .default
    ) private var publishedArray

    @CodableUserDefaults<[Int]>(
        key: "unpublishedArray",
        userDefaults: .standard,
        notificationCenter: nil
    ) private var unpublishedArray

    var cancellable: Cancellable!

    override func setUp() {
        value = Array(0 ..< Int.random(in: 0..<10))
        publishedArray = value
        unpublishedArray = value
        super.setUp()
    }

    override func tearDown() {
        cancellable = nil
        publishedArray = nil
        unpublishedArray = nil
        super.tearDown()
    }

    func testArraySet() throws {
        let publishedArray = try XCTUnwrap(self.publishedArray, "Array nil.")
        let expectedValue = try XCTUnwrap(self.value, "Array nil.")
        let userDefaultsValue = try XCTUnwrap(
            UserDefaults.standard.value(forKey: "array") as? [Int],
            "Array nil."
        )

        XCTAssertEqual(
            publishedArray,
            expectedValue,
            "Array not set correctly."
        )
        XCTAssertEqual(
            userDefaultsValue,
            expectedValue,
            "Array not set correctly."
        )
        XCTAssertEqual(
            publishedArray,
            userDefaultsValue,
            "Defaults value mismatch."
        )
    }

    func testArrayUnset() {

        publishedArray = nil
        XCTAssertNil(publishedArray, "Array not nil.")

        let value = UserDefaults.standard.value(forKey: "array") as? [Int]
        XCTAssertNil(value, "User default value still set.")

        XCTAssertEqual(publishedArray, value, "Defaults value mismatch.")
    }

    func testArrayPublisher() {
        XCTAssertNotNil($publishedArray, "Publisher nil for array.")
    }

    func testUnpublishedArrayPublisher() {
        XCTAssertNil(
            $unpublishedArray,
            "Publisher not nil for unpublished array."
        )
    }

    func testArrayUpdate() {
        let newValue = Array(0 ..< Int.random(in: 0..<10))
        cancellable = $publishedArray!.sink { value in
            let updatedValue = try! XCTUnwrap(value, "Updated value nil.")
            let defaultsValue = try! XCTUnwrap(
                UserDefaults.standard.value(forKey: "array") as? [Int],
                "User defaults value nil."
            )

            XCTAssertEqual(
                updatedValue,
                newValue,
                "Array not set correctly."
            )
            XCTAssertEqual(
                updatedValue,
                defaultsValue,
                "Defaults value mismatch."
            )
            XCTAssertEqual(
                defaultsValue,
                newValue,
                "Array incorrectly set."
            )
        }
        publishedArray = newValue
    }

}
