import Foundation
import UIKit

// MARK: DesignThemeModel
class DesignThemeModel: Codable {
    var theme: DesignTheme
    
    init(initTheme: DesignTheme){
        self.theme = initTheme
    }
}
