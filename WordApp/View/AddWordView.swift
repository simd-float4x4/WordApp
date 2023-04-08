import UIKit

protocol AddWordToWordListDelegate: AnyObject {
    func addWordToList(data: [String])
}

class AddWordView: UIView {
    
    @IBOutlet weak var singleWordTextView: UITextView!
    @IBOutlet weak var meaningWordTextView: UITextView!
    @IBOutlet weak var exampleSentenceTextView: UITextView!
    @IBOutlet weak var exampleTranslationTextView: UITextView!
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
        initializeTextField(view: view)
    }
    
    func initializeTextField(view: UIView) {
        let keyboardBar = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 45))
                keyboardBar.backgroundColor = UIColor.systemOrange
        
        let enter = UIButton(frame: CGRect(x: 300, y: 5, width: 80, height: 35))
        enter.backgroundColor = UIColor.white
        enter.layer.cornerRadius = 17
        enter.setTitle("登録", for: UIControl.State.normal)
        enter.setTitleColor(UIColor.black, for: UIControl.State.normal)
        // TODO: Controllerとactionを紐付ける
        enter.addTarget(self, action: #selector(onTapAddWord), for: UIControl.Event.touchUpInside)
        keyboardBar.addSubview(enter)
        
        singleWordTextView.inputAccessoryView = keyboardBar
        meaningWordTextView.inputAccessoryView = keyboardBar
        exampleSentenceTextView.inputAccessoryView = keyboardBar
        exampleTranslationTextView.inputAccessoryView = keyboardBar
    }
    
    @objc func onTapAddWord() {
        let wordData: [String] = [
            singleWordTextView.text!,
            meaningWordTextView.text!,
            exampleSentenceTextView.text!,
            exampleTranslationTextView.text!]
        addWordToWordListDelegate?.addWordToList(data: wordData)
    }
    
    func resetWordInputField() {
        singleWordTextView.text = ""
        meaningWordTextView.text = ""
        exampleSentenceTextView.text = ""
        exampleTranslationTextView.text = ""
    }
}
