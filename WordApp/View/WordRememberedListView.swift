import Foundation
import UIKit

// MARK: SortWordRememberedListWidgetDelegate
/// - func sortWordRememberedListView() → WordRememberedListViewControllerと接続
protocol SortWordRememberedListWidgetDelegate: AnyObject {
    func sortWordRememberedListView()
}

// MARK: WordRememberedListView
class WordRememberedListView: UIView {
    
    @IBOutlet weak var wordRememberedListWidget: UITableView!
    @IBOutlet weak var sortWordRememberedListButton: UIButton!
    @IBOutlet weak var viewNavigationBar: UINavigationBar!
    
    weak var sortWordRemeberedListDelegate: SortWordRememberedListWidgetDelegate!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    func loadNib(){
        let view = Bundle.main.loadNibNamed("WordRememberedListView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        if let subview = view.subviews.first  {
            self.addSubview(subview)
        }
    }
    
    @IBAction func sortWordRememberedList() {
        sortWordRemeberedListDelegate.sortWordRememberedListView()
    }
}
