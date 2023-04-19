import Foundation
import UIKit

class CustomView: UIView {
    
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
        self.layer.cornerRadius = self.frame.size.width * 0.05
        self.clipsToBounds = true
        self.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 1
        self.layer.backgroundColor = UIColor(hex: backGroundColor).cgColor
    }
    
    func fetchEncodedThemeData() {
        let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as! Int
        backGroundColor = themeModel.themeList[selected].theme.subColor
    }
}

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
        let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as! Int
        backGroundColor = themeModel.themeList[selected].theme.mainColor
    }
}

class CustomBackgroundLabel: UILabel {
    
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
        self.textColor = UIColor(hex: fontColor)
    }
    
    func fetchEncodedThemeData() {
        let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as! Int
        fontColor = themeModel.themeList[selected].theme.fontColor
    }
}
