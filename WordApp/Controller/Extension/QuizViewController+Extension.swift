import UIKit
import Foundation

// MARK: QuizViewControllerのQuizAnswerButtonIsTappedDelegate
//　ボタンが押された時の処理
extension QuizViewController: QuizAnswerButtonIsTappedDelegate {
    // 回答したQuizを配列の最後に持っていく
    func removeFirstQuiz() {
        //　最初のクイズを取得しておく
        let firstQuiz = quiz[0]
        // Quizの一番最初の要素を削除する
        deleteFirstQuizFromArray()
        //　appendすることで、配列の一番最後に現在のクイズを持っていく
        quiz.append(firstQuiz)
        print("✈️ removeFirstQuiz")
    }
    
    // 次の問題へ進む
    func moveToNextQuiz(view: QuizView) {
        //　回答したQuizを配列の最後に持っていく
        removeFirstQuiz()
        //　Quizの状態を更新
        reloadQuizState(view: view)
        //　回答ボタンの状態を更新
        resetButtonState(view: view)
        //　一番最初のクイズを表示する
        showCurrentQuiz(view: view)
        //　クイズの進捗Viewを更新する
        reloadProgressionView(view: view)
        //　次の問題が最後の問題か確認する
        checkNextQuizIsLast()
        print("✈️ moveToNextQuiz")
    }
    
    // QuizViewからIdを取得する
    func sendPressedButtonId(id: Int) {
        //　押されたボタンのIDを取得する
        getPressedButtonId = id
        //　押されたボタンが正解かどうか判定する
        checkPressedButtonIsCorrectAnswer(id: getPressedButtonId)
        print("✈️ sendPressedButtonId")
    }
    
    // 回答ボタンの色を変更する
    func changeInformationOnQuizWidget() {
        //　QuizViewを取得する
        let view = self.view as! QuizView
        // UIButtonのCongfigを設定
        var config = UIButton.Configuration.filled()
        // configの共通処理
        config.imagePadding = 8.0
        //　configにタイトルをセットする
        config.title = answerSelectionArray[getPressedButtonId]
        // 不正解の時
        if answerId != getPressedButtonId {
            // 背景を赤色に
            config.background.backgroundColor = UIColor.systemRed
            //　Xの画像が表示されるようにする
            config.image = UIImage(systemName: "multiply.circle")
            //　押されたボタンのIDによって分岐
            switch getPressedButtonId {
                case 0:
                //　1番最初のボタンが押された
                    view.quizFirstAnswerButton.configuration = config
                case 1:
                //　2番目のボタンが押された
                    view.quizSecondAnswerButton.configuration = config
                case 2:
                //　3番目のボタンが押された
                    view.quizThirdAnswerButton.configuration = config
                case 3:
                //　4番目のボタンが押された
                    view.quizFourthAnswerButton.configuration = config
                case 4:
                //　最後のボタンが押された
                    view.quizFifthAnswerButton.configuration = config
                default:
                    break
            }
        }
        // 正解の時
        // 背景を緑色に
        config.background.backgroundColor = UIColor.systemGreen
        //　Oの画像が表示されるように
        config.image = UIImage(systemName: "checkmark.circle")
        //　configにタイトルをセットする
        config.title = answerSelectionArray[answerId]
        //　押されたボタンのIDによって分岐
        switch answerId {
                case 0:
                //　1番最初のボタンが押された
                    view.quizFirstAnswerButton.configuration = config
                case 1:
                //　2番目のボタンが押された
                    view.quizSecondAnswerButton.configuration = config
                case 2:
                //　3番目のボタンが押された
                    view.quizThirdAnswerButton.configuration = config
                case 3:
                //　4番目のボタンが押された
                    view.quizFourthAnswerButton.configuration = config
                case 4:
                //　最後のボタンが押された
                    view.quizFifthAnswerButton.configuration = config
                default:
                    break
        }
        print("✈️ changeInformationOnQuizWidget")
    }
}

// MARK: QuizViewControllerのUINavigationBarDelegate
extension QuizViewController: UINavigationBarDelegate {
    //　ステータスバーとナビゲーションバーの隙間を自動的に埋める
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
