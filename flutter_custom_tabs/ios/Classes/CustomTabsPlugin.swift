import Flutter
import SafariServices
import UIKit

private let keyURL = "url"
private let keyOption = "safariVCOption"

public class CustomTabsPlugin: NSObject, FlutterPlugin {
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
            let option = arguments[keyOption] as! [String: Any]
            present(withURL: url, option: option, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func present(withURL url: String, option: [String: Any], result: @escaping FlutterResult) {
        if #available(iOS 9.0, *) {
            if let topViewController = UIWindow.keyWindow?.topViewController() {
                let safariViewController = SFSafariViewController.make(url: URL(string: url)!, option: option)
                topViewController.present(safariViewController, animated: true) {
                    result(nil)
                }
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}

private extension UIWindow {
    static var keyWindow: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    func topViewController() -> UIViewController? {
        var topViewController: UIViewController? = rootViewController
        while true {
            if let navigationController = topViewController as? UINavigationController {
                topViewController = navigationController.visibleViewController
                continue
            } else if let tabBarController = topViewController as? UITabBarController,
                      let selected = tabBarController.selectedViewController {
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
