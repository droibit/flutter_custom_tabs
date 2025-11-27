import SafariServices
import XCTest
@testable import flutter_custom_tabs_ios

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

  func testPresentSFSafariViewController() throws {
    launcher.setPresentCompletionHandlerResults(true)

    let url = try XCTUnwrap(URL(string: "https://example.com"))
    let options = SFSafariViewControllerOptions()
    plugin.launchURL(url.absoluteString, prefersDeepLink: false, options: options) { result in
      if case .failure = result {
        XCTFail("error")
      }
    }
    XCTAssertTrue(launcher.openArguments.isEmpty)
    XCTAssertEqual(launcher.presentArguments.count, 1)

    let actualArgument = try XCTUnwrap(launcher.presentArguments.first)
    XCTAssertTrue(actualArgument.viewControllerToPresent is SFSafariViewController)
  }

  func testFailedToPresentSFSafariViewController() throws {
    launcher.setPresentCompletionHandlerResults(false)

    let url = try XCTUnwrap(URL(string: "https://example.com"))
    let options = SFSafariViewControllerOptions()
    plugin.launchURL(url.absoluteString, prefersDeepLink: false, options: options) { result in
      if case let .failure(error) = result {
        XCTAssertTrue(error is PigeonError)
        let actualError = error as! PigeonError
        XCTAssertEqual(actualError.code, PigeonError.errorCode)
      } else {
        XCTFail("error")
      }
    }
    XCTAssertTrue(launcher.openArguments.isEmpty)
    XCTAssertEqual(launcher.presentArguments.count, 1)

    let actualArgument = try XCTUnwrap(launcher.presentArguments.first)
    XCTAssertTrue(actualArgument.viewControllerToPresent is SFSafariViewController)
  }

  func testOpenExternalBrowser() throws {
    launcher.setOpenCompletionHandlerResults(true)

    let url = try XCTUnwrap(URL(string: "https://example.com"))
    plugin.launchURL(url.absoluteString, prefersDeepLink: false, options: nil) { result in
      if case .failure = result {
        XCTFail("error")
      }
    }
    XCTAssertEqual(launcher.openArguments, [
      .init(url: url, options: [:]),
    ])
  }

  func testFailedToOpenExternalBrowser() throws {
    launcher.setOpenCompletionHandlerResults(false)

    let url = try XCTUnwrap(URL(string: "https://example.com"))
    plugin.launchURL(url.absoluteString, prefersDeepLink: false, options: nil) { result in
      if case let .failure(error) = result {
        XCTAssertTrue(error is PigeonError)
        let actualError = error as! PigeonError
        XCTAssertEqual(actualError.code, PigeonError.errorCode)
      } else {
        XCTFail("error")
      }
    }
    XCTAssertEqual(launcher.openArguments, [
      .init(url: url, options: [:]),
    ])
  }

  // MARK: - Deep Linking

  func testDeepLinkToNativeApp() throws {
    launcher.setOpenCompletionHandlerResults(true)

    let url = try XCTUnwrap(URL(string: "https://example.com"))
    plugin.launchURL(url.absoluteString, prefersDeepLink: true, options: nil) { result in
      if case .failure = result {
        XCTFail("error")
      }
    }
    XCTAssertEqual(launcher.openArguments, [
      .init(url: url, options: [.universalLinksOnly: true]),
    ])
    XCTAssertTrue(launcher.presentArguments.isEmpty)
  }

  func testFallBackToExternalBrowser() throws {
    launcher.setOpenCompletionHandlerResults(false, true)

    let url = try XCTUnwrap(URL(string: "https://example.com"))
    plugin.launchURL(url.absoluteString, prefersDeepLink: true, options: nil) { result in
      if case .failure = result {
        XCTFail("error")
      }
    }
    XCTAssertEqual(launcher.openArguments, [
      .init(url: url, options: [.universalLinksOnly: true]),
      .init(url: url, options: [:]),
    ])
    XCTAssertTrue(launcher.presentArguments.isEmpty)
  }

  func testFallBackToSFSafariViewController() throws {
    launcher.setOpenCompletionHandlerResults(false)
    launcher.setPresentCompletionHandlerResults(true)

    let url = try XCTUnwrap(URL(string: "https://example.com"))
    let options = SFSafariViewControllerOptions()
    plugin.launchURL(url.absoluteString, prefersDeepLink: true, options: options) { result in
      if case .failure = result {
        XCTFail("error")
      }
    }
    XCTAssertEqual(launcher.openArguments, [
      .init(url: url, options: [.universalLinksOnly: true]),
    ])
    XCTAssertEqual(launcher.presentArguments.count, 1)

    let actualArgument = try XCTUnwrap(launcher.presentArguments.first)
    XCTAssertTrue(actualArgument.viewControllerToPresent is SFSafariViewController)
  }

  // MARK: - Prewarming

  func testMayLaunchURLs() throws {
    let urls = try [
      XCTUnwrap(URL(string: "https://example.com")),
      XCTUnwrap(URL(string: "https://flutter.dev")),
    ]
    let urlStrings = urls.map(\.absoluteString)
    let expectedSessionId = "test-session-id"
    launcher.setPrewarmConnectionsResults(expectedSessionId)

    do {
      let sessionId = try plugin.mayLaunchURLs(urlStrings)
      XCTAssertEqual(sessionId, expectedSessionId)

      let actualArgument = try XCTUnwrap(launcher.prewarmConnectionsArguments.first)
      XCTAssertEqual(actualArgument.urls, urls)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

  func testMayLaunchURLsReturnsNil() throws {
    let urls = try [XCTUnwrap(URL(string: "https://example.com"))]
    let urlStrings = urls.map(\.absoluteString)
    launcher.setPrewarmConnectionsResults(nil)

    do {
      let sessionId = try plugin.mayLaunchURLs(urlStrings)
      XCTAssertNil(sessionId)

      let actualArgument = try XCTUnwrap(launcher.prewarmConnectionsArguments.first)
      XCTAssertEqual(actualArgument.urls, urls)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }

  // MARK: - Invalidate Session

  func testInvalidateSession() throws {
    do {
      let sessionId = "test-session-id"
      try plugin.invalidateSession(sessionId)

      let actualArgument = try XCTUnwrap(launcher.invalidatePrewarmingSessionArguments.first)
      XCTAssertEqual(actualArgument.sessionId, sessionId)
    } catch {
      XCTFail("Unexpected error: \(error)")
    }
  }
}
