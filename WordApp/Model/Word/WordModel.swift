import Foundation
import UIKit

// MARK: WordModel
class WordModel: Codable {
    var word: Word

    init(initWord: Word){
        word = initWord
    }
}
