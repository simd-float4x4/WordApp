import UIKit
import Foundation

// MARK: AddWordViewControllerのTableViewDelegate
extension AddWordViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
