import Flutter
import SafariServices
import UIKit

protocol Launcher {
  func open(
    _ url: URL,
    options: [UIApplication.OpenExternalURLOptionsKey: Any],
    completionHandler completion: ((Bool) -> Void)?
  )

  func present(_ viewControllerToPresent: UIViewController, completion: ((Bool) -> Void)?)

  func dismissAll(completion: (() -> Void)?)

  func prewarmConnections(to urls: [URL]) -> String?

  func invalidatePrewarmingSession(for sessionId: String)
}

extension Launcher {
  func open(
    _ url: URL,
    options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:],
    completionHandler completion: ((Bool) -> Void)? = nil
  ) {
    open(url, options: options, completionHandler: completion)
  }
}

// MARK: - Impl

final class DefaultLauncher: Launcher {
  private var prewarmingTokenCache = [String: Any]()

  func open(
    _ url: URL,
    options: [UIApplication.OpenExternalURLOptionsKey: Any],
    completionHandler completion: ((Bool) -> Void)?
  ) {
    UIApplication.shared.open(url, options: options, completionHandler: completion)
  }

  func present(_ viewControllerToPresent: UIViewController, completion: ((Bool) -> Void)?) {
    guard let topViewController = UIWindow.keyWindow?.topViewController() else {
      completion?(false)
      return
    }
    topViewController.present(viewControllerToPresent, animated: true) {
      completion?(true)
    }
  }

  func dismissAll(completion: (() -> Void)?) {
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

  func prewarmConnections(to urls: [URL]) -> String? {
    guard #available(iOS 15.0, *) else {
      return nil
    }

    let id = UUID().uuidString
    let newToken = SFSafariViewController.prewarmConnections(to: urls)
    prewarmingTokenCache[id] = newToken
    return id
  }

  func invalidatePrewarmingSession(for sessionId: String) {
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
    // iOS 13+
    if #available(iOS 13.0, *) {
      return UIApplication.shared
        .connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .first { $0.activationState == .foregroundActive }?
        .windows
        .first(where: \ .isKeyWindow)
    }
    // iOS 12 fallback
    return UIApplication.shared.windows.first(where: \ .isKeyWindow)
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
