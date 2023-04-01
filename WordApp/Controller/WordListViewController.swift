import UIKit

class WordListViewController: UIViewController {
    
    var myModel: WordListModel? {
        // セットされるたびにdidSetが動作する
        didSet {
            // ViewとModelとを結合し、Modelの監視を開始する
            registerModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = WordListView()
        
        self.myModel = WordListModel()
        initializeWordListWidget()
    }
    
    private func initializeWordListWidget() {
        let wordListView = self.view as! WordListView
        wordListView.wordListWidget.delegate = self
        wordListView.wordListWidget.dataSource = self.myModel
        wordListView.wordListWidget.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func registerModel() {
        guard let model = myModel else { return }
        
        // 配列が変化したらnotificationCenterで通知を受け取る。
        model.notificationCenter.addObserver(forName: .init(rawValue: "changeTweetList"),
                                             object: nil,
                                             queue: nil,
                                             using: {
            [unowned self] notification in
            let wordListView = self.view as! WordListView
            
            wordListView.wordListWidget.reloadData()
        })
    }
    
    // TableViewのセルのタップを検知して、Modelの配列追加する処理を呼び出す。
    @objc func onTapTableViewCell() { myModel?.addWordToList() }
}

// TableViewを描画・処理する為に最低限必要なデリゲートメソッド、データソース
extension WordListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Modelでタップされた時の追加処理を行う。
        self.onTapTableViewCell()
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "削除") { (action, view, completionHandler) in
            self.myModel?.removeWord(index: indexPath.row)
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor.systemRed
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
