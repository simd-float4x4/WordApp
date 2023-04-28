import UIKit
import Foundation

// MARK: DesignThemeListModel
class DesignThemeListModel: NSObject, UICollectionViewDataSource {
    //　テーマモデル
    static let shared = DesignThemeListModel()
    // UserDefaults
    let ud = UserDefaults.standard
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
                        vividColor: "000000",
                        complementalColor: "000000",
                        fontColor: "000000",
                        complementalFontColor: "FFFFFF",
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
                        vividColor: "581308",
                        complementalColor: "F7B2A7",
                        fontColor: "FFFFFF",
                        complementalFontColor: "000000",
                        fontName: "851Gkktt")
        ),
        DesignThemeModel.init(initTheme:
            DesignTheme(id: 3,
                        name: "オレンジ",
                        useImage: false,
                        themeImageForIconUrl: "",
                        backgroundImageUrl: "",
                        mainColor: "FAB12F",
                        subColor: "FFA500",
                        accentColor: "FEF3E2",
                        vividColor: "005AFF",
                        complementalColor: "005AFF",
                        fontColor: "000000",
                        complementalFontColor: "FFFFFF",
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
                        vividColor: "453C99",
                        complementalColor: "6F66C3",
                        fontColor: "FFFFFF",
                        complementalFontColor: "000000",
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
                        vividColor: "151D47",
                        complementalColor: "B8C0EA",
                        fontColor: "000000",
                        complementalFontColor: "FFFFFF",
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
                        vividColor: "268B7C",
                        complementalColor: "74D9CA",
                        fontColor: "FFFFFF",
                        complementalFontColor: "000000",
                        fontName: "LightNovelPOPv2")
        ),
        DesignThemeModel.init(initTheme:
            DesignTheme(id: 7,
                        name: "ラグジュアリー",
                        useImage: true,
                        themeImageForIconUrl: "luxury_icon",
                        backgroundImageUrl: "luxury",
                        mainColor: "222025",
                        subColor: "4D392E",
                        accentColor: "CFAA54",
                        vividColor: "B2CD61",
                        complementalColor: "2E424D",
                        fontColor: "FFFFFF",
                        complementalFontColor: "000000",
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
                        vividColor: "31689D",
                        complementalColor: "6299CE",
                        fontColor: "FFFFFF",
                        complementalFontColor: "000000",
                        fontName: "LightNovelPOPv2")
        ),
    
    
    ]
    
    //　コレクションの個数を返却する
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    //　各セルについて描画を行う
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //　セルを登録する
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        //　テーマIDを取得する
        let currentThemeId = ud.selectedThemeColorId
        //　各セルのテキストについて描画を行う
        setUpCollectionViewCellText(cell: cell, index: indexPath.row)
        //　セルを角丸にする
        makeCellCornerRadius(cell: cell, currentThemeId: currentThemeId as! Int, index: indexPath.row)
        //　セルの背景を設定する
        setUpCellBackground(cell: cell, index: indexPath.row)
        return cell
    }
    
    //　各セルのテキストについて描画を行う
    func setUpCollectionViewCellText(cell: UICollectionViewCell, index: Int) {
        //　フォントカラーを取得する
        let fontColor = themeList[index].theme.fontColor
        //　UIListContentConfiguration.cell()を宣言する
        var config = UIListContentConfiguration.cell()
        //　セルのテキストを設定する
        config.text = self.themeList[index].theme.name
        //　テキストを中央揃えにする
        config.textProperties.alignment = .center
        //　テキストをフォントカラーに設定する
        config.textProperties.color = UIColor(hex: fontColor)
        //　現在のフォントサイズを取得する
        let currentFontSize = config.textProperties.font.pointSize
        //　フォントを設定する
        config.textProperties.font = UIFont(name: self.themeList[index].theme.fontName, size: currentFontSize) ?? UIFont(name: "LightNovelPOPv2", size: 20.0)!
        //　configurationを適応する
        cell.contentConfiguration = config
    }
    
    //　セルを角丸にする
    func makeCellCornerRadius(cell: UICollectionViewCell, currentThemeId: Int, index: Int) {
        //　セルの角丸を設定する
        cell.layer.cornerRadius = cell.frame.size.width * 0.05
        //　clipsToBoundsを有効にする
        cell.clipsToBounds = true
        //　セルのボーダーカラーを設定する
        cell.layer.borderColor = UIColor.systemBlue.cgColor
        //　セルのボーダー幅を設定する
        cell.layer.borderWidth = index == currentThemeId ? 8.0 : 0.0
    }
    
    //　セルの背景を設定する
    func setUpCellBackground(cell: UICollectionViewCell, index: Int) {
        //　画像のアイコンurlを取得する
        let url = themeList[index].theme.themeImageForIconUrl
        //　セルの背景が画像なら
        if url != "" {
            //　セルの背景画像を取得する
            let cellBackgroundImage: UIImage = UIImage(named: url)!
            //　セルの背景画像をImageViewに設定する
            let cellBackgroundImageView = UIImageView(image: cellBackgroundImage)
            //　描画モードを設定する
            cellBackgroundImageView.contentMode = .scaleAspectFill
            //　imageViewのフレームとセルのフレームを合わせる
            cellBackgroundImageView.frame = cell.frame
            //　セルの背景をImageViewにする
            cell.backgroundView = cellBackgroundImageView
        } else {
            //　セルの背景が単色なら
            //　背景色を取得する
            let backgroundColor = themeList[index].theme.mainColor
            //　背景色を設定する
            cell.backgroundColor = UIColor(hex: backgroundColor)
        }
    }
}
