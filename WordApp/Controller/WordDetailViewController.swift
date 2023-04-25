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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //　UIを初期化する
        initializeUI()
    }
    
    //　UIを初期化する
    func initializeUI() {
        let view = WordDetailView()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                  action: #selector(onTapDismissWordView))
        view.onTapDismissView.addGestureRecognizer(tapGestureRecognizer)
        view.showSingleWordTextLabel.text = singleWord
        view.showMeaningTextLabel.text = meaning
        view.showExampleSentenseTextLabel.text = exampleSentence
        view.showExampleSentenseTranslationTextLabel.text = exampleTranslation
        view.showExampleSentenseTextLabel.adjustsFontSizeToFitWidth = true
        view.showExampleSentenseTranslationTextLabel.adjustsFontSizeToFitWidth = true
        self.view = view
        getSingleWordFromSentence()
    }
    
    func getSingleWordFromSentence() {
        let originalString = exampleSentence
        let target = singleWord
        if let range = originalString.range(of: target, options: .regularExpression) {
            // 開始位置と終了位置を取得する
            let startIndex = originalString.distance(from: originalString.startIndex, to: range.lowerBound)
            let endIndex = originalString.distance(from: originalString.startIndex, to: range.upperBound) - 1
            changeSingleWordFromExampleSentenceColor(start: startIndex, end: endIndex)
        }
    }
    
    func changeSingleWordFromExampleSentenceColor(start: Int, end: Int) {
        let view = self.view as! WordDetailView
        // UILabelの文字列（「はい、いいえ」）から、attributedStringを作成します.
        let attrText = NSMutableAttributedString(string: view.showExampleSentenseTextLabel.text!)
        // フォントカラーを設定します.
        let length = (end - start) + 1
        let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as? Int ?? 0
        let backgroundColor = themeModel.themeList[selected].theme.accentColor
        var fontColor = themeModel.themeList[selected].theme.complementalFontColor
        if selected == 1 || selected == 2 { fontColor = themeModel.themeList[selected].theme.fontColor }
        // rangeで該当箇所を指定します（ここでは「いいえ」が対象）.
        attrText.addAttribute(.foregroundColor,
            value: UIColor(hex: fontColor), range: NSMakeRange(start, length))
        // rangeで該当箇所を指定します（ここでは「いいえ」が対象）.
        attrText.addAttribute(.backgroundColor,
            value: UIColor(hex: backgroundColor), range: NSMakeRange(start, length))

        // attributedTextとしてUILabelに追加します.
        view.showExampleSentenseTextLabel.attributedText = attrText
    }
    
    @objc func onTapDismissWordView() {
        dismiss(animated: true,completion: nil)
    }
}
