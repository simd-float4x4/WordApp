import UIKit

// MARK: WordListViewController
class WordListViewController: UIViewController, ReloadWordListWidgetDelegate, SortWordListWidgetDelegate {
    
    var wordModel = WordListModel.shared    
    // DetailViewControllerに渡すための文字列
    var singleWord: String = ""
    var meaning: String = ""
    var exampleSentence: String = ""
    var exampleTranslation: String = ""
    // ソートタイプ：default値は1をセットする。
    var sortType: Int = 1
    var sortTypeTextArray: [String] = [
        NSLocalizedString("sortOldOrder", comment: ""),
        NSLocalizedString("sortNewOrder", comment: ""),
        NSLocalizedString("sortABCAsc", comment: ""),
        NSLocalizedString("sortABCDesc", comment: "")]
    var isDeleteModeOn: Bool = true
    
    var percetnageString = NSLocalizedString("percentageLabel", comment: "")
    var slashString = NSLocalizedString("slashLabel", comment: "")
    var wordDeleteButtonTextLabel = NSLocalizedString("WordDeleteButton", comment: "")
    var wordRememberedButtonTextLabel = NSLocalizedString("WordRememberedButton", comment: "")
    var zeroString = NSLocalizedString("zero", comment: "")
    // フォントカラー：初期値
    var accentColor: String = "000000"
    // 透明色
    let clearColor = UIColor.clear
    //　背景色
    var navigationBarBackgroundColor = "000000"
    // 一部テーマのナビゲーションバータイトルで使用する白色
    let navigationItemFontWhiteColor = UIColor.white
    // テーマモデルID
    var selectedThemeId: Int = 0
    // テーマモデル
    var themeModel = DesignThemeListModel.shared
    // UserDefaults
    let ud = UserDefaults.standard
    //　ナビゲーションバータイトル
    let navigationBarTitleString = NSLocalizedString("WordListViewTitleText", comment: "")
    // ナビゲーションバー：フレームサイズ（注意：iPhone X以降の端末）
    // TODO: iPhone 8、SEなどにも対応できるようにする
    let navigationBarViewFrameSize = (x: 0, y: 0, height: 94)
    let navigationBarFrameSize = (x: 0, y: 50, height: 44)
    // ナビゲーションアイテム：高さ
    let navigationItemHeight = (x: 0, y: 0, height: 50)
    // ステータスバー：高さ
    let statusBarHeight = 44
    //　ナビゲーションUILabel
    let navigationBarUILabelProperties = (x: 0, y: 50, fontSize: CGFloat(16.0))
    
    // 削除モード/暗記モード切り替えボタン。NavigationBarの左上に配置するものとする。
    @IBOutlet var nabigationBarLeftButton: UIBarButtonItem!
    
    let wordListNavigationItem = UINavigationItem(title: "単語帳画面")
    
    var navigationBarImageName = "brain"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        // 日本語訳の表示/非表示に関しては、アプリ起動時には原則trueをセットする
        ud.set(true, forKey: "isMeaningHidden")
        ud.synchronize()
        // データを呼び出す
        wordModel.fetchSavedData()
        // 描画系処理を呼び出す
        fetchCurrentProgress()
        initializeWordListWidget()
    }
    
    // 画面が呼ばれるたびにWordListWidgetを更新する
    override func viewWillAppear(_ animated: Bool) {
        initializeView()
        initializeWordListWidget()
        wordModel.changeUserReferredWordListStatus(key: "wordListIsShown")
        reloadWordListWidget()
        fetchCurrentProgress()
        showTabBarController()
    }
    
    func initializeView() {
        let view = WordListView()
        let screenWidth = getScreenWidth()
        
        let navBarView = UIView(frame: CGRect(
            x: navigationBarViewFrameSize.x,
            y: navigationBarViewFrameSize.y,
            width: screenWidth,
            height: navigationBarViewFrameSize.height))
        let navBar = UINavigationBar(frame: CGRect(
            x: navigationBarFrameSize.x,
            y: navigationBarFrameSize.y,
            width: screenWidth,
            height: navigationBarFrameSize.height))
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.configureWithTransparentBackground()
        appearance.shadowColor = clearColor
        
        //　保存されたテーマIDを取得する
        fetchSavedThemeData()
        //　テーマカラーを背景に代入する
        getNavigationBarBackgroundColor()
        // nabigationBarの背景色をセットする
        setNavigationBarBackgroundColor()
        
        let themeName = getThemeName()
        
        //　下記３テーマはナビゲーションバーの文字がDefaultフォントだと見にくいため白糸に
        if themeName == "ノーマル" || themeName == "スペース" || themeName == "ブルーソーダ" {
            appearance.titleTextAttributes  = [.foregroundColor: navigationItemFontWhiteColor]
        }
        
        if themeName != "ストロベリー" && themeName != "ラグジュアリー" {
            navBar.tintColor = navigationItemFontWhiteColor
        }
        
        navBarView.backgroundColor = UIColor(hex: navigationBarBackgroundColor)
        navBarView.tintColor = navigationItemFontWhiteColor
        
        navBar.backgroundColor = UIColor(hex: navigationBarBackgroundColor)
        
        wordListNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: navigationBarImageName)!, style: .plain, target: self, action: #selector(switchWordActionMode))
        wordListNavigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(toAddWordView))
        
        navBar.setItems([wordListNavigationItem], animated: false)
        
        navBar.scrollEdgeAppearance = appearance
        navBar.standardAppearance = appearance
        
        view.addSubview(navBarView)
        view.addSubview(navBar)
        
        self.view = view
    }
    
    // 最新の回答状況を取得する
    func fetchCurrentProgress() {
        let wordListView = self.view as! WordListView
        let wordSolvedSum = wordModel.wordList.filter({$0.word.isRemembered == true}).count
        let wordTotalSum = wordModel.wordList.count
        let wordRememberedPercentage = wordTotalSum != 0 ? wordSolvedSum * 100 / wordTotalSum : 100
        wordListView.progressWordSumLabel.text = String(wordSolvedSum) + slashString + String(wordTotalSum)
        wordListView.progressPercentageLabel.text = String(wordRememberedPercentage) + percetnageString
        wordListView.progressBarWidget.progress = Float(wordRememberedPercentage) / 100.0
        // データ個数が0の場合
        if wordTotalSum == 0 && wordSolvedSum == 0 {
            wordListView.progressPercentageLabel.text = zeroString + percetnageString
            wordListView.progressBarWidget.progress = 0.0 / 100.0
        }
    }
    
    // WordListWidgetを初期化する
    func initializeWordListWidget() {
        let wordListView = self.view as! WordListView
        wordListView.reloadWordListDelegate = self
        wordListView.sortWordListDelegate = self
        wordListView.wordListWidget.delegate = self
        wordListView.wordListWidget.dataSource = self.wordModel
        wordListView.wordListWidget.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // WordListWidgetをリロードする
    func reloadWordListWidget() {
        // WordListViewの描画を更新する
        let wordListView = self.view as! WordListView
        wordListView.wordListWidget.reloadData()
        // 表示上の配列をあらかじめfilterしておく
        let itemList =  wordModel.returnFilteredWordList(isWordRememberedStatus: false)
        if itemList.isEmpty == true {
            wordListView.wordListWidget.isHidden = true
            wordListView.thereIsNoWordLabel.isHidden = false
        } else {
            wordListView.wordListWidget.isHidden = false
            wordListView.thereIsNoWordLabel.isHidden = true
        }
    }
    
    // WordListWidgetに現在表示されているModelをUserDefaultsに保存する
    
    // WordListWidgetをソートする
    func sortWordListView() {
        let wordListView = self.view as! WordListView
        sortType += 1
        // TODO: 5(ソートタイプの上限)を定数管理する
        // 一巡したらソートタイプを1に戻す（sortType: 5~7は暗記専用）
        sortType = sortType == sortTypeTextArray.count + 1 ? 1 : sortType
        // wordListを並び替える
        wordModel.sortWordList(sortModeId: sortType)
        // ソートボタンのラベル文字を適宜変更する
        wordListView.sortWordListButton.setTitle(sortTypeTextArray[sortType-1], for: .normal)
        reloadWordListWidget()
    }
    
    private func registerModel() {
        // 配列が変化したらnotificationCenterで通知を受け取る。
        NotificationCenter.default.addObserver(
            forName: .notifyName,
            object: nil,
            queue: nil,
            using: {
                [unowned self] Notification in
                reloadWordListWidget()
        })
    }
    
    // ToDetailViewに遷移したときに値を渡す処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWordDetailView" {
            let wordDetailView = segue.destination as! WordDetailViewController
            wordDetailView.singleWord = singleWord
            wordDetailView.meaning = meaning
            wordDetailView.exampleSentence = exampleSentence
            wordDetailView.exampleTranslation = exampleTranslation
        }
    }
    
    // 画面遷移系メソッド
    @objc func toWordDetailView() {
        performSegue(withIdentifier: "toWordDetailView", sender: nil)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func toAddWordView() {
        performSegue(withIdentifier: "toAddWordView", sender: nil)
    }
    
    // 削除ボタンと暗記した！ボタンを切り替えた際にアイコンの画像を変更する
    @objc func switchWordActionMode() {
        isDeleteModeOn = isDeleteModeOn == true ? false : true
        navigationBarImageName = isDeleteModeOn == true ? "brain" : "trash.fill"
        viewWillAppear(true)
    }
}
