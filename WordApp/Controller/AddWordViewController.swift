import UIKit

class AddWordViewController: UIViewController, UITextViewDelegate, AddWordViewDelegate {
    
    var wordModel: WordListModel? {
        // セットされるたびにdidSetが動作する
        didSet {
            // ViewとModelとを結合し、Modelの監視を開始する
            registerModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeWordAddView()
    }
    
    func initializeWordAddView() {
        let view = AddWordView()
        view.singleWordTextView.delegate = self
        view.meaningWordTextView.delegate = self
        view.exampleSentenceTextView.delegate = self
        view.exampleTranslationTextView.delegate = self
        view.addWordViewDelegate = self
        self.view = view
        self.wordModel = WordListModel()
    }
    
    func reloadWordListWidget() {
        let wordListView = WordListView()
        wordListView.wordListWidget.reloadData()
    }
    
    private func registerModel() {
        guard let model = wordModel else { return }
        model.notificationCenter.post(name: .notifyName, object: nil)
    }
    
    func callAddWordFunction(data: [String]) {
        addWordToList(data: data)
    }
    
    @objc func addWordToList(data: [String]) {
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
            let currentWordId = wordModel?.wordList.count ?? 0
            wordModel?.addWordToList(id: currentWordId, data: data)
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
