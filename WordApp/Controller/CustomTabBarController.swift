import UIKit
import Foundation

protocol Reloadable {
    func reloadData()
}

class CustomTabBarController: UITabBarController {
    
    var themeModel = DesignThemeListModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func reloadData() {
        let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as! Int
        let barTintColor = themeModel.themeList[selected].theme.fontColor
        let accentColor = themeModel.themeList[selected].theme.accentColor
        self.tabBar.unselectedItemTintColor = UIColor(hex: barTintColor)
        self.tabBar.tintColor = UIColor(hex: accentColor)
    }
}
