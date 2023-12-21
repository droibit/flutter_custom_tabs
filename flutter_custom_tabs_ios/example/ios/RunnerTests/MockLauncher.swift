// swiftlint:disable legacy_objc_type
import Foundation
@testable import flutter_custom_tabs_ios

class MockLauncher: Launcher {
    private var openCompletionHandlerResults = [Bool]()
    private(set) var openArgumentStack = [OpenArgument]()
    private(set) var presentArgumentStack = [PresentArgument]()

    override init() {}

    func setOpenCompletionHandlerResults(_ values: Bool...) {
        openCompletionHandlerResults.append(contentsOf: values)
    }

    override func open(
        _ url: URL,
        options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:],
        completionHandler completion: ((Bool) -> Void)? = nil
    ) {
        openArgumentStack.append(.init(url: url, options: options))

        let opened = openCompletionHandlerResults.removeFirst()
        completion?(opened)
    }

    override func present(_ viewControllerToPresent: UIViewController, completion: (() -> Void)? = nil) {
        presentArgumentStack.append(
            .init(viewControllerToPresent: viewControllerToPresent)
        )
        completion?()
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
}

extension MockLauncher.OpenArgument: Equatable {
    static func == (lhs: MockLauncher.OpenArgument, rhs: MockLauncher.OpenArgument) -> Bool {
        lhs.url == rhs.url && NSDictionary(dictionary: lhs.options).isEqual(to: rhs.options)
    }
}
