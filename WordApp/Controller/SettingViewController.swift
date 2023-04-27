import UIKit

class SettingViewController: UIViewController, SettingViewDelegate, UICollectionViewDelegate {
    
    var wordModel = WordListModel.shared
    var themeModel = DesignThemeListModel.shared
    var quiz: [WordModel] = []
    var currentQuizTotal: Int = 0
    var currentChoicesTotal: Int = 5
    let ud = UserDefaults.standard
    
    @IBOutlet weak var viewNavigationBar: UINavigationBar!
    
    let settingNavigationItem = UINavigationItem(title: "設定画面")

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        getAndCheckCurrentQuizStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initializeView()
        getAndCheckCurrentQuizStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeAllSubviews(parentView: self.view)
    }
    
    func getAndCheckCurrentQuizStatus() {
        reloadCurrentStatus()
        checkMaximumAvaivleForQuizCount()
    }
    
    func removeAllSubviews(parentView: UIView){
        let subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func initializeView() {
        removeAllSubviews(parentView: self.view)
        let view = SettingView()
        view.settingViewDelegate = self
        view.collectionThemeCollectionView.delegate = self
        view.collectionThemeCollectionView.dataSource = self.themeModel
        view.collectionThemeCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        // CollectionViewの間隔を設定
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        view.collectionThemeCollectionView.collectionViewLayout = layout
        self.view = view
    }
    
    // 現在クイズ出来る問題数の上限を指定
    func checkMaximumAvaivleForQuizCount() {
        let view = self.view as! SettingView
        let forSegmentAt = currentQuizTotal / 5
        let choiceIndex = ud.value(forKey: "choicesSelectedSegmentIndex") as? Int ?? 0
        var quizIndex = ud.value(forKey: "quizMaximumSelectedSegmentIndex") as? Int ?? 0
        let threshold = ud.value(forKey: "maximumRememberedWordsCount") as? Int ?? 0
        print("🍓：", quizIndex, threshold)
        if quizIndex * 5 > threshold  {
            quizIndex = threshold / 5
            ud.set(quizIndex, forKey: "quizMaximumSelectedSegmentIndex")
            print("🍓：", quizIndex, threshold / 5)
        }
        view.changeMaximumQuizCountSegmentedControl.selectedSegmentIndex = quizIndex
        view.changeQuizAnswerSelectionCountSegmentedControl.selectedSegmentIndex = choiceIndex
        for i in 1 ..< 7 {
            var isAvaivable: Bool = true
            if i > forSegmentAt { isAvaivable = false }
            view.changeMaximumQuizCountSegmentedControl.setEnabled(isAvaivable, forSegmentAt: i)
        }
    }
    
    func reloadCurrentStatus() {
        // 利用可能なクイズ数を取得
        currentQuizTotal = wordModel.getAndReturnMaximumQuizCount()
        //　現在の選択肢の上限数を取得
        currentChoicesTotal = wordModel.getQuizAnswerSelections()
        
        print("==========================")
        print("利用可能なクイズ数： ", currentQuizTotal, "現在の選択肢上限数：　", currentChoicesTotal)
        print("==========================")
    }
    
    //　"選択肢"
    func updateMaximumQuizSelection(count: Int) {
        reloadCurrentStatus()
        print("updateMaximumQuizSelectionCount: ", count)
        wordModel.setQuizAnswerSelections(length: count)
    }
    
    //　"出題数"
    func updateMaximumQuizCount(count: Int) {
        var count = count
        reloadCurrentStatus()
        print("updateMaximumQuizCount: ", count)
        // segmentIndex == 0の際は全件返すようにしてあげる
        if count == 0 { count = currentQuizTotal }
        wordModel.setMaximumQuiz(count: count)
    }
}
