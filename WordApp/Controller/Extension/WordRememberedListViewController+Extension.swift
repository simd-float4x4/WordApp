import UIKit
import Foundation

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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //ヘッダーにするビューを生成
        let view = CustomView()
        let wordListView = self.view as! WordRememberedListView
        let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as? Int ?? 0
        let color = themeModel.themeList[selected].theme.accentColor
        var fontColor = themeModel.themeList[selected].theme.fontColor
        if selected == 0 || selected == 3 || selected == 4 || selected == 5 {
            fontColor = themeModel.themeList[selected].theme.complementalFontColor
        }
        view.backgroundColor = UIColor(hex: color)
        view.frame = CGRect(x: 20, y: 0, width: wordListView.wordRememberedListWidget.frame.width, height: 30)
        if selected == 1 {
            view.layer.shadowColor = UIColor.clear.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        //ヘッダーに追加するラベルを生成
        let headerLabel = UILabel()
        headerLabel.frame =  view.frame
        headerLabel.text = "誤答数"
        headerLabel.font = UIFont(name: "System", size: 10)
        headerLabel.textColor = UIColor(hex: fontColor)
        headerLabel.textAlignment = NSTextAlignment.left
        view.addSubview(headerLabel)
        
        return view
    }

}

// MARK: WordListViewControllerのUINavigationBarDelegate
extension WordRememberedListViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
