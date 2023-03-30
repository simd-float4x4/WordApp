import Foundation
import UIKit


class WordModel {
    let word: Word
    
    init(initWord: Word){
        word = initWord
    }
}

class WordListModel: NSObject, UITableViewDataSource {
    private(set) var wordDataArray: [WordModel] = [
        WordModel.init(initWord:
            Word(
                id: 1,
                singleWord: "affiliate",
                meaning: "〜を連携させる",
                exampleSentence: "In the States, doctors have their own offices and most are affiliated with a hospital within the area.",
                exampleTranslation: "アメリカの医者は自分の診療所を持っていても、大抵は地域のどこかの病院に所属しています。",
                isRemembered: false,
                wrongCount: 0)),
        WordModel.init(initWord:
            Word(
                id: 2,
                singleWord: "fabricate",
                meaning: "〜をでっち上げる",
                exampleSentence: "She fabricated the attack. ",
                exampleTranslation: "彼女はその暴行事件をでっち上げた。",
                isRemembered: true,
                wrongCount: 0)),
        WordModel.init(initWord:
            Word(
                id: 3,
                singleWord: "bibliography",
                meaning: "書誌",
                exampleSentence: "His first book was too short to have a bibliography. ",
                exampleTranslation: "彼の最初の本はごく短いもので参考文献一覧はなかった。",
                isRemembered: false,
                wrongCount: 5))
    ]
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wordDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let model = self.wordDataArray[indexPath.row]
        cell.textLabel?.text = model.word.singleWord
        return cell
    }
}
