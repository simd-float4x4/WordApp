import Foundation
import UIKit

// MARK: WordModel
class WordModel {
    var word: Word

    init(initWord: Word){
        word = initWord
    }
}

// MARK: WordListModel
class WordListModel: NSObject, UITableViewDataSource {
    // UserDefaults
    let ud = UserDefaults.standard
    // 単語帳画面／暗記単語一覧画面切り替えるための変数
    var checkIsThisRememberedWordList = true
    
    private override init() {}
    static let shared = WordListModel()
    
    // Modelで管理する配列に初期値を設定する。
    private(set) var wordList: [WordModel] = [
        WordModel.init(
            initWord: Word(
                id: 1,
                singleWord: "accentuate",
                meaning: "強調する",
                exampleSentence: "This picture was taken in the evening to accentuate the shows of ancient remains.",
                exampleTranslation: "この写真は古代遺物の出現を強調するために夕方撮影された。",
                isRemembered: true,
                wrongCount: 0)),
        WordModel.init(
            initWord: Word(
                id: 2,
                singleWord: "culminate",
                meaning: "締め括る／最高潮に達する",
                exampleSentence: "The ceremony was culminated with the national anthem.",
                exampleTranslation: "その式典は国歌斉唱で締めくくられた。",
                isRemembered: true,
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
                isRemembered: true,
                wrongCount: 0)),
        WordModel.init(
            initWord: Word(
                id: 5,
                singleWord: "sloppy",
                meaning: "杜撰な",
                exampleSentence: "He was accused of the responsibility of sloppy accounting.",
                exampleTranslation: "彼は杜撰な会計処理の責任を責め立てられた",
                isRemembered: true,
                wrongCount: 0)),
        WordModel.init(
            initWord: Word(
                id: 6,
                singleWord: "transcribe",
                meaning: "複写する",
                exampleSentence: "She can transcribe melodic patterns from sound even if melody is adlib",
                exampleTranslation: "たとえアドリブであっても、彼女は聴いた旋律パターンを楽譜に起こすことができる",
                isRemembered: true,
                wrongCount: 0)),
    ] {
        didSet{
            // Modelで管理している配列に変化があった場合に呼び出されて、通知する。
            NotificationCenter.default.post(
                name: .notifyName,
                object: nil,
                userInfo: ["list" : wordList])
        }
    }
    
    // 配列に新しい単語を追加する。
    /// - Parameters:
        ///   - id: 単語ID：wordList要素数を代入し、+1した値をIDとする。
        ///   - data: data[0]〜data[3]の要素数4のString型の配列。内訳は順番に単語、意味、例文、訳。
    func addWordToList(id: Int, data: [String]) {
        self.wordList.append(
            WordModel.init(initWord:
                Word(
                    id: id+1,
                    singleWord: data[0],
                    meaning: data[1],
                    exampleSentence: data[2],
                    exampleTranslation: data[3],
                    isRemembered: false,
                    wrongCount: 0))
        )
    }
    
    // 暗記モードがONの状態でWordListWidgetを右にスワイプした際に単語データのステータスを更新する
    /// - Parameters:
        ///   - index: 単語ID（Int）
    func upDateRememberStatus(index: Int) {
        let selectedWord = self.wordList.first(where: {$0.word.id == index})
        let currentRememberStatus = selectedWord?.word.isRemembered
        if currentRememberStatus == true {
            selectedWord?.word.isRemembered = false
        } else if currentRememberStatus == false {
            selectedWord?.word.isRemembered = true
        } else {
            print("error: cannot get curretRememberStatus")
        }
    }
    
    // 削除モードがONの状態の際に単語データを削除する
    /// - Parameters:
        ///   - index: 単語ID（Int）
    func removeWord(index: Int) {
        // idはUniqueであるため下記実装で問題がないと思われるが、今後のテストの結果次第で実装し直すべきだと思われる
        self.wordList.removeAll(where: {$0.word.id == index})
    }
    
    // WordListWidgetを並び替える
    /// - Parameters:
        ///   - sortModeId: 並び替えモードのID。
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
    
    //
    func changeUserReferredWordListStatus(key: String) {
        switch key {
            case "wordListIsShown":
                checkIsThisRememberedWordList = false
            case "wordRememberedListIsShown":
                checkIsThisRememberedWordList = true
            default:
                break
        }
    }
    
    // WordListWidgetを並び替える
    /// - Parameters:
        ///   - sortModeId: 並び替えモードのID。
    func returnFilteredWordList(isWordRememberedStatus: Bool) -> [WordModel] {
        let array = self.wordList.filter( {$0.word.isRemembered == isWordRememberedStatus})
        return array
    }
    
// MARK: UITableViewDatasoruce
    // UITableViewが返す要素数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // WordListをfilterしておく
        let availableWordList = returnFilteredWordList(isWordRememberedStatus: checkIsThisRememberedWordList)
        return availableWordList.count
    }
    
    // UITableViewの各セルが表示する内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 現在の意味表示モードのON/OFFを取得
        let currentMeaningVisibility  = ud.bool(forKey: "isMeaningHidden")
        // WordListをfilterしておく
        let availableWordList = returnFilteredWordList(isWordRememberedStatus: checkIsThisRememberedWordList)
        // wordModelを取得する
        let wordModel = availableWordList[indexPath.row]
        // cellを登録
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        // cellの描画
        var content = cell.defaultContentConfiguration()
        content.text = String(wordModel.word.id) + "：" + wordModel.word.singleWord + "（" + String(indexPath.row) + "）"
        content.secondaryText = currentMeaningVisibility == true ? nil : wordModel.word.meaning
        cell.contentConfiguration = content
        return cell
    }
}
