import UIKit
import Foundation

// MARK: QuizViewControllerのUINavigationBarDelegate
extension QuizViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

// MARK: QuizViewControllerのQuizAnswerButtonIsTappedDelegate
extension QuizViewController: QuizAnswerButtonIsTappedDelegate {
    // 回答したQuizを配列の最後に持っていく
    func removeFirstQuiz() {
        let firstQuiz = quiz[0]
        deleteFirstQuizFromArray()
        quiz.append(firstQuiz)
    }
    
    // 次の問題へ進む
    func moveToNextQuiz(view: QuizView) {
        removeFirstQuiz()
        reloadQuizState(view: view)
        resetButtonState(view: view)
        showCurrentQuiz(view: view)
        reloadProgressionView(view: view)
        checkNextQuizIsLast()
    }
    
    // QuizViewからIdを取得する
    func sendPressedButtonId(id: Int) {
        getPressedButtonId = id
        checkPressedButtonIsCorrectAnswer(id: getPressedButtonId)
    }
    
    // 回答ボタンの色を変更する
    func changeInformationOnQuizWidget() {
        let view = self.view as! QuizView
        // UIButtonのCongfigを設定
        var config = UIButton.Configuration.filled()
        // Configの共通処理
        config.imagePadding = 8.0
        config.title = answerSelectionArray[getPressedButtonId]
        
        // 不正解の時
        if answerId != getPressedButtonId {
            // 背景を赤色かつxアイコンが表示されるように
            config.background.backgroundColor = UIColor.systemRed
            config.image = UIImage(systemName: "multiply.circle")
            switch getPressedButtonId {
            case 0:
                view.quizFirstAnswerButton.configuration = config
            case 1:
                view.quizSecondAnswerButton.configuration = config
            case 2:
                view.quizThirdAnswerButton.configuration = config
            case 3:
                view.quizFourthAnswerButton.configuration = config
            case 4:
                view.quizFifthAnswerButton.configuration = config
            default:
                break
            }
        }
        // 正解時背景を緑かつチェックアイコンが表示されるように
        config.background.backgroundColor = UIColor.systemGreen
        config.image = UIImage(systemName: "checkmark.circle")
        config.title = answerSelectionArray[answerId]
        switch answerId {
            case 0:
                view.quizFirstAnswerButton.configuration = config
            case 1:
                view.quizSecondAnswerButton.configuration = config
            case 2:
                view.quizThirdAnswerButton.configuration = config
            case 3:
                view.quizFourthAnswerButton.configuration = config
            case 4:
                view.quizFifthAnswerButton.configuration = config
            default:
                break
        }
    }
}
