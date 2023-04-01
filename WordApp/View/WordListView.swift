import UIKit

protocol ReloadWordListWidgetDelegate: AnyObject {
  func reloadWordListWidget()
}

class WordListView: UIView {
    @IBOutlet weak var progressBarWidget: UIProgressView!
    @IBOutlet weak var progressPercentageLabel: UILabel!
    @IBOutlet weak var progressWordSumLabel: UILabel!
    @IBOutlet weak var wordListWidget: UITableView!
    @IBOutlet weak var hideMeaningButton: UIButton!
    weak var delegate: ReloadWordListWidgetDelegate?
    
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
    
    func initalizeProgressionWidgetStyle() {
        progressBarWidget.transform = CGAffineTransform(scaleX: 1.0, y: 6.0)
        progressBarWidget.progress = 0.0
        progressBarWidget.progressTintColor = UIColor.green
    }
    
    @IBAction func hideMeaning() {
        let ud = UserDefaults.standard
        let currentMeaningVisibility = ud.bool(forKey: "isMeaningHidden")
        let visibility = currentMeaningVisibility == true ? false : true
        ud.set(visibility, forKey: "isMeaningHidden")
        ud.synchronize()
        let hideMeaningButtonTitleLabelText = visibility == true ? "日本語訳を表示する" : "日本語訳を隠す"
        hideMeaningButton.setTitle(hideMeaningButtonTitleLabelText, for: .normal)
        
        delegate?.reloadWordListWidget()
    }
}
