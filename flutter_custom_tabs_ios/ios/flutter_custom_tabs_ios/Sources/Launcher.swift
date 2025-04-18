import Flutter
import SafariServices
import UIKit

open class Launcher {
  private var prewarmingTokenCache = [String: Any]()

  open func open(
    _ url: URL,
    options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:],
    completionHandler completion: ((Bool) -> Void)? = nil
  ) {
    UIApplication.shared.open(url, options: options, completionHandler: completion)
  }

  open func present(_ viewControllerToPresent: UIViewController, completion: ((Bool) -> Void)? = nil) {
    if let topViewController = UIWindow.keyWindow?.topViewController() {
      topViewController.present(viewControllerToPresent, animated: true) {
        completion?(true)
      }
    } else {
      completion?(false)
    }
  }

  open func dismissAll(completion: (() -> Void)? = nil) {
    guard let rootViewController = UIWindow.keyWindow?.rootViewController else {
      completion?()
      return
    }

    var presentedViewController = rootViewController.presentedViewController
    var presentedViewControllers = [UIViewController]()
    while presentedViewController != nil {
      if presentedViewController is SFSafariViewController {
        presentedViewControllers.append(presentedViewController!)
      }
      presentedViewController = presentedViewController!.presentedViewController
    }
    recursivelyDismissViewControllers(
      presentedViewControllers,
      animated: true,
      completion: completion
    )
  }

  open func prewarmConnections(to urls: [URL]) -> String? {
    guard #available(iOS 15.0, *) else {
      return nil
    }

    let id = UUID().uuidString
    let newToken = SFSafariViewController.prewarmConnections(to: urls)
    prewarmingTokenCache[id] = newToken
    return id
  }

  open func invalidatePrewarmingSession(withId sessionId: String) {
    guard #available(iOS 15.0, *) else {
      return
    }

    guard
      let id = UUID(uuidString: sessionId)?.uuidString,
      let token = prewarmingTokenCache[id] as? SFSafariViewController.PrewarmingToken
    else {
      return
    }
    token.invalidate()
    prewarmingTokenCache.removeValue(forKey: id)
  }
}

private extension UIWindow {
  static var keyWindow: UIWindow? {
    guard let delegate = UIApplication.shared.delegate as? FlutterAppDelegate else {
      return UIApplication.shared.windows.first(where: \.isKeyWindow)
    }
    return delegate.window
  }

  func topViewController() -> UIViewController? {
    recursivelyFindTopViewController(from: rootViewController)
  }
}

private func recursivelyFindTopViewController(from viewController: UIViewController?) -> UIViewController? {
  if let navigationController = viewController as? UINavigationController {
    recursivelyFindTopViewController(from: navigationController.visibleViewController)
  } else if let tabBarController = viewController as? UITabBarController,
            let selected = tabBarController.selectedViewController
  {
    recursivelyFindTopViewController(from: selected)
  } else if let presentedViewController = viewController?.presentedViewController {
    recursivelyFindTopViewController(from: presentedViewController)
  } else {
    viewController
  }
}

private func recursivelyDismissViewControllers(
  _ viewControllers: [UIViewController],
  animated flag: Bool,
  completion: (() -> Void)? = nil
) {
  var viewControllers = viewControllers
  guard let vc = viewControllers.popLast() else {
    completion?()
    return
  }

  vc.dismiss(animated: flag) {
    if viewControllers.isEmpty {
      completion?()
    } else {
      recursivelyDismissViewControllers(viewControllers, animated: flag, completion: completion)
    }
  }
}
