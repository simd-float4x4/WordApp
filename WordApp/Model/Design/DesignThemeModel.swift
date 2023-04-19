import Foundation
import UIKit

class DesignThemeModel: Codable {
    var theme: DesignTheme
    
    init(initTheme: DesignTheme){
        self.theme = initTheme
    }
}


class DesignThemeListModel: NSObject, UICollectionViewDataSource {
    
    static let shared = DesignThemeListModel()
    
    // Modelで管理する配列に初期値を設定する。
    var themeList: [DesignThemeModel] = [
        DesignThemeModel.init(initTheme:
            DesignTheme(id: 1,
                        name: "ノーマル",
                        useImage: false,
                        themeImageForIconUrl: "F4F4F4",
                        backgroundImageUrl: "",
                        mainColor: "F4F4F4",
                        subColor: "FFFFFF",
                        accentColor: "0076BA",
                        fontColor: "000000",
                        fontName: "")
        ),
        DesignThemeModel.init(initTheme:
            DesignTheme(id: 2,
                        name: "スペース",
                        useImage: true,
                        themeImageForIconUrl: "000000",
                        backgroundImageUrl: "",
                        mainColor: "000000",
                        subColor: "2A3757",
                        accentColor: "A7ECF7",
                        fontColor: "FFFFFF",
                        fontName: "")
        ),
        DesignThemeModel.init(initTheme:
            DesignTheme(id: 3,
                        name: "オレンジ",
                        useImage: true,
                        themeImageForIconUrl: "FFA500",
                        backgroundImageUrl: "Image/orange.png",
                        mainColor: "FAB12F",
                        subColor: "FFA500",
                        accentColor: "FEF3E2",
                        fontColor: "000000",
                        fontName: "")
        ),
        DesignThemeModel.init(initTheme:
            DesignTheme(id: 4,
                        name: "オリエンタル",
                        useImage: false,
                        themeImageForIconUrl: "303314",
                        backgroundImageUrl: "",
                        mainColor: "303314",
                        subColor: "90993C",
                        accentColor: "EFFF63",
                        fontColor: "FFFFFF",
                        fontName: "")
        ),
        DesignThemeModel.init(initTheme:
            DesignTheme(id: 5,
                        name: "ブルーソーダ",
                        useImage: true,
                        themeImageForIconUrl: "1881B5",
                        backgroundImageUrl: "",
                        mainColor: "1881B5",
                        subColor: "EAE2B8",
                        accentColor: "A90000",
                        fontColor: "000000",
                        fontName: "")
        ),
        DesignThemeModel.init(initTheme:
            DesignTheme(id: 6,
                        name: "ストロベリー",
                        useImage: true,
                        themeImageForIconUrl: "B45460",
                        backgroundImageUrl: "",
                        mainColor: "B45460",
                        subColor: "8B2635",
                        accentColor: "E6CCBE",
                        fontColor: "000000",
                        fontName: "")
        ),
        DesignThemeModel.init(initTheme:
            DesignTheme(id: 7,
                        name: "ラグジュアリー",
                        useImage: true,
                        themeImageForIconUrl: "222025",
                        backgroundImageUrl: "",
                        mainColor: "222025",
                        subColor: "4D392E",
                        accentColor: "CFAA54",
                        fontColor: "FFFFFF",
                        fontName: "")
        ),
        DesignThemeModel.init(initTheme:
            DesignTheme(id: 8,
                        name: "チョコレート",
                        useImage: true,
                        themeImageForIconUrl: "401100",
                        backgroundImageUrl: "",
                        mainColor: "401100",
                        subColor: "9D6631",
                        accentColor: "A9782C",
                        fontColor: "FFFFFF",
                        fontName: "")
        ),
    
    
    ]
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let backgroundColor = themeList[indexPath.row].theme.themeImageForIconUrl
        let fontColor = themeList[indexPath.row].theme.fontColor
        var config = UIListContentConfiguration.cell()
        let currentThemeId = UserDefaults.standard.value(forKey: "selectedThemeColorId") ?? 0
        config.text = self.themeList[indexPath.row].theme.name
        config.textProperties.alignment = .center
        config.textProperties.color = UIColor(hex: fontColor)
        cell.contentConfiguration = config
        cell.layer.cornerRadius = cell.frame.size.width * 0.05
        cell.clipsToBounds = true
        cell.layer.borderColor = UIColor.systemBlue.cgColor
        cell.layer.borderWidth = indexPath.row == currentThemeId as! Int ? 8.0 : 0.0
        cell.backgroundColor = UIColor(hex: backgroundColor)
        return cell
    }
}
