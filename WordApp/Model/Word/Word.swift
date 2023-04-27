import Foundation

//MARK: Word
struct Word: Codable {
    var id: Int //id
    var singleWord: String //単語
    var meaning: String //意味
    var exampleSentence: String //例文
    var exampleTranslation: String //日本語訳
    var isRemembered: Bool //暗記したか？
    var wrongCount: Int //間違った回数
}
