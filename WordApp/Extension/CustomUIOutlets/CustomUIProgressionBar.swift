import Foundation
import UIKit

// MARK: CustomUIProgressionBar
class CustomUIProgressionBar: UIProgressView {
    // バーのカラー：初期値
    var barAccentColor: String = "000000"
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
        getBarAccentColor()
        setBarAccentColor()
    }
    
    // 保存されたカラーテーマ情報を取得
    func fetchSavedThemeData() {
        // UdからテーマIdを取得
        selectedThemeId = ud.selectedThemeColorId
    }
    
    //　バーのアクセントカラーを取得する
    func getBarAccentColor() {
        barAccentColor = themeModel.themeList[selectedThemeId].theme.accentColor
    }
    
    //　バーのアクセントカラーをセットする
    func setBarAccentColor() {
        self.progressTintColor = UIColor(hex: barAccentColor)
    }
}
