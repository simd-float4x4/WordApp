//import UIKit
//import Foundation
//
//class CustomPlaneButton: UIButton {
//    
//    var fontColor: String = "000000"
//    var fontName: String = ""
//    var themeModel = DesignThemeListModel.shared
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        loadProperties()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//        loadProperties()
//    }
//    
//    func loadProperties() {
//        fetchEncodedThemeData()
//        if #available(iOS 15.0, *) {
//            var config = UIButton.Configuration.plain()
//            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
//                var outgoing = incoming
//                outgoing.font = UIFont(name: self.fontName, size: 20)
//                return outgoing
//            }
//            if self.tag == 1 {
//                config.title = "登録が古い順"
//            } else if self.tag == 2 {
//                config.title = "日本語訳を表示する"
//            }
//            self.configuration = config
//        }
//        self.titleLabel?.font = UIFont(name: fontName, size: 20)
//    }
//    
//    func fetchEncodedThemeData() {
//        let selected = UserDefaults.standard.value(forKey: "selectedThemeColorId") as! Int
//        fontName = themeModel.themeList[selected].theme.fontName
//    }
//}
