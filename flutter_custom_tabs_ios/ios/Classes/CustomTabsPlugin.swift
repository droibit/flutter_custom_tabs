import Flutter
import SafariServices

public class CustomTabsPlugin: NSObject, FlutterPlugin, CustomTabsApi {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let plugin = CustomTabsPlugin()
        CustomTabsApiSetup.setUp(binaryMessenger: registrar.messenger(), api: plugin)
        registrar.publish(plugin)
    }

    private let launcher: Launcher

    init(launcher: Launcher = Launcher()) {
        self.launcher = launcher
    }

    func launchURL(
        _ urlString: String,
        prefersDeepLink: Bool,
        options: SFSafariViewControllerOptions?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let url = URL(string: urlString)!
        if prefersDeepLink {
            launcher.open(url, options: [.universalLinksOnly: true]) { [weak self] opened in
                if !opened {
                    self?.launchURL(url, options: options, completion: completion)
                }
            }
        } else {
            launchURL(url, options: options, completion: completion)
        }
    }

    func closeAllIfPossible() throws {
        launcher.dismissAll()
    }

    // MARK: - Private

    private func launchURL(
        _ url: URL,
        options: SFSafariViewControllerOptions?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let options else {
            launcher.open(url) { _ in
                completion(.success(()))
            }
            return
        }

        let safariViewController = SFSafariViewController.make(url: url, options: options)
        launcher.present(safariViewController, animated: true) {
            completion(.success(()))
        }
    }
}
