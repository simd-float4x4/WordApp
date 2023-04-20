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
                        themeImageForIconUrl: "",
                        backgroundImageUrl: "",
                        mainColor: "F4F4F4",
                        subColor: "FFFFFF",
                        accentColor: "0076BA",
                        fontColor: "000000",
                        fontName: "DINAlternate-Bold")
        ),
        DesignThemeModel.init(initTheme:
            DesignTheme(id: 2,
                        name: "スペース",
                        useImage: true,
                        themeImageForIconUrl: "earth_icon",
                        backgroundImageUrl: "earth",
                        mainColor: "000000",
                        subColor: "A7ECF7",
                        accentColor: "2A3757",
                        fontColor: "FFFFFF",
                        fontName: "851Gkktt")
        ),
        DesignThemeModel.init(initTheme:
            DesignTheme(id: 3,
                        name: "オレンジ",
                        useImage: true,
                        themeImageForIconUrl: "",
                        backgroundImageUrl: "",
                        mainColor: "FAB12F",
                        subColor: "FFA500",
                        accentColor: "FEF3E2",
                        fontColor: "000000",
                        fontName: "DINAlternate-Bold")
        ),
        DesignThemeModel.init(initTheme:
            DesignTheme(id: 4,
                        name: "オリーブ",
                        useImage: false,
                        themeImageForIconUrl: "",
                        backgroundImageUrl: "",
                        mainColor: "303314",
                        subColor: "90993C",
                        accentColor: "EFFF63",
                        fontColor: "FFFFFF",
                        fontName: "HannariMincho-Regular")
        ),
        DesignThemeModel.init(initTheme:
            DesignTheme(id: 5,
                        name: "ブルーソーダ",
                        useImage: true,
                        themeImageForIconUrl: "soda_icon",
                        backgroundImageUrl: "soda",
                        mainColor: "1881B5",
                        subColor: "EAE2B8",
                        accentColor: "A90000",
                        fontColor: "000000",
                        fontName: "SoukouMincho")
        ),
        DesignThemeModel.init(initTheme:
            DesignTheme(id: 6,
                        name: "ストロベリー",
                        useImage: true,
                        themeImageForIconUrl: "strawberry_icon",
                        backgroundImageUrl: "strawberry",
                        mainColor: "B45460",
                        subColor: "8B2635",
                        accentColor: "E6CCBE",
                        fontColor: "FFFFFF",
                        fontName: "LightNovelPOPv2")
        ),
        DesignThemeModel.init(initTheme:
            DesignTheme(id: 7,
                        name: "ラグジュアリー",
                        useImage: true,
                        themeImageForIconUrl: "luxury_icon",
                        backgroundImageUrl: "tufting",
                        mainColor: "222025",
                        subColor: "4D392E",
                        accentColor: "CFAA54",
                        fontColor: "FFFFFF",
                        fontName: "Snell RoundHand")
        ),
        DesignThemeModel.init(initTheme:
            DesignTheme(id: 8,
                        name: "チョコレート",
                        useImage: true,
                        themeImageForIconUrl: "chocolate_icon",
                        backgroundImageUrl: "chocolate",
                        mainColor: "401100",
                        subColor: "9D6631",
                        accentColor: "A9782C",
                        fontColor: "FFFFFF",
                        fontName: "LightNovelPOPv2")
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
        let currentFontSize = config.textProperties.font.pointSize
        config.textProperties.font = UIFont(name: self.themeList[indexPath.row].theme.fontName, size: currentFontSize) ?? UIFont(name: "LightNovelPOPv2", size: 20.0)!
        cell.contentConfiguration = config
        cell.layer.cornerRadius = cell.frame.size.width * 0.05
        cell.clipsToBounds = true
        cell.layer.borderColor = UIColor.systemBlue.cgColor
        cell.layer.borderWidth = indexPath.row == currentThemeId as! Int ? 8.0 : 0.0
        let url = themeList[indexPath.row].theme.themeImageForIconUrl
        if url != "" {
            let image1: UIImage = UIImage(named: url)!
            let imageView = UIImageView(image: image1)
            imageView.contentMode = .scaleAspectFill
            imageView.frame = cell.frame
            cell.backgroundView = imageView
        } else {
            let backgroundColor = themeList[indexPath.row].theme.mainColor
            cell.backgroundColor = UIColor(hex: backgroundColor)
        }
    
    // 以下不要の可能性あり
        // let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "customTabBarController") as? CustomTabBarController {
//            tabBarController.loadViewIfNeeded()
//            print("tabBarReloadIsCalled")
//            for viewController in tabBarController.viewControllers ?? [] {
//                if let reloadable = viewController as? Reloadable {
//                    reloadable.reloadData()
//                }
//            }
//        }
        return cell
    }
}
