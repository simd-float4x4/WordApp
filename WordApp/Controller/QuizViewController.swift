import Foundation
import UIKit

// MARK: QuizViewController
class QuizViewController: UIViewController {
    //　ワードモデル
    var wordModel = WordListModel.shared
    //　テーマモデル
    var themeModel = DesignThemeListModel.shared
    //　クイズを格納するための配列
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
    //　ダミーの選択肢を格納するための配列
    var answerSelectionArray: [String] = []
    //　定数
    let alertErrorTitleLabel = NSLocalizedString("alertErrorTitle", comment: "エラー")
    let alertOkButton = NSLocalizedString("alertOkButton", comment: "OK")
    let alertQuizIsNotAvailableTitleLabel = NSLocalizedString("alertQuizIsNotAvailableTitle", comment: "クイズを利用するためには、単語を5つ以上暗記してください。")
    let alertQuizIsNotAvailableTextLabel = NSLocalizedString("alertQuizIsNotAvailableText", comment: "点です。（100点満点中）")
    let alertQuizIsFinishedTitleLabel = NSLocalizedString("alertQuizFinishedTitle", comment: "お疲れ様でした。")
    let alertQuizIsFinishedTextLabel = NSLocalizedString("alertQuizFinishedText", comment: "登録完了(")
    let alertQuizNumberTextLabel = NSLocalizedString("alertQuizNumber", comment: "問")
    let quizMoveToResultPresentationTextLabel = NSLocalizedString("quizMoveToResultPresentation", comment: "結果発表へ")
    //　ナビゲーションアイテム
    let QuizNavigationItem = UINavigationItem(title: "クイズモード")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //　Viewを初期化する
        initializeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //　Viewを初期化する
        initializeView()
    }
    
    //　Viewを初期化する
    func initializeView() {
        //　QuizViewのインスタンスを生成する
        let view = QuizView()
        self.view = view
        //　クイズが利用できるか確認する
        checkQuizIsAvailable()
        print("💓：　initializeView")
    }
    
    //　クイズが利用できるか確認する
    func checkQuizIsAvailable() {
        let quizView = self.view as! QuizView
        //　クイズが利用できるか確認する
        let isAvailable = checkIsQuizAvailable()
        //　利用可能であれば
        if isAvailable {
            //　クイズをセットする
            setQuiz(view: quizView)
        }
        print("💓：　checkQuizIsAvailable")
    }
    
    //　クイズをセットする
    func setQuiz(view: QuizView) {
        // 利用可能なクイズ数を取得
        currentQuizTotal = countCurrentRegisteredWord()
        print("🍫クイズ数：　", currentQuizTotal)
        //　現在のクイズに関してのプロパティを取得
        getQuizCurrentProperties()
        //　segment強制更新
        checkQuizCount()
        // クイズを初期化する
        initializeQuiz(view: view)
        // 最初のクイズを取得する
        getFirstQuiz(view: view)
        print("💓：　setQuiz")
    }
    
    //　クイズのカウント・segmented
    func checkQuizCount() {
        //　選択されたSegmentedIndexの値
        let quizIndex = ud.quizMaximumSelectedSegmentIndex
        // Segmented * 5 = 問題の出現上限数となる
        let max = 5 * quizIndex
        print("🍫つまみ：　", quizIndex)
        print("🍫上限数：　", max)
        //　出題数が「全部」であるなら
        if quizIndex == 0 {
            // 全部の値を返却する
            maximumQuizCount = countCurrentRegisteredWord()
            //　selectedSegmentedIndexを0に更新する
            ud.quizMaximumSelectedSegmentIndex = 0
            print("🔔1: ", ud.quizMaximumSelectedSegmentIndex)
            print("🤗出題数：　", maximumQuizCount)
        } else {
            //　segment＝それ以外の場合、値に問題があるかチェック
            //　保存されたsegmentより単語総数が小さい場合
            if currentQuizTotal < max { // e.g. 9 < 10
                //　出題数を更新。5で割った余りを切り捨てる
                maximumQuizCount = (currentQuizTotal/5) * 5 // e.g. 9/5 * 5
                //　selectedSegmentedIndexを上と同じ要領で強制更新する
                ud.quizMaximumSelectedSegmentIndex = currentQuizTotal/5
                print("🔔2: ", ud.quizMaximumSelectedSegmentIndex)
                print("🤗つまみ：　", currentQuizTotal/5)
            } else {
                // なにも問題がない場合
                //　上限にmaxを設定する
                maximumQuizCount = max
                //　selectedSegmentedIndexを強制更新する
                ud.quizMaximumSelectedSegmentIndex = currentQuizTotal/5
                print("🔔3: ", ud.quizMaximumSelectedSegmentIndex)
                print("🤗出題数：　", maximumQuizCount)
            }
            print("😱")
        }
        print("💓：　checkQuizCount")
    }
    
    // 設定からクイズに関する情報を取得する
    func getQuizCurrentProperties() {
        //　回答選択肢の数を取得する
        maximumAnswerChoicesCount = wordModel.getQuizAnswerSelections()
        //　出題数の数を取得する
        maximumQuizCount = wordModel.getAndReturnMaximumQuizCount()
        print("🍫選択肢数：　", maximumAnswerChoicesCount)
        print("🍫出題数：　", maximumQuizCount)
        print("💓：　getQuizCurrentProperties")
    }
    
    // UIの初期化
    func initQuizUI(view: QuizView) {
        // ProgressのUIを初期化する
        initProgressArea(view: view)
        // 回答ボタンのUIを初期化する
        initButtonState(view: view)
        decideButtonDisplayOrNot(view: view)
        print("💓：　initQuizUI")
    }
    
    // ProgressのUIを初期化する
    func initProgressArea(view: QuizView) {
        let string = NSLocalizedString("one", comment: "") + NSLocalizedString("quizCurrentQuizNumber", comment: "")
        view.quizProgressionLabel.text = string
        view.quizProgressBar.progress = 0.0
        view.moveToNextQuizButton.setTitle(NSLocalizedString("quizMoveToNextQuizButtonText", comment: ""), for: .normal)
        print("💓：　initProgressArea")
    }
    
    // 回答ボタンのUIを初期化する
    func initButtonState(view: QuizView) {
        // 回答ボタンの色・テキストをリセットする
        resetButtonState(view: view)
        view.quizAnswerButtonIsTappedDelegate = self
        print("💓：　initButtonState")
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
        print("💓：　resetButtonState")
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
        print("💓：　decideButtonDisplayOrNot")
    }
    
    // クイズを初期化
    func initializeQuiz(view: QuizView) {
        // UIの状態を初期化
        initQuizUI(view: view)
        // クイズをシャッフルして配列を生成する
        quiz = makeRandomQuizList()
        //　答えた数を0に設定
        totalSolvedQuizCount = 0
        //　間違えた数を0に設定
        totalQuizWrongCount = 0
        print("💓：　initializeQuiz")
    }
    
    // 最初のクイズを取得
    func getFirstQuiz(view: QuizView) {
        //　エラーハンドリング：クイズが0問の状態でアクセスした場合
        if quiz.isEmpty == true {
            let okAction = UIAlertAction(title: alertOkButton, style: .default) { _ in
                // WordListに戻す
                self.goToTheRootViewController()
            }
            //　アラートを表示
            showAlert(title: alertErrorTitleLabel, message: "クイズを生成できませんでした。", actions: [okAction])
        } else {
            // 最初のQuizを抽出
            let currentQuiz = quiz[0]
            // これが一番最初のQuizならストッパーとして利用するためIDを控えておく
            currentQuizStopper = currentQuiz.word.id
            // クイズを表示する
            showCurrentQuiz(view: view)
        }
        print("💓：　getFirstQuiz")
    }
    
    // クイズを表示する
    func showCurrentQuiz(view: QuizView) {
        //　配列最初のクイズを取得
        let currentQuiz = quiz[0]
        //　単語の意味用に空配列を宣言
        var meaningArray: [String] = []
        //　空配列に現在のクイズの意味を格納
        meaningArray.append(currentQuiz.word.meaning)
        print("✊:　", maximumAnswerChoicesCount)
        print("🃏: ", quiz.count)
        print("🕊：　", quiz[maximumAnswerChoicesCount].word.meaning)
        //　回答選択肢の数によってダミー選択肢を生成
        for i in 1 ..< maximumAnswerChoicesCount {
            //　配列にダミー選択肢を格納
            meaningArray.append(quiz[i].word.meaning)
            print("i: ", i, " ", quiz[i].word.meaning)
        }
        print("🎱: ", meaningArray.count)
        print("🐶： ", currentQuiz, "🐶： ", meaningArray.count, "🐶： ", meaningArray[0])
        //　配列最初のクイズ、ダミー選択肢、正解の選択肢を渡す
        drawInformationOnQuizWidget(quiz: currentQuiz, dummyAnswers: meaningArray, correctAnswer: meaningArray[0], view: view)
        print("💓：　showCurrentQuiz")
    }

    // 登録した単語が特定の単語数未満だった場合アラートを表示する
    func checkIsQuizAvailable() -> Bool {
        //　現在の単語の暗記件数を取得する
        let currenWordRegisterCount = countCurrentRegisteredWord()
        //　5問以下であれば
        if currenWordRegisterCount < maximumAnswerChoicesCount {
            // 登録した単語が特定の単語数未満だった場合のアラートを表示する
            wordAmountIsNotEnoughToActivateQuizAlert()
            return false
        }
        print("💓：　checkIsQuizAvailable")
        return true
    }
    
    // 登録した単語が特定の単語数未満だった場合表示するアラート
    func wordAmountIsNotEnoughToActivateQuizAlert() {
        let okAction = UIAlertAction(title: alertOkButton, style: .default) { _ in
            //　単語帳画面に戻る
            self.goToTheRootViewController()
        }
        //　登録した単語が特定の単語数未満だった旨のアラートを表示する
        showAlert(title: alertQuizIsNotAvailableTitleLabel, message: alertQuizIsNotAvailableTextLabel, actions: [okAction])
    }
    
    // RootViewController(WordListViewController)に遷移する
    func goToTheRootViewController() {
        //　WordListViewControllerのindexを取得する
        let UINavigationController = self.tabBarController?.viewControllers?[0];
        //　取得したControllerのindexをselectedにする
        self.tabBarController?.selectedViewController = UINavigationController;
    }
    
    // 現在登録されている単語の数を取得
    func countCurrentRegisteredWord() -> Int{
        print("💓：　countCurrentRegisterWord")
        //　現在登録されている単語の数を取得
        return wordModel.getAndReturnMaximumQuizCount()
    }
    
    // 暗記したQuizのWordListをランダムにシャッフルして返す
    func makeRandomQuizList() -> [WordModel] {
        // wordListをランダムにシャッフル
        let quizArray = wordModel.wordList.filter({$0.word.isRemembered == true}).shuffled()
        // 出題数の分だけ配列の[0]から単語を生成する
        let returnArray = quizArray.prefix(maximumQuizCount).map{$0}
        print("🍄maximumQuizCount: ", maximumQuizCount)
        print("💓：　makeRandomQuizList")
        return returnArray
    }
    
    // WordListの一番最初の要素を削除する
    func deleteFirstQuizFromArray() {
        //wordList最初の要素をremoveする
        quiz.remove(at: 0)
        print("💓：　deleteFirstQuizFromArray")
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
        print("🍀: 1-OK")
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
                print("🍀: 2-1-OK")
            // ダミー選択肢が正解と同じ内容かつ既にボタンが現れたのか判定
            } else if answer == correctAnswer && isCorrectAnswerAlreadyAppeared == true {
                //　周回変数
                var wrap = 0
                //　検索対象のダミー選択肢ID
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
                            print("🍀: 2-2-OK")
                        }
                        // 検索2周目突入で
                        if wrap == 2 {
                            // ランダムプリセットから値を強制set
                            answer = DummyData().returnOneMeaning()
                            // 強制検索終了
                            finishSearching = true
                            print("🍀: 2-3-OK")
                        }
                        print("🍀: 2-3-NG")
                    } else {
                        // 検索終了していない状態で配列の末尾に行ったらindex=0でリセット
                        index = 0
                        //　周回変数に1をインクリメント
                        wrap += 1
                        print("🍀: 2-4-OK")
                    }
                    // 検索対象のダミー選択肢IDをインクリメント
                    index += 1
                }
            }
            // ダミー選択肢のボタンが重複した場合
            for j in 0 ..< i {
                if answer == dummy[j] {
                    // ランダムプリセットから値をset
                    answer = DummyData().returnOneMeaning()
                }
                print("🍁: ", answer)
                print("🍀: 2-5-OK")
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
        print("💓：　drawInformation")
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
        print("💓：　checkedPressedButtonIsCorrectAnswer")
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
        print("💓：　reloadQuizState")
    }
    
    // この問題が最終問題かどうか取得する
    func checkNextQuizIsLast() {
        // この問題のidがstopperで設定したidと同一であれば
        if quiz[0].word.id == currentQuizStopper {
            //　正解数を取得
            let solvedCorrectlyCount = totalSolvedQuizCount - totalQuizWrongCount
            //　スコアを算出し、ラベルに代入
            let scoreString = String(solvedCorrectlyCount * 100 / totalSolvedQuizCount) + alertQuizIsFinishedTextLabel + "\n⭕️" + String(solvedCorrectlyCount)   + alertQuizNumberTextLabel  + " " + "❌" + String(totalQuizWrongCount)  + alertQuizNumberTextLabel
            // OKが押されたのであれば
            let okAction = UIAlertAction(title: alertOkButton, style: .default) { _ in
                //　単語帳画面に移動する
                self.goToTheRootViewController()
            }
            //　アラートを表示する
            showAlert(title: alertQuizIsFinishedTitleLabel, message: scoreString, actions: [okAction])
            getQuizCurrentProperties()
            //　TODO: 検証（不要？）
            ud.quizMaximumSelectedSegmentIndex = maximumQuizCount/5
            goToTheRootViewController()
        }
        print("💓：　checkNextQuizIsLast")
    }

    // Progressionを更新する
    func reloadProgressionView(view: QuizView) {
        //　分母に回答した問題数を代入する
        let demominator = maximumQuizCount
        //　進捗率を生成する
        let progressionRate = Float(totalSolvedQuizCount) / Float(demominator)
        //　進捗率をラベルに設定する
        view.quizProgressionLabel.text = String(totalSolvedQuizCount+1) + "  問目"
        //　ProgressionBarを設定する
        view.quizProgressBar.progress = Float(progressionRate)
        print("💓：　reloadProgresisonView")
    }
}
