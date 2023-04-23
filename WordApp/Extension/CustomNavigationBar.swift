import UIKit

class CustomNavigationBar: UINavigationBar {
    var color: String = "000000"
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
//        self.tintColor = UIColor(hex: color)
//        self.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(hex: color)]
    }
    
    func fetchEncodedThemeData() {
        let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as? Int ?? 0
        if selected == 1 || selected == 3 || selected == 6 || selected == 7 {
            let color = themeModel.themeList[selected].theme.subColor
            self.barTintColor = UIColor(hex: color)
        }
    }
}
