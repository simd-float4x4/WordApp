import UIKit

class SettingViewController: UIViewController, SettingViewDelegate, UICollectionViewDelegate {
    //　ワードモデル
    var wordModel = WordListModel.shared
    //　テーマモデル
    var themeModel = DesignThemeListModel.shared
    //　現在の出題数
    var currentQuizTotal: Int = 0
    //　現在の選択肢数
    var currentChoicesTotal: Int = 5
    //　UserDefaults
    let ud = UserDefaults.standard
    //　NavigaionItem
    let settingNavigationItem = UINavigationItem(title: "設定画面")

    override func viewDidLoad() {
        super.viewDidLoad()
        //　Viewを初期化する
        initializeView()
        //　現在のクイズの状態を確認し取得する
        getAndCheckCurrentQuizStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //　Viewを初期化する
        initializeView()
        //　現在のクイズの状態を確認し取得する
        getAndCheckCurrentQuizStatus()
    }
    
    //　現在のクイズの状態を確認し取得する
    func getAndCheckCurrentQuizStatus() {
        //　現在の状態をリロードする
        reloadCurrentStatus()
        //　現在クイズ出来る問題数の上限を指定
        checkMaximumAvaivleForQuizCount()
    }
    
    //　Viewを初期化する
    func initializeView() {
        //　SettingViewを宣言
        let view = SettingView()
        //　Delegateを設定
        view.settingViewDelegate = self
        view.collectionThemeCollectionView.delegate = self
        //　DataSourceを設定
        view.collectionThemeCollectionView.dataSource = self.themeModel
        //　Cellを登録
        view.collectionThemeCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        // UICollectionViewFlowLayOutを設定する
        setUpUICollectionViewFlowLayOut(view: view)
        self.view = view
    }
    
    // UICollectionViewFlowLayOutを設定する
    func setUpUICollectionViewFlowLayOut(view: SettingView) {
        //　UICollectionViewFlowLayOutを宣言する
        let layout = UICollectionViewFlowLayout()
        // CollectionViewの間隔を設定
        layout.minimumInteritemSpacing = 8
        // UICollectionViewFlowLayOutをviewのCollectionに設定する
        view.collectionThemeCollectionView.collectionViewLayout = layout
    }
    
    // 現在クイズ出来る問題数の上限を指定
    func checkMaximumAvaivleForQuizCount() {
        //　SettingViewを取得
        let view = self.view as! SettingView
        //　クイズの出題数上限値
        let forSegmentAt = currentQuizTotal / 5
        //　選択肢数
        let choiceIndex = ud.choicesSelectedSegmentIndex
        //　クイズの出題数
        let quizIndex = ud.quizMaximumSelectedSegmentIndex
        //　各データをSegmentedControlに設定
        view.changeMaximumQuizCountSegmentedControl.selectedSegmentIndex = quizIndex
        view.changeQuizAnswerSelectionCountSegmentedControl.selectedSegmentIndex = choiceIndex
        for i in 1 ..< 7 {
            //　基本は利用可能
            var isAvaivable: Bool = true
            //　上限値未満のSegmentは利用不可にする
            if i > forSegmentAt { isAvaivable = false }
            //　SegmentedControlに利用状態を登録する
            view.changeMaximumQuizCountSegmentedControl.setEnabled(isAvaivable, forSegmentAt: i)
        }
    }
    
    //　現在の状態をリロードする
    func reloadCurrentStatus() {
        // 利用可能なクイズ数を取得
        currentQuizTotal = wordModel.getAndReturnMaximumQuizCount()
        //　現在の選択肢の上限数を取得
        currentChoicesTotal = wordModel.getQuizAnswerSelections()
    }
    
    //　"選択肢"
    func updateMaximumQuizSelection(count: Int) {
        //　現在の状態をリロードする
        reloadCurrentStatus()
        wordModel.setQuizAnswerSelections(length: count)
    }
    
    //　"出題数"
    func updateMaximumQuizCount(count: Int) {
        var count = count
        //　現在の状態をリロードする
        reloadCurrentStatus()
        // segmentIndex == 0の際は全件返すようにしてあげる
        if count == 0 { count = currentQuizTotal }
        wordModel.setMaximumQuiz(count: count)
    }
}
