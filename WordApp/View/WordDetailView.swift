import Foundation
import UIKit

class WordDetailView: UIView {
    
    @IBOutlet weak var singleWordLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var exampleSentenseLabel: UILabel!
    @IBOutlet weak var exampleSentenseTranslationLabel: UILabel!
    @IBOutlet weak var cancelView: UIView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        loadNib()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    func loadNib(){
        let view = Bundle.main.loadNibNamed("WordDetailView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        if let subview = view.subviews.first  {
            self.addSubview(subview)
        }
        exampleSentenseLabel.numberOfLines = 0
        exampleSentenseLabel.sizeToFit()
    }
}
