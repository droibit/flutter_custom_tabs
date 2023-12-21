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

    open func present(_ viewControllerToPresent: UIViewController, completion: (() -> Void)? = nil) {
        if let topViewController = UIWindow.keyWindow?.topViewController() {
            dismissStack.append { [weak viewControllerToPresent] in
                viewControllerToPresent?.dismiss(animated: true)
            }
            topViewController
                .present(viewControllerToPresent, animated: true, completion: completion)
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
        var topViewController: UIViewController? = rootViewController
        while true {
            if let navigationController = topViewController as? UINavigationController {
                topViewController = navigationController.visibleViewController
                continue
            } else if let tabBarController = topViewController as? UITabBarController,
                      let selected = tabBarController.selectedViewController
            {
                topViewController = selected
                continue
            } else if let presentedViewController = topViewController?.presentedViewController {
                topViewController = presentedViewController
            } else {
                break
            }
        }
        return topViewController
    }
}
