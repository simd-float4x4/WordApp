import UIKit

// MARK: ReloadWordListWidgetDelegate
/// - func reloadWotdListWidget() → WordListViewControllerと接続
protocol ReloadWordListWidgetDelegate: AnyObject {
    func reloadWordListWidget()
}

// MARK: SortWordListWidgetDelegate
/// - func sortWordListView() → WordListViewControllerと接続
protocol SortWordListWidgetDelegate: AnyObject {
    func sortWordListView()
}

// MARK: WordListView
class WordListView: UIView {
    // ProgressWidget
    /// - Outlets:
    ///   - ProgressBarWidget: 進捗率表示機能内のProgressBar。
    @IBOutlet weak var progressBarWidget: UIProgressView!
    ///   - ProgressPercentageLabel: 進捗率表示機能内の進捗率表示ラベル。単位は%。
    @IBOutlet weak var progressPercentageLabel: UILabel!
    ///   - ProgressBarWidget: 進捗率表示機能内の回答数表示ラベル。単位は[回答数]/[総数]。
    @IBOutlet weak var progressWordSumLabel: UILabel!
    // 単語表示用テーブル
    @IBOutlet weak var wordListWidget: UITableView!
    // 日本語訳の表示/非表示をするためのボタン
    @IBOutlet weak var hideMeaningButton: UIButton!
    //　単語リストをソートするためのボタン
    @IBOutlet weak var sortWordListButton: UIButton!
    // 単語リスト登録が0件の際に表示するためのラベル
    @IBOutlet weak var thereIsNoWordLabel: UILabel!
    //　reloadWordListWidgetDelegate
    /// - func reloadWordListWidget() → WordListViewControllerと接続
    weak var reloadWordListDelegate: ReloadWordListWidgetDelegate?
    //　reloadWordListWidgetDelegate
    /// - func sortWordListView() → WordListViewControllerと接続
    weak var sortWordListDelegate: SortWordListWidgetDelegate?
    //　テーマモデル
    let themeModel = DesignThemeListModel.shared
    // UserDefaults
    let ud = UserDefaults.standard
    //　透明色
    let clearColor = UIColor.clear
    // ProgressBarの設定
    let progressionBarProperties = (transformX: 1.0, transformY: 6.0,  defaultProgressValue: Float(0.0))
    // 「日本語訳を表示する」UILabel
    let showTranslation = NSLocalizedString("showTranslation", comment: "")
    //　「日本語訳を隠す」UILabel
    let hideTranslation = NSLocalizedString("hideTranslation", comment: "")
    
   override init(frame: CGRect){
       super.init(frame: frame)
       loadNib()
   }

   required init(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)!
       loadNib()
   }

    // NibFileをLoadする
    func loadNib(){
        let view = Bundle.main.loadNibNamed("WordListView", owner: self, options: nil)?.first as! UIView
        view.frame = self.frame
        if let subview = view.subviews.first  {
            self.addSubview(subview)
        }
        initializeWidget()
    }
    
    // UIを初期化する
    func initializeWidget() {
        initalizeProgressionWidgetStyle()
        initializeWordListWidgetStyle()
    }
    
    // ProgressionBar（Outlet）の初期化
    func initalizeProgressionWidgetStyle() {
        // ProgressBarをX軸方向とY軸方向に変形させる
        progressBarWidget.transform = CGAffineTransform(
            scaleX: progressionBarProperties.transformX, y: progressionBarProperties.transformY)
        // ProgressBarにデフォルト値を格納する
        progressBarWidget.progress = progressionBarProperties.defaultProgressValue
        // ProgressBarにデフォルトカラーを設定する
        progressBarWidget.backgroundColor = clearColor
    }
    
    // WordListWidgetの初期化
    func initializeWordListWidgetStyle() {
        wordListWidget.backgroundColor = UIColor.clear
        thereIsNoWordLabel.text = NSLocalizedString("WordListWidgetIsNilLabel", comment: "")
    }
    
    // 意味を表示/隠すトグル
    @IBAction func hideMeaning() {
        // 現在の意味の表示を取得
        let currentMeaningVisibility = ud.isMeaningHidden
        // 現在の視認状態と逆のBoolを設定
        let visibility = currentMeaningVisibility == true ? false : true
        // 上書き保存
        ud.isMeaningHidden = visibility
        // 表示モードの変更に伴いラベルテキストも変更
        let hideMeaningButtonTitleLabelText = visibility != true ?  hideTranslation : showTranslation
        hideMeaningButton.setTitle(hideMeaningButtonTitleLabelText, for: .normal)
        // リロードする
        /// WordListViewControllerのreloadWordListWidget()と接続
        reloadWordListDelegate?.reloadWordListWidget()
    }
    
    // ソートする
    @IBAction func sortWordListWidget() {
        // ソートする
        /// WordListViewControllerのsortWordListView()と接続
        sortWordListDelegate?.sortWordListView()
    }
    
}
