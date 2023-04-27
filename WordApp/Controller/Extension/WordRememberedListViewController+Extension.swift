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
        //　スワイプアクション背景色を緑色にする
        categorizeToWordListAction.backgroundColor = UIColor.systemGreen
        return UISwipeActionsConfiguration(actions: [categorizeToWordListAction])
    }
    
    //　テーマの名前を取得する
    func getThemeName(index: Int) -> String{
        // テーマの名称を取得する
        let themeName = themeModel.themeList[index].theme.name
        return themeName
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //　viewのheightをセット
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //　ヘッダーにするビューを生成
        var view = CustomView()
        //　テーマIDを取得
        let selected = ud.selectedThemeColorId
        //　テーマ名を取得
        let themeName = getThemeName(index: selected)
        //　フォントカラーを取得
        var fontColor = themeModel.themeList[selected].theme.fontColor
        //　フォントカラーの補色をセット
        fontColor = setUpComplementalFontColor(themeName: themeName, selected: selected)
        //　Viewのカラーをセットアップ
        view = setUpViewColor(view: view, selected: selected)
        //　ヘッダーに追加するラベルを生成
        var headerLabel = UILabel()
        headerLabel = makeHeaderLabel(label: headerLabel, fontColor:  fontColor, parentView: view)
        //　viewにラベルをaddSubViewする
        view.addSubview(headerLabel)
        return view
    }
    
    //　フォントカラーの補色をセット
    func setUpComplementalFontColor(themeName: String, selected: Int) -> String {
        //　フォントカラーを取得
        var fontColor = themeModel.themeList[selected].theme.fontColor
        //　テーマ名が特定テーマであれば
        if themeName == "ノーマル" || themeName == "オリーブ" || themeName == "ブルーソーダ" || themeName == "ストロベリー" {
            //　フォントカラーを補色にセット
            fontColor = themeModel.themeList[selected].theme.complementalFontColor
        }
        return fontColor
    }
    
    //　Viewのカラーをセットアップ
    func setUpViewColor(view: CustomView, selected: Int) -> CustomView {
        //　暗記リスト画面を取得
        let wordListView = self.view as! WordRememberedListView
        //　テーマ名を取得
        let themeName = getThemeName(index: selected)
        //　アクセントカラーを取得
        let color = themeModel.themeList[selected].theme.accentColor
        //　Viewの背景をアクセントカラーに
        view.backgroundColor = UIColor(hex: color)
        //　ViewのフレームをWordListWidgetの幅、heightForInSectionにピッタリ合わせるよう返す
        view.frame = CGRect(x: 20, y: 0, width: wordListView.wordRememberedListWidget.frame.width, height: 30)
        //　テーマ名がスペースだったら
        if themeName == "スペース" {
            //　影の色を設定する
            view.layer.shadowColor = UIColor.clear.cgColor
            //　影のオフセットを設定する
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        return view
    }
    
    //　ヘッダーに追加するラベルを生成
    func makeHeaderLabel(label: UILabel, fontColor: String, parentView: UIView) -> UILabel{
        //　ラベルのフレームをviewの大きさと合わせる
        label.frame =  parentView.frame
        //　ラベルのテキストを設定する
        label.text = "誤答数"
        //　ラベルのフォントとサイズを設定する
        label.font = UIFont(name: "System", size: 10)
        //　ラベルのテキストカラーを設定する
        label.textColor = UIColor(hex: fontColor)
        //　ラベルを左寄せにする
        label.textAlignment = NSTextAlignment.left
        return label
    }

}

// MARK: WordListViewControllerのUINavigationBarDelegate
extension WordRememberedListViewController: UINavigationBarDelegate {
    //　ステータスバーとナビゲーションバーの隙間を自動的に埋める
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
