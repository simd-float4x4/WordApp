import UIKit

// MARK: UIColor
extension UIColor {    
    // UIColor(hex: "#COLOR_CODE")で、カラーコードを指定できるようにする
    /// - Parameters:
        ///   - hex: カラーコード。#FFFFFF のように指定。
        ///   - alpha: 透明度。0.0~1.0 のように指定。
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
}
