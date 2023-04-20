import Foundation
import UIKit

class WordDetailViewController: UIViewController {
    
    var singleWord: String = ""
    var meaning: String = ""
    var exampleSentence: String = ""
    var exampleTranslation: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeWordDetailView()
    }
    
    func initializeWordDetailView() {
        let view = WordDetailView()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                  action: #selector(onTapDismissWordView))
        view.cancelView.addGestureRecognizer(tapGestureRecognizer)
        view.singleWordLabel.text = singleWord
        view.meaningLabel.text = meaning
        view.exampleSentenseLabel.text = exampleSentence
        view.exampleSentenseTranslationLabel.text = exampleTranslation
        view.exampleSentenseLabel.adjustsFontSizeToFitWidth = true
        view.exampleSentenseTranslationLabel.adjustsFontSizeToFitWidth = true
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
        let attrText = NSMutableAttributedString(string: view.exampleSentenseLabel.text!)
        // フォントカラーを設定します.
        let length = (end - start) + 1
        // rangeで該当箇所を指定します（ここでは「いいえ」が対象）.
        attrText.addAttribute(.foregroundColor,
            value: UIColor.red, range: NSMakeRange(start, length))

        // attributedTextとしてUILabelに追加します.
        view.exampleSentenseLabel.attributedText = attrText
    }
    
    @objc func onTapDismissWordView() {
        dismiss(animated: true,completion: nil)
    }
}
