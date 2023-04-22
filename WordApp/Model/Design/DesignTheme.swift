import Foundation

struct DesignTheme: Codable {
    var id: Int
    var name: String
    var useImage: Bool
    var themeImageForIconUrl: String
    var backgroundImageUrl: String
    var mainColor: String
    var subColor: String
    var accentColor: String
    var vividColor: String
    var complementalColor: String // 補色
    var fontColor: String
    var complementalFontColor: String // フォントの補色
    var fontName: String
}
