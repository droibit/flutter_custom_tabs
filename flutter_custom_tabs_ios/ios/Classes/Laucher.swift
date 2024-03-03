import UIKit

open class Launcher {
    private var dismissStack = [() -> Void]()

    open func open(
        _ url: URL,
        options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:],
        completionHandler completion: ((Bool) -> Void)? = nil
    ) {
        UIApplication.shared.open(url, options: options, completionHandler: completion)
    }

    open func present(_ viewControllerToPresent: UIViewController, completion: ((Bool) -> Void)? = nil) {
        if let topViewController = UIWindow.keyWindow?.topViewController() {
            dismissStack.append { [weak viewControllerToPresent] in
                viewControllerToPresent?.dismiss(animated: true)
            }
            topViewController.present(viewControllerToPresent, animated: true) {
                completion?(true)
            }
        } else {
            completion?(false)
        }
    }

    open func dismissAll() {
        while let task = dismissStack.popLast() {
            task()
        }
    }
}

private extension UIWindow {
    static var keyWindow: UIWindow? {
        guard let delegate = UIApplication.shared.delegate as? FlutterAppDelegate else {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
        return delegate.window
    }

    func topViewController() -> UIViewController? {
        recursivelyFindTopViewController(from: rootViewController)
    }

    private func recursivelyFindTopViewController(from viewController: UIViewController?) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return recursivelyFindTopViewController(from: navigationController.visibleViewController)
        } else if let tabBarController = viewController as? UITabBarController,
                  let selected = tabBarController.selectedViewController
        {
            return recursivelyFindTopViewController(from: selected)
        } else if let presentedViewController = viewController?.presentedViewController {
            return recursivelyFindTopViewController(from: presentedViewController)
        } else {
            return viewController
        }
    }
}
