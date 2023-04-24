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
    @IBOutlet weak var quizDescriptionTextLabel: UILabel!
    
    @IBOutlet weak var viewNavigationBar: UINavigationBar!
    
    weak var quizAnswerButtonIsTappedDelegate: QuizAnswerButtonIsTappedDelegate?
    
    var isAnsweredBool: Bool = false
    
    let themeModel = DesignThemeListModel.shared
    
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
            let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 94))
            navBar.backgroundColor = UIColor.white
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            navBar.standardAppearance = appearance
            let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as? Int ?? 0
            var color = themeModel.themeList[selected].theme.accentColor
            if selected == 3 || selected == 2 || selected == 5 { color = themeModel.themeList[selected].theme.complementalColor }
            navBar.barTintColor = UIColor(hex: color)
            navBar.backgroundColor = UIColor(hex: color)
            let settingNavigationItem = UINavigationItem(title: "クイズモード")
            navBar.setItems([settingNavigationItem], animated: false)
            
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.shadowColor = .clear
            navBar.scrollEdgeAppearance = navigationBarAppearance
        
            let titleLabelView = UIView()
            titleLabelView.frame = CGRect(x: UIScreen.main.bounds.width / 4, y: 0, width: UIScreen.main.bounds.width / 2, height: 94)
            let title = settingNavigationItem.title
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.frame = CGRect(x: 0, y: 50, width: UIScreen.main.bounds.width / 2, height: 44)
            label.font = UIFont.boldSystemFont(ofSize: 16)
            
            subview.addSubview(navBar)
            titleLabelView.addSubview(label)
            subview.addSubview(titleLabelView)
            
            self.addSubview(subview)
        }
        moveToNextQuizButton.isHidden = true
        quizDescriptionTextLabel.text = NSLocalizedString("quizQuestionTextLabel", comment: "")
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
