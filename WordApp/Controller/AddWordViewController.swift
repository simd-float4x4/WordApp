import UIKit

// MARK: AddWordViewController
class AddWordViewController: UIViewController, UITextViewDelegate, AddWordToWordListDelegate {
    
    var model = WordListModel()
    
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
        self.view = view
    }
    
    // 単語を登録する
    func addWordToList(data: [String]) {
        // バリデーションチェック
        let checkBool = makeValidationToAddWord(data: data)
        // エラー発生時
        if !checkBool {
            // TODO: エラーハンドリング
            let alertContent = UIAlertController(
                title: "エラー",
                message: "単語の登録が出来ませんでした。",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alertContent.addAction(okAction)
            present(alertContent, animated: true, completion: nil)
        } else {
        // バリデーション追加時
            let currentWordId = model.wordList.count
            model.addWordToList(id: currentWordId, data: data)
            let alertContent = UIAlertController(
                title: "登録完了（"+data[0]+"）",
                message: "単語を完了いたしました。",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style: .default) { (action) in
                    let view = AddWordView()
                    view.resetWordInputField()
                    self.initializeWordAddView()
                self.dismiss(animated: true, completion: nil)
            }
            alertContent.addAction(okAction)
            present(alertContent, animated: true, completion: nil)
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
            preVC.wordModel = self.model
            // TODO: WordListViewの最新版の中身を登録する
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
}
