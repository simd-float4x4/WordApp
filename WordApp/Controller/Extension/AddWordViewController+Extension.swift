import UIKit
import Foundation

// MARK: AddWordViewControllerのTableViewDelegate
extension AddWordViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension AddWordViewController {
    func makeNavBar() -> UINavigationBar{
        let screenWidth = getScreenWidth()
        let navBar = UINavigationBar(frame: CGRect(
            x: navigationBarFrameSize.x,
            y: navigationBarFrameSize.y,
            width: screenWidth,
            height: navigationBarFrameSize.height))
        return navBar
    }
    
    func makeNavBarView() -> UIView {
        let screenWidth = getScreenWidth()
        let navBarView = UIView(frame: CGRect(
            x: navigationBarViewFrameSize.x,
            y: navigationBarViewFrameSize.y,
            width: screenWidth,
            height: navigationBarViewFrameSize.height))
        return navBarView
    }
    
    // 保存されたカラーテーマ情報を取得
    func fetchSavedThemeData() {
        selectedThemeId = ud.selectedThemeColorId
    }
    
    //　スクリーン幅を取得する
    func getScreenWidth() -> Int {
        let screenWidth = Int(UIScreen.main.bounds.width)
        return screenWidth
    }
    
    //　テーマの名前を取得する
    func getThemeName() -> String{
        // テーマの名称を取得する
        let themeName = DesignThemeListModel.shared.themeList[selectedThemeId].theme.name
        return themeName
    }
    
    //　アクセントカラーを取得
    func getNavigationBarColor() {
        navigationBarBackgroundColor = themeModel.themeList[selectedThemeId].theme.accentColor
    }
    
    //　アクセントカラーをセット
    func setNavigationBarColor(navBar: UINavigationBar) {
        let themeName = getThemeName()
        if themeName == "オレンジ" || themeName == "オリーブ" || themeName == "ストロベリー" {
            navigationBarBackgroundColor = themeModel.themeList[selectedThemeId].theme.complementalColor
        } else {
            // 上記３テーマ以外は補色をセットする
            navigationBarBackgroundColor = themeModel.themeList[selectedThemeId].theme.accentColor
        }
        if themeName != "ストロベリー" && themeName != "ラグジュアリー" {
            navBar.tintColor = navigationItemFontWhiteColor
        }
        navBar.backgroundColor = UIColor(hex: navigationBarBackgroundColor)
    }
    
    func setAppearenceConfig() -> UINavigationBarAppearance{
        let themeName = getThemeName()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = clearColor
        //　下記３テーマはナビゲーションバーの文字がDefaultフォントだと見にくいため白色に
        if themeName == "ノーマル" || themeName == "スペース" || themeName == "ブルーソーダ" {
            appearance.titleTextAttributes  = [.foregroundColor: navigationItemFontWhiteColor]
        }
        return appearance
    }
    
    func setNavBarItems(navBar: UINavigationBar) {
        addWordNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: navigationBarImageName)!, style: .plain, target: self, action: #selector(onTapDismissWordView))
        navBar.setItems([addWordNavigationItem], animated: false)
    }
    
    func setColorOnNavBarView(navBarView: UIView) {
        navBarView.backgroundColor = UIColor(hex: navigationBarBackgroundColor)
        navBarView.tintColor = navigationItemFontWhiteColor
    }
}
