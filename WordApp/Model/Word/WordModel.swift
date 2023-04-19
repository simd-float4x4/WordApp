import Foundation
import UIKit

// MARK: WordModel
class WordModel: Codable {
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
    
    //　現在の選択肢数
    var currentQuizChoicesCount: Int = 5
    
    //　現在のクイズ出題数
    var currentQuizMaximumCount: Int = 5
    
    private override init() {}
    static let shared = WordListModel()
    
    // Modelで管理する配列に初期値を設定する。
    var wordList: [WordModel] = []
    
    // データを更新
    func updateData(){
        let encodedData = try? JSONEncoder().encode(self.wordList)
        UserDefaults.standard.set(encodedData, forKey: "hoge")

    }
    
    // 保存したデータを取得
    func fetchSavedData() {
        let data = UserDefaults.standard.data(forKey: "hoge")
        if data != nil {
            let wordModelData = try? JSONDecoder().decode([WordModel].self, from: data!)
            wordList = wordModelData!
        }
    }
    
    // 配列に新しい単語を追加する。
    /// - Parameters:
        ///   - id: 単語ID：wordList.last?のid + 1した値を代入する。
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
        self.updateData()
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
        self.updateData()
    }
    
    // 削除モードがONの状態の際に単語データを削除する
    /// - Parameters:
        ///   - index: 単語ID（Int）
    func removeWord(index: Int) {
        // idはUniqueであるため下記実装で問題がないと思われるが、今後のテストの結果次第で実装し直すべきだと思われる
        self.wordList.removeAll(where: {$0.word.id == index})
        self.updateData()
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
        case 5:
            //　ランダム
            self.wordList.shuffle()
        case 6:
            // 誤答数多い順
            self.wordList.sort(by: {$0.word.wrongCount > $1.word.wrongCount})
        case 7:
            // 誤答数少ない順
            self.wordList.sort(by: {$0.word.wrongCount < $1.word.wrongCount})
        default:
            break
        }
    }
    
    // Userが参照した画面によってTableViewの表示モードを切り替える
    /// - Parameters:
        ///   - key: モード名。
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
    
    // 誤答数をリセット
    /// - Parameters:
        ///   - index: 単語ID（Int）
    func resetWordWrongCount(index: Int) {
        let selectedWord = self.wordList.first(where: {$0.word.id == index})
        selectedWord?.word.wrongCount = 0
        self.updateData()
    }
    
    // WordListWidgetを並び替える
    /// - Parameters:
        ///   - sortModeId: 並び替えモードのID。
    func returnFilteredWordList(isWordRememberedStatus: Bool) -> [WordModel] {
        let array = self.wordList.filter( {$0.word.isRemembered == isWordRememberedStatus})
        return array
    }
    
    //　クイズの上限数を返却
    func getAndReturnMaximumQuizCount() -> Int {
        let currentRememberedWordList = self.wordList.filter({$0.word.isRemembered == true})
        return currentRememberedWordList.count
    }
    
    //　クイズのうち、設定した先頭n件分のデータを返却
    func getMaximumQuizCount() -> Int {
        return currentQuizMaximumCount
    }
    
    //　クイズの上限数をセット
    func setMaximumQuiz(count: Int) {
        currentQuizMaximumCount = count
    }
    
    //　選択肢の上限数を返却
    func getAndReturnQuizChoices() -> Int {
        return currentQuizChoicesCount
    }
    
    //　選択肢の上限数をセット
    func setReturnQuizChoices(count: Int) {
        currentQuizChoicesCount = count
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
        if checkIsThisRememberedWordList {
            // 現在の誤答数を取得
            let currentWrongCount = wordModel.word.wrongCount
            // SystemImageのファイル名を生成
            let suffixFileName = currentWrongCount >= 6 ? ".circle.fill" : ".circle"
            let fileName = String(currentWrongCount) + suffixFileName
            // 色を指定
            let priorityRedColor = CGFloat(Float(currentWrongCount)/10)
            let color = UIColor(red: priorityRedColor, green: 0.25, blue: 0.25, alpha: 1.0)
            // 誤答数を表示
            content.image = UIImage(systemName: fileName)
            content.imageProperties.tintColor = color
        }
        content.text = wordModel.word.singleWord
        content.secondaryText = currentMeaningVisibility == true ? nil : wordModel.word.meaning
        cell.contentConfiguration = content
        return cell
    }
}
