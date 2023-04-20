import UIKit
import Foundation

class CustomUISegmentedControl: UISegmentedControl {
    
    var color: String = "0000FF"
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
        color = themeModel.themeList[selected].theme.accentColor
        let ud = UserDefaults.standard
        let getQuizSelectionCount = ud.value(forKey: "maximumQuizSelectionCount") as? Int ?? 0
        let getMaximumQuizCount = ud.value(forKey: "maximumQuizCount") as? Int ?? 0
        // 選択時の背景色（iOS13から選択時の背景はselectedSegmentTintColorで指定するようになりました）
        if #available(iOS 13.0, *) {
            self.selectedSegmentTintColor = UIColor(hex: color)
        }
        else {
            self.tintColor = UIColor(hex: color)
        }
        // 文字色
        let bgColor = themeModel.themeList[selected].theme.fontColor
        self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor(hex: bgColor)], for: .selected)
        self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor(hex: "000000")], for: .normal)
        self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor(hex: "CCCCCC")], for: .disabled)
        if self.tag == 1 {
            self.selectedSegmentIndex = getQuizSelectionCount
        } else if self.tag == 2 {
            self.selectedSegmentIndex = getMaximumQuizCount
        }
    }
    
    func fetchEncodedThemeData() {
        let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as? Int ?? 0
        color = themeModel.themeList[selected].theme.accentColor
    }
}
