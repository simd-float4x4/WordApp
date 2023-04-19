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
        inputTestData()
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
        let singleArray = ["envisage", "culminate", "accentuate", "sloppy", "transcribe", "protectionism", "trespass"]
        let meaningArray = ["〜を想像する", "〜を締めくくる", "〜を強調する", "杜撰な", "複写する", "保護主義", "〜を侵害する"]
        let exampleArray = [
            "Did you ever envisage that your book might be translated into different languages?",
            "The ceremony was culminated with the national anthem.",
            "This picture was taken in the evening to accentuate the shows of ancient remains.",
            "He was accused of the responsibility of sloppy accounting.",
            "She can transcribe melodic patterns from sound even if melody is adlib",
            "The country denounced Japan's protectionism to conceal its own lack of economic policy.",
            "He trespassed on neighbor's land without any allowance.",
        ]
        let transArray = [
            "自分の本がいろいろな国の言葉に翻訳されると予想されましたか？",
            "その式典は国歌斉唱で締めくくられた。",
            "この写真は古代遺物の出現を強調するために夕方撮影された。",
            "彼は杜撰な会計処理の責任を責め立てられた",
            "たとえアドリブであっても、彼女は聴いた旋律パターンを楽譜に起こすことができる",
            "その国は自らの経済的な無策を隠すために日本の保護貿易主義を非難しました。",
            "彼は無断で隣人の土地に侵入した。"
        ]
        
        let index = Int.random(in: 0..<7)
        
        singleWordTextView.text = singleArray[index]
        meaningWordTextView.text = meaningArray[index]
        exampleSentenceTextView.text = exampleArray[index]
        exampleTranslationTextView.text = transArray[index]
    }
    
    func setTappedTextView() {
        addWordToWordListDelegate?.getTappedTextviewName(name: ".singleWord")
    }
}
