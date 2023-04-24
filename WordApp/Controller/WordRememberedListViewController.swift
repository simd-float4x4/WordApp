import UIKit

class WordRememberedListViewController: UIViewController, SortWordRememberedListWidgetDelegate {
    
    var wordModel = WordListModel.shared
    var themeModel = DesignThemeListModel.shared
    
    // DetailViewControllerに渡すための文字列
    var singleWord: String = ""
    var meaning: String = ""
    var exampleSentence: String = ""
    var exampleTranslation: String = ""
    
    // ソートタイプ：default値は1をセットする。
    var sortType: Int = 1
    var sortTypeTextArray: [String] = [
        NSLocalizedString("sortOldOrder", comment: ""),
        NSLocalizedString("sortNewOrder", comment: ""),
        NSLocalizedString("sortABCAsc", comment: ""),
        NSLocalizedString("sortABCDesc", comment: ""),
        NSLocalizedString("sortRandom", comment: ""),
        NSLocalizedString("sortWrongCountAsc", comment: ""),
        NSLocalizedString("sortWrongCountDesc", comment: "")]
    
    let WordRememberedListNavigationItem = UINavigationItem(title: "暗記リスト")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initializeView()
        wordModel.changeUserReferredWordListStatus(key: "wordRememberedListIsShown")
        self.reloadWordListWidget()
    }
    
    func initializeView() {
        let view = WordRememberedListView()
        view.wordRememberedListWidget.delegate = self
        view.wordRememberedListWidget.dataSource = self.wordModel
        view.sortWordRemeberedListDelegate = self
        // view.viewNavigationBar.delegate = self
        // view.viewNavigationBar.setItems([WordRememberedListNavigationItem], animated: false)
        let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as? Int ?? 0
        if selected == 1 || selected == 3 || selected == 6 || selected == 7 {
            let color = themeModel.themeList[selected].theme.subColor
            // view.viewNavigationBar.barTintColor = UIColor(hex: color)
        }
        self.view = view
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
        // WordListViewの描画を更新する
        let wordListView = self.view as! WordRememberedListView
        wordListView.wordRememberedListWidget.reloadData()
        if wordModel.wordList.isEmpty == true {
            wordListView.wordRememberedListWidget.isHidden = true
        } else {
            wordListView.wordRememberedListWidget.isHidden = false
        }
    }
    
    // WordListWidgetをソートする
    func sortWordRememberedListView() {
        let wordRememberedListView = self.view as! WordRememberedListView
        sortType += 1
        // TODO: (ソートタイプの上限)を定数管理する
        // 一巡したらソートタイプを1に戻す
        sortType = sortType == sortTypeTextArray.count + 1 ? 1 : sortType
        // wordListを並び替える
        wordModel.sortWordList(sortModeId: sortType)
        // ソートボタンのラベル文字を適宜変更する
        wordRememberedListView.sortWordRememberedListButton.setTitle(sortTypeTextArray[sortType-1], for: .normal)
        reloadWordListWidget()
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
        let categorizeToWordListAction = UIContextualAction(style: .normal, title: NSLocalizedString("WordRecoveryButton", comment: "")) { (action, view, completionHandler) in
            // 単語帳に戻す
            self.wordModel.upDateRememberStatus(index: id)
            // 誤答数をリセットする
            self.wordModel.resetWordWrongCount(index: id)
            // WoedListを更新する
            self.reloadWordListWidget()
            completionHandler(true)
        }
        categorizeToWordListAction.backgroundColor = UIColor.systemGreen
        return UISwipeActionsConfiguration(actions: [categorizeToWordListAction])
    }

}

extension WordRememberedListViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
