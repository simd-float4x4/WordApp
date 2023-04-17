import UIKit

// MARK: AddWordToWordListDelegate
/// - func addWordToList(data: [String]) → AddWordViewControllerと接続
protocol AddWordToWordListDelegate: AnyObject {
    func addWordToList(data: [String])
    func getTappedTextviewName(name: String)
}

// MARK: AddWordView
class AddWordView: UIView {
    // @IBOutletの宣言
    @IBOutlet weak var singleWordTextView: UITextView!
    @IBOutlet weak var meaningWordTextView: UITextView!
    @IBOutlet weak var exampleSentenceTextView: UITextView!
    @IBOutlet weak var exampleTranslationTextView: UITextView!
    
    @IBOutlet weak var wordAddContainerView: UIView!
    
    var tappedTextViewName = ""
    
    weak var addWordToWordListDelegate: AddWordToWordListDelegate?
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    func loadNib(){
        let view = Bundle.main.loadNibNamed("AddWordView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        if let subview = view.subviews.first  {
            self.addSubview(subview)
        }
        initializeTextField()
        // テストデータを自動入力。（今後のデバッグ用に残す）
        // inputTestData()
    }
    
    // UITextFieldを初期化する
    func initializeTextField() {
        // UITextField上部にViewを生成
        let keyboardBar = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 45))
                keyboardBar.backgroundColor = UIColor.systemOrange
        // 登録ボタンの生成と登録
        let enter = UIButton(frame: CGRect(x: 300, y: 5, width: 80, height: 35))
        enter.backgroundColor = UIColor.white
        enter.layer.cornerRadius = 17
        enter.setTitle("登録", for: UIControl.State.normal)
        enter.setTitleColor(UIColor.black, for: UIControl.State.normal)
        // TODO: Viewの責務ではない？　議論の余地あり
        enter.addTarget(self, action: #selector(onTapAddWord), for: UIControl.Event.touchUpInside)
        keyboardBar.addSubview(enter)
        singleWordTextView.inputAccessoryView = keyboardBar
        meaningWordTextView.inputAccessoryView = keyboardBar
        exampleSentenceTextView.inputAccessoryView = keyboardBar
        exampleTranslationTextView.inputAccessoryView = keyboardBar
    }
    
    // 登録ボタン押下時にModelにデータを橋渡し
    @objc func onTapAddWord() {
        let wordData: [String] = [
            singleWordTextView.text!,
            meaningWordTextView.text!,
            exampleSentenceTextView.text!,
            exampleTranslationTextView.text!]
        /// func addWordToList(data: [String]) → AddWordViewControllerと接続
        addWordToWordListDelegate?.addWordToList(data: wordData)
    }
    
    // 全てのTextViewをリセット・初期化する
    func resetWordInputField() {
        singleWordTextView.text = ""
        meaningWordTextView.text = ""
        exampleSentenceTextView.text = ""
        exampleTranslationTextView.text = ""
    }
    
    func inputTestData() {
        singleWordTextView.text = "envisage"
        meaningWordTextView.text = "〜を想像する"
        exampleSentenceTextView.text = "Did you ever envisage that your book might be translated into different languages?"
        exampleTranslationTextView.text = "自分の本がいろいろな国の言葉に翻訳されると予想されましたか？"
    }
    
    func setTappedTextView() {
        addWordToWordListDelegate?.getTappedTextviewName(name: ".singleWord")
    }
}
