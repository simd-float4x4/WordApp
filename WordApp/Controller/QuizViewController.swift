import Foundation
import UIKit

// MARK: QuizViewController
class QuizViewController: UIViewController {
    
    var wordModel = WordListModel.shared
    var themeModel = DesignThemeListModel.shared
    
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
    // UserDefaults
    let ud = UserDefaults.standard
    
    var topSafeAreaHeight: CGFloat = 0
    var bottomSafeAreaHeight: CGFloat = 0
    
    var answerSelectionArray: [String] = []
    
    @IBOutlet weak var viewNavigationBar: UINavigationBar!
    
    let alertOkButton = NSLocalizedString("alertOkButton", comment: "")
    let alertQuizIsNotAvailableTitleLabel = NSLocalizedString("alertQuizIsNotAvailableTitle", comment: "")
    let alertQuizIsNotAvailableTextLabel = NSLocalizedString("alertQuizIsNotAvailableText", comment: "")
    let alertQuizIsFinishedTitleLabel = NSLocalizedString("alertQuizFinishedTitle", comment: "")
    let alertQuizIsFinishedTextLabel = NSLocalizedString("alertQuizFinishedText", comment: "")
    let alertQuizNumberTextLabel = NSLocalizedString("alertQuizNumber", comment: "")
    let quizMoveToResultPresentationTextLabel = NSLocalizedString("quizMoveToResultPresentation", comment: "")
    
    let QuizNavigationItem = UINavigationItem(title: "クイズモード")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initializeView()
    }
    
    func initializeView() {
        let view = QuizView()
        self.view = view
        let quizView = self.view as! QuizView
        let isAvailable = checkIsQuizAvailable()
        if isAvailable {
            setQuiz(view: quizView)
        }
    }
    
    func setQuiz(view: QuizView) {
        // 利用可能なクイズ数を取得
        currentQuizTotal = countCurrentRegisteredWord()
        print("🍫クイズ数：　", currentQuizTotal)
        //　現在のクイズに関してのプロパティを取得
        getQuizCurrentProperties()
        //　segment強制更新
        hogehogehoge()
        // クイズを初期化する
        initializeQuiz(view: view)
        // 最初のクイズを取得する
        getFirstQuiz(view: view)
    }
    
    func hogehogehoge() {
        //　選択されたSegmentedIndexの値
        let quizIndex = ud.value(forKey: "quizMaximumSelectedSegmentIndex") as? Int ?? 0
        // Segmented * 5 = 問題の出現上限数となる
        let max = 5 * quizIndex
        print("🍫つまみ：　", quizIndex)
        print("🍫上限数：　", max)
        if quizIndex == 0 {
            // segment==0の際、全部の値を返却する
            maximumQuizCount = countCurrentRegisteredWord()
            ud.set(0, forKey: "quizMaximumSelectedSegmentIndex")
            print("🤗出題数：　", maximumQuizCount)
        } else {
            //　segment＝それ以外の場合、値に問題があるかチェック
            //　保存されたsegmentより単語総数が小さい場合
            if currentQuizTotal < max { // e.g. 9 < 10
                maximumQuizCount = (currentQuizTotal/5) * 5 // e.g. 9/5 * 5
                ud.set(currentQuizTotal/5, forKey: "quizMaximumSelectedSegmentIndex")
                print("🤗つまみ：　", currentQuizTotal/5)
            } else {
                // なにも問題がない場合
                maximumQuizCount = max
                ud.set(currentQuizTotal/5, forKey: "quizMaximumSelectedSegmentIndex")
                print("🤗出題数：　", maximumQuizCount)
            }
            print("😱")
        }
    }
    
    // 設定からクイズに関する情報を取得する
    func getQuizCurrentProperties() {
        maximumAnswerChoicesCount = wordModel.getQuizAnswerSelections()
        maximumQuizCount = wordModel.getAndReturnMaximumQuizCount()
        print("🍫出題数：　", maximumQuizCount)
    }
    
    // UIの初期化
    func initQuizUI(view: QuizView) {
        initProgressArea(view: view)
        initButtonState(view: view)
        decideButtonDisplayOrNot(view: view)
    }
    
    // ProgressのUIを初期化する
    func initProgressArea(view: QuizView) {
        let string = NSLocalizedString("one", comment: "") + NSLocalizedString("quizCurrentQuizNumber", comment: "")
        view.quizProgressionLabel.text = string
        view.quizProgressBar.progress = 0.0
        view.moveToNextQuizButton.setTitle(NSLocalizedString("quizMoveToNextQuizButtonText", comment: ""), for: .normal)
    }
    
    // 回答ボタンのUIを初期化する
    func initButtonState(view: QuizView) {
        resetButtonState(view: view)
        view.quizAnswerButtonIsTappedDelegate = self
    }
    
    // 回答ボタンの色・テキストをリセットする
    func resetButtonState(view: QuizView) {
        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = UIColor.systemGray
        config.image = nil
        view.quizFirstAnswerButton.configuration = config
        view.quizSecondAnswerButton.configuration = config
        view.quizThirdAnswerButton.configuration = config
        view.quizFourthAnswerButton.configuration = config
        view.quizFifthAnswerButton.configuration = config
        view.moveToNextQuizButton.isHidden = true
    }
    
    // ボタンを描画するかどうか決定する
    func decideButtonDisplayOrNot(view: QuizView) {
        let selectionCount = wordModel.getQuizAnswerSelections()
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
    func initializeQuiz(view: QuizView) {
        // UIの状態を初期化
        initQuizUI(view: view)
        // クイズをシャッフルして配列を生成する
        quiz = makeRandomQuizList()
        totalSolvedQuizCount = 0
        totalQuizWrongCount = 0
    }
    
    // 最初のクイズを取得
    func getFirstQuiz(view: QuizView) {
        if quiz.isEmpty == true {
            let okAction = UIAlertAction(title: alertOkButton, style: .default) { _ in
                self.goToTheRootViewController()
            }
            showAlert(title: "Error: Index Out Of Range", message: "let currentQuiz = quiz[0]", actions: [okAction])
        } else {
            // 最初のQuizを抽出
            let currentQuiz = quiz[0]
            // これが一番最初のQuizならストッパーとして利用するためIDを控えておく
            currentQuizStopper = currentQuiz.word.id
            showCurrentQuiz(view: view)
        }
    }
    
    // クイズの表示メソッド
    func showCurrentQuiz(view: QuizView) {
        let currentQuiz = quiz[0]
        var meaningArray: [String] = []
        meaningArray.append(currentQuiz.word.meaning)
//        print("⭐︎currentQuizCount: ", quiz.count)
//        print("⭐︎maximumAnswerChoices: ", maximumAnswerChoicesCount)
        for i in 1 ..< maximumAnswerChoicesCount {
            // print("i: ", i)
            meaningArray.append(quiz[i].word.meaning)
        }
        drawInformationOnQuizWidget(quiz: currentQuiz, dummyAnswers: meaningArray, correctAnswer: meaningArray[0], view: view)
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
        let okAction = UIAlertAction(title: alertOkButton, style: .default) { _ in
            self.goToTheRootViewController()
        }
        showAlert(title: alertQuizIsNotAvailableTitleLabel, message: alertQuizIsNotAvailableTextLabel, actions: [okAction])
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
        let quizArray = wordModel.wordList.filter({$0.word.isRemembered == true}).shuffled()
        let returnArray = quizArray.prefix(maximumQuizCount).map{$0}
        print("🍄maximumQuizCount: ", maximumQuizCount)
        return returnArray
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
    func drawInformationOnQuizWidget(quiz: WordModel, dummyAnswers: [String], correctAnswer: String, view: QuizView) {
        // 選択肢配列は問題ごとに削除しておく
        answerSelectionArray.removeAll()
        // 問題を表示
        view.quizSingleWordLabel.text = quiz.word.singleWord
        // dummyAnswerをshuffleする（※　正解のanswerも含まれている）
        let dummy = dummyAnswers.shuffled()
        // 同じ回答の重複対策用フラグ
        var isCorrectAnswerAlreadyAppeared: Bool = false
        // クイズ選択肢の数だけ
        for i in 0 ..< maximumAnswerChoicesCount {
            // answerを生成する
            var answer = ""
            answer = dummy[i]
            // dummy配列の中の値が、correctAnswerと同一ならanswerIdを取得する
            if answer == correctAnswer && isCorrectAnswerAlreadyAppeared == false {
                // どのボタンを押したら正解判定にするのか決める
                answerId = i
                // 既に正解は現れたか？
                isCorrectAnswerAlreadyAppeared = true
            // ダミー選択肢が正解と同じ内容かつ既にボタンが現れたのか判定
            } else if answer == correctAnswer && isCorrectAnswerAlreadyAppeared == true {
                var index = i
                // 検索終了するか？
                var finishSearching: Bool = false
                //　検索終了まで続行
                while !finishSearching {
                    // 配列の末尾まで検索
                    if index < maximumAnswerChoicesCount {
                        // dummy選択肢のラベルが、correctAnswerと合致しないのであれば
                        if dummy[index] != correctAnswer {
                            // ランダムプリセットから値をset
                            answer = DummyData().returnOneMeaning()
                            // 検索終了
                            finishSearching = true
                        }
                    } else {
                        // 検索終了していない状態で配列の末尾に行ったらindex=0でリセット
                        index = 0
                    }
                    // indexをインクリメント
                    index += 1
                }
            }
            // ダミー選択肢のボタンが重複した場合
            for j in 0 ..< i {
                if answer == dummy[j] {
                    // ランダムプリセットから値をset
                    answer = DummyData().returnOneMeaning()
                }
            }
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
            // 最終的に確定された選択肢を配列に格納
            answerSelectionArray.append(answer)
        }
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
        // wordModelにupdateした値を保存
        wordModel.updateWordWrongCount(index: quiz[0].word.id, newWrongCount: quiz[0].word.wrongCount)
        // 今回のQuizで解答数を更新
        totalSolvedQuizCount += 1
    }
    
    // 問題の状態を更新する
    func reloadQuizState(view: QuizView) {
        // 回答したかを判定するBoolをfalseに
        view.isAnsweredBool = false
        //　次の問題へボタンは非表示に
        view.moveToNextQuizButton.isHidden = true
        // 次の問題が最初に出題した問題であれば（=この問題が最終問題なら）、ラベルの表示を変更する
        if quiz[1].word.id == currentQuizStopper {
            view.moveToNextQuizButton.setTitle(quizMoveToResultPresentationTextLabel, for: .normal)
        }
    }
    
    // この問題が最終問題かどうか取得する
    func checkNextQuizIsLast() {
        if quiz[0].word.id == currentQuizStopper {
            let solvedCorrectlyCount = totalSolvedQuizCount - totalQuizWrongCount
            let scoreString = String(solvedCorrectlyCount * 100 / totalSolvedQuizCount) + alertQuizIsFinishedTextLabel + "\n⭕️" + String(solvedCorrectlyCount)   + alertQuizNumberTextLabel  + " " + "❌" + String(totalQuizWrongCount)  + alertQuizNumberTextLabel
            let okAction = UIAlertAction(title: alertOkButton, style: .default) { _ in
                self.goToTheRootViewController()
            }
            showAlert(title: alertQuizIsFinishedTitleLabel, message: scoreString, actions: [okAction])
            getQuizCurrentProperties()
            ud.set(maximumQuizCount/5, forKey: "quizMaximumSelectedSegmentIndex")
            goToTheRootViewController()
        }
    }

    // Progressionを更新する
    func reloadProgressionView(view: QuizView) {
        let demominator = maximumQuizCount
        let progressionRate = Float(totalSolvedQuizCount) / Float(demominator)
        view.quizProgressionLabel.text = String(totalSolvedQuizCount+1) + "  問目"
        view.quizProgressBar.progress = Float(progressionRate)
    }
}
