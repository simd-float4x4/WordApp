import UIKit

class WordListViewController: UIViewController {
    
    var myModel: WordListModel? {
        // セットされるたびにdidSetが動作する
        didSet {
            // ViewとModelとを結合し、Modelの監視を開始する
            registerModel()
        }
    }

    override func loadView() {
        super.loadView()
        self.view = WordListView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myModel = WordListModel()
        settingTableView()
    }
    
    private func settingTableView () {
        let tweetListView = self.view as! WordListView
        tweetListView.wordListWidget.delegate = self
        tweetListView.wordListWidget.dataSource = self.myModel
        // TableViewに表示するCellを登録する
        tweetListView.wordListWidget.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func registerModel() {
        guard let model = myModel else { return }
        
        // 配列が変化したらnotificationCenterで通知を受け取る。
        model.notificationCenter.addObserver(forName: .init(rawValue: "changeTweetList"),
                                             object: nil,
                                             queue: nil,
                                             using: {
            [unowned self] notification in
            let tweetListView = self.view as! WordListView
            
            tweetListView.wordListWidget.reloadData()
        })
    }
    
    // TableViewのセルのタップを検知して、Modelの配列追加する処理を呼び出す。
    @objc func onTapTableViewCell() { myModel?.addTweetList() }
}

// TableViewを描画・処理する為に最低限必要なデリゲートメソッド、データソース
extension WordListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Modelでタップされた時の追加処理を行う。
        self.onTapTableViewCell()
    }
}
