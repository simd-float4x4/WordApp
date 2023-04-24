import UIKit

// MARK: UIImage
extension UIImage {
    // UIImageを背景色で塗りつぶすためのメソッド
    /// - Parameters:
        ///   - color: 色を指定。
        ///   - size: 大きさを指定。
    convenience init?(color: UIColor, size: CGSize) {
        guard let cgImage = UIGraphicsImageRenderer(size: size).image(actions: { rendererContext in
            // 引数で渡された色を指定する
            rendererContext.cgContext.setFillColor(color.cgColor)
            // 指定された色で塗りつぶす
            rendererContext.fill(.init(origin: .zero, size: size))
        }).cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
    
    // UIImageを複数枚合成するためのメソッド
    /// - Parameters:
        ///   - image: 画像。この画像は、配列で渡すことで複数枚併用することができる。
    func composite(image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))

        // 画像を真ん中に重ねる
        let rect = CGRect(x: (self.size.width - image.size.width)/2,
                          y: (self.size.height - image.size.height)/2,
                          width: image.size.width,
                          height: image.size.height)
        image.draw(in: rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}
