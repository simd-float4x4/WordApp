import UIKit

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
    
    func initializeWordAddView() {
        let view = AddWordView()
        view.singleWordTextView.delegate = self
        view.meaningWordTextView.delegate = self
        view.exampleSentenceTextView.delegate = self
        view.exampleTranslationTextView.delegate = self
        view.addWordToWordListDelegate = self
        self.view = view
    }
    
    func reloadWordListWidget() {
        let wordListView = WordListView()
        wordListView.wordListWidget.reloadData()
    }
    
    func addWordToList(data: [String]) {
        let checkBool = makeValidationToAddWord(data: data)
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
            // TODO: 確実に要素数を取得する方法を探す
            // TODO: WordListViewController経由で.addWordListする
            let currentWordId = model.wordList.count
            model.addWordToList(id: currentWordId, data: data)
            registerModel()
        }
    }
    
    func makeValidationToAddWord(data: [String]) -> Bool{
        for i in 0 ..< data.count {
            if data[i].isEmpty {
                return false
            }
        }
        return true
    }
    
    func registerModel() {
        NotificationCenter.default.post(name: .notifyName, object: nil)
    }
    
    func sendWordModelToPrevious() {
        if let index = navigationController?.viewControllers.count {
            let preVC = navigationController?.viewControllers[index - 1] as! WordListViewController
            preVC.wordModel = self.model
            print(self.model.wordList.last?.word)
            print(preVC.wordModel?.wordList.last?.word)
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
