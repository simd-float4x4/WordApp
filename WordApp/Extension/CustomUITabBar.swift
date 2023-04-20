import Foundation
import UIKit

class CustomUITabBar: UITabBar {
    
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
        // fetchEncodedThemeData()
        self.unselectedItemTintColor = UIColor(hex: "BBBBBB")
        // self.tintColor = UIColor(hex: "CC3333")
        
    }
    
//    func fetchEncodedThemeData() {
//        let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as! Int
//        let barTintColor = themeModel.themeList[selected].theme.fontColor
//        let accentColor = themeModel.themeList[selected].theme.accentColor
//    }
}
