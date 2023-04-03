import Foundation
import UIKit
 
class WordModel {
    var word: Word

    init(initWord: Word){
        word = initWord
    }
}

class WordListModel: NSObject, UITableViewDataSource {
    
    // Modelを監視するクラス
    let notificationCenter = NotificationCenter()
    
    // Modelで管理する配列に初期値を設定する。
    private(set) var wordList: [WordModel] = [
        WordModel.init(
            initWord: Word(
                id: 1,
                singleWord: "accentuate",
                meaning: "強調する",
                exampleSentence: "This picture was taken in the evening to accentuate the shows of ancient remains.",
                exampleTranslation: "この写真は古代遺物の出現を強調するために夕方撮影された。",
                isRemembered: false,
                wrongCount: 0)),
        WordModel.init(
            initWord: Word(
                id: 2,
                singleWord: "culminate",
                meaning: "締め括る／最高潮に達する",
                exampleSentence: "The ceremony was culminated with the national anthem.",
                exampleTranslation: "その式典は国歌斉唱で締めくくられた。",
                isRemembered: false,
                wrongCount: 0)),
        WordModel.init(
            initWord: Word(
                id: 3,
                singleWord: "protectionism",
                meaning: "保護主義",
                exampleSentence: "The country denounced Japan's protectionism to conceal its own lack of economic policy.",
                exampleTranslation: "その国は自らの経済的な無策を隠すために日本の保護貿易主義を非難しました。",
                isRemembered: false,
                wrongCount: 0)),
        WordModel.init(
            initWord: Word(
                id: 4,
                singleWord: "trespass",
                meaning: "侵害する",
                exampleSentence: "He trespassed on neighbor's land without any allowance.",
                exampleTranslation: "彼は無断で隣人の土地に侵入した。",
                isRemembered: false,
                wrongCount: 0)),
        WordModel.init(
            initWord: Word(
                id: 5,
                singleWord: "sloppy",
                meaning: "杜撰な",
                exampleSentence: "He was accused of the responsibility of sloppy accounting.",
                exampleTranslation: "彼は杜撰な会計処理の責任を責め立てられた",
                isRemembered: false,
                wrongCount: 0)),
        WordModel.init(
            initWord: Word(
                id: 6,
                singleWord: "transcribe",
                meaning: "複写する",
                exampleSentence: "She can transcribe melodic patterns from sound even if melody is adlib",
                exampleTranslation: "たとえアドリブであっても、彼女は聴いた旋律パターンを楽譜に起こすことができる",
                isRemembered: false,
                wrongCount: 0)),
    ] {
        didSet{
            // Modelで管理している配列に変化があった場合に呼び出されて、通知する。
            notificationCenter.post(name: .init(rawValue: "changeTweetList"), object: nil, userInfo: ["list" : wordList])
        }
    }
    
    // 配列に新しいツイートを追加する。
    func addWordToList() {
        self.wordList.append(
            WordModel.init(initWord:
                Word(
                    id: 7,
                    singleWord: "bibliography",
                    meaning: "書誌",
                    exampleSentence: "His first book was too short to have a bibliography. ",
                    exampleTranslation: "彼の最初の本はごく短いもので参考文献一覧はなかった。",
                    isRemembered: false,
                    wrongCount: 5))
        )
    }
    
    func upDateRememberStatus(index: Int) {
        self.wordList[index].word.isRemembered = true
    }
    
    func removeWord(index: Int) {
        self.wordList.remove(at: index)
    }
    
    func sortWordList(sortModeId: Int) {
        switch sortModeId {
        case 1:
            // ID順（昇順）
            self.wordList.sort(by: {$0.word.id < $1.word.id})
        case 2:
            // ID順（降順）
            self.wordList.sort(by: {$0.word.id > $1.word.id})
        case 3:
            //　昇順
            self.wordList.sort(by: {$0.word.singleWord < $1.word.singleWord})
        case 4:
            //　降順
            self.wordList.sort(by: {$0.word.singleWord > $1.word.singleWord})
        default:
            break
        }
    }
    
    // MARK: UITableViewDatasoruce
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ud = UserDefaults.standard
        let currentMeaningVisibility  = ud.bool(forKey: "isMeaningHidden")
        let wordModel = self.wordList[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        var content = cell.defaultContentConfiguration()
        content.text = wordModel.word.singleWord
        content.secondaryText = currentMeaningVisibility == true ? nil : wordModel.word.meaning
        cell.contentConfiguration = content
        return cell
        
    }
}
