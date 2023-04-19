import Foundation

struct Word: Codable {
    var id: Int
    var singleWord: String
    var meaning: String
    var exampleSentence: String
    var exampleTranslation: String
    var isRemembered: Bool
    var wrongCount: Int
}
