import Foundation
import UIKit

// MARK: CustomImageFrame
class CustomImageFrame: UIImageView {
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
        hideOrShowImageFrames()
    }
    
    // 保存されたカラーテーマ情報を取得
    func fetchSavedThemeData() {
        selectedThemeId = ud.selectedThemeColorId
    }
    
    // フレームを表示するか隠すか決定する
    func hideOrShowImageFrames() {
        // テーマの名称を取得する
        let themeName = DesignThemeListModel.shared.themeList[selectedThemeId].theme.name
        // 選択されているテーマがラグジュアリーテーマであれば、frameを表示する。
        if themeName == "ラグジュアリー" {
            self.isHidden = false
        } else {
            self.isHidden = true
        }
    }
}
