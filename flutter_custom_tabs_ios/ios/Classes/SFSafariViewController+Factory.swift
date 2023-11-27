// swiftlint:disable identifier_name cyclomatic_complexity
import SafariServices
import UIKit.UIColor

private let pageSheetDetentMedium = "medium"
private let pageSheetDetentLarge = "large"

extension SFSafariViewController {
    static func make(url: URL, options: SafariViewControllerOptionsMessage) -> SFSafariViewController {
        let configuration = SFSafariViewController.Configuration()
        if let barCollapsingEnabled = options.barCollapsingEnabled {
            configuration.barCollapsingEnabled = barCollapsingEnabled
        }
        if let entersReaderIfAvailable = options.entersReaderIfAvailable {
            configuration.entersReaderIfAvailable = entersReaderIfAvailable
        }

        let viewController = SFSafariViewController(
            url: url,
            configuration: configuration
        )

        if let barTintColorHex = options.preferredBarTintColor,
           let barTintColor = UIColor(hex: barTintColorHex)
        {
            viewController.preferredBarTintColor = barTintColor
        }
        if let controlTintColorHex = options.preferredControlTintColor,
           let controlTintColor = UIColor(hex: controlTintColorHex)
        {
            viewController.preferredControlTintColor = controlTintColor
        }

        if let dismissButtonStyleRawValue = options.dismissButtonStyle,
           let dismissButtonStyle = SFSafariViewController.DismissButtonStyle(rawValue: Int(dismissButtonStyleRawValue))
        {
            viewController.dismissButtonStyle = dismissButtonStyle
        }

        if let modalPresentationStyleRawValue = options.modalPresentationStyle,
           let modalPresentationStyle = UIModalPresentationStyle(rawValue: Int(modalPresentationStyleRawValue))
        {
            viewController.modalPresentationStyle = modalPresentationStyle

            if #available(iOS 15, *),
               modalPresentationStyle == .pageSheet || modalPresentationStyle == .formSheet,
               let sheetPresentationController = viewController.sheetPresentationController,
               let pageSheetConfiguration = options.pageSheet
            {
                sheetPresentationController.configure(with: pageSheetConfiguration)
            }
        }
        return viewController
    }
}

@available(iOS 15.0, *)
private extension UISheetPresentationController {
    func configure(with configuration: SheetPresentationControllerConfigurationMessage) {
        if !configuration.detents.isEmpty {
            detents = configuration.detents.compactMap { detent in
                switch detent {
                case pageSheetDetentMedium:
                    return .medium()
                case pageSheetDetentLarge:
                    return .large()
                default:
                    return nil
                }
            }
        }
        if let largestUndimmedDetentIdentifier = configuration.largestUndimmedDetentIdentifier {
            switch largestUndimmedDetentIdentifier {
            case pageSheetDetentMedium:
                self.largestUndimmedDetentIdentifier = .medium
            case pageSheetDetentLarge:
                self.largestUndimmedDetentIdentifier = .large
            default:
                break
            }
        }

        if let prefersScrollingExpandsWhenScrolledToEdge = configuration.prefersScrollingExpandsWhenScrolledToEdge {
            self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        }
        if let prefersGrabberVisible = configuration.prefersGrabberVisible {
            self.prefersGrabberVisible = prefersGrabberVisible
        }
        if let preferredCornerRadius = configuration.preferredCornerRadius {
            self.preferredCornerRadius = CGFloat(preferredCornerRadius)
        }
        if let prefersEdgeAttachedInCompactHeight = configuration.prefersEdgeAttachedInCompactHeight {
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
                    a = CGFloat((hexNumber & 0xFF00_0000) >> 24) / 255
                    r = CGFloat((hexNumber & 0x00FF_0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x0000_FF00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000_00FF) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}
