import UIKit
import Foundation

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
        let deleteAction = UIContextualAction(style: .normal, title: wordDeleteButtonTextLabel) { (action, view, completionHandler) in
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
        let rememberedAction = UIContextualAction(style: .normal, title: wordRememberedButtonTextLabel) { (action, view, completionHandler) in
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

// MARK: WordListViewControllerのUINavigationBarDelegate
extension WordListViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
