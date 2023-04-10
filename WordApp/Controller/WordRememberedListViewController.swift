import UIKit

class WordRememberedListViewController: UIViewController {
    
    var wordModel = WordListModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = WordRememberedListView()
        view.wordRememberedListWidget.delegate = self
        view.wordRememberedListWidget.dataSource = self.wordModel
        // checkIsThisRememberedWordListの変数を切り替える
        self.wordModel.changeUserReferredWordListStatus()
        self.view = view
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
    
    // セルをスワイプした時の処理
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // 表示上の配列をあらかじめfilterしておく
        let itemList =  wordModel.returnFilteredWordList(isWordRememberedStatus: true)
        // 配列からidを取得
        let id = itemList[indexPath.row].word.id
        // 復元アクション
        let categorizeToWordListAction = UIContextualAction(style: .normal, title: "覚えた") { (action, view, completionHandler) in
            self.wordModel.upDateRememberStatus(index: id)
            self.reloadWordListWidget()
            completionHandler(true)
        }
        categorizeToWordListAction.backgroundColor = UIColor.systemGreen
        return UISwipeActionsConfiguration(actions: [categorizeToWordListAction])
    }
}
