import UIKit

// MARK: WordListViewController
class WordListViewController: UIViewController, ReloadWordListWidgetDelegate, SortWordListWidgetDelegate {
    
    var wordModel = WordListModel.shared
    
    // DetailViewControllerに渡すための文字列
    var singleWord: String = ""
    var meaning: String = ""
    var exampleSentence: String = ""
    var exampleTranslation: String = ""
    // ソートタイプ：default値は1をセットする。
    var sortType: Int = 1
    // TODO: Localizable.stringにする
    var sortTypeTextArray: [String] = ["登録日時が古い順", "登録日時が新しい順", "アルファベット順(昇順)", "アルファベット順(降順)"]
    var isDeleteModeOn: Bool = true
    
    // 削除モード/暗記モード切り替えボタン。NavigationBarの左上に配置するものとする。
    @IBOutlet var nabigationBarLeftButton: UIBarButtonItem!
    
    let ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        // 日本語訳の表示/非表示に関しては、アプリ起動時には原則trueをセットする
        ud.set(true, forKey: "isMeaningHidden")
        ud.synchronize()
        // データを呼び出す
        wordModel.fetchSavedData()
        // 描画系処理を呼び出す
        fetchCurrentProgress()
        initializeWordListWidget()
    }
    
    // 画面が呼ばれるたびにWordListWidgetを更新する
    override func viewWillAppear(_ animated: Bool) {
        initializeView()
        initializeWordListWidget()
        wordModel.changeUserReferredWordListStatus(key: "wordListIsShown")
        reloadWordListWidget()
        fetchCurrentProgress()
        showTabBarController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeAllSubviews(parentView: self.view)
    }
    
    func removeAllSubviews(parentView: UIView){
        let subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func initializeView() {
        removeAllSubviews(parentView: self.view)
        let view = WordListView()
        self.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let navHeight = self.navigationController?.navigationBar.frame.height ?? 0
        let bottomHeight = -(self.tabBarController?.tabBar.frame.height ?? 0)
        print(navHeight, bottomHeight)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: navHeight),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: bottomHeight),
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 4.0),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 4.0),
            view.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            view.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        ])
    }
    
    // 最新の回答状況を取得する
    private func fetchCurrentProgress() {
        let wordListView = self.view.subviews.first as! WordListView
        let wordSolvedSum = wordModel.wordList.filter({$0.word.isRemembered == true}).count
        let wordTotalSum = wordModel.wordList.count
        // TODO: 暗記機能実装後にゼロ除算対策をする
        let wordRememberedPercentage = wordTotalSum != 0 ? wordSolvedSum * 100 / wordTotalSum : 100
        wordListView.progressWordSumLabel.text = String(wordSolvedSum) + " / " + String(wordTotalSum)
        wordListView.progressPercentageLabel.text = String(wordRememberedPercentage) + " %"
        wordListView.progressBarWidget.progress = Float(wordRememberedPercentage) / 100.0
    }
    
    // WordListWidgetを初期化する
    private func initializeWordListWidget() {
        let wordListView = self.view.subviews.first as! WordListView
        wordListView.reloadWordListDelegate = self
        wordListView.sortWordListDelegate = self
        wordListView.wordListWidget.delegate = self
        wordListView.wordListWidget.dataSource = self.wordModel
        wordListView.wordListWidget.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // WordListWidgetをリロードする
    func reloadWordListWidget() {
        // WordListViewの描画を更新する
        let wordListView = self.view.subviews.first as! WordListView
        wordListView.wordListWidget.reloadData()
        // 表示上の配列をあらかじめfilterしておく
        let itemList =  wordModel.returnFilteredWordList(isWordRememberedStatus: false)
        if itemList.isEmpty == true {
            wordListView.wordListWidget.isHidden = true
        } else {
            wordListView.wordListWidget.isHidden = false
        }
    }
    
    // WordListWidgetに現在表示されているModelをUserDefaultsに保存する
    
    // WordListWidgetをソートする
    func sortWordListView() {
        let wordListView = self.view.subviews.first as! WordListView
        sortType += 1
        // TODO: 5(ソートタイプの上限)を定数管理する
        // 一巡したらソートタイプを1に戻す（sortType: 5~7は暗記専用）
        sortType = sortType == 5 ? 1 : sortType
        // wordListを並び替える
        wordModel.sortWordList(sortModeId: sortType)
        // ソートボタンのラベル文字を適宜変更する
        wordListView.sortWordListButton.setTitle(sortTypeTextArray[sortType-1], for: .normal)
        reloadWordListWidget()
    }
    
    private func registerModel() {
        // 配列が変化したらnotificationCenterで通知を受け取る。
        NotificationCenter.default.addObserver(
            forName: .notifyName,
            object: nil,
            queue: nil,
            using: {
                [unowned self] Notification in
                reloadWordListWidget()
        })
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
    
    @IBAction func toAddWordView() {
        performSegue(withIdentifier: "toAddWordView", sender: nil)
    }
    
    // 削除ボタンと暗記した！ボタンを切り替えた際にアイコンの画像を変更する
    @IBAction func switchWordActionMode() {
        isDeleteModeOn = isDeleteModeOn == true ? false : true
        nabigationBarLeftButton.image = isDeleteModeOn == true ? UIImage(systemName: "brain") : UIImage(systemName: "trash.fill")
    }
}

// MARK: WordListViewControllerのTableViewDelegate
// TableViewを描画・処理する為に最低限必要なデリゲートメソッド、データソース
extension WordListViewController: UITableViewDelegate {

    // セルが選択された際の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 表示上の配列をあらかじめfilterしておく
        let itemList =  wordModel.returnFilteredWordList(isWordRememberedStatus: false)
        // タップされた時の追加処理を行う。
        tableView.deselectRow(at: indexPath, animated: true)
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
        let itemList =  wordModel.returnFilteredWordList(isWordRememberedStatus: false)
        // 削除アクション
        let deleteAction = UIContextualAction(style: .normal, title: "削除") { (action, view, completionHandler) in
            // 配列からidを取得
            let id = itemList[indexPath.row].word.id
            // wordModel.wordListから該当するidの要素を削除
            self.wordModel.removeWord(index: id)
            // WordListWidgetを更新
            self.reloadWordListWidget()
            // ProgressBarを更新
            self.fetchCurrentProgress()
            completionHandler(true)
        }
        // 暗記アクション
        let rememberedAction = UIContextualAction(style: .normal, title: "覚えた") { (action, view, completionHandler) in
            let id = itemList[indexPath.row].word.id
            self.wordModel.upDateRememberStatus(index: id)
            // WordListWidgetを更新
            self.reloadWordListWidget()
            // ProgressBarを更新
            self.fetchCurrentProgress()
            completionHandler(true)
        }
        // 背景色の決定
        deleteAction.backgroundColor = UIColor.systemRed
        rememberedAction.backgroundColor = UIColor.blue
        // 削除モードがON/OFFの時、アクションを切り替える
        if isDeleteModeOn != true {
            return UISwipeActionsConfiguration(actions: [rememberedAction])
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // 単語登録画面から帰ってきた時にTabBarの非表示を解除する（厳密にはどの画面から飛んできても表示する）
    func showTabBarController() {
        self.tabBarController?.tabBar.isHidden = false
    }
}
