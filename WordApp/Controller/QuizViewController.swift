import Foundation
import UIKit

// MARK: QuizViewController
class QuizViewController: UIViewController, QuizAnswerButtonIsTappedDelegate {
    
    var wordModel = WordListModel.shared
    var quiz: [WordModel] = []
    // 選択肢の数
    var maximumAnswerChoicesCount: Int = 5
    // 出題するクイズの数
    var maximumQuizCount: Int = 0
    // StopperのID格納変数
    var currentQuizStopper: Int = 0
    // 現在暗記した単語の総数
    var currentQuizTotal: Int = 0
    // 正解のボタンID
    var answerId: Int = 0
    // ユーザーが押下したボタンID格納変数
    var getPressedButtonId: Int = 0
    // 間違えた数
    var totalQuizWrongCount: Int = 0
    // 解いた数
    var totalSolvedQuizCount: Int = 0
    
    var topSafeAreaHeight: CGFloat = 0
    var bottomSafeAreaHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = QuizView()
        self.view = view
        let isAvailable = checkIsQuizAvailable()
        if isAvailable {
            // 現状クイズが出来る状態であれば
            //　現在のクイズに関してのプロパティを取得
            getQuizCurrentProperties()
            // 利用可能なクイズ数を取得
            currentQuizTotal = countCurrentRegisteredWord()
            // クイズを初期化する
            initializeQuiz()
            // 最初のクイズを取得する
            getFirstQuiz()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let isAvailable = checkIsQuizAvailable()
        if isAvailable {
            //　現在のクイズに関してのプロパティを取得
            getQuizCurrentProperties()
            // 利用可能なクイズ数を取得
            currentQuizTotal = countCurrentRegisteredWord()
            // クイズを初期化する
            initializeQuiz()
            // 最初のクイズを取得する
            getFirstQuiz()
        }
    }
    
    // 設定からクイズに関する情報を取得する
    func getQuizCurrentProperties() {
        maximumAnswerChoicesCount = wordModel.getAndReturnQuizChoices()
        maximumQuizCount = wordModel.getAndReturnMaximumQuizCount()
    }
    
    
    // UIの初期化
    func initQuizUI() {
        let view = self.view as! QuizView
        initProgressArea(view: view)
        initButtonState(view: view)
        decideButtonDisplayOrNot(view: view)
    }
    
    // ProgressのUIを初期化する
    func initProgressArea(view: QuizView) {
        view.quizProgressionLabel.text = "1問目"
        view.quizProgressBar.progress = 0.0
        view.moveToNextQuizButton.setTitle("次の問題へ", for: .normal)
    }
    
    // 回答ボタンのUIを初期化する
    func initButtonState(view: QuizView) {
        resetButtonState(view: view)
        view.quizAnswerButtonIsTappedDelegate = self
    }
    
    // 回答ボタンの色・テキストをリセットする
    func resetButtonState(view: QuizView) {
        view.quizFirstAnswerButton.configuration?.background.backgroundColor = UIColor.systemGray
        view.quizSecondAnswerButton.configuration?.background.backgroundColor = UIColor.systemGray
        view.quizThirdAnswerButton.configuration?.background.backgroundColor = UIColor.systemGray
        view.quizFourthAnswerButton.configuration?.background.backgroundColor = UIColor.systemGray
        view.quizFifthAnswerButton.configuration?.background.backgroundColor = UIColor.systemGray
    }
    
    // ボタンを描画するかどうか決定する
    func decideButtonDisplayOrNot(view: QuizView) {
        let selectionCount = wordModel.getAndReturnQuizChoices()
        var fourthChoiceIsHidden = true
        var fifthChoiceIsHidden = true
        if selectionCount == 4 {
            fourthChoiceIsHidden = false
        }
        if selectionCount == 5 {
            fourthChoiceIsHidden = false
            fifthChoiceIsHidden = false
        }
        view.quizFourthAnswerButton.isHidden = fourthChoiceIsHidden
        view.quizFifthAnswerButton.isHidden = fifthChoiceIsHidden
    }
    
    // クイズを初期化
    func initializeQuiz() {
        // UIの状態を初期化
        initQuizUI()
        // クイズをシャッフルして配列を生成する
        quiz = makeRandomQuizList()
        totalSolvedQuizCount = 0
        totalQuizWrongCount = 0
    }
    
    // 最初のクイズを取得
    func getFirstQuiz() {
        // 最初のQuizを抽出
        let currentQuiz = quiz[0]
        // これが一番最初のQuizならストッパーとして利用するためIDを控えておく
        currentQuizStopper = currentQuiz.word.id
        showCurrentQuiz()
    }
    
    // クイズの表示メソッド
    func showCurrentQuiz() {
        let currentQuiz = quiz[0]
        var meaningArray: [String] = []
        meaningArray.append(currentQuiz.word.meaning)
        for i in 1 ..< maximumAnswerChoicesCount {
            meaningArray.append(quiz[i].word.meaning)
        }
        drawInformationOnQuizWidget(quiz: currentQuiz, dummyAnswers: meaningArray, correctAnswer: meaningArray[0])
    }

    // 登録した単語が特定の単語数未満だった場合アラートを表示する
    func checkIsQuizAvailable() -> Bool {
        let currenWordRegisterCount = countCurrentRegisteredWord()
        if currenWordRegisterCount < maximumAnswerChoicesCount {
            wordAmountIsNotEnoughToActivateQuizAlert()
            return false
        }
        return true
    }
    
    // 登録した単語が特定の単語数未満だった場合表示するアラート
    func wordAmountIsNotEnoughToActivateQuizAlert() {
        // TODO: handlerをAlertに持っていけるようになったら共通化
        let alertContent = UIAlertController(
            title: "現在クイズ機能はご利用いただけません。",
            message: "クイズを利用するためには、単語を5つ以上暗記してください。",
            preferredStyle: .alert)
        let getAction = UIAlertAction(
            title: "OK",
            style: .default) { (action) in
                self.goToTheRootViewController()
            }
        alertContent.addAction(getAction)
        present(alertContent, animated: true, completion: nil)
    }
    
    // RootViewController(WordListViewController)に遷移する
    func goToTheRootViewController() {
        let UINavigationController = self.tabBarController?.viewControllers?[0];
        self.tabBarController?.selectedViewController = UINavigationController;
    }
    
    // 現在登録されている単語の数を取得
    func countCurrentRegisteredWord() -> Int{
        return wordModel.getAndReturnMaximumQuizCount()
    }
    
    // 暗記したQuizのWordListをランダムにシャッフルして返す
    func makeRandomQuizList() -> [WordModel] {
        // wordListをランダムにシャッフル
        var quizArray = wordModel.wordList.filter({$0.word.isRemembered == true}).shuffled()
        let maximumQuizCount = wordModel.getMaximumQuizCount()
        quizArray = quizArray.prefix(maximumQuizCount).map { $0 }
        print("配列の数：")
        print(quizArray.count)
        return quizArray
    }
    
    // ダミー解答を生成する
    func makeDummyQuizMeaning(quiz: [WordModel]) -> [String] {
        var meaningArray: [String] = []
        for i in 1 ..< quiz.count {
            let meaning = quiz[i].word.meaning
            meaningArray.append(meaning)
        }
        return meaningArray
    }
    
    // WordListの一番最初の要素を削除する
    func deleteFirstQuizFromArray() {
        //wordList最初の要素をremoveする
        quiz.remove(at: 0)
    }
    
    // WordListの要素をUIに反映させる
    func drawInformationOnQuizWidget(quiz: WordModel, dummyAnswers: [String], correctAnswer: String) {
        let view = self.view as! QuizView
        // 問題を表示
        view.quizSingleWordLabel.text = quiz.word.singleWord
        let dummy = dummyAnswers.shuffled()
        for i in 0 ..< maximumAnswerChoicesCount {
            // String型の変数：answerを宣言
            var answer = ""
            answer = dummy[i]
            // シャッフルした配列から正解の添字を取得
            if answer == correctAnswer { answerId = i }
            // 各ボタンに描画
            if i == 0 { view.quizFirstAnswerButton.configuration?.title = answer }
            if i == 1 { view.quizSecondAnswerButton.configuration?.title = answer }
            if i == 2 { view.quizThirdAnswerButton.configuration?.title = answer }
            switch maximumAnswerChoicesCount {
                case 4:
                    if i == 3 { view.quizFourthAnswerButton.configuration?.title = answer }
                case 5:
                    if i == 3 { view.quizFourthAnswerButton.configuration?.title = answer }
                    if i == 4 { view.quizFifthAnswerButton.configuration?.title = answer }
                default:
                    break
            }
        }
    }
    
    // 回答ボタンの色を変更する
    func changeInformationOnQuizWidget() {
        let view = self.view as! QuizView
        // 不正解の時
        if answerId != getPressedButtonId {
            switch getPressedButtonId {
            case 0:
                view.quizFirstAnswerButton.configuration?.background.backgroundColor = UIColor.systemRed
            case 1:
                view.quizSecondAnswerButton.configuration?.background.backgroundColor = UIColor.systemRed
            case 2:
                view.quizThirdAnswerButton.configuration?.background.backgroundColor = UIColor.systemRed
            case 3:
                view.quizFourthAnswerButton.configuration?.background.backgroundColor = UIColor.systemRed
            case 4:
                view.quizFifthAnswerButton.configuration?.background.backgroundColor = UIColor.systemRed
            default:
                break
            }
        }
        // 正解の時：Tapしたボタンだけ緑色にする、選択肢の前にチェックマークをつける
        switch answerId {
        case 0:
            view.quizFirstAnswerButton.configuration?.background.backgroundColor = UIColor.systemGreen
        case 1:
            view.quizSecondAnswerButton.configuration?.background.backgroundColor = UIColor.systemGreen
        case 2:
            view.quizThirdAnswerButton.configuration?.background.backgroundColor = UIColor.systemGreen
        case 3:
            view.quizFourthAnswerButton.configuration?.background.backgroundColor = UIColor.systemGreen
        case 4:
            view.quizFifthAnswerButton.configuration?.background.backgroundColor = UIColor.systemGreen
        default:
            break
        }
    }

    // QuizViewからIdを取得する
    func sendPressedButtonId(id: Int) {
        getPressedButtonId = id
        checkPressedButtonIsCorrectAnswer(id: getPressedButtonId)
    }
    
    // 正解か不正かどうか判定する
    func checkPressedButtonIsCorrectAnswer(id: Int) {
        if id != answerId {
            // この問題のWrongCountを更新
            quiz[0].word.wrongCount += 1
            // 今回のQuizで間違えた回数を取得
            totalQuizWrongCount += 1
            //　10回以上誤答した場合強制的に暗記リストから削除
            if quiz[0].word.wrongCount >= 10 {
                quiz[0].word.isRemembered = false
                quiz[0].word.wrongCount = 0
            }
        }
        // 今回のQuizで解答数を更新
        totalSolvedQuizCount += 1
    }
    
    // 回答したQuizを配列の最後に持っていく
    func removeFirstQuiz() {
        let firstQuiz = quiz[0]
        deleteFirstQuizFromArray()
        quiz.append(firstQuiz)
    }
    
    // 次の問題へ進む
    func moveToNextQuiz() {
        let view = self.view as! QuizView
        removeFirstQuiz()
        reloadQuizState(view: view)
        resetButtonState(view: view)
        showCurrentQuiz()
        reloadProgressionView()
        checkNextQuizIsLast()
    }
    
    // 問題の状態を更新する
    func reloadQuizState(view: QuizView) {
        // 回答したかを判定するBoolをfalseに
        view.isAnsweredBool = false
        //　次の問題へボタンは非表示に
        view.moveToNextQuizButton.isHidden = true
        // 次の問題が最初に出題した問題であれば（=この問題が最終問題なら）、ラベルの表示を変更する
        if quiz[1].word.id == currentQuizStopper {
            view.moveToNextQuizButton.setTitle("結果発表へ", for: .normal)
        }
    }
    
    // この問題が最終問題かどうか取得する
    func checkNextQuizIsLast() {
        if quiz[0].word.id == currentQuizStopper {
            let solvedCorrectlyCount = totalSolvedQuizCount - totalQuizWrongCount
            let scoreString = String(solvedCorrectlyCount * 100 / totalSolvedQuizCount) + "点です。（100点満点中）" + "\n⭕️" + String(solvedCorrectlyCount) + "問　❌" + String(totalQuizWrongCount) + "問"
            let alertContent = UIAlertController(
                title: "お疲れ様でした。",
                message: scoreString,
                preferredStyle: .alert)
            let getAction = UIAlertAction(
                title: "OK",
                style: .default) { (action) in
                    self.goToTheRootViewController()
                }
            alertContent.addAction(getAction)
            present(alertContent, animated: true, completion: nil)
            goToTheRootViewController()
        }
    }

    // Progressionを更新する
    func reloadProgressionView() {
        let view = self.view as! QuizView
        let progressionRate = Float(totalSolvedQuizCount) / Float(maximumAnswerChoicesCount)
        view.quizProgressionLabel.text = String(totalSolvedQuizCount+1) + "問目"
        view.quizProgressBar.progress = Float(progressionRate)
    }
    
    // TODO: Alertにhandlerを渡せるようになったら共通化
    // アラートを作る
    func makeAlert(alertTitle: String, alertMessage: String, alertAction: [String]){
        let commonAlert = CommonAlert()
        let alert = commonAlert.make(alertTitle: alertTitle, alertMessage: alertMessage, alertAction: alertAction)
        present(alert, animated: true, completion: nil)
    }
}
