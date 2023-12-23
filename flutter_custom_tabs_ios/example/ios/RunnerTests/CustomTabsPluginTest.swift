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
        let url = URL(string: "https://example.com")!
        let options = SFSafariViewControllerOptions()
        plugin.launchURL(url.absoluteString, prefersDeepLink: false, options: options) { result in
            if case .failure = result {
                XCTFail("error")
            }
        }
        XCTAssertTrue(launcher.openArgumentStack.isEmpty)
        XCTAssertEqual(launcher.presentArgumentStack.count, 1)

        let actualArgment = launcher.presentArgumentStack.first!
        XCTAssertTrue(actualArgment.viewControllerToPresent is SFSafariViewController)
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

    func testlFallBackToExternalBrowser() throws {
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

    func testFallBackToSFSfariViewController() throws {
        launcher.setOpenCompletionHandlerResults(false)

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

        let actualArgment = launcher.presentArgumentStack.first!
        XCTAssertTrue(actualArgment.viewControllerToPresent is SFSafariViewController)
    }
}
