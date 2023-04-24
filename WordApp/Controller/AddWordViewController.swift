import UIKit

// MARK: AddWordViewController
class AddWordViewController: UIViewController, UITextViewDelegate, AddWordToWordListDelegate {
    
    var wordModel = WordListModel.shared
    var themeModel = DesignThemeListModel.shared
    var tappedTextViewName = ""
    
    let alertErrorTitleLabel = NSLocalizedString("alertErrorTitle", comment: "")
    let alertMessageSucceedLabel = NSLocalizedString("alertRegisterWordIsFinishedText", comment: "")
    let alertMesssageFailedLabel = NSLocalizedString("alertRegisterWordIsFailedText", comment: "")
    let alertOkButton = NSLocalizedString("alertOkButton", comment: "")
    let alertRegisterFinishedPrefixLabel = NSLocalizedString("alertRegisterWordIsFinishedTitle", comment: "")
    let alertRegisterFinishedSuffixLabel = NSLocalizedString("alertRegisterWordIsFinishedTitleSuffix", comment: "")

    let singleWordTextViewisTapped = NSLocalizedString("single", comment: "")
    let meaningTextViewisTapped = NSLocalizedString("meaning", comment: "")
    let exampleSentenceTextViewisTapped = NSLocalizedString("ex-sente", comment: "")
    let exampleTranslationTextViewisTapped = NSLocalizedString("ex-trans", comment: "")
    
    let addWordNavigationItem = UINavigationItem(title: "単語登録画面")
    
    var navigationBarImageName = "chevron.backward"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeWordAddView()
        hideTabBarController()
        setNotificationCenters()
        setTapGesuture()
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
        let navBarView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 94))
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width, height: 44))
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navBar.standardAppearance = appearance
        let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as? Int ?? 0
        var color = themeModel.themeList[selected].theme.accentColor
        if selected == 3 { color = themeModel.themeList[selected].theme.complementalColor }
        navBarView.tintColor = UIColor.white
        navBarView.backgroundColor = UIColor(hex: color)
        let settingNavigationItem = UINavigationItem(title: "単語登録画面")
        
        settingNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: navigationBarImageName)!, style: .plain, target: self, action: #selector(onTapDismissWordView))
        navBar.setItems([settingNavigationItem], animated: false)
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        navBar.scrollEdgeAppearance = navigationBarAppearance
    
        navBarView.addSubview(navBar)
        view.addSubview(navBarView)
        
        self.view = view
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension AddWordViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
