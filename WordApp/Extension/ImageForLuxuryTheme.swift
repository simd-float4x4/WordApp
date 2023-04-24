import Foundation
import UIKit

// MARK: ImageForLuxuryTheme
class ImageForLuxuryTheme: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadProperties()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadProperties()
    }
    
    func loadProperties() {
        let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as? Int ?? 0
        if selected == 6 {
            self.isHidden = false
        } else {
            self.isHidden = true
        }
    }
}
