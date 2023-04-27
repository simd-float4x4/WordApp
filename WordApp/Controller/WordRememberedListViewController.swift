import UIKit

class WordRememberedListViewController: UIViewController, SortWordRememberedListWidgetDelegate {
    
    var wordModel = WordListModel.shared
    var themeModel = DesignThemeListModel.shared
    let ud = UserDefaults.standard
    
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
