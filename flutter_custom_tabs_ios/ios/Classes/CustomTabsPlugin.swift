import Flutter
import SafariServices
import UIKit

private let keyURL = "url"
private let keyOptions = "safariVCOptions"

public class CustomTabsPlugin: NSObject, FlutterPlugin {
    private var dismissStack = [() -> Void]()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "plugins.flutter.droibit.github.io/custom_tabs",
            binaryMessenger: registrar.messenger()
        )
        let instance = CustomTabsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "launch":
            let arguments = call.arguments as! [String: Any]
            let url = arguments[keyURL] as! String
            let options = arguments[keyOptions] as! [String: Any]
            present(withURL: url, options: options, result: result)
        case "closeAllIfPossible":
            dismissAllIfPossible(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func present(withURL url: String, options: [String: Any], result: @escaping FlutterResult) {
        if let topViewController = UIWindow.keyWindow?.topViewController() {
            let safariViewController = SFSafariViewController.make(url: URL(string: url)!, options: options)
            dismissStack.append { [weak safariViewController] in
                safariViewController?.dismiss(animated: true)
            }
            topViewController.present(safariViewController, animated: true) {
                result(nil)
            }
        }
    }

    private func dismissAllIfPossible(result: @escaping FlutterResult) {
        while let task = dismissStack.popLast() {
            task()
        }
        result(nil)
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
