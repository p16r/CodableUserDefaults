import XCTest
import Combine
@testable import CodableUserDefaults

class CodableUserDefaultsURLTests: XCTestCase {

    static var allTests = [
        (testURLSet, "testURLSet"),
        (testURLUnset, "testURLUnset"),
        (testURLPublisher, "testURLPublisher"),
        (testUnpublishedURLPublisher, "testUnpublishedURLPublisher"),
        (testURLUpdate, "testURLUpdate"),
    ]

    private var value: URL!

    @CodableUserDefaults<URL>(
        key: "url",
        userDefaults: .standard,
        notificationCenter: .default
    ) private var publishedURL

    @CodableUserDefaults<URL>(
        key: "unpublishedURL",
        userDefaults: .standard,
        notificationCenter: nil
    ) private var unpublishedURL

    var cancellable: Cancellable!

    override func setUp() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "localhost"
        components.path = "/path"
        components.fragment = "fragment"
        components.port = 443
        components.queryItems = [.init(name: "parameter", value: "value")]

        value = components.url
        publishedURL = value
        unpublishedURL = value
        super.setUp()
    }

    override func tearDown() {
        cancellable = nil
        publishedURL = nil
        unpublishedURL = nil
        super.tearDown()
    }

    func testURLSet() throws {
        let publishedURL = try XCTUnwrap(self.publishedURL, "URL nil.")
        let expectedValue = try XCTUnwrap(self.value, "URL nil.")

        let defaultsData = try! XCTUnwrap(
            UserDefaults.standard.data(forKey: "url"),
            "User defaults value nil."
        )
        let defaultsValue = try! XCTUnwrap(
            try? decoder.decode(URL?.self, from: defaultsData),
            "Unable to parse user defaults value."
        )

        XCTAssertEqual(publishedURL, expectedValue, "URL not set correctly.")
        XCTAssertEqual(publishedURL, defaultsValue, "Defaults value mismatch.")
        XCTAssertEqual(defaultsValue, expectedValue, "URL not set correctly.")
    }

    func testURLUnset() {

        publishedURL = nil
        XCTAssertNil(publishedURL, "URL not nil.")

        let value = UserDefaults.standard.value(forKey: "url") as? URL
        XCTAssertNil(value, "User default value still set.")

        XCTAssertEqual(publishedURL, value, "Defaults value mismatch.")
    }

    func testURLPublisher() {
        XCTAssertNotNil($publishedURL, "Publisher nil for url.")
    }

    func testUnpublishedURLPublisher() {
        XCTAssertNil(
            $unpublishedURL,
            "Publisher not nil for unpublished url."
        )
    }

    func testURLUpdate() {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "localhost"
        components.path = "/different-path"
        components.fragment = "fragment2"
        components.port = 443
        components.queryItems = [.init(name: "newParameter", value: "value")]

        let newValue = components.url

        cancellable = $publishedURL!.sink { value in
            let updatedValue = try! XCTUnwrap(value, "Updated value nil.")
            let defaultsData = try! XCTUnwrap(
                UserDefaults.standard.data(forKey: "url"),
                "User defaults value nil."
            )
            let defaultsValue = try! XCTUnwrap(
                try? decoder.decode(URL?.self, from: defaultsData),
                "Unable to parse user defaults value."
            )

            XCTAssertEqual(
                updatedValue,
                newValue,
                "URL not set correctly."
            )
            XCTAssertEqual(
                updatedValue,
                defaultsValue,
                "Defaults value mismatch."
            )
            XCTAssertEqual(
                defaultsValue,
                newValue,
                "URL incorrectly set."
            )
        }
        publishedURL = newValue
    }

}
