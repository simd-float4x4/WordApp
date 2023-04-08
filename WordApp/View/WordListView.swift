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
    // @IBOutletの宣言
    @IBOutlet weak var progressBarWidget: UIProgressView!
    @IBOutlet weak var progressPercentageLabel: UILabel!
    @IBOutlet weak var progressWordSumLabel: UILabel!
    @IBOutlet weak var wordListWidget: UITableView!
    @IBOutlet weak var hideMeaningButton: UIButton!
    @IBOutlet weak var sortWordListButton: UIButton!
    
    weak var reloadWordListDelegate: ReloadWordListWidgetDelegate?
    weak var sortWordListDelegate: SortWordListWidgetDelegate?
    
    let ud = UserDefaults.standard
    
   override init(frame: CGRect){
       super.init(frame: frame)
       loadNib()
       initalizeProgressionWidgetStyle()
   }

   required init(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)!
       loadNib()
   }

    func loadNib(){
       let view = Bundle.main.loadNibNamed("WordListView", owner: self, options: nil)?.first as! UIView
       view.frame = self.bounds
       if let subview = view.subviews.first  {
           self.addSubview(subview)
       }
    }
    
    // ProgressionBar（Outlet）のStyleの初期化
    func initalizeProgressionWidgetStyle() {
        progressBarWidget.transform = CGAffineTransform(scaleX: 1.0, y: 6.0)
        progressBarWidget.progress = 0.0
        progressBarWidget.progressTintColor = UIColor.green
    }
    
    // 意味を表示/隠すトグル
    @IBAction func hideMeaning() {
        // 現在の意味の表示を取得
        let currentMeaningVisibility = ud.bool(forKey: "isMeaningHidden")
        // 現在の視認状態と逆のBoolを設定
        let visibility = currentMeaningVisibility == true ? false : true
        // 上書き保存
        ud.set(visibility, forKey: "isMeaningHidden")
        ud.synchronize()
        // 表示モードの変更に伴いラベルテキストも変更
        let hideMeaningButtonTitleLabelText = visibility == true ? "日本語訳を表示する" : "日本語訳を隠す"
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
