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
    
    var answerSelectionArray: [String] = []
    
    // プリセット値：ダミー用回答（正解が2個以上ある際に使用する）
    var presetDummyAnswersArray = [
        "〜を明らかにする", "〜を横断する", "〜を乗り越える", "減少する", "分配する", "証明する", "を起訴する", "を回避する", "を蒸発させる",
        "〜に追従する", "〜を目撃する", "〜が落ちる", "干渉する", "救出する", "痛める", "を再生させる", "を飲む", "を破壊する",
        "形式上の", "個別の", "交互の", "神経症の〜", "時代遅れの〜", "揮発性の〜", "親切な", "綺麗に保たれている", "一過性の〜",
        "卓越", "支配権", "酵素", "信条", "領事", "吸収", "友愛", "花婿", "誘導", "完成", "詰め物", "襲撃", "事件", "建築物", "栽培", "（グラスなどの）容器"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
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
        initializeView()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        removeAllSubviews(parentView: self.view)
    }
    
    func removeAllSubviews(parentView: UIView){
        let subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func initializeView() {
        removeAllSubviews(parentView: self.view)
        let view = QuizView()
        self.view = view
    }
    
    // 設定からクイズに関する情報を取得する
    func getQuizCurrentProperties() {
        maximumAnswerChoicesCount = wordModel.getAndReturnQuizChoices()
        maximumQuizCount = wordModel.getMaximumQuizCount()
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
        view.quizProgressionLabel.text = "1　 問目"
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
        var config = UIButton.Configuration.filled()
        config.background.backgroundColor = UIColor.systemGray
        config.image = nil
        view.quizFirstAnswerButton.configuration = config
        view.quizSecondAnswerButton.configuration = config
        view.quizThirdAnswerButton.configuration = config
        view.quizFourthAnswerButton.configuration = config
        view.quizFifthAnswerButton.configuration = config
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
        // TODO: change variable
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
        let _maximumQuizCount = maximumQuizCount
        quizArray = quizArray.prefix(_maximumQuizCount).map { $0 }
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
        // 選択肢配列は問題ごとに削除しておく
        answerSelectionArray.removeAll()
        // QuizViewを定義
        let view = self.view as! QuizView
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
                            let randomInt = Int.random(in: 0 ..< presetDummyAnswersArray.count)
                            answer = presetDummyAnswersArray[randomInt]
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
                    let randomInt = Int.random(in: 0 ..< presetDummyAnswersArray.count)
                    answer = presetDummyAnswersArray[randomInt]
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
        let progressionRate = Float(totalSolvedQuizCount) / Float(maximumQuizCount)
        view.quizProgressionLabel.text = String(totalSolvedQuizCount+1) + "  問目"
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
