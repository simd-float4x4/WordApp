import Foundation
import UIKit

class CustomUIProgressionBar: UIProgressView {
    
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
        self.progressTintColor = UIColor(hex: color)
    }
    
    func fetchEncodedThemeData() {
        var selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as? Int ?? 0
        color = themeModel.themeList[selected].theme.accentColor
    }
}
