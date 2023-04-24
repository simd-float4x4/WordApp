import UIKit

// MARK: Alert
/// UIViewController拡張(アラート)
public extension UIViewController {
    // アラートを表示するメソッド
    func showAlert(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true)
    }

}
