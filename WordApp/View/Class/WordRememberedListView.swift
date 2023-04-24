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
    
    let themeModel = DesignThemeListModel.shared
    
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
            let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: subview.frame.size.width, height: 94))
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            navBar.standardAppearance = appearance
            let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as? Int ?? 0
            var color = themeModel.themeList[selected].theme.accentColor
            if selected == 3 || selected == 2 || selected == 5 { color = themeModel.themeList[selected].theme.complementalColor }
            navBar.barTintColor = UIColor(hex: color)
            navBar.backgroundColor = UIColor(hex: color)
            let settingNavigationItem = UINavigationItem(title: "暗記リスト")
            navBar.setItems([settingNavigationItem], animated: false)
            
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.shadowColor = .clear
            navBar.scrollEdgeAppearance = navigationBarAppearance
        
            let titleLabelView = UIView()
            titleLabelView.frame = CGRect(x: subview.frame.size.width / 4, y: 0, width: subview.frame.size.width / 2, height: 94)
            let title = settingNavigationItem.title
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            label.frame = CGRect(x: 0, y: 50, width: subview.frame.size.width / 2, height: 44)
            label.font = UIFont.boldSystemFont(ofSize: 16)
            
            subview.addSubview(navBar)
            titleLabelView.addSubview(label)
            subview.addSubview(titleLabelView)
            
            self.addSubview(subview)
        }
    }
    
    @IBAction func sortWordRememberedList() {
        sortWordRemeberedListDelegate.sortWordRememberedListView()
    }
}
