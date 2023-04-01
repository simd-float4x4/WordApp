import UIKit

class WordListView: UIView {
   @IBOutlet weak var wordListWidget: UITableView!
   
   override init(frame: CGRect){
       super.init(frame: frame)
       loadNib()
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
}
