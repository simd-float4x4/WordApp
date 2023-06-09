import Foundation
import UIKit

// MARK: QuizAnswerButtonisTappedDelegate
/// - func removeFirstQuiz() → QuizViewControllerと接続
/// - func moveToNextQuiz() → QuizViewControllerと接続
/// - func sendPressedButtonId(id: Int) → QuizViewControllerと接続
/// - func changeInformationOnQuizWidget()→ QuizViewControllerと接続
protocol QuizAnswerButtonIsTappedDelegate: AnyObject {
    func removeFirstQuiz()
    func moveToNextQuiz(view: QuizView)
    func sendPressedButtonId(id: Int)
    func changeInformationOnQuizWidget()
}

// MARK: QuizView
class QuizView: UIView {
    // 単語表示用ラベル
    @IBOutlet weak var quizSingleWordLabel: UILabel!
    // 1つ目の解答ボタン
    @IBOutlet weak var quizFirstAnswerButton: UIButton!
    // 2つ目の解答ボタン
    @IBOutlet weak var quizSecondAnswerButton: UIButton!
    // 3つ目の解答ボタン
    @IBOutlet weak var quizThirdAnswerButton: UIButton!
    //　4つ目の解答ボタン
    @IBOutlet weak var quizFourthAnswerButton: UIButton!
    //　5つ目の解答ボタン
    @IBOutlet weak var quizFifthAnswerButton: UIButton!
    //　クイズの進捗率を示すためのProgressionBar
    @IBOutlet weak var quizProgressBar: UIProgressView!
    //　クイズの進捗率を示すためのUILabel
    @IBOutlet weak var quizProgressionLabel: UILabel!
    // 次の問題（最終問題）へと移動するボタン
    @IBOutlet weak var moveToNextQuizButton: UIButton!
    // 選択肢を選ぶことを説明するためのボタン
    @IBOutlet weak var quizDescriptionTextLabel: UILabel!
    //　quizViewDelegate
    /// - QuizAnswerButtonIsTappedDelegate → QuizViewControllerと接続
    weak var quizAnswerButtonIsTappedDelegate: QuizAnswerButtonIsTappedDelegate?
    //　既に回答したか判定するためのフラグ
    var isAnsweredBool: Bool = false
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
    let navigationBarTitleString = NSLocalizedString("QuizViewTitleText", comment: "")
    // ナビゲーションバー：フレームサイズ
    var navigationBarFrameSize = (x: 0, y: 0, height: 94)
    // ナビゲーションアイテム：高さ
    var navigationItemHeight = (x: 0, y: 0, height: 50)
    // ステータスバー：高さ
    let statusBarHeight = 44
    //　ナビゲーションUILabel
    var navigationBarUILabelProperties = (x: 0, y: 50, fontSize: CGFloat(16.0))
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    func loadNib(){
        let view = Bundle.main.loadNibNamed("QuizView", owner: self, options: nil)?.first as! UIView
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
            width: Int(UIScreen.main.bounds.size.width),
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
            width: Int(UIScreen.main.bounds.size.width)  / 2,
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
            width: Int(UIScreen.main.bounds.size.width),
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
    
    // 1番目のボタンが呼ばれた際の処理
    @IBAction func pressedFirstbutton() {
        // 未回答であれば
        if !isAnsweredBool {
            // Controllerにid=0を送る
            quizAnswerButtonIsTappedDelegate?.sendPressedButtonId(id: 0)
            //　ボタンの描画を更新する
            quizAnswerButtonIsTappedDelegate?.changeInformationOnQuizWidget()
            //　次の問題へ行くためのボタンをfalseにする
            moveToNextQuizButton.isHidden = false
        }
        //　未回答にする
        isAnsweredBool = true
    }
    
    //　2番目のボタンが呼ばれた際の処理
    @IBAction func pressedSecondbutton() {
        // 未回答であれば
        if !isAnsweredBool {
            // Controllerにid=1を送る
            quizAnswerButtonIsTappedDelegate?.sendPressedButtonId(id: 1)
            //　ボタンの描画を更新する
            quizAnswerButtonIsTappedDelegate?.changeInformationOnQuizWidget()
            //　次の問題へ行くためのボタンをfalseにする
            moveToNextQuizButton.isHidden = false
        }
        // 未回答にする
        isAnsweredBool = true
    }
    
    //　3番目のボタンが呼ばれた際の処理
    @IBAction func pressedThirdbutton() {
        // 未回答であれば
        if !isAnsweredBool {
            // Controllerにid=2を送る
            quizAnswerButtonIsTappedDelegate?.sendPressedButtonId(id: 2)
            //　ボタンの描画を更新する
            quizAnswerButtonIsTappedDelegate?.changeInformationOnQuizWidget()
            //　次の問題へ行くためのボタンをfalseにする
            moveToNextQuizButton.isHidden = false
        }
        // 未回答にする
        isAnsweredBool = true
    }
    
    //　4番目のボタンが呼ばれた際の処理
    @IBAction func pressedFourthbutton() {
        // 未回答であれば
        if !isAnsweredBool {
            // Controllerにid=3を送る
            quizAnswerButtonIsTappedDelegate?.sendPressedButtonId(id: 3)
            //　ボタンの描画を更新する
            quizAnswerButtonIsTappedDelegate?.changeInformationOnQuizWidget()
            //　次の問題へ行くためのボタンをfalseにする
            moveToNextQuizButton.isHidden = false
        }
        // 未回答にする
        isAnsweredBool = true
    }
    
    //　5番目のボタンが呼ばれた際の処理
    @IBAction func pressedFifthbutton() {
        // 未回答であれば
        if !isAnsweredBool {
            // Controllerにid=4を送る
            quizAnswerButtonIsTappedDelegate?.sendPressedButtonId(id: 4)
            //　ボタンの描画を更新する
            quizAnswerButtonIsTappedDelegate?.changeInformationOnQuizWidget()
            //　次の問題へ行くためのボタンをfalseにする
            moveToNextQuizButton.isHidden = false
        }
        // 未回答にする
        isAnsweredBool = true
    }
    
    //　次の問題へと移動する
    @IBAction func moveToNextQuiz() {
        quizAnswerButtonIsTappedDelegate?.moveToNextQuiz(view: self)
    }
}
