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
                if opened {
                    completion(.success(()))
                } else {
                    self?.launchURL(url, options: options, completion: completion)
                }
            }
        } else {
            launchURL(url, options: options, completion: completion)
        }
    }

    func closeAllIfPossible(completion: @escaping (Result<Void, any Error>) -> Void) {
        launcher.dismissAll {
            completion(.success(()))
        }
    }

    func mayLaunchURLs(_ urlStrings: [String?]) throws -> String? {
        let urls = urlStrings.map { URL(string: $0!)! }
        guard let sessionId = launcher.prewarmConnections(to: urls) else {
            return nil
        }
        return sessionId
    }

    func invalidateSession(_ sessionId: String) throws {
        launcher.invalidatePrewarmingSession(withId: sessionId)
    }

    // MARK: - Private

    private func launchURL(
        _ url: URL,
        options: SFSafariViewControllerOptions?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let options else {
            launcher.open(url) { opened in
                if opened {
                    completion(.success(()))
                } else {
                    completion(.failure(
                        PigeonError(message: "Failed to launch external browser.")
                    ))
                }
            }
            return
        }

        let safariViewController = SFSafariViewController.make(url: url, options: options)
        launcher.present(safariViewController) { presented in
            if presented {
                completion(.success(()))
            } else {
                completion(.failure(
                    PigeonError(message: "Failed to launch SFSafariViewController.")
                ))
            }
        }
    }
}

extension PigeonError {
    convenience init(message: String) {
        self.init(code: Self.errorCode, message: message, details: nil)
    }

    static let errorCode = "LAUNCH_ERROR"
}
