import UIKit

// MARK: WordDetailViewController
class WordRememberedListViewController: UIViewController, SortWordRememberedListWidgetDelegate {
    //　ワードモデル
    var wordModel = WordListModel.shared
    //　テーマモデル
    var themeModel = DesignThemeListModel.shared
    //　UserDefaults
    let ud = UserDefaults.standard
    
    // DetailViewControllerに渡すための文字列
    var singleWord: String = ""
    var meaning: String = ""
    var exampleSentence: String = ""
    var exampleTranslation: String = ""
    
    // ソートタイプ：default値は1をセットする。
    var sortType: Int = 1
    //　ソートボタンのテキスト
    var sortTypeTextArray: [String] = [
        NSLocalizedString("sortOldOrder", comment: ""),
        NSLocalizedString("sortNewOrder", comment: ""),
        NSLocalizedString("sortABCAsc", comment: ""),
        NSLocalizedString("sortABCDesc", comment: ""),
        NSLocalizedString("sortRandom", comment: ""),
        NSLocalizedString("sortWrongCountAsc", comment: ""),
        NSLocalizedString("sortWrongCountDesc", comment: "")]
    //　ナビゲーションバータイトル
    let WordRememberedListNavigationItem = UINavigationItem(title: "暗記リスト")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //　Viewを初期化する
        initializeView()
        //　WordListWidgetを更新する
        reloadWordListWidget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //　Viewを初期化する
        initializeView()
        //　現在暗記リストが表示されていることを通知する
        wordModel.changeUserReferredWordListStatus(key: "wordRememberedListIsShown")
        //　WordListWidgetを更新する
        reloadWordListWidget()
    }
    
    //　Viewを初期化する
    func initializeView() {
        //　WordRememberedListViewを取得する
        let view = WordRememberedListView()
        //　Delegateを設定する
        view.wordRememberedListWidget.delegate = self
        view.sortWordRemeberedListDelegate = self
        //　DataSourceを設定する
        view.wordRememberedListWidget.dataSource = self.wordModel
        //　ラベルに初期値を設定する
        view.thereIsNoWordLabel.text = NSLocalizedString("WordListWidgetIsNilLabel", comment: "")
        self.view = view
    }
    
    // ToDetailViewに遷移したときに値を渡す処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //　詳細画面に移動
        if segue.identifier == "toWordDetailView" {
            //　単語詳細画面を取得する
            let wordDetailView = segue.destination as! WordDetailViewController
            //　値を渡す
            wordDetailView.singleWord = singleWord
            wordDetailView.meaning = meaning
            wordDetailView.exampleSentence = exampleSentence
            wordDetailView.exampleTranslation = exampleTranslation
        }
    }
    
    //　詳細画面に行く
    @objc func toWordDetailView() {
        performSegue(withIdentifier: "toWordDetailView", sender: nil)
    }
    
    // WordListWidgetをリロードする
    func reloadWordListWidget() {
        // WordListViewの描画を更新する
        let wordListView = self.view as! WordRememberedListView
        //　テーブルをリロードする
        wordListView.wordRememberedListWidget.reloadData()
        //　暗記された単語の数がゼロなら
        if wordModel.returnFilteredWordList(isWordRememberedStatus: true).count == 0 {
            //　テーブルを隠して、ラベルを表示する
            wordListView.wordRememberedListWidget.isHidden = true
            wordListView.thereIsNoWordLabel.isHidden = false
        } else {
            //　テーブルを表示して、ラベルを隠す
            wordListView.wordRememberedListWidget.isHidden = false
            wordListView.thereIsNoWordLabel.isHidden = true
        }
    }
    
    // WordListWidgetをソートする
    func sortWordRememberedListView() {
        //　WordRememberedListViewを取得する
        let wordRememberedListView = self.view as! WordRememberedListView
        //　ソートタイプをインクリメント
        sortType += 1
        // TODO: (ソートタイプの上限)を定数管理する
        // 一巡したらソートタイプを1に戻す
        sortType = sortType == sortTypeTextArray.count + 1 ? 1 : sortType
        // wordListを並び替える
        wordModel.sortWordList(sortModeId: sortType)
        // ソートボタンのラベル文字を適宜変更する
        wordRememberedListView.sortWordRememberedListButton.setTitle(sortTypeTextArray[sortType-1], for: .normal)
        // WordListWidgetをリロードする
        reloadWordListWidget()
    }
}
