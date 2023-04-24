import Foundation
import UIKit

// MARK: CustomBackgroundView
class CustomBackgroundView: UIView {
    // 背景色
    var backGroundColor: String = "FFFFFF"
    // テーマモデル
    var themeModel = DesignThemeListModel.shared
    // UserDefaults
    let ud = UserDefaults.standard
    // 画像を使用するか？
    var useImage: Bool = false
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
        setBackgroundColor()
    }
    
    // 保存されたカラーテーマ情報を取得
    func fetchSavedThemeData() {
        // UdからテーマIdを取得
        selectedThemeId = ud.selectedThemeColorId
        // 背景色を取得
        backGroundColor = themeModel.themeList[selectedThemeId].theme.mainColor
        // 画像を使用するか確認
        useImage = themeModel.themeList[selectedThemeId].theme.useImage
        // trueなら画像を更新
        if useImage == true{
            setBackGroundImage(selectedThemeId: selectedThemeId)
        }
    }
    
    // CustomBackgroundViewにテーマ情報を格納し、画像周りを再描画（特定テーマのみ）
    func setBackGroundImage(selectedThemeId: Int) {
        let imageUrl = themeModel.themeList[selectedThemeId].theme.backgroundImageUrl
        // imageUrlからimageを取得
        let fetchedImage: UIImage = UIImage(named: imageUrl)!
        // fetchedImageからimageViewを生成
        let imageView = UIImageView(image: fetchedImage)
        // imageViewの描画モードとframeを決定
        imageView.contentMode = .scaleAspectFill
        imageView.frame = self.frame
        // viewの一番下のlayerにsubViewする
        self.insertSubview(imageView, at: 0)
    }
    
    // CustomBackgroundVIewにテーマ情報を格納し、背景周りを再描画
    func setBackgroundColor() {
        self.layer.backgroundColor = UIColor(hex: backGroundColor).cgColor
    }
}
