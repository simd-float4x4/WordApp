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
        //　テーマ名一覧を取得する
        let themeNameList = ThemeName().list
        //　テーマ名を一覧から取得する
        guard let luxury = themeNameList["luxury"] else { return }
        // 選択されているテーマがラグジュアリーテーマであれば、frameを表示する。
        if themeName == luxury {
            self.isHidden = false
        } else {
            self.isHidden = true
        }
    }
}
