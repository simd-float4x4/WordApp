import UIKit
import Foundation

class CustomNavigationItem: UIBarButtonItem {
    
    var color: String = "0000FF"
    var themeModel = DesignThemeListModel.shared

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadProperties()
    }
    
    func loadProperties() {
        fetchEncodedThemeData()
        // self.tintColor = UIColor(hex: color)
        
    }
    
    func fetchEncodedThemeData() {
        // let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as! Int
        // color = themeModel.themeList[selected].theme.fontColor
    }
}
