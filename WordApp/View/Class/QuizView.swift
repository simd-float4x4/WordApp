import Foundation
import UIKit

// MARK: QuizAnswerButtonisTappedDelegate
/// - func removeFirstQuiz() → QuizViewControllerと接続
protocol QuizAnswerButtonIsTappedDelegate: AnyObject {
    func removeFirstQuiz()
    func moveToNextQuiz()
    func sendPressedButtonId(id: Int)
    func changeInformationOnQuizWidget()
}


// MARK: QuizView
class QuizView: UIView {
    
    @IBOutlet weak var quizSingleWordLabel: UILabel!
    @IBOutlet weak var quizFirstAnswerButton: UIButton!
    @IBOutlet weak var quizSecondAnswerButton: UIButton!
    @IBOutlet weak var quizThirdAnswerButton: UIButton!
    @IBOutlet weak var quizFourthAnswerButton: UIButton!
    @IBOutlet weak var quizFifthAnswerButton: UIButton!
    
    @IBOutlet weak var quizProgressBar: UIProgressView!
    @IBOutlet weak var quizProgressionLabel: UILabel!
    
    @IBOutlet weak var moveToNextQuizButton: UIButton!
    @IBOutlet weak var quizDescriptionTextLabel: UILabel!
    

    
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
    // テーマモデル
    var themeModel = DesignThemeListModel.shared
    // UserDefaults
    let ud = UserDefaults.standard
    //　ナビゲーションバータイトル
    let navigationBarTitleString = NSLocalizedString("QuizViewTitleText", comment: "")
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
        let view = Bundle.main.loadNibNamed("QuizView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        if let subview = view.subviews.first  {
            // UIを初期化する
            initializeUI(parentView: subview)
        }
    }
    
    // UIを初期化する
    func initializeUI(parentView: UIView) {
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
        // 次の問題へ行くためのボタンを非表示にする
        moveToNextQuizButton.isHidden = true
        // クイズの問題文のUILabelの初期値を格納する
        quizDescriptionTextLabel.text = NSLocalizedString("quizQuestionTextLabel", comment: "")
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
        if themeName == "オレンジ" || themeName == "オリーブ" || themeName == "ストロベリー" {
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
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = clearColor
        navigationBarAppearance.backgroundColor = UIColor(hex: accentColor)
        navBar.standardAppearance = navigationBarAppearance
        navBar.scrollEdgeAppearance = navigationBarAppearance
        return navBar
    }
    
    @IBAction func pressedFirstbutton() {
        if !isAnsweredBool {
            quizAnswerButtonIsTappedDelegate?.sendPressedButtonId(id: 0)
            quizAnswerButtonIsTappedDelegate?.changeInformationOnQuizWidget()
            moveToNextQuizButton.isHidden = false
        }
        isAnsweredBool = true
    }
    
    @IBAction func pressedSecondbutton() {
        if !isAnsweredBool {
            quizAnswerButtonIsTappedDelegate?.sendPressedButtonId(id: 1)
            quizAnswerButtonIsTappedDelegate?.changeInformationOnQuizWidget()
            moveToNextQuizButton.isHidden = false
        }
        isAnsweredBool = true
    }
    
    @IBAction func pressedThirdbutton() {
        if !isAnsweredBool {
            quizAnswerButtonIsTappedDelegate?.sendPressedButtonId(id: 2)
            quizAnswerButtonIsTappedDelegate?.changeInformationOnQuizWidget()
            moveToNextQuizButton.isHidden = false
        }
        isAnsweredBool = true
    }
    
    @IBAction func pressedFourthbutton() {
        if !isAnsweredBool {
            quizAnswerButtonIsTappedDelegate?.sendPressedButtonId(id: 3)
            quizAnswerButtonIsTappedDelegate?.changeInformationOnQuizWidget()
            moveToNextQuizButton.isHidden = false
        }
        isAnsweredBool = true
    }
    
    @IBAction func pressedFifthbutton() {
        if !isAnsweredBool {
            quizAnswerButtonIsTappedDelegate?.sendPressedButtonId(id: 4)
            quizAnswerButtonIsTappedDelegate?.changeInformationOnQuizWidget()
            moveToNextQuizButton.isHidden = false
        }
        isAnsweredBool = true
    }
    
    // idをControllerに送るだけのメソッド
    func sendPressedButtonId(id: Int) -> Int {
        return id
    }
    
    @IBAction func moveToNextQuiz() {
        quizAnswerButtonIsTappedDelegate?.moveToNextQuiz()
    }
}
