import UIKit

class WordListViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var drawingXibArea: UIView!
    
    var myModel: WordListModel?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Viewファイルからxibファイルを読み込む
        let view = Bundle.main.loadNibNamed("WordListView", owner: self, options: nil)?.first as! UIView
        view.frame = drawingXibArea.bounds
        drawingXibArea.addSubview(view)
        settingTableView()
    }
    
    private func settingTableView () {
        let wordListView = drawingXibArea as! WordListView
        wordListView.wordListWidget.delegate = self
        wordListView.wordListWidget.dataSource = self.myModel
        // TableViewに表示するCellを登録する
        wordListView.wordListWidget.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}
