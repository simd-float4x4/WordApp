import UIKit
import Foundation

// MARK: WordListViewControllerのTableViewDelegate
// TableViewを描画・処理する為に最低限必要なデリゲートメソッド、データソース
extension WordListViewController: UITableViewDelegate {

    // セルが選択された際の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 表示上の配列をあらかじめfilterしておく
        let itemList =  wordModel.returnFilteredWordList(isWordRememberedStatus: false)
        // タップされた時の追加処理を行う。
        tableView.deselectRow(at: indexPath, animated: true)
        // 配列からidを取得
        let id = itemList[indexPath.row].word.id
        // 取得したidからデータ絞り込み
        let model = wordModel.wordList.first(where: {$0.word.id == id})
        // 単語詳細画面に行く際のデータを橋渡し
        self.singleWord = model?.word.singleWord ?? ""
        self.meaning = model?.word.meaning ?? ""
        self.exampleSentence = model?.word.exampleSentence ?? ""
        self.exampleTranslation = model?.word.exampleTranslation ?? ""
        // 単語詳細画面へ
        self.toWordDetailView()
    }
    
    // セルをスワイプした時の処理
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 表示上の配列をあらかじめfilterしておく
        let itemList =  wordModel.returnFilteredWordList(isWordRememberedStatus: false)
        // 削除アクション
        let deleteAction = UIContextualAction(style: .normal, title: wordDeleteButtonTextLabel) { (action, view, completionHandler) in
            // 配列からidを取得
            let id = itemList[indexPath.row].word.id
            // wordModel.wordListから該当するidの要素を削除
            self.wordModel.removeWord(index: id)
            // WordListWidgetを更新
            self.reloadWordListWidget()
            // ProgressBarを更新
            self.fetchCurrentProgress()
            completionHandler(true)
        }
        // 暗記アクション
        let rememberedAction = UIContextualAction(style: .normal, title: wordRememberedButtonTextLabel) { (action, view, completionHandler) in
            let id = itemList[indexPath.row].word.id
            self.wordModel.upDateRememberStatus(index: id)
            // WordListWidgetを更新
            self.reloadWordListWidget()
            // ProgressBarを更新
            self.fetchCurrentProgress()
            completionHandler(true)
        }
        // 背景色の決定
        deleteAction.backgroundColor = UIColor.systemRed
        rememberedAction.backgroundColor = UIColor.blue
        // 削除モードがON/OFFの時、アクションを切り替える
        if isDeleteModeOn != true {
            return UISwipeActionsConfiguration(actions: [rememberedAction])
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // 単語登録画面から帰ってきた時にTabBarの非表示を解除する（厳密にはどの画面から飛んできても表示する）
    func showTabBarController() {
        self.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: WordListViewControllerのViewControleer
extension WordListViewController {
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
        wordListNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: navigationBarImageName)!, style: .plain, target: self, action: #selector(switchWordActionMode))
        wordListNavigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(toAddWordView))
        navBar.setItems([wordListNavigationItem], animated: false)
    }
    
    func setColorOnNavBarView(navBarView: UIView) {
        navBarView.backgroundColor = UIColor(hex: navigationBarBackgroundColor)
        navBarView.tintColor = navigationItemFontWhiteColor
    }
    
    // ラベルのプロパティを設定してから返す
    func setTitleAndTintColorProperties(parentView: UIView) -> UILabel {
        // UILabelのインスタンスを作成
        let label = UILabel()
        // タイトルをセット
        label.text = navigationBarTitleString
        //　タイトルを中央寄せに
        label.textAlignment = .center
        //　タイトルをframeに合わせる
        label.frame = CGRect(
            x: navigationBarUILabelProperties.x,
            y: navigationBarUILabelProperties.y,
            width: Int(UIScreen.main.bounds.size.width),
            height: statusBarHeight)
        label.backgroundColor = UIColor.red
        // テーマ名を取得
        let themeName = getThemeName()
        //　下記３テーマはナビゲーションバーの文字がDefaultフォントだと見にくいため白糸に
        if themeName == "ノーマル" || themeName == "スペース" || themeName == "ブルーソーダ" {
            label.textColor = navigationItemFontWhiteColor
        }
        //フォントサイズを指定
        label.font = UIFont.boldSystemFont(ofSize: navigationBarUILabelProperties.fontSize)
        return label
    }
    
    // タイトルビューのプロパティを設定してから返す
    func setAndGetTitleViewProperties(parentView: UIView) -> UIView {
        // UIViewのインスタンスを作成
        let titleView = UIView()
        //　viewをframeに合わせる
        titleView.frame = CGRect(
            x: Int(parentView.frame.size.width) / 4,
            y: navigationBarFrameSize.y,
            width: Int(UIScreen.main.bounds.size.width)  / 2,
            height: navigationBarFrameSize.height)
        titleView.backgroundColor = UIColor.green
        return titleView
        
    }
    
    // navigationBarのセットアップ
    func setUpNavigationBar(parentView : UIView) -> UINavigationBar {
        //　ナビゲーションバーのタイトルを取得
        let wordRememberListNavigationItem = UINavigationItem(title: navigationBarTitleString)
        // ナビゲーションバーをframeに合わせる
        var navBar = UINavigationBar(frame: CGRect(
            x: navigationBarFrameSize.x,
            y: navigationBarFrameSize.y,
            width: Int(UIScreen.main.bounds.size.width),
            height: navigationBarFrameSize.height))
        navBar.backgroundColor = UIColor.yellow
        // ナビゲーションバーに色をセットする
        navBar = setColorOnNavigationBar(navBar: navBar)
        
        wordRememberListNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: navigationBarImageName)!, style: .plain, target: self, action: #selector(switchWordActionMode))
        wordRememberListNavigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(toAddWordView))
        // テーマ名を取得
        let themeName = getThemeName()
        //　下記３テーマはナビゲーションバーの文字がDefaultフォントだと見にくいため白糸に
        if themeName == "ノーマル" || themeName == "スペース" || themeName == "ブルーソーダ" {
            navBar.tintColor = navigationItemFontWhiteColor
        }
        // ナビゲーションバーにナビゲーションアイテムをセットする
        navBar.setItems([wordRememberListNavigationItem], animated: false)
        return navBar
    }
    
    //　navigationBarにカラーをセットする
    func setColorOnNavigationBar(navBar: UINavigationBar) -> UINavigationBar {
        // ナビゲーションバーの見た目を設定
        let navigationBarAppearance = UINavigationBarAppearance()
        // 透明にする
        navigationBarAppearance.configureWithOpaqueBackground()
        // 影のカラーを消す（これにより下線が消える）
        navigationBarAppearance.shadowColor = clearColor
        //　背景色を設定
        navigationBarAppearance.backgroundColor = UIColor(hex: accentColor)
        //　ApperaranceをNavBarに設定
        navBar.standardAppearance = navigationBarAppearance
        navBar.scrollEdgeAppearance = navigationBarAppearance
        return navBar
    }
}
