import UIKit

class CustomNavigationBar: UINavigationBar {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
