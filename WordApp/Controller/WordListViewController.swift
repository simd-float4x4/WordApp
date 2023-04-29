import UIKit

// MARK: WordListViewController
class WordListViewController: UIViewController, ReloadWordListWidgetDelegate, SortWordListWidgetDelegate {
    //　ワードもdる
    var wordModel = WordListModel.shared    
    // DetailViewControllerに渡すための文字列
    var singleWord: String = ""
    var meaning: String = ""
    var exampleSentence: String = ""
    var exampleTranslation: String = ""
    // ソートタイプ：default値は1をセットする。
    var sortType: Int = 1
    //　ソートボタンのテキスト
    var sortTypeTextArray: [String] = [
        NSLocalizedString("sortOldOrder", comment: "登録日時が古い順"),
        NSLocalizedString("sortNewOrder", comment: "登録日時が新しい順"),
        NSLocalizedString("sortABCAsc", comment: "ABC順（昇順）"),
        NSLocalizedString("sortABCDesc", comment: "ABC順（降順）")]
    //　削除モード/暗記モード切り替え変数（Default: true）
    var isDeleteModeOn: Bool = true
    //　ProgressBarのテキスト
    var percetnageString = NSLocalizedString("percentageLabel", comment: "%")
    var slashString = NSLocalizedString("slashLabel", comment: "/")
    var zeroString = NSLocalizedString("zero", comment: "0")
    //　スワイプアクションボタンのテキスト
    var wordDeleteButtonTextLabel = NSLocalizedString("WordDeleteButton", comment: "削除")
    var wordRememberedButtonTextLabel = NSLocalizedString("WordRememberedButton", comment: "覚えた")
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
    // ナビゲーションバー：フレームサイズ
    var navigationBarViewFrameSize = (x: 0, y: 0, height: 94)
    var navigationBarFrameSize = (x: 0, y: 50, height: 44)
    // ナビゲーションアイテム：高さ
    var navigationItemHeight = (x: 0, y: 0, height: 50)
    // ステータスバー：高さ
    var statusBarHeight = 44
    //　ナビゲーションUILabel
    var navigationBarUILabelProperties = (x: 0, y: 50, fontSize: CGFloat(16.0))
    //　navigationItem
    let wordListNavigationItem = UINavigationItem(title: "単語帳画面")
    //　ナビゲーションバーに使用する画像の名前（デフォルト）
    var navigationBarImageName = "brain"
    //　ナビゲーションバーに使用する画像の名前（暗記モード）
    var navigationBarImageNameBrain = "brain"
    //　ナビゲーションバーに使用する画像の名前（削除モード）
    var navigationBarImageNameTrash = "trash.fill"
    // 「日本語訳を表示する」UILabel
    let showTranslation = NSLocalizedString("showTranslation", comment: "")
    //　「日本語訳を隠す」UILabel
    let hideTranslation = NSLocalizedString("hideTranslation", comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //　Viewを初期化する
        initializeView()
        // データを呼び出す
        wordModel.fetchSavedData()
        // 描画系処理を呼び出す
        fetchCurrentProgress()
        //　WordListWidgetを初期化する
        initializeWordListWidget()
    }
    
    // 画面が呼ばれるたびにWordListWidgetを更新する
    override func viewWillAppear(_ animated: Bool) {
        //　Viewを初期化する
        initializeView()
        //　WordListWidgetを初期化する
        initializeWordListWidget()
        //　現在単語リストが表示されていることを通知する
        wordModel.changeUserReferredWordListStatus(key: "wordListIsShown")
        //　WordListWidgetを更新する
        reloadWordListWidget()
        //　最新の状況を取得する
        fetchCurrentProgress()
        //　TabBarControllerを表示する
        showTabBarController()
    }
    
    //　ノッチによってナビゲーションバーのサイズを決定する
    func decideNavigationSizeByNotch() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        //safeAreaの値が44.0以上であれば、ノッチがあるので、x位置をずらします。
        if(window?.safeAreaInsets.top ?? 0.0 <= 44.0){
            navigationBarFrameSize.height = 44
            navigationBarFrameSize.y = 16
            navigationBarViewFrameSize.height = 16
        }
    }
    
    //　Viewを初期化する
    func initializeView() {
        //　ノッチによってナビゲーションバーのサイズを決定する
        decideNavigationSizeByNotch()
        //　WordListViewを取得する
        var view = WordListView()
        //　ナビゲーションバーを生成する
        view = addNavigationBarToView(view: view)
        //　削除モード/暗記モードのon/offフラグを取得する
        isDeleteModeOn = ud.isDeleteModeOn
        //　ボタンのアイコンを切り替える
        navigationBarImageName = isDeleteModeOn == true ? navigationBarImageNameBrain : navigationBarImageNameTrash
        // viewを代入
        self.view = view
    }
    
    // 最新の回答状況を取得する
    func fetchCurrentProgress() {
        //　WordListViewを取得
        let wordListView = self.view as! WordListView
        //　暗記した単語の数をカウント
        let wordSolvedSum = wordModel.wordList.filter({$0.word.isRemembered == true}).count
        //　単語の総数をカウント
        let wordTotalSum = wordModel.wordList.count
        //　進捗率
        let wordRememberedPercentage = wordTotalSum != 0 ? wordSolvedSum * 100 / wordTotalSum : 100
        //　回答状況
        wordListView.progressWordSumLabel.text = String(wordSolvedSum) + slashString + String(wordTotalSum)
        //　%
        wordListView.progressPercentageLabel.text = String(wordRememberedPercentage) + percetnageString
        //　ProgressBarの進捗率
        wordListView.progressBarWidget.progress = Float(wordRememberedPercentage) / 100.0
        // データ個数が0の場合
        if wordTotalSum == 0 && wordSolvedSum == 0 {
            //　0%にする
            wordListView.progressPercentageLabel.text = zeroString + percetnageString
            //　ProgressionBarを0に設定する
            wordListView.progressBarWidget.progress = 0.0 / 100.0
        }
    }
    
    // WordListWidgetを初期化する
    func initializeWordListWidget() {
        let wordListView = self.view as! WordListView
        // Delegateを設定する
        wordListView.reloadWordListDelegate = self
        wordListView.sortWordListDelegate = self
        wordListView.wordListWidget.delegate = self
        // DataSourceを設定する
        wordListView.wordListWidget.dataSource = self.wordModel
        //　セルを登録する
        wordListView.wordListWidget.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // ソートボタンのラベル文字を適宜変更する
        wordListView.sortWordListButton.setTitle(sortTypeTextArray[sortType-1], for: .normal)
        //　日本語訳の表示/非表示を取得する
        let isTranslationHiddenTrue = ud.isMeaningHidden != true ?  hideTranslation : showTranslation
        //　日本語訳の表示/非表示を適宜変更する
        wordListView.hideMeaningButton.setTitle(isTranslationHiddenTrue, for: .normal)
    }
    
    // WordListWidgetをリロードする
    func reloadWordListWidget() {
        // WordListViewの描画を更新する
        let wordListView = self.view as! WordListView
        wordListView.wordListWidget.reloadData()
        // 表示上の配列をあらかじめfilterしておく
        let itemList =  wordModel.returnFilteredWordList(isWordRememberedStatus: false)
        //　配列が空だったら
        if itemList.isEmpty == true {
            //　テーブル/ラベルのhiddenを更新
            wordListView.wordListWidget.isHidden = true
            wordListView.thereIsNoWordLabel.isHidden = false
        } else {
            //　テーブル/ラベルのhiddenを更新
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
        //　WordListWidgetを更新する
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
        //　詳細画面に行く時
        if segue.identifier == "toWordDetailView" {
            //　WordDetailViewControllerを取得
            let wordDetailView = segue.destination as! WordDetailViewController
            //　値を渡す
            wordDetailView.singleWord = singleWord
            wordDetailView.meaning = meaning
            wordDetailView.exampleSentence = exampleSentence
            wordDetailView.exampleTranslation = exampleTranslation
        }
    }
    
    //　詳細画面に行く
    @objc func toWordDetailView() {
        //　詳細画面に行く時
        performSegue(withIdentifier: "toWordDetailView", sender: nil)
        //　タブコントローラを隠す
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //　登録画面に行く
    @IBAction func toAddWordView() {
        performSegue(withIdentifier: "toAddWordView", sender: nil)
    }
    
    // 削除ボタンと暗記した！ボタンを切り替えた際にアイコンの画像を変更する
    @objc func switchWordActionMode() {
        //　削除モードのON/OFFを切り替える
        isDeleteModeOn = isDeleteModeOn == true ? false : true
        //　ボタンのアイコンを切り替える
        navigationBarImageName = isDeleteModeOn == true ? navigationBarImageNameBrain : navigationBarImageNameTrash
        //　現在の削除モードをUserDefaultsに保存する
        ud.isDeleteModeOn = isDeleteModeOn
        //　Viewを読み込む
        viewWillAppear(true)
    }
}
