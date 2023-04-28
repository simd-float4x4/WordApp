import UIKit
import Foundation

// MARK: CustomBackgroundLabel
class CustomBackgroundLabel: UILabel {
    // フォントカラー：初期値
    var fontColor: String = "000000"
    // フォント名：初期値
    var fontName: String = ""
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
        //　テーマ名を取得する
        let themeName = getThemeName()
        //　テーマ名一覧を取得する
        let themeNameList = ThemeName().list
        //　テーマ名を一覧から取得する
        guard let normal = themeNameList["normal"] else { return }
        fontColor = themeModel.themeList[selectedThemeId].theme.fontColor
        fontName = themeModel.themeList[selectedThemeId].theme.fontName
        if themeName == normal {
            //　フォントカラーをセットする
            setBackgroundColorCaseNormal(mainModeColor: UIColor(hex: fontColor), darkModeColor: UIColor(hex: "F0F0F0"))
        } else {
            //　フォントカラーをセットする
            setFontColor()
        }
        // CustomUIOutletsにテーマ情報を格納し、再描画
        setThemeProperties()
    }
    
    //　テーマの名前を取得する
    func getThemeName() -> String{
        // テーマの名称を取得する
        let themeName = themeModel.themeList[selectedThemeId].theme.name
        return themeName
    }
    
    // CustomUIOutletsにテーマ情報を格納し、再描画
    func setThemeProperties() {
        //　フォントサイズを取得する
        let fontSize = self.font.pointSize
        //　フォントを設定する
        self.font = UIFont(name: fontName, size: fontSize)
        //　フォントを自動調整する
        self.adjustsFontSizeToFitWidth = true
    }
    
    //　フォントカラーをセットする
    func setFontColor() {
        self.textColor = UIColor(hex: fontColor)
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
        self.textColor = dynamicColor
    }
}
