import UIKit
import Foundation

// MARK: CustomTabBar
class CustomTabBar: UITabBar {
    // フォントカラー：初期値
    var tabBarBackgroundColor: String = "F7F7F7"
    // フォントカラー：初期値
    var tabBarComplementalBackgroundColor: String = "171A23"
    // テーマモデルID
    var selectedThemeId: Int = 0
    // テーマモデル
    var themeModel = DesignThemeListModel.shared
    // UserDefaults
    let ud = UserDefaults.standard
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadProperties()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadProperties()
    }
    
    //　呼ばれたときにロードするメソッド
    func loadProperties() {
        fetchSavedThemeData()
    }
    
    // 保存されたカラーテーマ情報を取得
    func fetchSavedThemeData() {
        selectedThemeId = ud.selectedThemeColorId
        //　フォントカラーをセットする
        setBackgroundColorCaseNormal(mainModeColor: UIColor(hex: tabBarBackgroundColor), darkModeColor: UIColor(hex: tabBarComplementalBackgroundColor))
    }
    
    //　ノーマルテーマのみダークモード対応
    func setBackgroundColorCaseNormal(mainModeColor: UIColor, darkModeColor: UIColor) {
        let dynamicColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
           if traitCollection.userInterfaceStyle == .dark {
               return darkModeColor
           } else {
               return mainModeColor
           }
        }
        self.backgroundColor = dynamicColor
    }
}
