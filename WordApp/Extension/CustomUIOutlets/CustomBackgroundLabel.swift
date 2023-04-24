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
        fetchEncodedThemeData()
        setThemeProperties()
    }
    
    // 保存されたカラーテーマ情報を取得
    func fetchEncodedThemeData() {
        let selected = ud.selectedThemeColorId
        fontColor = themeModel.themeList[selected].theme.fontColor
        fontName = themeModel.themeList[selected].theme.fontName
    }
    
    // CustomUIOutletsにテーマ情報を格納し、再描画
    func setThemeProperties() {
        self.textColor = UIColor(hex: fontColor)
        let fontSize = self.font.pointSize
        self.font = UIFont(name: fontName, size: fontSize)
        self.adjustsFontSizeToFitWidth = true
    }
}
