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
}
