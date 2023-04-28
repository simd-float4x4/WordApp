import UIKit
import Foundation

// MARK: UIsegmentedControl
class CustomUISegmentedControl: UISegmentedControl {
    // アクセントカラー
    var accentColor: String = "0000FF"
    //　背景色
    var customBackgroundColor = ""
    // 選択肢の数を取得（初期値: 5）
    var getQuizSelectionCount = 5
    // 現在登録されている単語の総数を取得
    var getAllQuiz = 0
    // 現在暗記した単語の数を取得（初期値: 0）
    var getMaximumRememberedWordsCount = 0
    // テーマモデルID
    var selectedThemeId: Int = 0
    // テーマモデル
    var themeModel = DesignThemeListModel.shared
    //　選択肢数変更Control
    var chooseSelectionCountSegmentedControlTagNumber = 1
    //　現在暗記した単語の総数変更Control
    var chooseRememberedWordSegmentedControlTagNumber = 2
    //　SegmentControlの刻み値（現在：５）
    var quizStepValue = 5
    // ワードモデル
    var wordModel = WordListModel.shared
    // UserDefaults
    let ud = UserDefaults.standard
    // 画像を使用するか？
    var useImage: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadProperties()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadProperties()
    }
    
    //　呼ばれたときにロードするメソッド
    func loadProperties() {
        setColors()
        getAndSearchWordsCount()
        setSegmentedIndex()
        // updateQuizCount()
    }
    
    // カラーをセットする
    func setColors() {
        fetchSavedThemeData()
        setAccentColor()
        setSegmentColor()
        setFontColor()
    }
    
    // 保存されたカラーテーマ情報を取得
    func fetchSavedThemeData() {
        // UdからテーマIdを取得
        selectedThemeId = ud.selectedThemeColorId
    }
    
    //　アクセントカラーをセットする
    func setAccentColor() {
        accentColor = themeModel.themeList[selectedThemeId].theme.accentColor
    }
    
    // 現在の単語の登録状況を調べて取得する
    func getAndSearchWordsCount() {
        getAllQuiz = wordModel.getAndReturnMaximumQuizCount()
        getQuizSelectionCount = ud.maximumQuizSelectionCount
        getMaximumRememberedWordsCount = ud.maximumRememberedWordsCount
    }
    
    // SegmentedControlのつまみの色を設定
    func setSegmentColor() {
        // iOS13以降/以前で色の指定方法が異なることに留意
        if #available(iOS 13.0, *) {
            self.selectedSegmentTintColor = UIColor(hex: accentColor)
        }
        else {
            self.tintColor = UIColor(hex: accentColor)
        }
    }
    
    // フォントカラーを設定する
    func setFontColor() {
        changeFontColorByTheme()
        changeFontColorByWordsCount()
    }
    
    // テーマで色を変更する
    func changeFontColorByTheme() {
        //　テーマ名を取得する
        let themeName = getThemeName()
        //　テーマ名一覧を取得する
        let themeNameList = ThemeName().list
        //　テーマ名を一覧から取得する
        guard let space = themeNameList["space"] else { return }
        guard let orange = themeNameList["orange"] else { return }
        guard let chocolate = themeNameList["chocolate"] else { return }
        //　該当するテーマでなければ
        if themeName != space && themeName != orange && themeName != chocolate {
            //　色を変更
            customBackgroundColor = themeModel.themeList[selectedThemeId].theme.complementalFontColor
        } else {
            //　通常のフォントカラーのまま
            customBackgroundColor = themeModel.themeList[selectedThemeId].theme.fontColor
        }
    }
    
    //　単語の登録数でフォントカラーを変更する
    func changeFontColorByWordsCount() {
        self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor(hex: customBackgroundColor)], for: .selected)
        self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor(hex: "000000")], for: .normal)
        self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor(hex: "CCCCCC")], for: .disabled)
    }
    
    //　segmentedIndexを登録する
    func setSegmentedIndex() {
        // 選択肢数
        if self.tag == chooseSelectionCountSegmentedControlTagNumber {
            // 現在保存されている選択肢にセット
            self.selectedSegmentIndex = getQuizSelectionCount
        // 問題上限数
        } else if self.tag == chooseRememberedWordSegmentedControlTagNumber {
            // 暗記した単語 / 刻みの値にセット
            self.selectedSegmentIndex = getMaximumRememberedWordsCount / quizStepValue
        }
    }

    //　テーマの名前を取得する
    func getThemeName() -> String{
        // テーマの名称を取得する
        let themeName = DesignThemeListModel.shared.themeList[selectedThemeId].theme.name
        return themeName
    }
}
