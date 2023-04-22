import UIKit

// MARK: AddWordViewController
class AddWordViewController: UIViewController, UITextViewDelegate, AddWordToWordListDelegate {
    
    var wordModel = WordListModel.shared
    var tappedTextViewName = ""
    
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
        self.view = view
    }
    
    // 単語を登録する
    func addWordToList(data: [String]) {
        // バリデーションチェック
        let checkBool = makeValidationToAddWord(data: data)
        // エラー発生時
        if !checkBool {
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            showAlert(title: "エラー", message: "単語の登録が出来ませんでした。", actions: [okAction])
        } else {
            // バリデーション追加時
            let currentWordId = wordModel.wordList.last?.word.id ?? 0
            wordModel.addWordToList(id: currentWordId, data: data)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                let view = AddWordView()
                view.resetWordInputField()
                self.initializeWordAddView()
                self.dismiss(animated: true, completion: nil)
            }
            showAlert(title: "登録完了（"+data[0]+"）", message: "単語を完了いたしました。", actions: [okAction])
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
            tappedTextViewName = ".singleWord"
        }
        if textView == addWordView.meaningWordTextView {
            tappedTextViewName = ".meaningWord"
        }
        if textView == addWordView.exampleSentenceTextView {
            tappedTextViewName = ".exampleSentence"
        }
        if textView == addWordView.exampleTranslationTextView {
            tappedTextViewName = ".exampleTranslation"
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
            if self.tappedTextViewName == ".exampleTranslation" {
                exampleHeight = 0.75
            }
            if self.tappedTextViewName == ".exampleSentence" {
                exampleHeight = 0.5
            }
            // singleWordだったら動かさない
            if self.tappedTextViewName == ".exampleTranslation" || self.tappedTextViewName == ".exampleSentence" {
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
    
    // AddWordViewからタップ情報を取得
    func getTappedTextviewName(name: String) {
        tappedTextViewName = name
    }
}
