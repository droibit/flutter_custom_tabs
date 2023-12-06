import Flutter
import SafariServices

public class CustomTabsPlugin: NSObject, FlutterPlugin, CustomTabsApi {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let plugin = CustomTabsPlugin()
        CustomTabsApiSetup.setUp(binaryMessenger: registrar.messenger(), api: plugin)
        registrar.publish(plugin)
    }

    private var dismissStack = [() -> Void]()

    func launchURL(
        _ urlString: String,
        prefersDeepLink: Bool,
        options: SafariViewControllerOptionsMessage?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let url = URL(string: urlString)!
        if prefersDeepLink {
            UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { [weak self] opened in
                if !opened {
                    self?.launchURL(url, options: options, completion: completion)
                }
            }
        } else {
            launchURL(url, options: options, completion: completion)
        }
    }

    func closeAllIfPossible() throws {
        while let task = dismissStack.popLast() {
            task()
        }
    }

    // MARK: - Private

    private func launchURL(
        _ url: URL,
        options: SafariViewControllerOptionsMessage?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let options else {
            UIApplication.shared.open(url) { _ in
                completion(.success(()))
            }
            return
        }

        if let topViewController = UIWindow.keyWindow?.topViewController() {
            let safariViewController = SFSafariViewController.make(url: url, options: options)
            dismissStack.append { [weak safariViewController] in
                safariViewController?.dismiss(animated: true)
            }
            topViewController.present(safariViewController, animated: true) {
                completion(.success(()))
            }
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
