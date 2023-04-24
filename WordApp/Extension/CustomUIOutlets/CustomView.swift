import Foundation
import UIKit

// MARK: CustomView
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
        let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as? Int ?? 0
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 1
        if selected == 1 {
            self.layer.backgroundColor = UIColor(hex: backGroundColor, alpha: 0.6).cgColor
            self.layer.shadowColor = UIColor.systemPink.cgColor
            self.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        } else {
            if self.frame.size.height < 60.0 {
                self.layer.cornerRadius = self.frame.size.width * 0.03
            } else {
                self.layer.cornerRadius = self.frame.size.width * 0.05
            }
            self.layer.backgroundColor = UIColor(hex: backGroundColor).cgColor
            self.clipsToBounds = true
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        }
    }
    
    func fetchEncodedThemeData() {
        let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as? Int ?? 0
        backGroundColor = themeModel.themeList[selected].theme.subColor
    }
}
