import UIKit

// MARK: UIImage
extension UIImage {

    convenience init?(color: UIColor, size: CGSize) {
        guard let cgImage = UIGraphicsImageRenderer(size: size).image(actions: { rendererContext in
            rendererContext.cgContext.setFillColor(color.cgColor) // 色を指定
            rendererContext.fill(.init(origin: .zero, size: size)) // 塗りつぶす
        }).cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
    
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
