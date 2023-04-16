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
    
    @IBOutlet var testLabel: UILabel!
    
    weak var settingViewDelegate: SettingViewDelegate!
    
    var currentChoicesTotal: Int = 5
    
    var currentMaximumQuizSum: Int = 0
    
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
        if let subview = view.subviews.first  {
            self.addSubview(subview)
        }
        // セグメントが変更された時に呼び出すメソッドの設定
        quizAnserSegmentedControl.addTarget(self, action: #selector(quizChoicesSegmentedControl(_:)), for: UIControl.Event.valueChanged)
        makeQuizSumCountControl.addTarget(self, action: #selector(quizMaximumCountSegmentedControl(_:)), for: UIControl.Event.valueChanged)
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
    }
}
