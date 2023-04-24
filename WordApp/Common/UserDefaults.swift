import Foundation

// UserDefaultsの拡張クラス
extension UserDefaults {
    
    // UserDefaultsのKeyをまとめたenum
    private enum UDKey: String {
        case selectedThemeColorId
        case maximumQuizSelectionCount
        case maximumRememberedWordsCount
    }
    
    // データの全件削除処理
    func removeAllObject() {
        // removeObject(forKey: UDKey.selectedThemeColorId.rawValue)
    }
    
    // 「selectedThemeColorId」のセッターゲッターの処理（テーマID）
    var selectedThemeColorId: Int {
        get {
            return integer(forKey: UDKey.selectedThemeColorId.rawValue)
        }
        set(val) {
            set(val, forKey: UDKey.selectedThemeColorId.rawValue)
        }
    }
    
    // 「maximumQuizSelectionCount」のセッターゲッターの処理（テーマID）
    var maximumQuizSelectionCount: Int {
        get {
            return integer(forKey: UDKey.selectedThemeColorId.rawValue)
        }
        set(val) {
            set(val, forKey: UDKey.selectedThemeColorId.rawValue)
        }
    }
    
    // 「maximumRememberedWordsCount」のセッターゲッターの処理（テーマID）
    var maximumRememberedWordsCount: Int {
        get {
            return integer(forKey: UDKey.selectedThemeColorId.rawValue)
        }
        set(val) {
            set(val, forKey: UDKey.selectedThemeColorId.rawValue)
        }
    }
}
