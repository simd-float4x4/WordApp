import Foundation

struct DesignTheme: Codable {
    var id: Int //id
    var name: String //デザインテーマ名
    var useImage: Bool //画像を使用するか？
    var themeImageForIconUrl: String //アイコン画像URL
    var backgroundImageUrl: String //背景画像URL
    var mainColor: String //メインカラー
    var subColor: String //サブカラー
    var accentColor: String //アクセントカラー
    var vividColor: String //ビビッドカラー
    var complementalColor: String //補色
    var fontColor: String //フォントカラー
    var complementalFontColor: String //フォントカラーの補色
    var fontName: String //フォント名
}
