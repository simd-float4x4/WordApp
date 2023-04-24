import Foundation
import UIKit

// MARK: SettingViewDelegate
protocol SettingViewDelegate: AnyObject {
    func updateMaximumQuizSelection(count: Int)
    func updateMaximumQuizCount(count: Int)
}

// MARK: SettingViewDelegate
class SettingView: UIView {
    // 回答選択肢を調整するSegmenControl
    @IBOutlet weak var quizAnserSegmentedControl: UISegmentedControl!
    
    //　クイズの回答数を生成するControl
    @IBOutlet weak var makeQuizSumCountControl: UISegmentedControl!
    
    //　テーマ選択用CollectionView
    @IBOutlet weak var collectionThemeCollectionView: UICollectionView!
    
    @IBOutlet weak var settingViewSelectQuizSelectionCountTextLabel: UILabel!
    @IBOutlet weak var settingViewQuizMaximumCountTextLabel: UILabel!
    @IBOutlet weak var settingViewDesignThemeTextLabel: UILabel!
    
    @IBOutlet var testLabel: UILabel!
    
    weak var settingViewDelegate: SettingViewDelegate!
    
    var currentChoicesTotal: Int = 5
    
    var currentMaximumQuizSum: Int = 0
    
    let ud = UserDefaults.standard
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
        let view = Bundle.main.loadNibNamed("SettingView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        // セグメントが変更された時に呼び出すメソッドの設定
        quizAnserSegmentedControl.addTarget(self, action: #selector(quizChoicesSegmentedControl(_:)), for: UIControl.Event.valueChanged)
        makeQuizSumCountControl.addTarget(self, action: #selector(quizMaximumCountSegmentedControl(_:)), for: UIControl.Event.valueChanged)
        settingViewSelectQuizSelectionCountTextLabel.text = NSLocalizedString("settingSelectionAnswerCountTitle", comment: "")
        settingViewQuizMaximumCountTextLabel.text = NSLocalizedString("settingMaximumQuizCountTitle", comment: "")
        settingViewDesignThemeTextLabel.text = NSLocalizedString("settingDesignThemeTitle", comment: "")
        
        if let subview = view.subviews.first  {
            let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: subview.frame.size.width, height: 94))
            navBar.backgroundColor = UIColor.white
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            navBar.standardAppearance = appearance
            let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as? Int ?? 0
            var color = themeModel.themeList[selected].theme.accentColor
            if selected == 3 || selected == 2 || selected == 5 { color = themeModel.themeList[selected].theme.complementalColor }
            navBar.barTintColor = UIColor(hex: color)
            navBar.backgroundColor = UIColor(hex: color)
            let settingNavigationItem = UINavigationItem(title: "設定画面")
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
    
    @IBAction func quizChoicesSegmentedControl(_ sender: UISegmentedControl) {
        switch Int(sender.selectedSegmentIndex) {
            case 0:
                currentChoicesTotal = 5
            case 1:
                currentChoicesTotal = 4
            case 2:
                currentChoicesTotal = 3
            default:
                break
        }
        settingViewDelegate.updateMaximumQuizSelection(count: currentChoicesTotal)
        ud.set(sender.selectedSegmentIndex, forKey: "choicesSelectedSegmentIndex")
    }
    
    @IBAction func quizMaximumCountSegmentedControl(_ sender: UISegmentedControl) {
        switch Int(sender.selectedSegmentIndex) {
            case 0:
                currentMaximumQuizSum = 0
            case 1:
                currentMaximumQuizSum = 5
            case 2:
                currentMaximumQuizSum = 10
            case 3:
                currentMaximumQuizSum = 15
            case 4:
                currentMaximumQuizSum = 20
            case 5:
                currentMaximumQuizSum = 25
            case 6:
                currentMaximumQuizSum = 30
            default:
                break
        }
        settingViewDelegate.updateMaximumQuizCount(count: currentMaximumQuizSum)
        ud.set(sender.selectedSegmentIndex, forKey: "quizMaximumSelectedSegmentIndex")
    }
}


