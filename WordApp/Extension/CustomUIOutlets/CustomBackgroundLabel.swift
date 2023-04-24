import UIKit
import Foundation

// MARK: CustomBackgroundLabel
class CustomBackgroundLabel: UILabel {
    // フォントカラー：初期値
    var fontColor: String = "000000"
    // フォント名：初期値
    var fontName: String = ""
    // テーマモデル
    var themeModel = DesignThemeListModel.shared
    // UserDefaults
    let ud = UserDefaults.standard
    // テーマモデルID
    var selectedThemeId: Int = 0
    
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
        setThemeProperties()
    }
    
    // 保存されたカラーテーマ情報を取得
    func fetchSavedThemeData() {
        selectedThemeId = ud.selectedThemeColorId
        fontColor = themeModel.themeList[selectedThemeId].theme.fontColor
        fontName = themeModel.themeList[selectedThemeId].theme.fontName
    }
    
    // CustomUIOutletsにテーマ情報を格納し、再描画
    func setThemeProperties() {
        self.textColor = UIColor(hex: fontColor)
        let fontSize = self.font.pointSize
        self.font = UIFont(name: fontName, size: fontSize)
        self.adjustsFontSizeToFitWidth = true
    }
}
