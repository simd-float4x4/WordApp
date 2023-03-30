import UIKit

class WordListViewController: UIViewController {
    
    @IBOutlet weak var drawingXibArea: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Viewファイルからxibファイルを読み込む
        let view = Bundle.main.loadNibNamed("WordListView", owner: self, options: nil)?.first as! UIView
        view.frame = drawingXibArea.bounds
        drawingXibArea.addSubview(view)
    }
}
