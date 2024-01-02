import SafariServices
import XCTest

@testable import flutter_custom_tabs_ios

private typealias OpenArgument = MockLauncher.OpenArgument

final class CustomTabsPluginTest: XCTestCase {
    private var launcher: MockLauncher!
    private var plugin: CustomTabsPlugin!

    override func setUpWithError() throws {
        launcher = MockLauncher()
        plugin = CustomTabsPlugin(launcher: launcher)
    }

    override func tearDownWithError() throws {
        plugin = nil
    }

    func testPresentSFSafariViewController() {
        launcher.setPresentCompletionHandlerResults(true)

        let url = URL(string: "https://example.com")!
        let options = SFSafariViewControllerOptions()
        plugin.launchURL(url.absoluteString, prefersDeepLink: false, options: options) { result in
            if case .failure = result {
                XCTFail("error")
            }
        }
        XCTAssertTrue(launcher.openArgumentStack.isEmpty)
        XCTAssertEqual(launcher.presentArgumentStack.count, 1)

        let actualArgument = launcher.presentArgumentStack.first!
        XCTAssertTrue(actualArgument.viewControllerToPresent is SFSafariViewController)
    }

    func testFailedToPresentSFSafariViewController() {
        launcher.setPresentCompletionHandlerResults(false)

        let url = URL(string: "https://example.com")!
        let options = SFSafariViewControllerOptions()
        plugin.launchURL(url.absoluteString, prefersDeepLink: false, options: options) { result in
            if case let .failure(error) = result {
                XCTAssertTrue(error is FlutterError)
                let actualError = error as! FlutterError
                XCTAssertEqual(actualError.code, FlutterError.errorCode)
            } else {
                XCTFail("error")
            }
        }
        XCTAssertTrue(launcher.openArgumentStack.isEmpty)
        XCTAssertEqual(launcher.presentArgumentStack.count, 1)

        let actualArgument = launcher.presentArgumentStack.first!
        XCTAssertTrue(actualArgument.viewControllerToPresent is SFSafariViewController)
    }

    func testOpenExternalBrowser() throws {
        launcher.setOpenCompletionHandlerResults(true)

        let url = URL(string: "https://example.com")!
        plugin.launchURL(url.absoluteString, prefersDeepLink: false, options: nil) { result in
            if case .failure = result {
                XCTFail("error")
            }
        }
        XCTAssertEqual(launcher.openArgumentStack, [
            .init(url: url, options: [:]),
        ])
    }

    func testFailedToOpenExternalBrowser() throws {
        launcher.setOpenCompletionHandlerResults(false)

        let url = URL(string: "https://example.com")!
        plugin.launchURL(url.absoluteString, prefersDeepLink: false, options: nil) { result in
            if case let .failure(error) = result {
                XCTAssertTrue(error is FlutterError)
                let actualError = error as! FlutterError
                XCTAssertEqual(actualError.code, FlutterError.errorCode)
            } else {
                XCTFail("error")
            }
        }
        XCTAssertEqual(launcher.openArgumentStack, [
            .init(url: url, options: [:]),
        ])
    }

    // MARK: - Deep Linking

    func testDeepLinkToNativeApp() throws {
        launcher.setOpenCompletionHandlerResults(true)

        let url = URL(string: "https://example.com")!
        plugin.launchURL(url.absoluteString, prefersDeepLink: true, options: nil) { result in
            if case .failure = result {
                XCTFail("error")
            }
        }
        XCTAssertEqual(launcher.openArgumentStack, [
            .init(url: url, options: [.universalLinksOnly: true]),
        ])
        XCTAssertTrue(launcher.presentArgumentStack.isEmpty)
    }

    func testFallBackToExternalBrowser() throws {
        launcher.setOpenCompletionHandlerResults(false, true)

        let url = URL(string: "https://example.com")!
        plugin.launchURL(url.absoluteString, prefersDeepLink: true, options: nil) { result in
            if case .failure = result {
                XCTFail("error")
            }
        }
        XCTAssertEqual(launcher.openArgumentStack, [
            .init(url: url, options: [.universalLinksOnly: true]),
            .init(url: url, options: [:]),
        ])
        XCTAssertTrue(launcher.presentArgumentStack.isEmpty)
    }

    func testFallBackToSFSafariViewController() throws {
        launcher.setOpenCompletionHandlerResults(false)
        launcher.setPresentCompletionHandlerResults(true)

        let url = URL(string: "https://example.com")!
        let options = SFSafariViewControllerOptions()
        plugin.launchURL(url.absoluteString, prefersDeepLink: true, options: options) { result in
            if case .failure = result {
                XCTFail("error")
            }
        }
        XCTAssertEqual(launcher.openArgumentStack, [
            .init(url: url, options: [.universalLinksOnly: true]),
        ])
        XCTAssertEqual(launcher.presentArgumentStack.count, 1)

        let actualArgument = launcher.presentArgumentStack.first!
        XCTAssertTrue(actualArgument.viewControllerToPresent is SFSafariViewController)
    }
}
