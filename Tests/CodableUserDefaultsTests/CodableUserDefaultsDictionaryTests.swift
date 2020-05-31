import XCTest
import Combine
@testable import CodableUserDefaults

class CodableUserDefaultsDictionaryTests: XCTestCase {

    static var allTests = [
        (testDictionarySet, "testDictionarySet"),
        (testDictionaryUnset, "testDictionaryUnset"),
        (testDictionaryPublisher, "testDictionaryPublisher"),
        (testUnpublishedDictionaryPublisher, "testUnpublishedDictionaryPublisher"),
        (testDictionaryUpdate, "testDictionaryUpdate"),
    ]

    private var value: [String: Int]!

    @CodableUserDefaults<[String: Int]>(
        key: "dictionary",
        userDefaults: .standard,
        notificationCenter: .default
    ) private var publishedDictionary

    @CodableUserDefaults<[String: Int]>(
        key: "unpublishedDictionary",
        userDefaults: .standard,
        notificationCenter: nil
    ) private var unpublishedDictionary

    var cancellable: Cancellable!

    override func setUp() {
        value = ["A": Int.random(in: 0..<10), "B": Int.random(in: 0..<10)]
        publishedDictionary = value
        unpublishedDictionary = value
        super.setUp()
    }

    override func tearDown() {
        cancellable = nil
        publishedDictionary = nil
        unpublishedDictionary = nil
        super.tearDown()
    }

    func testDictionarySet() throws {
        let publishedDictionary = try XCTUnwrap(self.publishedDictionary, "Dictionary nil.")
        let expectedValue = try XCTUnwrap(self.value, "Dictionary nil.")
        let userDefaultsValue = try XCTUnwrap(
            UserDefaults.standard.value(forKey: "dictionary") as? [String: Int],
            "Dictionary nil."
        )

        XCTAssertEqual(
            publishedDictionary,
            expectedValue,
            "Dictionary not set correctly."
        )
        XCTAssertEqual(
            userDefaultsValue,
            expectedValue,
            "Dictionary not set correctly."
        )
        XCTAssertEqual(
            publishedDictionary,
            userDefaultsValue,
            "Defaults value mismatch."
        )
    }

    func testDictionaryUnset() {

        publishedDictionary = nil
        XCTAssertNil(publishedDictionary, "Dictionary not nil.")

        let value = UserDefaults.standard.value(forKey: "dictionary") as? [String: Int]
        XCTAssertNil(value, "User default value still set.")

        XCTAssertEqual(publishedDictionary, value, "Defaults value mismatch.")
    }

    func testDictionaryPublisher() {
        XCTAssertNotNil($publishedDictionary, "Publisher nil for dictionary.")
    }

    func testUnpublishedDictionaryPublisher() {
        XCTAssertNil(
            $unpublishedDictionary,
            "Publisher not nil for unpublished dictionary."
        )
    }

    func testDictionaryUpdate() {
        let newValue = ["A": Int.random(in: 0..<10), "B": Int.random(in: 0..<10)]
        cancellable = $publishedDictionary!.sink { value in
            let updatedValue = try! XCTUnwrap(value, "Updated value nil.")
            let defaultsValue = try! XCTUnwrap(
                UserDefaults.standard.value(forKey: "dictionary") as? [String: Int],
                "User defaults value nil."
            )

            XCTAssertEqual(
                updatedValue,
                newValue,
                "Dictionary not set correctly."
            )
            XCTAssertEqual(
                updatedValue,
                defaultsValue,
                "Defaults value mismatch."
            )
            XCTAssertEqual(
                defaultsValue,
                newValue,
                "Dictionary incorrectly set."
            )
        }
        publishedDictionary = newValue
    }

}
