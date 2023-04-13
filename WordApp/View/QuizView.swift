import Foundation
import UIKit

// MARK: QuizAnswerButtonisTappedDelegate
/// - func removeFirstQuiz() → QuizViewControllerと接続
protocol QuizAnswerButtonIsTappedDelegate: AnyObject {
    func removeFirstQuiz()
    func moveToNextQuiz()
    func sendPressedButtonId(id: Int)
    func changeInformationOnQuizWidget()
}


// MARK: QuizView
class QuizView: UIView {
    
    @IBOutlet weak var quizSingleWordLabel: UILabel!
    @IBOutlet weak var quizFirstAnswerButton: UIButton!
    @IBOutlet weak var quizSecondAnswerButton: UIButton!
    @IBOutlet weak var quizThirdAnswerButton: UIButton!
    @IBOutlet weak var quizFourthAnswerButton: UIButton!
    @IBOutlet weak var quizFifthAnswerButton: UIButton!
    
    @IBOutlet weak var quizProgressBar: UIProgressView!
    @IBOutlet weak var quizProgressionLabel: UILabel!
    
    @IBOutlet weak var moveToNextQuizButton: UIButton!
    
    weak var quizAnswerButtonIsTappedDelegate: QuizAnswerButtonIsTappedDelegate?
    
    var isAnsweredBool: Bool = false
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    func loadNib(){
        let view = Bundle.main.loadNibNamed("QuizView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        if let subview = view.subviews.first  {
            self.addSubview(subview)
        }
        moveToNextQuizButton.isHidden = true
    }
    
    @IBAction func pressedFirstbutton() {
        if !isAnsweredBool {
            quizAnswerButtonIsTappedDelegate?.sendPressedButtonId(id: 0)
            quizAnswerButtonIsTappedDelegate?.changeInformationOnQuizWidget()
            moveToNextQuizButton.isHidden = false
        }
        isAnsweredBool = true
    }
    
    @IBAction func pressedSecondbutton() {
        if !isAnsweredBool {
            quizAnswerButtonIsTappedDelegate?.sendPressedButtonId(id: 1)
            quizAnswerButtonIsTappedDelegate?.changeInformationOnQuizWidget()
            moveToNextQuizButton.isHidden = false
        }
        isAnsweredBool = true
    }
    
    @IBAction func pressedThirdbutton() {
        if !isAnsweredBool {
            quizAnswerButtonIsTappedDelegate?.sendPressedButtonId(id: 2)
            quizAnswerButtonIsTappedDelegate?.changeInformationOnQuizWidget()
            moveToNextQuizButton.isHidden = false
        }
        isAnsweredBool = true
    }
    
    @IBAction func pressedFourthbutton() {
        if !isAnsweredBool {
            quizAnswerButtonIsTappedDelegate?.sendPressedButtonId(id: 3)
            quizAnswerButtonIsTappedDelegate?.changeInformationOnQuizWidget()
            moveToNextQuizButton.isHidden = false
        }
        isAnsweredBool = true
    }
    
    @IBAction func pressedFifthbutton() {
        if !isAnsweredBool {
            quizAnswerButtonIsTappedDelegate?.sendPressedButtonId(id: 4)
            quizAnswerButtonIsTappedDelegate?.changeInformationOnQuizWidget()
            moveToNextQuizButton.isHidden = false
        }
        isAnsweredBool = true
    }
    
    
    // idをControllerに送るだけのメソッド
    func sendPressedButtonId(id: Int) -> Int {
        return id
    }
    
    @IBAction func moveToNextQuiz() {
        quizAnswerButtonIsTappedDelegate?.moveToNextQuiz()
    }
}
