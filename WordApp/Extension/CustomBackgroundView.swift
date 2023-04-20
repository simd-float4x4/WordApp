import Foundation
import UIKit

class CustomBackgroundView: UIView {
    
    var backGroundColor: String = "FFFFFF"
    var themeModel = DesignThemeListModel.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadProperties()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadProperties()
    }
    
    func loadProperties() {
        fetchEncodedThemeData()
        self.layer.backgroundColor = UIColor(hex: backGroundColor).cgColor
    }
    
    func fetchEncodedThemeData() {
        let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as? Int ?? 0
        backGroundColor = themeModel.themeList[selected].theme.mainColor
        if selected == 1 || selected == 6 || selected == 5 || selected == 7 || selected == 4 {
            setBackGroundImage(imageId: selected)
        }
    }
    
    func setBackGroundImage(imageId: Int) {
        let imageUrl = themeModel.themeList[imageId].theme.backgroundImageUrl
        let image1: UIImage = UIImage(named: imageUrl)!
        let imageView = UIImageView(image: image1)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = self.frame
        self.insertSubview(imageView, at: 0)
    }
}
