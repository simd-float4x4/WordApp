import Foundation
import UIKit

class WordDetailViewController: UIViewController {
    
    var singleWord: String = ""
    var meaning: String = ""
    var exampleSentence: String = ""
    var exampleTranslation: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = WordDetailView()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                  action: #selector(onTapDismissWordView))
        view.cancelView.addGestureRecognizer(tapGestureRecognizer)
        view.singleWordLabel.text = singleWord
        view.meaningLabel.text = meaning
        view.exampleSentenseLabel.text = exampleSentence
        view.exampleSentenseTranslationLabel.text = exampleTranslation
        self.view = view
    }
    
    @objc func onTapDismissWordView() {
        dismiss(animated: true,completion: nil)
    }
}
