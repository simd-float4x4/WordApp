import Foundation

struct DesignTheme: Codable {
    var id: Int
    var name: String
    var useImage: Bool
    var themeImageForIconUrl: String
    var backgroundImageUrl: String
    // TODO: 適切な型に代入する
    var mainColor: String
    var subColor: String
    var accentColor: String
    
    //TODO: fontcolor, font
    var fontColor: String
    var fontName: String
}
