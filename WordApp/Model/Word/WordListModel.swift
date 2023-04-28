import UIKit
import Foundation

// MARK: WordListModel
class WordListModel: NSObject, UITableViewDataSource {
    // UserDefaults
    let ud = UserDefaults.standard
    //　テーマモード
    var themeModel = DesignThemeListModel.shared
    //　現在のソートID
    var currentSortMode = 0
    // 単語帳画面／暗記単語一覧画面切り替えるための変数
    var checkIsThisRememberedWordList = true
    //　現在の選択肢数
    var currentQuizChoicesCount: Int = 5
    //　現在のクイズ出題数
    var currentQuizMaximumCount: Int = 5
    //　WordListModel配列
    private override init() {}
    static let shared = WordListModel()
    // Modelで管理する配列に初期値を設定する。
    var wordList: [WordModel] = []
    
    // データを更新
    func updateData(){
        //　wordListをJSONでエンコードする
        let encodedData = try? JSONEncoder().encode(self.wordList)
        //　UserDefaultsにエンコードしたデータを保存する
        ud.savedEncodedData = encodedData
        //　現在の暗記単語数を取得する
        currentQuizMaximumCount = getAndReturnMaximumQuizCount()
        //　暗記単語数をUserDefalutsに保存する
        ud.maximumRememberedWordsCount = currentQuizMaximumCount
    }
    
    // 保存したデータを取得
    func fetchSavedData() {
        //　JSONにエンコードしたデータをDeCodeする
        let data = ud.savedEncodedData
        //　DeCodeした値がなければ
        if data != nil {
            //　データをDeCodeする
            let wordModelData = try? JSONDecoder().decode([WordModel].self, from: data!)
            //　DeCodeした値をwordListに格納する
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
        //　データを更新する
        self.updateData()
    }
    
    // 暗記モードがONの状態でWordListWidgetを右にスワイプした際に単語データのステータスを更新する
    /// - Parameters:
        ///   - index: 単語ID（Int）
    func upDateRememberStatus(index: Int) {
        //　単語をIDで取得
        let selectedWord = self.wordList.first(where: {$0.word.id == index})
        //　現在の暗記情報を取得
        let currentRememberStatus = selectedWord?.word.isRemembered
        //　暗記リストから単語帳画面に復元するときは
        if currentRememberStatus == true {
            //　現在の暗記数を取得（この単語を差し引く）
            let currentQuizTotal = getAndReturnMaximumQuizCount() - 1
            //　設定画面の出題数Segmentを強制更新
            if ud.quizMaximumSelectedSegmentIndex * 5 > currentQuizTotal {
                ud.quizMaximumSelectedSegmentIndex = currentQuizTotal/5
            }
            print("🔔5: ", ud.quizMaximumSelectedSegmentIndex * 5, "/", currentQuizTotal)
            print("🔔6: ", ud.quizMaximumSelectedSegmentIndex)
        }
        //　暗記情報を更新
        selectedWord?.word.isRemembered = currentRememberStatus == true ? false : true
        //　データを更新する
        self.updateData()
        //　暗記した単語の値を取得する
        let quizCount = self.wordList.filter({$0.word.isRemembered == true}).count
        //　出題数を更新する
        self.setMaximumQuiz(count: quizCount)
    }
    
    // 削除モードがONの状態の際に単語データを削除する
    /// - Parameters:
        ///   - index: 単語ID（Int）
    func removeWord(index: Int) {
        // 単語を削除する
        self.wordList.removeAll(where: {$0.word.id == index})
        //　データを更新する
        self.updateData()
    }
    
    // WordListWidgetを並び替える
    /// - Parameters:
        ///   - sortModeId: 並び替えモードのID。
    func sortWordList(sortModeId: Int) {
        //　現在のソートモードを取得する
        currentSortMode = sortModeId
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
        //　keyによってcheckIsThisRememberedWordListを切り替える
        switch key {
            case "wordListIsShown":
                checkIsThisRememberedWordList = false
            case "wordRememberedListIsShown":
                checkIsThisRememberedWordList = true
            default:
                break
        }
    }
    
    // 誤答数をアップデート
    /// - Parameters:
        ///   - index: 単語ID（Int）
    func updateWordWrongCount(index: Int, newWrongCount: Int) {
        //　単語をidで取得する
        let selectedWord = self.wordList.first(where: {$0.word.id == index})
        //　誤答数を取得する
        selectedWord?.word.wrongCount = newWrongCount
        //　データを更新する
        self.updateData()
    }
    
    // 誤答数をリセット
    /// - Parameters:
        ///   - index: 単語ID（Int）
    func resetWordWrongCount(index: Int) {
        //　単語をidで取得する
        let selectedWord = self.wordList.first(where: {$0.word.id == index})
        //　誤答数を0にする
        selectedWord?.word.wrongCount = 0
        //　データを更新する
        self.updateData()
    }
    
    // WordListWidgetを並び替える
    /// - Parameters:
        ///   - sortModeId: 並び替えモードのID。
    func returnFilteredWordList(isWordRememberedStatus: Bool) -> [WordModel] {
        //　isWordRememberedStatusによってfilterされたデータを返す
        let array = self.wordList.filter( {$0.word.isRemembered == isWordRememberedStatus})
        return array
    }

    //　選択肢の数をセットする
    /// - Parameters:
        ///   - length: 回答数3~5
    func setQuizAnswerSelections(length: Int) {
        ud.currentQuizSelections = length
    }
    
    //　選択肢の数を取得する
    func getQuizAnswerSelections() -> Int {
        if ud.currentQuizSelections == 0 {
            ud.currentQuizSelections = 5
        }
        return ud.currentQuizSelections
    }
    
    //　クイズの上限数を返却
    func getAndReturnMaximumQuizCount() -> Int {
        let currentRememberedWordList = self.wordList.filter({$0.word.isRemembered == true})
        return currentRememberedWordList.count
    }
    
    //　クイズの上限数をセット
    func setMaximumQuiz(count: Int) {
        currentQuizMaximumCount = count
        ud.maximumRememberedWordsCount = currentQuizMaximumCount
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
        let selected = ud.selectedThemeColorId
        // 現在の意味表示モードのON/OFFを取得
        let currentMeaningVisibility  = ud.isMeaningHidden
        // WordListをfilterしておく
        let availableWordList = returnFilteredWordList(isWordRememberedStatus: checkIsThisRememberedWordList)
        // wordModelを取得する
        let wordModel = availableWordList[indexPath.row]
        // cellを登録
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        // cellの描画
        var content = cell.defaultContentConfiguration()
        //　cellのサブテキストに日本語訳を表示
        content.secondaryText = currentMeaningVisibility == true ? nil : wordModel.word.meaning
        //　これが暗記リストなのであれば
        if checkIsThisRememberedWordList {
            // 現在の誤答数を取得
            let currentWrongCount = wordModel.word.wrongCount
            // SystemImageのファイル名を生成
            let suffixFileName = ".circle"
            let fileName = String(currentWrongCount) + suffixFileName
            // 色を指定
            let priorityRedColor = CGFloat(Float(currentWrongCount)/10)
            let color = UIColor(red: priorityRedColor, green: 0.2, blue: 0.2, alpha: 1.0)
            // 画像の定義
            let iconImage = UIImage(systemName: fileName)?.withTintColor(UIColor.white)
            let backgroundImage = UIImage(color: color, size: .init(width: 10, height: 10))
            // UIImageを合成
            let mixedImage = backgroundImage?.composite(image: iconImage!)
            // 誤答数を表示
            content.image = mixedImage
            content.secondaryText = nil
        }
        //　textに単語を表示
        content.text = wordModel.word.singleWord
        //　テーマ名を取得する
        let themeName = getThemeName(themeId: selected)
        //　テーマ名一覧を取得する
        let themeNameList = ThemeName().list
        //　テーマ名を一覧から取得する
        let normal = themeNameList["normal"]
        //　フォントカラーを取得
        var fontColor = UIColor(hex: themeModel.themeList[selected].theme.fontColor)
        //　ノーマルだったらダークモード対応するために分岐
        if themeName == normal {
            //　フォントカラー（補色）を取得
            let complementalFontColor = UIColor(hex: themeModel.themeList[selected].theme.complementalFontColor)
            //　ノーマルテーマのみダークモード対応
            fontColor = setFontColorCaseNormal(mainModeColor: fontColor, darkModeColor: complementalFontColor)
            //　textにフォントカラーを設定
            content.textProperties.color = fontColor
            //　textにサブカラーを設定
            content.secondaryTextProperties.color = fontColor
        }
        //　textにフォントカラーを設定
        content.textProperties.color = fontColor
        //　textにサブカラーを設定
        content.secondaryTextProperties.color = fontColor
        //　セルのcontentConfigurationにcontentを設定
        cell.contentConfiguration = content
        //　セルの背景に透明色を設定
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    //　ABC順のソートでアルファベットを表示
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        //　ABC順で並べた時（昇順、降順）
        if currentSortMode == 3 || currentSortMode == 4 {
            //　空配列を宣言
            var titles = [String]()
            // WordListをfilterしておく
            let availableWordList = returnFilteredWordList(isWordRememberedStatus: checkIsThisRememberedWordList)
            //　単語の数だけ先頭１文字を取得する
            for section in 0 ..< availableWordList.count {
                let index = availableWordList[section].word.singleWord.prefix(1)
                //　空配列に１文字を格納する
                titles.append(String(index))
            }
            return titles
        }
        return []
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let section = Int(title) else {
            return 0
        }
        return section
    }
    
    //　テーマの名前を取得する
    func getThemeName(themeId: Int) -> String{
        // テーマの名称を取得する
        let themeName = themeModel.themeList[themeId].theme.name
        return themeName
    }
    
    //　ノーマルテーマのみダークモード対応
    func setFontColorCaseNormal(mainModeColor: UIColor, darkModeColor: UIColor) -> UIColor {
        let dynamicColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
           if traitCollection.userInterfaceStyle == .dark {
               return darkModeColor
           } else {
               return mainModeColor
           }
        }
        return dynamicColor
    }
}
