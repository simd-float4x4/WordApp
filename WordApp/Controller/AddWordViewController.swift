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
    // ナビゲーションバー：フレームサイズ
    var navigationBarViewFrameSize = (x: 0, y: 0, height: 94)
    var navigationBarFrameSize = (x: 0, y: 50, height: 44)
    // ナビゲーションアイテム：高さ
    var navigationItemHeight = (x: 0, y: 0, height: 50)
    // ステータスバー：高さ
    let statusBarHeight = 44
    //　ナビゲーションUILabel
    var navigationBarUILabelProperties = (x: 0, y: 50, fontSize: CGFloat(16.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //　Viewを初期化する
        initializeWordAddView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 1つ前の画面に引数を渡す
        sendWordModelToPrevious()
    }
    
    
    //　ノッチによってナビゲーションバーのサイズを決定する
    func decideNavigationSizeByNotch() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        //safeAreaの値が44.0以上であれば、ノッチがあるので、x位置をずらします。
        if(window?.safeAreaInsets.top ?? 0.0 <= 44.0){
            navigationBarFrameSize.height = 44
            navigationBarFrameSize.y = 16
            navigationBarViewFrameSize.height = 16
        }
    }
    
    // Viewの初期化
    func initializeWordAddView() {
        //　ノッチによってナビゲーションバーのサイズを決定する
        decideNavigationSizeByNotch()
        //　AddWordViewを初期化する
        var view = AddWordView()
        //　UITextViewのdelegateを設定する
        view.singleWordTextView.delegate = self
        view.meaningWordTextView.delegate = self
        view.exampleSentenceTextView.delegate = self
        view.exampleTranslationTextView.delegate = self
        view.addWordToWordListDelegate = self
        //　ナビゲーションバーを生成する
        view = addNavigationBarToView(view: view)
        // viewを代入
        self.view = view
        //　タブバーコントローラを隠す
        hideTabBarController()
        //　notificationCenterを登録する
        setNotificationCenters()
        //　tapGestureを設定する
        setTapGesuture()
    }
    
    // 単語を登録する
    func addWordToList(data: [String]) {
        // バリデーションチェック
        let checkBool = makeValidationToAddWord(data: data)
        // エラー発生時
        if !checkBool {
            //　OKActionを設定する
            let okAction = UIAlertAction(title: alertOkButton, style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            //　アラートを表示する
            showAlert(title: alertErrorTitleLabel, message: alertMesssageFailedLabel, actions: [okAction])
        } else {
        //　登録成功時
            //　現在のwordIdを取得する
            let currentWordId = wordModel.wordList.last?.word.id ?? 0
            //　単語を登録する
            wordModel.addWordToList(id: currentWordId, data: data)
            //　OKActionを設定する
            let okAction = UIAlertAction(title: alertOkButton, style: .default) { _ in
                //　AddWordViewを取得する
                let view = AddWordView()
                //　入力欄をリセットする
                view.resetWordInputField()
                //　viewを初期化する
                self.initializeWordAddView()
            }
            //　アラート終了時のラベルを設定する
            let alertFinishedLabelString = alertRegisterFinishedPrefixLabel + data[0] + alertRegisterFinishedSuffixLabel
            //　アラートを表示する
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
        //　キーボードの移動率
        var rate = 0.0
        // タップされたtextFieldがどれか取得
        DispatchQueue.main.async {
            //　例文（日本語訳）がタップされたのであれば
            if self.tappedTextViewName == self.exampleTranslationTextViewisTapped {
                //　キーボードの移動率を0.75に設定
                rate = 0.75
            }
            if self.tappedTextViewName == self.exampleSentenceTextViewisTapped {
                //　キーボードの移動率を0.5に設定
                rate = 0.5
            }
            // singleWordだったら動かさない
            if self.tappedTextViewName == self.exampleTranslationTextViewisTapped || self.tappedTextViewName == self.exampleSentenceTextViewisTapped {
                // keyboardのsizeを取得
                if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    // TODO: 条件式の算出方法については要検討、再議論の必要あり
                    //　viewの座標をキーボードのサイズ*移動率の分だけズラす
                    if self.view.frame.origin.y == 0 {
                        self.view.frame.origin.y -= keyboardSize.height * rate
                    } else {
                        let suggestionHeight = self.view.frame.origin.y + keyboardSize.height * rate
                        self.view.frame.origin.y -= suggestionHeight
                    }
                }
            }
        }
    }
    
    // キーボードが閉じられた時の処理
    @objc func keyboardWillHide() {
        //　viewの座標を0にリセットする
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
        //　キーボードのキャンセルを検知する
        tapGesture.cancelsTouchesInView = false
        //　tapGestureを登録する
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // キーボードがキャンセルされた時の処理
    @objc func dismissKeyboard() {
        //　編集が終わったことを通知する
        self.view.endEditing(true)
    }
    
    //　WordListConrollerに戻る
    @objc func onTapDismissWordAddView() {
        // 画面を消す
        dismiss(animated: true,completion: nil)
    }
}
