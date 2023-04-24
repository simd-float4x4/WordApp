import Foundation
import UIKit

// MARK: CustomView
class CustomView: UIView {
    //　透明度
    var backgroundTransparency: [CGFloat] = [0.6, 1.0]
    //　ピンク
    var pinkColor = UIColor.systemPink
    // 黒
    var blackColor = UIColor.black
    // 背景色のカラー：初期値
    var customViewBackgroundColor: String = "FFFFFF"
    // テーマモデルID
    var selectedThemeId: Int = 0
    // テーマモデル
    var themeModel = DesignThemeListModel.shared
    //　影の透明度
    var shadowOpacity: Float = 1.0
    //　影のズレ
    var shadowOffsetXandY: [CGFloat] =  [3.0, 3.0]
    //　影の半径
    var shadowRadius: CGFloat = 1.0
    //　ボタンの角丸閾値
    var buttonCornerRadiusThreshold = 60.0
    //　ボタンの角丸比率
    var buttonCornerRadiusProportion: [CGFloat] =  [0.03, 0.05]
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
        setDefaultBackgroundColor()
        reloadCustomView()
    }
    
    // viewを更新する
    func reloadCustomView() {
        let themeName = getThemeName()
        setCommonShadowProperties()
        if themeName == "スペース" {
            setBackgroundColor(alpha: backgroundTransparency[0])
            setShadowColor(color: pinkColor)
        } else {
            setCornerRadius()
            setBackgroundColor(alpha: backgroundTransparency[1])
            setShadowColor(color: blackColor)
            self.clipsToBounds = true
        }
        setShadowOffsets(w: shadowOffsetXandY[0], h: shadowOffsetXandY[1])
    }
    
    //　背景色をセットする
    func setBackgroundColor(alpha: CGFloat) {
        self.layer.backgroundColor = UIColor(hex: customViewBackgroundColor, alpha: alpha).cgColor
    }
    
    // 影の色をセットする
    func setShadowColor(color: UIColor) {
        self.layer.shadowColor = color.cgColor
    }
    
    //　影の距離をセットする
    func setShadowOffsets(w: CGFloat, h: CGFloat) {
        self.layer.shadowOffset = CGSize(width: w, height: h)
    }
    
    // 影の透明度と半径をセットする
    func setCommonShadowProperties() {
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
    }
    
    // 角丸をセットする
    func setCornerRadius() {
        if self.frame.size.height < buttonCornerRadiusThreshold {
            self.layer.cornerRadius = self.frame.size.width * buttonCornerRadiusProportion[0]
        } else {
            self.layer.cornerRadius = self.frame.size.width * buttonCornerRadiusProportion[1]
        }
    }
    
    // 保存されたカラーテーマ情報を取得
    func fetchSavedThemeData() {
        selectedThemeId = ud.selectedThemeColorId
    }
    
    //　背景色をセットする
    func setDefaultBackgroundColor() {
        customViewBackgroundColor = themeModel.themeList[selectedThemeId].theme.subColor
    }
    
    //　テーマの名前を取得する
    func getThemeName() -> String{
        // テーマの名称を取得する
        let themeName = DesignThemeListModel.shared.themeList[selectedThemeId].theme.name
        return themeName
    }
}
