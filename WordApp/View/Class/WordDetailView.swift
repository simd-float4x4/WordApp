import Foundation
import UIKit

class WordDetailView: UIView {
    // 単語を表示するためのラベル
    @IBOutlet weak var showSingleWordTextLabel: UILabel!
    //　意味を表示するためのラベル
    @IBOutlet weak var showMeaningTextLabel: UILabel!
    //　例文を表示するためのラベル
    @IBOutlet weak var showExampleSentenseTextLabel: UILabel!
    //　日本語訳を表示するためのラベル
    @IBOutlet weak var showExampleSentenseTranslationTextLabel: UILabel!
    //　押下時に前の画面に戻るための全画面View
    @IBOutlet weak var onTapDismissView: UIView!
    //　onTapDismissViewの機能を説明するためのラベル
    @IBOutlet weak var onTapRootViewTextLabel: UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    // NibFileをLoadする
    func loadNib(){
        let view = Bundle.main.loadNibNamed("WordDetailView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        if let subview = view.subviews.first  {
            self.addSubview(subview)
        }
        initializeWidget()
    }
    
    // UIを初期化する
    func initializeWidget() {
        onTapRootViewTextLabel.text = NSLocalizedString("buttonBackToWordList", comment: "")
    }
}
