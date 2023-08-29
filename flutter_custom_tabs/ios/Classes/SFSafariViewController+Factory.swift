import SafariServices
import UIKit

private let keyPreferredBarTintColor = "preferredBarTintColor"
private let keyPreferredControlTintColor = "preferredControlTintColor"
private let keyBarCollapsingEnabled = "barCollapsingEnabled"
private let keyEntersReaderIfAvailable = "entersReaderIfAvailable"
private let keyDismissButtonStyle = "dismissButtonStyle"

extension SFSafariViewController {    
     static func make(url: URL, option: [String: Any]) -> SFSafariViewController {
         let configuration = SFSafariViewController.Configuration()
         if let barCollapsingEnabled = option[keyBarCollapsingEnabled] as? Bool {
             configuration.barCollapsingEnabled = barCollapsingEnabled
         }
         if let entersReaderIfAvailable = option[keyEntersReaderIfAvailable] as? Bool {
             configuration.entersReaderIfAvailable = entersReaderIfAvailable
         }
         
         let viewController = SFSafariViewController(
             url: url,
             configuration: configuration
         )
        
         if let barTintColorHex = option[keyPreferredBarTintColor] as? String,
            let barTintColor = UIColor(hex: barTintColorHex) {
             viewController.preferredBarTintColor = barTintColor
         }
         if let controlTintColorHex = option[keyPreferredControlTintColor] as? String,
            let controlTintColor = UIColor(hex: controlTintColorHex) {
             viewController.preferredControlTintColor = controlTintColor
         }
        
         if let dismissButtonStyleRawValue = option[keyDismissButtonStyle] as? Int,
            let dismissButtonStyle = SFSafariViewController.DismissButtonStyle(rawValue: dismissButtonStyleRawValue) {
             viewController.dismissButtonStyle = dismissButtonStyle
         }
         return viewController
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
