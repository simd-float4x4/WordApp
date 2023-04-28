import Foundation
import UIKit

// MARK: SettingViewDelegate
/// - func updateMaximumQuizSelection(count: Int) → SettingViewControllerと接続
/// - func updateMaximumQuizCount(count: Int) → SettingViewControllerと接続
protocol SettingViewDelegate: AnyObject {
    func updateMaximumQuizSelection(count: Int)
    func updateMaximumQuizCount(count: Int)
}

// MARK: SettingViewDelegate
class SettingView: UIView {
    // 回答選択肢を調整するSegmenControl
    @IBOutlet weak var changeQuizAnswerSelectionCountSegmentedControl: UISegmentedControl!
    //　クイズの回答数を生成するControl
    @IBOutlet weak var changeMaximumQuizCountSegmentedControl: UISegmentedControl!
    //　テーマ選択用CollectionView
    @IBOutlet weak var collectionThemeCollectionView: UICollectionView!
    //　クイズの選択肢数変更用SegmentedControlの説明用ラベル
    @IBOutlet weak var settingViewSelectQuizSelectionCountTextLabel: UILabel!
    //　クイズの出題数変更用SegmentedControlの説明用ラベル
    @IBOutlet weak var settingViewQuizMaximumCountTextLabel: UILabel!
    //　アプリ全体のテーマ変更用SegmentedControlの説明用ラベル
    @IBOutlet weak var settingViewDesignThemeTextLabel: UILabel!
    //　settingViewDelegate
    /// - settingViewDelegate → SettingViewControllerと接続
    weak var settingViewDelegate: SettingViewDelegate!
    //　現在の選択肢数（デフォルト）
    var currentChoicesTotal: Int = 5
    //　現在の出題数（デフォルト）
    var currentMaximumQuizSum: Int = 0
    // フォントカラー：初期値
    var accentColor: String = "000000"
    // 透明色
    let clearColor = UIColor.clear
    // 一部テーマのナビゲーションバータイトルで使用する白色
    let navigationItemFontWhiteColor = UIColor.white
    // テーマモデルID
    var selectedThemeId: Int = 0
    //　UserDefaults
    let ud = UserDefaults.standard
    //　テーマモデル
    let themeModel = DesignThemeListModel.shared
    //　ナビゲーションバータイトル
    let navigationBarTitleString = NSLocalizedString("SettingViewTitleText", comment: "")
    // ナビゲーションバー：フレームサイズ（注意：iPhone X以降の端末）
    // TODO: iPhone 8、SEなどにも対応できるようにする
    let navigationBarFrameSize = (x: 0, y: 0, height: 94)
    // ナビゲーションアイテム：高さ
    let navigationItemHeight = (x: 0, y: 0, height: 50)
    // ステータスバー：高さ
    let statusBarHeight = 44
    //　ナビゲーションUILabel
    let navigationBarUILabelProperties = (x: 0, y: 50, fontSize: CGFloat(16.0))
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    func loadNib(){
        let view = Bundle.main.loadNibNamed("SettingView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        if let subview = view.subviews.first  {
            initializeUI(parentView: subview)
        }
    }
    
    // UIを初期化する
    func initializeUI(parentView: UIView) {
        // SegmentedControlを初期化する
        setSegmentedControl()
        // UILabelにtextをセットする
        setLabelText()
        // 保存したテーマを取得する
        fetchSavedThemeData()
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
    
    func setSegmentedControl() {
        // セグメントが変更された時に呼び出すメソッドの設定
        /// - クイズの選択肢変更用SegmentedControlの設定
        changeQuizAnswerSelectionCountSegmentedControl.addTarget(self, action: #selector(quizChoicesSegmentedControl(_:)), for: UIControl.Event.valueChanged)
        /// - クイズの出題数変更用SegmentedControlの設定
        changeMaximumQuizCountSegmentedControl.addTarget(self, action: #selector(quizMaximumCountSegmentedControl(_:)), for: UIControl.Event.valueChanged)
    }
    
    // UILabelTextに初期値を設定
    func setLabelText() {
        // UILabelの初期化
        settingViewSelectQuizSelectionCountTextLabel.text = NSLocalizedString("settingSelectionAnswerCountTitle", comment: "")
        settingViewQuizMaximumCountTextLabel.text = NSLocalizedString("settingMaximumQuizCountTitle", comment: "")
        settingViewDesignThemeTextLabel.text = NSLocalizedString("settingDesignThemeTitle", comment: "")
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
        guard let orange = themeNameList["orange"] else { return }
        guard let olive = themeNameList["olive"] else { return }
        guard let strawberry = themeNameList["berry"] else { return }
        if themeName == orange || themeName == olive || themeName == strawberry {
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
        //　下記３テーマはナビゲーションバーの文字がDefaultフォントだと見にくいため白糸に
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
        let wordRememberListNavigationItem = UINavigationItem(title: navigationBarTitleString)
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
    
    // クイズ選択肢変更用SegmentedControl
    @IBAction func quizChoicesSegmentedControl(_ sender: UISegmentedControl) {
        //　senderの値によって代入値を変更する
        switch Int(sender.selectedSegmentIndex) {
            case 0:
                currentChoicesTotal = 5
            case 1:
                currentChoicesTotal = 4
            case 2:
                currentChoicesTotal = 3
            default:
                break
        }
        print("currentChoicesTotal: ", currentChoicesTotal)
        //　選択肢の数を更新する
        settingViewDelegate.updateMaximumQuizSelection(count: currentChoicesTotal)
        //　現在の値をUserDefaultsに保存する
        ud.choicesSelectedSegmentIndex = sender.selectedSegmentIndex
    }
    
    @IBAction func quizMaximumCountSegmentedControl(_ sender: UISegmentedControl) {
        //　senderの値によって代入値を変更する
        switch Int(sender.selectedSegmentIndex) {
            case 0:
                currentMaximumQuizSum = 0
            case 1:
                currentMaximumQuizSum = 5
            case 2:
                currentMaximumQuizSum = 10
            case 3:
                currentMaximumQuizSum = 15
            case 4:
                currentMaximumQuizSum = 20
            case 5:
                currentMaximumQuizSum = 25
            case 6:
                currentMaximumQuizSum = 30
            default:
                break
        }
        //　出題数の数を更新する
        settingViewDelegate.updateMaximumQuizCount(count: currentMaximumQuizSum)
        //　現在の値をUserDefaultsに保存する
        ud.quizMaximumSelectedSegmentIndex = sender.selectedSegmentIndex
    }
}


