import Foundation
import UIKit

class CommonAlert {
    func make(alertTitle: String, alertMessage: String, alertAction: [String]) -> UIAlertController{
        let alertContent = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: .alert)
        for i in 0 ..< alertAction.count {
            var getAction = UIAlertAction()
            switch alertAction[i] {
                case ".ok":
                    getAction = UIAlertAction(
                        title: "OK",
                        style: .default) { (action) in
                            
                        }
                case ".cancel":
                    break
                default :
                    break
            }
            alertContent.addAction(getAction)
        }
        return alertContent
    }
}
