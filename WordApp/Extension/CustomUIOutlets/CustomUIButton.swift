import Foundation
import UIKit

// MARK: CustomUIButton
class CustomUIButton: UIButton {
    
    var backGroundColor: String = "FF0000"
    var backgroundSubColor: String = "FFFFFF"
    var fontColor: String = "000000"
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
        
    }
    
    func fetchEncodedThemeData() {
        let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as? Int ?? 0
        backGroundColor = themeModel.themeList[selected].theme.mainColor
        backgroundSubColor = themeModel.themeList[selected].theme.complementalColor
        fontColor = themeModel.themeList[selected].theme.fontColor
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        self.layer.backgroundColor = UIColor(hex: backGroundColor).cgColor
        self.contentHorizontalAlignment = .center
        self.titleLabel?.tintColor = UIColor(hex: fontColor)
        if selected == 4 {
            fontColor  = themeModel.themeList[selected].theme.complementalFontColor
            self.titleLabel?.tintColor = UIColor(hex: fontColor)
            
        }
    }
}

// UIButtonタップ時に背景色を指定できるようにする（UIColorと併用）
extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let image = color.image
        setBackgroundImage(image, for: state)
    }
}
