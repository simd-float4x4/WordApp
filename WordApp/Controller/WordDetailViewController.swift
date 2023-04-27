import Foundation
import UIKit

// MARK: WordDetailViewController
class WordDetailViewController: UIViewController {
    //　単語（AddWordViewControllerから値を受け渡す用の変数）
    var singleWord: String = ""
    //　意味（AddWordViewControllerから値を受け渡す用の変数）
    var meaning: String = ""
    //　例文（AddWordViewControllerから値を受け渡す用の変数）
    var exampleSentence: String = ""
    //　例文・日本語訳（AddWordViewControllerから値を受け渡す用の変数）
    var exampleTranslation: String = ""
    //　テーマモデル
    var themeModel = DesignThemeListModel.shared
    //　UserDefaults
    let ud = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //　UIを初期化する
        initializeUI()
    }
    
    //　UIを初期化する
    func initializeUI() {
        //　WordDetailViewを取得する
        let view = WordDetailView()
        //　tapGestureを登録する
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                  action: #selector(onTapDismissWordDetailView))
        view.onTapDismissView.addGestureRecognizer(tapGestureRecognizer)
        // UILabelを初期化する
        view.showSingleWordTextLabel.text = singleWord
        view.showMeaningTextLabel.text = meaning
        view.showExampleSentenseTextLabel.text = exampleSentence
        view.showExampleSentenseTranslationTextLabel.text = exampleTranslation
        //　TODO: フォントサイズをピッタリ合わせる（ハミ出し対策）
        view.showExampleSentenseTextLabel.adjustsFontSizeToFitWidth = true
        view.showExampleSentenseTranslationTextLabel.adjustsFontSizeToFitWidth = true
        self.view = view
        //　例文から単語を抜き出す
        getSingleWordFromSentence()
    }
    
    //　例文から単語を抜き出す
    func getSingleWordFromSentence() {
        //　例文を取得
        let originalString = exampleSentence
        //　ターゲット（単語を取得）
        let target = singleWord
        if let range = originalString.range(of: target, options: .regularExpression) {
            // 開始位置と終了位置を取得する
            let startIndex = originalString.distance(from: originalString.startIndex, to: range.lowerBound)
            let endIndex = originalString.distance(from: originalString.startIndex, to: range.upperBound) - 1
            //　開始位置〜終了位置の文字の色を変える
            changeSingleWordFromExampleSentenceColor(start: startIndex, end: endIndex)
        }
    }
    
    //　開始位置〜終了位置の文字の色を変える
    func changeSingleWordFromExampleSentenceColor(start: Int, end: Int) {
        let view = self.view as! WordDetailView
        // attributedStringの文字列を作成する
        let attrText = NSMutableAttributedString(string: view.showExampleSentenseTextLabel.text!)
        // 単語の長さを取得する
        let length = (end - start) + 1
        //　現在のテーマカラーIDを取得する
        let selected = ud.selectedThemeColorId
        //　現在の背景色を取得する
        let backgroundColor = themeModel.themeList[selected].theme.accentColor
        //　現在のフォントカラーを取得する
        var fontColor = themeModel.themeList[selected].theme.complementalFontColor
        //　現在のテーマ名を取得する
        let themeName = getThemeName(index: selected)
        //　一部テーマ名なら
        if themeName == "スペース" || themeName == "オレンジ" {
            //　フォントカラーを変更する
            fontColor = themeModel.themeList[selected].theme.fontColor }
        //　該当箇所を指定する
        attrText.addAttribute(.foregroundColor,
            value: UIColor(hex: fontColor), range: NSMakeRange(start, length))
        // 該当箇所を指定する
        attrText.addAttribute(.backgroundColor,
            value: UIColor(hex: backgroundColor), range: NSMakeRange(start, length))
        // attributedTextとしてUILabelに追加する
        view.showExampleSentenseTextLabel.attributedText = attrText
    }
    
    //　押下された際にWordDetailViewに戻る
    @objc func onTapDismissWordDetailView() {
        // Viewを消す
        dismiss(animated: true,completion: nil)
    }
    
    //　テーマの名前を取得する
    func getThemeName(index: Int) -> String{
        // テーマの名称を取得する
        let themeName = themeModel.themeList[index].theme.name
        return themeName
    }
}
