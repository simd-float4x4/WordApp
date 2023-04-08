import UIKit

//TODO: Delegateをextensionごとに切り出す
//TODO: 全体的にコードが非常に読みにくいので適宜リファクタリングする
class WordListViewController: UIViewController, ReloadWordListWidgetDelegate, SortWordListWidgetDelegate {
    
    var wordModel: WordListModel? {
        // セットされるたびにdidSetが動作する
        didSet {
            // ViewとModelとを結合し、Modelの監視を開始する
            registerModel()
        }
    }
    var notificationObserver: NSObjectProtocol?
    
    var singleWord: String = ""
    var meaning: String = ""
    var exampleSentence: String = ""
    var exampleTranslation: String = ""
    var sortType: Int = 1
    var sortTypeTextArray: [String] = ["登録日時が古い順", "登録日時が新しい順", "アルファベット順(昇順)", "アルファベット順(降順)"]
    var isDeleteModeOn: Bool = true
    
    @IBOutlet var nabigationBarLeftButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = WordListView()
        
        let ud = UserDefaults.standard
        ud.set(true, forKey: "isMeaningHidden")
        ud.synchronize()

        self.wordModel = WordListModel()
        fetchCurrentProgress()
        initializeWordListWidget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initializeWordListWidget()
        reloadWordListWidget()
        print(wordModel?.wordList.last?.word)
    }
    
    private func fetchCurrentProgress() {
        let wordListView = self.view as! WordListView
        let wordSolvedSum = 2
        let wordTotalSum = wordModel?.wordList.count ?? 0
        // TODO: 暗記機能実装後にゼロ除算対策をする
        let wordRememberedPercentage = wordTotalSum != 0 ? wordSolvedSum * 100 / wordTotalSum : 100
        wordListView.progressWordSumLabel.text = String(wordSolvedSum) + " / " + String(wordTotalSum)
        wordListView.progressPercentageLabel.text = String(wordRememberedPercentage) + " %"
        wordListView.progressBarWidget.progress = Float(wordRememberedPercentage) / 100.0
    }
    
    private func initializeWordListWidget() {
        let wordListView = self.view as! WordListView
        wordListView.reloadWordListDelegate = self
        wordListView.sortWordListDelegate = self
        wordListView.wordListWidget.delegate = self
        wordListView.wordListWidget.dataSource = self.wordModel
        wordListView.wordListWidget.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func reloadWordListWidget() {
        let wordListView = self.view as! WordListView
        wordListView.wordListWidget.reloadData()
    }
    
    func sortWordListView() {
        let wordListView = self.view as! WordListView
        sortType += 1
        sortType = sortType == 5 ? 1 : sortType
        wordModel?.sortWordList(sortModeId: sortType)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWordDetailView" {
            let wordDetailView = segue.destination as! WordDetailViewController
            wordDetailView.singleWord = singleWord
            wordDetailView.meaning = meaning
            wordDetailView.exampleSentence = exampleSentence
            wordDetailView.exampleTranslation = exampleTranslation
        }
    }
    
    // TableViewのセルのタップを検知して、Modelの配列追加する処理を呼び出す。
    @objc func onTapTableViewCell() {
        // wordModel?.addWordToList(id: 100, data: ["0","a","sa","ss"])
        fetchCurrentProgress()
    }
    
    @objc func toWordDetailView() {
        performSegue(withIdentifier: "toWordDetailView", sender: nil)
    }
    
    @IBAction func toAddWordView() {
        performSegue(withIdentifier: "toAddWordView", sender: nil)
    }
    
    // 削除ボタンと暗記した！ボタンを切り替える
    @IBAction func switchWordActionMode() {
        isDeleteModeOn = isDeleteModeOn == true ? false : true
        nabigationBarLeftButton.image = isDeleteModeOn == true ? UIImage(systemName: "brain") : UIImage(systemName: "trash.fill")
    }
}

// TableViewを描画・処理する為に最低限必要なデリゲートメソッド、データソース
extension WordListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Modelでタップされた時の追加処理を行う。
        tableView.deselectRow(at: indexPath, animated: true)
        let model = wordModel?.wordList[indexPath.row]
        self.singleWord = model?.word.singleWord ?? ""
        self.meaning = model?.word.meaning ?? ""
        self.exampleSentence = model?.word.exampleSentence ?? ""
        self.exampleTranslation = model?.word.exampleTranslation ?? ""
        self.toWordDetailView()
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "削除") { (action, view, completionHandler) in
            self.wordModel?.removeWord(index: indexPath.row)
            self.fetchCurrentProgress()
            completionHandler(true)
        }
        let rememberedAction = UIContextualAction(style: .normal, title: "覚えた") { (action, view, completionHandler) in
            self.wordModel?.upDateRememberStatus(index: indexPath.row)
            // TODO: 暗記リスト配列に追加
            self.wordModel?.removeWord(index: indexPath.row)
            // TODO: ProgressBarを更新
            self.fetchCurrentProgress()
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor.systemRed
        rememberedAction.backgroundColor = UIColor.blue
        if isDeleteModeOn != true {
            return UISwipeActionsConfiguration(actions: [rememberedAction])
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}


extension Notification.Name {
    static let notifyName = Notification.Name("changeWordList")
}
