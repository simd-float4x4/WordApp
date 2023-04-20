import UIKit
import Foundation

class CustomBackgroundLabel: UILabel {
    
    var fontColor: String = "000000"
    var fontName: String = ""
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
        self.textColor = UIColor(hex: fontColor)
        let fontSize = self.font.pointSize
        self.font = UIFont(name: fontName, size: fontSize)
        self.adjustsFontSizeToFitWidth = true
    }
    
    func fetchEncodedThemeData() {
        let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as? Int ?? 0
        fontColor = themeModel.themeList[selected].theme.fontColor
        fontName = themeModel.themeList[selected].theme.fontName
    }
}
