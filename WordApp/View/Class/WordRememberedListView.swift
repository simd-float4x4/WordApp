import Foundation
import UIKit

// MARK: SortWordRememberedListWidgetDelegate
/// - func sortWordRememberedListView() → WordRememberedListViewControllerと接続
protocol SortWordRememberedListWidgetDelegate: AnyObject {
    func sortWordRememberedListView()
}

// MARK: WordRememberedListView
class WordRememberedListView: UIView {
    // 単語表示用テーブル
    @IBOutlet weak var wordRememberedListWidget: UITableView!
    //　単語リストをソートするためのボタン
    @IBOutlet weak var sortWordRememberedListButton: UIButton!
    //　sortWordListWidgetDelegate
    /// - func sortWordListWidget() → WordListViewControllerと接続
    weak var sortWordRemeberedListDelegate: SortWordRememberedListWidgetDelegate!
    // フォントカラー：初期値
    var accentColor: String = "000000"
    // 透明色
    let clearColor = UIColor.clear
    // 一部テーマのナビゲーションバータイトルで使用する白色
    let navigationItemFontWhiteColor = UIColor.white
    // テーマモデルID
    var selectedThemeId: Int = 0
    // テーマモデル
    var themeModel = DesignThemeListModel.shared
    // UserDefaults
    let ud = UserDefaults.standard
    //　ナビゲーションバータイトル
    let navigationBarTitleString = NSLocalizedString("WordRememberedListViewTitleText", comment: "")
    // ナビゲーションバー：フレームサイズ
    var navigationBarFrameSize = (x: 0, y: 0, height: 94)
    // ナビゲーションアイテム：高さ
    var navigationItemHeight = (x: 0, y: 0, height: 50)
    // ステータスバー：高さ
    let statusBarHeight = 44
    //　ナビゲーションUILabel
    var navigationBarUILabelProperties = (x: 0, y: 50, fontSize: CGFloat(16.0))
    // 単語リスト登録が0件の際に表示するためのラベル
    @IBOutlet weak var thereIsNoWordLabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    // NibFileをLoadする
    func loadNib(){
        let view = Bundle.main.loadNibNamed("WordRememberedListView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        if let subview = view.subviews.first  {
            // UIを初期化する
            initializeUI(parentView: subview)
        }
    }
    
    //　ノッチによってナビゲーションバーのサイズを決定する
    func decideNavigationSizeByNotch() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        //safeAreaの値が44.0以上であれば、ノッチがあるので、x位置をずらします。
        if(window?.safeAreaInsets.top ?? 0.0 <= 44.0){
            navigationBarFrameSize.height = 60
            navigationBarUILabelProperties.y = 16
        }
    }
    
    // UIを初期化する
    func initializeUI(parentView: UIView) {
        // 保存したテーマを取得する
        fetchSavedThemeData()
        //　ノッチによってナビゲーションバーのサイズを決定する
        decideNavigationSizeByNotch()
        //　テーマのアクセントカラーを取得する
        getAccentColor()
        //　アクセントカラーをセットする
        setAccentColor()
        // ナビゲーションバーを設定する
        let navBar = setUpNavigationBar(parentView: parentView)
        //　ナビゲーションバーのタイトルを格納するViewを設定する
        let titleView = setAndGetTitleViewProperties(parentView: parentView)
        //　ナビゲーションバーのタイトルラベルを設定する
        let titleViewLabel = setAndGetUILabelProperties(parentView: parentView)
        // subViewをする
        parentView.addSubview(navBar)
        titleView.addSubview(titleViewLabel)
        parentView.addSubview(titleView)
        self.addSubview(parentView)
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
    
    //　アクセントカラーを取得
    func getAccentColor() {
        accentColor = themeModel.themeList[selectedThemeId].theme.accentColor
    }
    
    //　アクセントカラーをセット
    func setAccentColor() {
        let themeName = getThemeName()
        //　テーマ名一覧を取得する
        let themeNameList = ThemeName().list
        //　テーマ名を一覧から取得する
        guard let olive = themeNameList["olive"] else { return }
        guard let orange = themeNameList["orange"] else { return }
        guard let strawberry = themeNameList["berry"] else { return }
        if themeName == olive || themeName == orange || themeName == strawberry {
            accentColor = themeModel.themeList[selectedThemeId].theme.complementalColor
        } else {
            // 上記３テーマ以外は補色をセットする
            accentColor = themeModel.themeList[selectedThemeId].theme.accentColor
        }
    }
    
    // ラベルのプロパティを設定してから返す
    func setAndGetUILabelProperties(parentView: UIView) -> UILabel {
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
            width: Int(parentView.frame.size.width) / 2,
            height: statusBarHeight)
        // テーマ名を取得
        let themeName = getThemeName()
        //　テーマ名一覧を取得する
        let themeNameList = ThemeName().list
        //　テーマ名を一覧から取得する
        let normal = themeNameList["normal"]
        let space = themeNameList["space"]
        let soda = themeNameList["soda"]
        //　下記３テーマはナビゲーションバーの文字がDefaultフォントだと見にくいため白色に
        if themeName == normal || themeName == space || themeName == soda {
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
            width: Int(parentView.frame.size.width) / 2,
            height: navigationBarFrameSize.height)
        return titleView
        
    }
    
    // navigationBarのセットアップ
    func setUpNavigationBar(parentView : UIView) -> UINavigationBar {
        //　ナビゲーションバーのタイトルを取得
        let wordRememberListNavigationItem = UINavigationItem(title: "")
        // ナビゲーションバーをframeに合わせる
        var navBar = UINavigationBar(frame: CGRect(
            x: navigationBarFrameSize.x,
            y: navigationBarFrameSize.y,
            width: Int(parentView.frame.size.width),
            height: navigationBarFrameSize.height))
        // ナビゲーションバーに色をセットする
        navBar = setColorOnNavigationBar(navBar: navBar)
        // ナビゲーションバーにナビゲーションアイテムをセットする
        navBar.setItems([wordRememberListNavigationItem], animated: false)
        return navBar
    }
    
    //　navigationBarにカラーをセットする
    func setColorOnNavigationBar(navBar: UINavigationBar) -> UINavigationBar {
        // ナビゲーションバーの見た目を設定
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = clearColor
        navigationBarAppearance.backgroundColor = UIColor(hex: accentColor)
        navBar.standardAppearance = navigationBarAppearance
        navBar.scrollEdgeAppearance = navigationBarAppearance
        return navBar
    }
    
    // 単語帳をソートする
    /// - func sortWordRememberedList() → WordRememberedListViewControllerと接続
    @IBAction func sortWordRememberedList() {
        sortWordRemeberedListDelegate.sortWordRememberedListView()
    }
}
