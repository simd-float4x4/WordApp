import UIKit

// MARK: AddWordToWordListDelegate
/// - func addWordToList(data: [String]) → AddWordViewControllerと接続
protocol AddWordToWordListDelegate: AnyObject {
    func addWordToList(data: [String])
}

// MARK: AddWordView
class AddWordView: UIView {
    //　単語入力TextView
    @IBOutlet weak var singleWordTextView: UITextView!
    //　意味入力TextView
    @IBOutlet weak var meaningWordTextView: UITextView!
    //　例文入力TextView
    @IBOutlet weak var exampleSentenceTextView: UITextView!
    //　日本語訳入力TextView
    @IBOutlet weak var exampleTranslationTextView: UITextView!
    //　単語Label
    @IBOutlet weak var singleWordTextLabel: UILabel!
    //　意味Label
    @IBOutlet weak var meaningWordTextLabel: UILabel!
    //　例文Label
    @IBOutlet weak var exampleSentenceTextLabel: UILabel!
    //　日本語訳Label
    @IBOutlet weak var exampleTranslationTextLabel: UILabel!
    // テーマモデル
    var themeModel = DesignThemeListModel.shared
    //　AddWordViewと接続するためのDelegate
    weak var addWordToWordListDelegate: AddWordToWordListDelegate?
    // 登録ボタンのUILabel
    let registerWordButtonLabel = NSLocalizedString("registerUIButton", comment: "")
    //　登録ボタンの各種設定
    var registerWordButtonEnterButton = (x: 300, y: 5, width: 80, height: 34, cornerRadius: CGFloat(17.0), backGroundColor: UIColor.white, titleLabelColor: UIColor.black)
    // キーボード上のViewの各種設定
    var keyBoardBarProperties = (x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: 45, backgroundColor: UIColor.systemOrange)
    
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
        let view = Bundle.main.loadNibNamed("AddWordView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        if let subview = view.subviews.first  {
            self.addSubview(subview)
        }
        // UIを初期化する
        initializeWidget()
    }
    
    // UIを初期化する
    func initializeWidget() {
        initializeUILabel()
        initializeTextField()
    }
    
    // UILabelの初期値を取得する
    func initializeUILabel() {
        // 各UILabelのtextをNSLocalizedStringから取得
        singleWordTextLabel.text = NSLocalizedString("singleWordLabel", comment: "")
        meaningWordTextLabel.text = NSLocalizedString("meaningWordLabel", comment: "")
        exampleSentenceTextLabel.text = NSLocalizedString("exampleSentenceLabel", comment: "")
        exampleTranslationTextLabel.text = NSLocalizedString("exampleTranslationLabel", comment: "")
    }
    
    // UITextFieldを初期化する
    func initializeTextField() {
        // UITextField上部にViewを生成
        let viewForRegisterButtonAboveKeyboard = UIView(frame: CGRect(
            x: keyBoardBarProperties.x,
            y: keyBoardBarProperties.y,
            width: keyBoardBarProperties.width,
            height: keyBoardBarProperties.height))
        // 背景色を設定
        viewForRegisterButtonAboveKeyboard.backgroundColor = keyBoardBarProperties.backgroundColor
        // 登録ボタンの生成と登録
        let onTapWordRegisterButton = UIButton(frame:
                                CGRect(x: registerWordButtonEnterButton.x,
                                       y: registerWordButtonEnterButton.y,
                                       width: registerWordButtonEnterButton.width,
                                       height: registerWordButtonEnterButton.height))
        // 背景色を設定
        onTapWordRegisterButton.backgroundColor = registerWordButtonEnterButton.backGroundColor
        // 角丸を設定
        onTapWordRegisterButton.layer.cornerRadius = registerWordButtonEnterButton.cornerRadius
        //　Titleを設定
        onTapWordRegisterButton.setTitle(registerWordButtonLabel, for: UIControl.State.normal)
        //　TitleColorを設定
        onTapWordRegisterButton.setTitleColor(registerWordButtonEnterButton.titleLabelColor, for: UIControl.State.normal)
        // 押下時の処理を指定(onTapRegisterWord)
        onTapWordRegisterButton.addTarget(self, action: #selector(onTapRegisterWord), for: UIControl.Event.touchUpInside)
        // viewにaddSubviewする
        viewForRegisterButtonAboveKeyboard.addSubview(onTapWordRegisterButton)
        // 各UITextViewのキーボード上に機能を設定する
        singleWordTextView.inputAccessoryView = viewForRegisterButtonAboveKeyboard
        meaningWordTextView.inputAccessoryView = viewForRegisterButtonAboveKeyboard
        exampleSentenceTextView.inputAccessoryView = viewForRegisterButtonAboveKeyboard
        exampleTranslationTextView.inputAccessoryView = viewForRegisterButtonAboveKeyboard
    }
    
    // 全てのTextViewをリセット・初期化する
    func resetWordInputField() {
        singleWordTextView.text = ""
        meaningWordTextView.text = ""
        exampleSentenceTextView.text = ""
        exampleTranslationTextView.text = ""
    }
    
    // ダミーデータを取得し、入力する
    func inputDummyData() {
        let dummyData = DummyData().make()
        singleWordTextView.text = dummyData[0]
        meaningWordTextView.text = dummyData[1]
        exampleSentenceTextView.text = dummyData[2]
        exampleTranslationTextView.text = dummyData[3]
    }
    
    // 登録ボタン押下時にModelにデータを橋渡し
    @objc func onTapRegisterWord() {
        let wordData: [String] = [
            singleWordTextView.text!,
            meaningWordTextView.text!,
            exampleSentenceTextView.text!,
            exampleTranslationTextView.text!]
        /// func addWordToList(data: [String]) → AddWordViewControllerと接続
        addWordToWordListDelegate?.addWordToList(data: wordData)
    }
    
    // ダミーデータを登録する
    @IBAction func autoAddDummyData() {
        for i in 0 ..< 10 {
            inputDummyData()
            onTapRegisterWord()
        }
    }
}
