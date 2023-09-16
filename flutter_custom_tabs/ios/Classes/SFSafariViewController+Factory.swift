import SafariServices
import UIKit.UIColor

private let keyPreferredBarTintColor = "preferredBarTintColor"
private let keyPreferredControlTintColor = "preferredControlTintColor"
private let keyBarCollapsingEnabled = "barCollapsingEnabled"
private let keyEntersReaderIfAvailable = "entersReaderIfAvailable"
private let keyDismissButtonStyle = "dismissButtonStyle"
private let keyModalPresentationStyle = "modalPresentationStyle"
private let keyPageSheet = "pageSheet"
private let keyPageSheetDetents = "detents"
private let keyPageSheetLargestUndimmedDetentIdentifier = "largestUndimmedDetentIdentifier"
private let keyPageSheetPrefersScrollingExpandsWhenScrolledToEdge = "prefersScrollingExpandsWhenScrolledToEdge"
private let keyPageSheetPrefersGrabberVisible = "prefersGrabberVisible"
private let keyPageSheetPrefersEdgeAttachedInCompactHeight = "prefersEdgeAttachedInCompactHeight"
private let keyPageSheetPreferredCornerRadius = "preferredCornerRadius"

private let pageSheetDetentMedium = "medium"
private let pageSheetDetentLarge = "large"

extension SFSafariViewController {
    static func make(url: URL, options: [String: Any]) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        if let barCollapsingEnabled = options[keyBarCollapsingEnabled] as? Bool {
            configuration.barCollapsingEnabled = barCollapsingEnabled
        }
        if let entersReaderIfAvailable = options[keyEntersReaderIfAvailable] as? Bool {
            configuration.entersReaderIfAvailable = entersReaderIfAvailable
        }

        let viewController = SFSafariViewController(
            url: url,
            configuration: configuration
        )

        if let barTintColorHex = options[keyPreferredBarTintColor] as? String,
           let barTintColor = UIColor(hex: barTintColorHex)
        {
            viewController.preferredBarTintColor = barTintColor
        }
        if let controlTintColorHex = options[keyPreferredControlTintColor] as? String,
           let controlTintColor = UIColor(hex: controlTintColorHex)
        {
            viewController.preferredControlTintColor = controlTintColor
        }

        if let dismissButtonStyleRawValue = options[keyDismissButtonStyle] as? Int,
           let dismissButtonStyle = SFSafariViewController.DismissButtonStyle(rawValue: dismissButtonStyleRawValue)
        {
            viewController.dismissButtonStyle = dismissButtonStyle
        }

        if let modalPresentationStyleRawValue = options[keyModalPresentationStyle] as? Int,
           let modalPresentationStyle = UIModalPresentationStyle(rawValue: modalPresentationStyleRawValue)
        {
            viewController.modalPresentationStyle = modalPresentationStyle

            if #available(iOS 15, *),
               let pageSheetConfig = options[keyPageSheet] as? [String: Any],
               modalPresentationStyle == .pageSheet || modalPresentationStyle == .formSheet,
               let sheet = viewController.sheetPresentationController
            {
                sheet.configure(with: pageSheetConfig)
            }
        }
        return viewController
    }
}

@available(iOS 15.0, *)
private extension UISheetPresentationController {
    func configure(with configuration: [String: Any]) {
        if let rawDetents = configuration[keyPageSheetDetents] as? [String], !rawDetents.isEmpty {
            self.detents = rawDetents.compactMap {
                switch $0 {
                case pageSheetDetentMedium:
                    return .medium()
                case pageSheetDetentLarge:
                    return .large()
                default:
                    return nil
                }
            }
        }
        if let largestUndimmedDetentIdentifier = configuration[keyPageSheetLargestUndimmedDetentIdentifier] as? String {
            switch largestUndimmedDetentIdentifier {
            case pageSheetDetentMedium:
                self.largestUndimmedDetentIdentifier = .medium
            case pageSheetDetentLarge:
                self.largestUndimmedDetentIdentifier = .large
            default:
                break
            }
        }
        if let prefersScrollingExpandsWhenScrolledToEdge = configuration[keyPageSheetPrefersScrollingExpandsWhenScrolledToEdge] as? Bool {
            self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        }
        if let prefersGrabberVisible = configuration[keyPageSheetPrefersGrabberVisible] as? Bool {
            self.prefersGrabberVisible = prefersGrabberVisible
        }
        if let preferredCornerRadius = configuration[keyPageSheetPreferredCornerRadius] as? Float {
            self.preferredCornerRadius = CGFloat(preferredCornerRadius)
        }
        if let prefersEdgeAttachedInCompactHeight = configuration[keyPageSheetPrefersEdgeAttachedInCompactHeight] as? Bool {
            self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        }
    }
}

private extension UIColor {
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    a = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}
