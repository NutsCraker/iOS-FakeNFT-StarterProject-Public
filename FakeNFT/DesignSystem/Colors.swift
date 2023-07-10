import UIKit

extension UIColor {
    // Creates color from a hex string
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }
    
    // MARK: - Changeable colors
    
    static var appBlack: UIColor {
        UIColor { (traits) -> UIColor in
            traits.userInterfaceStyle == .light ?
            UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00) :
            UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
        }
    }
    
    static var appWhite: UIColor {
        UIColor { (traits) -> UIColor in
            traits.userInterfaceStyle == .light ?
            UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00) :
            UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
        }
    }
    
    static var appLightGrey: UIColor {
        UIColor { (traits) -> UIColor in
            traits.userInterfaceStyle == .light ?
            UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1.00) :
            UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.00)
        }
    }
    
    // MARK: - Universal colors
    
    static let customGrey = UIColor(red: 0.38, green: 0.36, blue: 0.36, alpha: 1.00)
    static let customRed = UIColor(red: 0.96, green: 0.42, blue: 0.42, alpha: 1.00)
    static let customBackground = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
    static let customGreen = UIColor(red: 0.11, green: 0.62, blue: 0.00, alpha: 1.00)
    static let customBlue = UIColor(red: 0.04, green: 0.52, blue: 1.00, alpha: 1.00)
    static let customBlack = UIColor(red: 0.10, green: 0.11, blue: 0.13, alpha: 1.00)
    static let customWhite = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
    static let customYellow = UIColor(red: 1.00, green: 0.94, blue: 0.05, alpha: 1.00)
    
}
import UIKit

enum Icons: String {
    case trash = "trash-icon"
    case successPay = "success-pay-status"
    case failurePay = "failure-pay-status"
    case sort = "sort-icon"
}

extension UIImage {
    static func asset(_ icon: Icons) -> UIImage {
        UIImage(named: icon.rawValue) ?? UIImage()
    }
}


enum ColorAsset: String {
    case black
    case blackUniversal
    case blue
    case green
    case gray
    case lightGray
    case red
    case white
    case whiteUniversal
    case yellow
}

extension UIColor {
    static func asset(_ colorAsset: ColorAsset) -> UIColor {
        UIColor(named: colorAsset.rawValue) ?? .clear
    }
}
