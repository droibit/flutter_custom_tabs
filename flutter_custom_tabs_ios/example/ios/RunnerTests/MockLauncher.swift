// swiftlint:disable legacy_objc_type
import Foundation
import UIKit
@testable import flutter_custom_tabs_ios

final class MockLauncher: Launcher {
  private var openCompletionHandlerResults = [Bool]()
  private var presentCompletionHandlerResults = [Bool]()
  private var prewarmConnectionsResults = [String?]()
  private(set) var openArguments = [OpenArgument]()
  private(set) var presentArguments = [PresentArgument]()
  private(set) var prewarmConnectionsArguments = [PrewarmConnectionsArgument]()
  private(set) var invalidatePrewarmingSessionArguments = [InvalidatePrewarmingSessionArgument]()

  init() {}

  func setOpenCompletionHandlerResults(_ values: Bool...) {
    openCompletionHandlerResults.append(contentsOf: values)
  }

  func setPresentCompletionHandlerResults(_ values: Bool...) {
    presentCompletionHandlerResults.append(contentsOf: values)
  }

  func setPrewarmConnectionsResults(_ values: String?...) {
    prewarmConnectionsResults.append(contentsOf: values)
  }

  func open(
    _ url: URL,
    options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:],
    completionHandler completion: ((Bool) -> Void)? = nil
  ) {
    openArguments.append(.init(url: url, options: options))

    let opened = openCompletionHandlerResults.removeFirst()
    completion?(opened)
  }

  func present(_ viewControllerToPresent: UIViewController, completion: ((Bool) -> Void)? = nil) {
    presentArguments.append(
      .init(viewControllerToPresent: viewControllerToPresent)
    )

    let presented = presentCompletionHandlerResults.removeFirst()
    completion?(presented)
  }

  func dismissAll(completion: (() -> Void)?) {}

  func prewarmConnections(to urls: [URL]) -> String? {
    prewarmConnectionsArguments.append(.init(urls: urls))
    return prewarmConnectionsResults.removeFirst()
  }

  func invalidatePrewarmingSession(for sessionId: String) {
    invalidatePrewarmingSessionArguments.append(.init(sessionId: sessionId))
  }
}

extension MockLauncher {
  struct OpenArgument {
    let url: URL?
    let options: [UIApplication.OpenExternalURLOptionsKey: Any]
  }

  struct PresentArgument {
    let viewControllerToPresent: UIViewController?
  }

  struct PrewarmConnectionsArgument {
    let urls: [URL]
  }

  struct InvalidatePrewarmingSessionArgument {
    let sessionId: String
  }
}

extension MockLauncher.OpenArgument: Equatable {
  static func == (lhs: MockLauncher.OpenArgument, rhs: MockLauncher.OpenArgument) -> Bool {
    lhs.url == rhs.url && NSDictionary(dictionary: lhs.options).isEqual(to: rhs.options)
  }
}
