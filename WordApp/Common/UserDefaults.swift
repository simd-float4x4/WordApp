import Foundation

// MARK: UserDefaults
// UserDefaultsの拡張クラス
extension UserDefaults {
    // UserDefaultsのKeyをまとめたenum
    private enum UDKey: String {
        case selectedThemeColorId
        case maximumQuizSelectionCount
        case maximumRememberedWordsCount
        case isMeaningHidden
        case quizMaximumSelectedSegmentIndex
        case choicesSelectedSegmentIndex
        case currentQuizSelections
        case savedEncodedData
    }
    
    // データの全件削除処理
    func removeAllObject() {
        // removeObject(forKey: UDKey.selectedThemeColorId.rawValue)
    }
    
    // 「selectedThemeColorId」のセッターゲッターの処理（テーマID）
    //　現在選択されているテーマID
    var selectedThemeColorId: Int {
        get {
            return integer(forKey: UDKey.selectedThemeColorId.rawValue)
        }
        set(val) {
            set(val, forKey: UDKey.selectedThemeColorId.rawValue)
        }
    }
    
    // 「maximumQuizSelectionCount」のセッターゲッターの処理（テーマID）
    //　現在選択されている選択肢の数
    var maximumQuizSelectionCount: Int {
        get {
            return integer(forKey: UDKey.selectedThemeColorId.rawValue)
        }
        set(val) {
            set(val, forKey: UDKey.selectedThemeColorId.rawValue)
        }
    }
    
    // 「maximumRememberedWordsCount」のセッターゲッターの処理（テーマID）
    //　現在選択されているクイズ機能の出題問題数
    var maximumRememberedWordsCount: Int {
        get {
            return integer(forKey: UDKey.selectedThemeColorId.rawValue)
        }
        set(val) {
            set(val, forKey: UDKey.selectedThemeColorId.rawValue)
        }
    }
    
    // 「isMeaningHidden」のセッターゲッターの処理
    //　WordListWidgetで現在日本語が表示されているか判定する変数
    var isMeaningHidden: Bool {
        get {
            return bool(forKey: UDKey.isMeaningHidden.rawValue)
        }
        set(val) {
            set(val, forKey: UDKey.isMeaningHidden.rawValue)
        }
    }
    
    // 「quizMaximumSelectedSegmentIndex」のセッターゲッターの処理
    //　設定画面でクイズの出題数を保存するための変数
    var quizMaximumSelectedSegmentIndex: Int {
        get {
            return integer(forKey: UDKey.quizMaximumSelectedSegmentIndex.rawValue)
        }
        set(val) {
            set(val, forKey: UDKey.quizMaximumSelectedSegmentIndex.rawValue)
        }
    }
    
    // 「choicesSelectedSegmentIndex」のセッターゲッターの処理
    //　設定画面でクイズの選択肢数を保存するための変数
    var choicesSelectedSegmentIndex: Int {
        get {
            return integer(forKey: UDKey.choicesSelectedSegmentIndex.rawValue)
        }
        set(val) {
            set(val, forKey: UDKey.choicesSelectedSegmentIndex.rawValue)
        }
    }
    
    // 「currentQuizSelections」のセッターゲッターの処理
    //　設定画面で回答選択肢の数を保存するための変数
    var currentQuizSelections: Int {
        get {
            return integer(forKey: UDKey.currentQuizSelections.rawValue)
        }
        set(val) {
            set(val, forKey: UDKey.currentQuizSelections.rawValue)
        }
    }
    
    // 「savedEncodedData」のセッターゲッターの処理
    //　設定画面で回答選択肢の数を保存するための変数
    var savedEncodedData: Data? {
        get {
            return data(forKey: UDKey.savedEncodedData.rawValue)
        }
        set(val) {
            set(val, forKey: UDKey.savedEncodedData.rawValue)
        }
    }
}
