import UIKit

class SettingViewController: UIViewController, SettingViewDelegate, UICollectionViewDelegate {
    
    var wordModel = WordListModel.shared
    var themeModel = DesignThemeListModel.shared
    var quiz: [WordModel] = []
    var currentQuizTotal: Int = 0
    var currentChoicesTotal: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        getAndCheckCurrentQuizStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initializeView()
        getAndCheckCurrentQuizStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeAllSubviews(parentView: self.view)
    }
    
    func getAndCheckCurrentQuizStatus() {
        // 利用可能なクイズ数を取得
        currentQuizTotal = wordModel.getAndReturnMaximumQuizCount()
        //　現在のクイズ上限数を取得
        currentChoicesTotal = wordModel.getAndReturnQuizChoices()
        checkMaximumAvaivleForQuizCount()
    }
    
    func removeAllSubviews(parentView: UIView){
        let subviews = parentView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
    
    func initializeView() {
        removeAllSubviews(parentView: self.view)
        let view = SettingView()
        view.settingViewDelegate = self
        view.collectionThemeCollectionView.delegate = self
        view.collectionThemeCollectionView.dataSource = self.themeModel
        view.collectionThemeCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        // CollectionViewの間隔を設定
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        view.collectionThemeCollectionView.collectionViewLayout = layout
        self.view = view
    }
    
    // 現在クイズ出来る問題数の上限を指定
    func checkMaximumAvaivleForQuizCount() {
        let view = self.view as! SettingView
        let forSegmentAt = currentQuizTotal / 5
        for i in 1 ..< 7 {
            var isAvaivable: Bool = true
            if i > forSegmentAt { isAvaivable = false }
            view.makeQuizSumCountControl.setEnabled(isAvaivable, forSegmentAt: i);
        }
    }
    
    func reloadCurrentStatus() {
        // 利用可能なクイズ数を取得
        currentQuizTotal = wordModel.getAndReturnMaximumQuizCount()
        //　現在のクイズ上限数を取得
        currentChoicesTotal = wordModel.getAndReturnQuizChoices()
    }
    
    func updateMaximumQuizSelection(count: Int) {
        reloadCurrentStatus()
        upDateAppInfo(choicesCount: count)
    }
    
    func updateMaximumQuizCount(count: Int) {
        reloadCurrentStatus()
        var sum = 0
        if count == 0 { sum = currentQuizTotal }
        if count != 0 { sum = count }
        wordModel.setMaximumQuiz(count: sum)
    }
    
    func upDateAppInfo(choicesCount: Int) {
        wordModel.setReturnQuizChoices(count: choicesCount)
    }
}

extension SettingViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let view = self.view as! SettingView
        let width: CGFloat = view.collectionThemeCollectionView.frame.width / 2  - 16
        let height = width / 3.2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ud = UserDefaults.standard
        ud.set(indexPath.row, forKey: "selectedThemeColorId")
        collectionView.reloadData()
        viewDidLoad()
    }
}
