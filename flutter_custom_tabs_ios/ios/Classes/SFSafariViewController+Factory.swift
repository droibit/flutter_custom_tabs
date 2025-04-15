// swiftlint:disable identifier_name cyclomatic_complexity
import SafariServices
import UIKit.UIColor

private let pageSheetDetentMedium = "medium"
private let pageSheetDetentLarge = "large"

extension SFSafariViewController {
  static func make(url: URL, options: SFSafariViewControllerOptions) -> SFSafariViewController {
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

    if let barTintColorHex = options.preferredBarTintColor {
      viewController.preferredBarTintColor = UIColor(barTintColorHex)
    }
    if let controlTintColorHex = options.preferredControlTintColor {
      viewController.preferredControlTintColor = UIColor(controlTintColorHex)
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
  func configure(with configuration: UISheetPresentationControllerConfiguration) {
    if !configuration.detents.isEmpty {
      detents = configuration.detents.compactMap { detent in
        switch detent {
        case pageSheetDetentMedium: .medium()
        case pageSheetDetentLarge: .large()
        default: nil
        }
      }
    }

    if let largestUndimmedDetentIdentifier = configuration.largestUndimmedDetentIdentifier {
      self.largestUndimmedDetentIdentifier = switch largestUndimmedDetentIdentifier {
      case pageSheetDetentMedium: .medium
      case pageSheetDetentLarge: .large
      default: nil
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
  convenience init(_ hex: Int64) {
    let a = CGFloat((hex & 0xFF000000) >> 24) / 255
    let r = CGFloat((hex & 0x00FF0000) >> 16) / 255
    let g = CGFloat((hex & 0x0000FF00) >> 8) / 255
    let b = CGFloat(hex & 0x000000FF) / 255
    self.init(red: r, green: g, blue: b, alpha: a)
  }
}
