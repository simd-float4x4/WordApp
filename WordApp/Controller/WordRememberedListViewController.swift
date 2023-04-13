import UIKit

class WordRememberedListViewController: UIViewController {
    
    var wordModel = WordListModel.shared
    
    // DetailViewControllerに渡すための文字列
    var singleWord: String = ""
    var meaning: String = ""
    var exampleSentence: String = ""
    var exampleTranslation: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = WordRememberedListView()
        view.wordRememberedListWidget.delegate = self
        view.wordRememberedListWidget.dataSource = self.wordModel
        self.view = view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        wordModel.changeUserReferredWordListStatus(key: "wordRememberedListIsShown")
        self.reloadWordListWidget()
    }
    
    // ToDetailViewに遷移したときに値を渡す処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWordDetailView" {
            let wordDetailView = segue.destination as! WordDetailViewController
            wordDetailView.singleWord = singleWord
            wordDetailView.meaning = meaning
            wordDetailView.exampleSentence = exampleSentence
            wordDetailView.exampleTranslation = exampleTranslation
        }
    }
    
    // 画面遷移系メソッド
    @objc func toWordDetailView() {
        performSegue(withIdentifier: "toWordDetailView", sender: nil)
    }
    
    // WordListWidgetをリロードする
    func reloadWordListWidget() {
        // TODO: WordListViewの最新版の中身を取得する
        
        // WordListViewの描画を更新する
        let wordListView = self.view as! WordRememberedListView
        wordListView.wordRememberedListWidget.reloadData()
        if wordModel.wordList.isEmpty == true {
            wordListView.wordRememberedListWidget.isHidden = true
        } else {
            wordListView.wordRememberedListWidget.isHidden = false
        }
    }
}


// MARK: WordRememberedListViewControllerのTableViewDelegate
// TableViewを描画・処理する為に最低限必要なデリゲートメソッド、データソース
extension WordRememberedListViewController: UITableViewDelegate {
    
    // セルが選択された際の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // タップされた時にセルの選択を解除する。
        tableView.deselectRow(at: indexPath, animated: true)
        // 表示上の配列をあらかじめfilterしておく
        let itemList =  wordModel.returnFilteredWordList(isWordRememberedStatus: true)
        // 配列からidを取得
        let id = itemList[indexPath.row].word.id
        // 取得したidからデータ絞り込み
        let model = wordModel.wordList.first(where: {$0.word.id == id})
        // 単語詳細画面に行く際のデータを橋渡し
        self.singleWord = model?.word.singleWord ?? ""
        self.meaning = model?.word.meaning ?? ""
        self.exampleSentence = model?.word.exampleSentence ?? ""
        self.exampleTranslation = model?.word.exampleTranslation ?? ""
        // 単語詳細画面へ
        self.toWordDetailView()
    }
    
    // セルをスワイプした時の処理
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 表示上の配列をあらかじめfilterしておく
        let itemList =  wordModel.returnFilteredWordList(isWordRememberedStatus: true)
        // 配列からidを取得
        let id = itemList[indexPath.row].word.id
        // 復元アクション
        let categorizeToWordListAction = UIContextualAction(style: .normal, title: "復元") { (action, view, completionHandler) in
            self.wordModel.upDateRememberStatus(index: id)
            self.reloadWordListWidget()
            completionHandler(true)
        }
        categorizeToWordListAction.backgroundColor = UIColor.systemGreen
        return UISwipeActionsConfiguration(actions: [categorizeToWordListAction])
    }
}
