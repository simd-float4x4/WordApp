import UIKit

// MARK: AddWordViewController
class AddWordViewController: UIViewController, UITextViewDelegate, AddWordToWordListDelegate {
    //　ワードモデル
    var wordModel = WordListModel.shared
    // テーマモデル
    var themeModel = DesignThemeListModel.shared
    //　タップしたTextViewの名前
    var tappedTextViewName = ""
    //　アラートタイトル
    let alertErrorTitleLabel = NSLocalizedString("alertErrorTitle", comment: "エラー")
    let alertMessageSucceedLabel = NSLocalizedString("alertRegisterWordIsFinishedText", comment: "単語を完了いたしました。")
    //　アラートタイトル・失敗
    let alertMesssageFailedLabel = NSLocalizedString("alertRegisterWordIsFailedText", comment: "単語を登録できませんでした。")
    //　アラートOKボタン（OK）
    let alertOkButton = NSLocalizedString("alertOkButton", comment: "OK")
    //　アラート登録完了ラベル・接頭辞
    let alertRegisterFinishedPrefixLabel = NSLocalizedString("alertRegisterWordIsFinishedTitle", comment: "登録完了(")
    //　アラート登録完了ラベル・接尾語
    let alertRegisterFinishedSuffixLabel = NSLocalizedString("alertRegisterWordIsFinishedTitleSuffix", comment: ")")
    //　単語登録TextView押下時ID
    let singleWordTextViewisTapped = NSLocalizedString("single", comment: ".single")
    //　意味登録TextView押下時ID
    let meaningTextViewisTapped = NSLocalizedString("meaning", comment: ".meaning")
    //　例文登録TextView押下時ID
    let exampleSentenceTextViewisTapped = NSLocalizedString("ex-sente", comment: ".exampleSentence")
    //　日本語訳登録TextView押下時ID
    let exampleTranslationTextViewisTapped = NSLocalizedString("ex-trans", comment: ".exampleTranslation")
    //　ナビゲーションアイテム
    let addWordNavigationItem = UINavigationItem(title: "単語登録画面")
    //　戻るボタン・アイコン名
    var navigationBarImageName = "chevron.backward"
    // フォントカラー：初期値
    var accentColor: String = "000000"
    // 透明色
    let clearColor = UIColor.clear
    //　背景色
    var navigationBarBackgroundColor = "000000"
    // 一部テーマのナビゲーションバータイトルで使用する白色
    let navigationItemFontWhiteColor = UIColor.white
    // テーマモデルID
    var selectedThemeId: Int = 0
    // UserDefaults
    let ud = UserDefaults.standard
    //　ナビゲーションバータイトル
    let navigationBarTitleString = NSLocalizedString("WordListViewTitleText", comment: "")
    // ナビゲーションバー：フレームサイズ（注意：iPhone X以降の端末）
    // TODO: iPhone 8、SEなどにも対応できるようにする
    let navigationBarViewFrameSize = (x: 0, y: 0, height: 94)
    let navigationBarFrameSize = (x: 0, y: 50, height: 44)
    // ナビゲーションアイテム：高さ
    let navigationItemHeight = (x: 0, y: 0, height: 50)
    // ステータスバー：高さ
    let statusBarHeight = 44
    //　ナビゲーションUILabel
    let navigationBarUILabelProperties = (x: 0, y: 50, fontSize: CGFloat(16.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeWordAddView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 1つ前の画面に引数を渡す
        sendWordModelToPrevious()
    }
    
    // Viewの初期化
    func initializeWordAddView() {
        let view = AddWordView()
        view.singleWordTextView.delegate = self
        view.meaningWordTextView.delegate = self
        view.exampleSentenceTextView.delegate = self
        view.exampleTranslationTextView.delegate = self
        view.addWordToWordListDelegate = self
        
        let screenWidth = Int(UIScreen.main.bounds.width)
        let navBarView = UIView(frame: CGRect(
            x: navigationBarViewFrameSize.x,
            y: navigationBarViewFrameSize.y,
            width: screenWidth,
            height: navigationBarViewFrameSize.height))
        let navBar = UINavigationBar(frame: CGRect(
            x: navigationBarFrameSize.x,
            y: navigationBarFrameSize.y,
            width: screenWidth,
            height: navigationBarFrameSize.height))
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = clearColor
        
        selectedThemeId = ud.selectedThemeColorId
        navigationBarBackgroundColor = themeModel.themeList[selectedThemeId].theme.accentColor
        
        let themeName = getThemeName()
        //　下記３テーマはナビゲーションバーの文字がDefaultフォントだと見にくいため白糸に
        if themeName == "ノーマル" || themeName == "スペース" || themeName == "ブルーソーダ" {
            appearance.titleTextAttributes  = [.foregroundColor: navigationItemFontWhiteColor]
        }
        
        if themeName != "ストロベリー" && themeName != "ラグジュアリー" {
            navBar.tintColor = navigationItemFontWhiteColor
        }
        
        if themeName == "オレンジ" || themeName == "オリーブ" || themeName == "ストロベリー" {
            navigationBarBackgroundColor = themeModel.themeList[selectedThemeId].theme.complementalColor
        } else {
            // 上記３テーマ以外は補色をセットする
            navigationBarBackgroundColor = themeModel.themeList[selectedThemeId].theme.accentColor
        }
        
        navBarView.backgroundColor = UIColor(hex: navigationBarBackgroundColor)
        navBarView.tintColor = navigationItemFontWhiteColor
        
        navBar.backgroundColor = UIColor(hex: navigationBarBackgroundColor)
        
        addWordNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: navigationBarImageName)!, style: .plain, target: self, action: #selector(onTapDismissWordView))
        
        navBar.setItems([addWordNavigationItem], animated: false)
        
        navBar.scrollEdgeAppearance = appearance
        navBar.standardAppearance = appearance
        
        view.addSubview(navBarView)
        view.addSubview(navBar)
        
        self.view = view
        hideTabBarController()
        setNotificationCenters()
        setTapGesuture()
    }
    
    // 単語を登録する
    func addWordToList(data: [String]) {
        // バリデーションチェック
        let checkBool = makeValidationToAddWord(data: data)
        // エラー発生時
        if !checkBool {
            let okAction = UIAlertAction(title: alertOkButton, style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            showAlert(title: alertErrorTitleLabel, message: alertMesssageFailedLabel, actions: [okAction])
        } else {
            // バリデーション追加時
            let currentWordId = wordModel.wordList.last?.word.id ?? 0
            wordModel.addWordToList(id: currentWordId, data: data)
            
            let okAction = UIAlertAction(title: alertOkButton, style: .default) { _ in
                let view = AddWordView()
                view.resetWordInputField()
                self.initializeWordAddView()
            }
            let alertFinishedLabelString = alertRegisterFinishedPrefixLabel + data[0] + alertRegisterFinishedSuffixLabel
            showAlert(title: alertFinishedLabelString, message: alertMessageSucceedLabel, actions: [okAction])
            registerModel()
        }
    }
    
    // バリデーションチェック（暫定的にnilチェックのみ）
    func makeValidationToAddWord(data: [String]) -> Bool{
        for i in 0 ..< data.count {
            if data[i].isEmpty {
                return false
            }
        }
        return true
    }
    
    // NotificationCenterに変更を通知
    func registerModel() {
        NotificationCenter.default.post(name: .notifyName, object: nil)
    }
    
    // WorListViewControllerのwordModelを更新する
    func sendWordModelToPrevious() {
        if let index = navigationController?.viewControllers.count {
            let preVC = navigationController?.viewControllers[index - 1] as! WordListViewController
            preVC.wordModel = self.wordModel
        }
    }
    
    // TextViewがタップされたら
    func textViewDidBeginEditing(_ textView: UITextView) {
        // WordListViewを取得
        let addWordView = self.view as! AddWordView
        // タップしたTextViewによってキーを変更
        if textView == addWordView.singleWordTextView {
            tappedTextViewName = singleWordTextViewisTapped
        }
        if textView == addWordView.meaningWordTextView {
            tappedTextViewName = meaningTextViewisTapped
        }
        if textView == addWordView.exampleSentenceTextView {
            tappedTextViewName = exampleSentenceTextViewisTapped
        }
        if textView == addWordView.exampleTranslationTextView {
            tappedTextViewName = exampleTranslationTextViewisTapped
        }
    }
    //テキストフィールドでリターンが押されたときに通知され起動するメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // TabbarControllerを非表示に
    func hideTabBarController() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // NotificationCenterを登録する
    func setNotificationCenters() {
        // キーボードが表示される際の処理
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        // キーボードが閉じられる際の処理
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // キーボードが表示される時の処理
    @objc func keyboardWillShow(notification: NSNotification) {
        var exampleHeight = 0.0
        // タップされたtextFieldがどれか取得
        DispatchQueue.main.async {
            if self.tappedTextViewName == self.exampleTranslationTextViewisTapped {
                exampleHeight = 0.75
            }
            if self.tappedTextViewName == self.exampleSentenceTextViewisTapped {
                exampleHeight = 0.5
            }
            // singleWordだったら動かさない
            if self.tappedTextViewName == self.exampleTranslationTextViewisTapped || self.tappedTextViewName == self.exampleSentenceTextViewisTapped {
                // keyboardのsizeを取得
                if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    // TODO: 条件式の算出方法については要検討、再議論の必要あり
                    if self.view.frame.origin.y == 0 {
                        self.view.frame.origin.y -= keyboardSize.height * exampleHeight
                    } else {
                        let suggestionHeight = self.view.frame.origin.y + keyboardSize.height * exampleHeight
                        self.view.frame.origin.y -= suggestionHeight
                    }
                }
            }
        }
    }
    
    // キーボードが閉じられた時の処理
    @objc func keyboardWillHide() {
        DispatchQueue.main.async {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    }
    
    // タップされた際のGestureを登録する
    func setTapGesuture() {
        // キーボードがキャンセルされたときの処理
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // キーボードがキャンセルされた時の処理
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func onTapDismissWordView() {
        dismiss(animated: true,completion: nil)
    }
}
