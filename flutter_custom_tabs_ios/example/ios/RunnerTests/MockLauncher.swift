// swiftlint:disable legacy_objc_type
import Foundation
@testable import flutter_custom_tabs_ios

class MockLauncher: Launcher {
  private var openCompletionHandlerResults = [Bool]()
  private var presentCompletionHandlerResults = [Bool]()
  private var prewarmConnectionsResults = [String?]()
  private(set) var openArguments = [OpenArgument]()
  private(set) var presentArguments = [PresentArgument]()
  private(set) var prewarmConnectionsArguments = [PrewarmConnectionsArgument]()
  private(set) var invalidatePrewarmingSessionArguments = [InvalidatePrewarmingSessionArgument]()

  override init() {}

  func setOpenCompletionHandlerResults(_ values: Bool...) {
    openCompletionHandlerResults.append(contentsOf: values)
  }

  func setPresentCompletionHandlerResults(_ values: Bool...) {
    presentCompletionHandlerResults.append(contentsOf: values)
  }

  func setPrewarmConnectionsResults(_ values: String?...) {
    prewarmConnectionsResults.append(contentsOf: values)
  }

  override func open(
    _ url: URL,
    options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:],
    completionHandler completion: ((Bool) -> Void)? = nil
  ) {
    openArguments.append(.init(url: url, options: options))

    let opened = openCompletionHandlerResults.removeFirst()
    completion?(opened)
  }

  override func present(_ viewControllerToPresent: UIViewController, completion: ((Bool) -> Void)? = nil) {
    presentArguments.append(
      .init(viewControllerToPresent: viewControllerToPresent)
    )

    let presented = presentCompletionHandlerResults.removeFirst()
    completion?(presented)
  }

  override func prewarmConnections(to urls: [URL]) -> String? {
    prewarmConnectionsArguments.append(.init(urls: urls))
    return prewarmConnectionsResults.removeFirst()
  }

  override func invalidatePrewarmingSession(withId sessionId: String) {
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
