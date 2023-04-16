import UIKit

class SettingViewController: UIViewController, SettingViewDelegate {
    
    var wordModel = WordListModel.shared
    var quiz: [WordModel] = []
    var currentQuizTotal: Int = 0
    var currentChoicesTotal: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = SettingView()
        view.settingViewDelegate = self
        self.view = view
        // 利用可能なクイズ数を取得
        currentQuizTotal = wordModel.getAndReturnMaximumQuizCount()
        //　現在のクイズ上限数を取得
        currentChoicesTotal = wordModel.getAndReturnQuizChoices()
        checkMaximumAvaivleForQuizCount()
    }
    
    // 現在クイズ出来る問題数の上限を指定
    func checkMaximumAvaivleForQuizCount() {
        let view = self.view as! SettingView
        let forSegmentAt = currentQuizTotal / 5
        for i in 1 ..< 7 {
            var isAvaivable: Bool = true
            if i > forSegmentAt { isAvaivable = false }
            view.makeQuizSumCountControl.setEnabled(isAvaivable, forSegmentAt: i);
        }
    }
    
    func reloadCurrentStatus() {
        // 利用可能なクイズ数を取得
        currentQuizTotal = wordModel.getAndReturnMaximumQuizCount()
        //　現在のクイズ上限数を取得
        currentChoicesTotal = wordModel.getAndReturnQuizChoices()
    }
    
    func updateMaximumQuizSelection(count: Int) {
        reloadCurrentStatus()
        upDateAppInfo(choicesCount: count)
    }
    
    func updateMaximumQuizCount(count: Int) {
        reloadCurrentStatus()
        var sum = 0
        if count == 0 { sum = currentQuizTotal }
        if count != 0 { sum = count }
        wordModel.setMaximumQuiz(count: sum)
        print("現在の設定：")
        print(sum)
    }
    
    func upDateAppInfo(choicesCount: Int) {
        wordModel.setReturnQuizChoices(count: choicesCount)
    }
}
