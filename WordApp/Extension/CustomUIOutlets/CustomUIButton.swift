import Foundation
import UIKit

// MARK: CustomUIButton
class CustomUIButton: UIButton {
    // 背景色のカラー：初期値
    var backGroundColor: String = "FF0000"
    // サブ背景色のカラー：初期値
    var backGroundSubColor: String = "FF0000"
    // フォントカラー：初期値
    var fontColor: String = "FF0000"
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
        setColors()
    }
    
    // カラーを取得する
    func setColors() {
        fetchSavedThemeData()
        backGroundColor = themeModel.themeList[selectedThemeId].theme.mainColor
        backGroundSubColor = themeModel.themeList[selectedThemeId].theme.complementalColor
        fontColor = themeModel.themeList[selectedThemeId].theme.fontColor
        let themeName = getThemeName()
        if themeName == "ブルーソーダ" { changetitleLabelColor() }
        changeDesignStyle()
    }
    
    // 保存されたカラーテーマ情報を取得
    func fetchSavedThemeData() {
        selectedThemeId = ud.selectedThemeColorId
    }
    
    //　テーマの名前を取得する
    func getThemeName() -> String{
        // テーマの名称を取得する
        let themeName = DesignThemeListModel.shared.themeList[selectedThemeId].theme.name
        return themeName
    }
    
    // 特定のテーマの時にtitleLabelの色を変更する
    func changetitleLabelColor() {
        fontColor  = themeModel.themeList[selectedThemeId].theme.complementalFontColor
    }
    
    //　デザインを変更する
    func changeDesignStyle() {
        makeCornerRadius()
        setColor()
        makeContentAlignmentCenter()
    }
    
    //　角を丸くする
    func makeCornerRadius() {
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
    
    // カラーを設定する
    func setColor() {
        self.layer.backgroundColor = UIColor(hex: backGroundColor).cgColor
        self.titleLabel?.tintColor = UIColor(hex: fontColor)
    }
    
    //　中央寄せにする
    func makeContentAlignmentCenter() {
        self.contentHorizontalAlignment = .center
    }
}
