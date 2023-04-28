import UIKit
import Foundation

// MARK: AddWordViewControllerのUIViewController
extension AddWordViewController {
    //　viewにナビゲーションバーを追加する
    func addNavigationBarToView(view: AddWordView) -> AddWordView {
        // ナビゲーションバーを生成
        let navBar = makeNavBar()
        // ナビゲーションバービューを生成
        let navBarView = makeNavBarView()
        //　保存されたテーマIDを取得する
        fetchSavedThemeData()
        //　テーマカラーを色に代入する
        getNavigationBarColor()
        // nabigationBarの色をセットする
        setNavigationBarColor(navBar: navBar)
        //　appearanceを設定
        let appearance = setAppearenceConfig()
        // ナビゲーションアイテムを設定
        setNavBarItems(navBar: navBar)
        //　ナビゲーションバービューに色を設定
        setColorOnNavBarView(navBarView: navBarView)
        //　ナビゲーションバーにappearanceを設定
        navBar.scrollEdgeAppearance = appearance
        navBar.standardAppearance = appearance
        // viewに追加
        view.addSubview(navBarView)
        view.addSubview(navBar)
        
        return view
    }
    
    
    // ナビゲーションバーを作る
    func makeNavBar() -> UINavigationBar{
        //　スクリーン幅を取得する
        let screenWidth = getScreenWidth()
        // ナビゲーションバーを宣言する
        let navBar = UINavigationBar(frame: CGRect(
            x: navigationBarFrameSize.x,
            y: navigationBarFrameSize.y,
            width: screenWidth,
            height: navigationBarFrameSize.height))
        return navBar
    }
    
    //　ナビゲーションバーとステータスバーの間を埋めるためのViewを作る
    func makeNavBarView() -> UIView {
        //　スクリーン幅を取得する
        let screenWidth = getScreenWidth()
        //　ナビゲーションバーViewを宣言する
        let navBarView = UIView(frame: CGRect(
            x: navigationBarViewFrameSize.x,
            y: navigationBarViewFrameSize.y,
            width: screenWidth,
            height: navigationBarViewFrameSize.height))
        return navBarView
    }
    
    // 保存されたカラーテーマ情報を取得
    func fetchSavedThemeData() {
        //　テーマカラーを取得する
        selectedThemeId = ud.selectedThemeColorId
    }
    
    //　スクリーン幅を取得する
    func getScreenWidth() -> Int {
        //　スクリーン幅を取得する
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
        //　ナビゲーションバーの背景色を取得する
        navigationBarBackgroundColor = themeModel.themeList[selectedThemeId].theme.accentColor
    }
    
    //　アクセントカラーをセット
    func setNavigationBarColor(navBar: UINavigationBar) {
        //　テーマ名を取得する
        let themeName = getThemeName()
        //　テーマ名一覧を取得する
        let themeNameList = ThemeName().list
        //　テーマ名を一覧から取得する
        guard let orange = themeNameList["orange"] else { return }
        guard let olive = themeNameList["olive"] else { return }
        guard let strawberry = themeNameList["berry"] else { return }
        guard let luxury = themeNameList["luxury"] else { return }
        //　下記３テーマは特定の色をセットする
        if themeName == orange || themeName == olive || themeName == strawberry {
            navigationBarBackgroundColor = themeModel.themeList[selectedThemeId].theme.complementalColor
        } else {
            // 上記３テーマ以外は補色をセットする
            navigationBarBackgroundColor = themeModel.themeList[selectedThemeId].theme.accentColor
        }
        //　下記２テーマ以外はナビゲーションバーのボタンの色が見にくいため白色にする
        if themeName != strawberry && themeName != luxury {
            navBar.tintColor = navigationItemFontWhiteColor
        }
        // 背景色をセットする
        navBar.backgroundColor = UIColor(hex: navigationBarBackgroundColor)
    }
    
    //　UINavigationBarAppearanceをセットする
    func setAppearenceConfig() -> UINavigationBarAppearance{
        //　テーマ名を取得する
        let themeName = getThemeName()
        //　UINavigationBarAppearanceを初期化する
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = clearColor
        //　テーマ名一覧を取得する
        let themeNameList = ThemeName().list
        //　テーマ名を一覧から取得する
        let normal = themeNameList["normal"]
        let space = themeNameList["space"]
        let soda = themeNameList["soda"]
        //　下記３テーマはナビゲーションバーの文字がDefaultフォントだと見にくいため白色に
        if themeName == normal || themeName == space || themeName == soda {
            appearance.titleTextAttributes  = [.foregroundColor: navigationItemFontWhiteColor]
        }
        return appearance
    }
    
    //　ナビゲーションアイテムボタンをセットする
    func setNavBarItems(navBar: UINavigationBar) {
        addWordNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: navigationBarImageName)!, style: .plain, target: self, action: #selector(onTapDismissWordAddView))
        navBar.setItems([addWordNavigationItem], animated: false)
    }
    
    //　ナビゲーションバーViewにも同様の色をセットする
    func setColorOnNavBarView(navBarView: UIView) {
        navBarView.backgroundColor = UIColor(hex: navigationBarBackgroundColor)
        navBarView.tintColor = navigationItemFontWhiteColor
    }
}
