import UIKit

class WordListViewController: UIViewController, ReloadWordListWidgetDelegate {
    
    var wordModel: WordListModel? {
        // セットされるたびにdidSetが動作する
        didSet {
            // ViewとModelとを結合し、Modelの監視を開始する
            registerModel()
        }
    }
    
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
    
    private func fetchCurrentProgress() {
        let wordListView = self.view as! WordListView
        let wordSolvedSum = 0
        let wordTotalSum = wordModel?.wordList.count ?? 0
        // TO-DO:　暗記機能実装後にゼロ除算対策をする
        let wordRememberedPercentage = wordTotalSum != 0 ? wordSolvedSum * 100 / wordTotalSum : 100
        wordListView.progressWordSumLabel.text = String(wordSolvedSum) + " / " + String(wordTotalSum)
        wordListView.progressPercentageLabel.text = String(wordRememberedPercentage) + " %"
        wordListView.progressBarWidget.progress = Float(wordRememberedPercentage) / 100.0
    }
    
    private func initializeWordListWidget() {
        let wordListView = self.view as! WordListView
        wordListView.delegate = self
        wordListView.wordListWidget.delegate = self
        wordListView.wordListWidget.dataSource = self.wordModel
        wordListView.wordListWidget.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func reloadWordListWidget() {
        let wordListView = self.view as! WordListView
        wordListView.wordListWidget.reloadData()
    }
    
    private func registerModel() {
        guard let model = wordModel else { return }
        
        // 配列が変化したらnotificationCenterで通知を受け取る。
        model.notificationCenter.addObserver(forName: .init(rawValue: "changeTweetList"),
                                             object: nil,
                                             queue: nil,
                                             using: {
            [unowned self] notification in
            reloadWordListWidget()
        })
    }
    
    // TableViewのセルのタップを検知して、Modelの配列追加する処理を呼び出す。
    @objc func onTapTableViewCell() {
        wordModel?.addWordToList()
        fetchCurrentProgress()
    }
}

// TableViewを描画・処理する為に最低限必要なデリゲートメソッド、データソース
extension WordListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Modelでタップされた時の追加処理を行う。
        self.onTapTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "削除") { (action, view, completionHandler) in
            self.wordModel?.removeWord(index: indexPath.row)
            self.fetchCurrentProgress()
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor.systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
