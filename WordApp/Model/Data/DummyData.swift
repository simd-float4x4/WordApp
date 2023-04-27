import Foundation

// MARK: DummyData
class DummyData {
    let singleArray = [
        "envisage",
        "culminate",
        "accentuate",
        "sloppy",
        "transcribe",
        "protectionism",
        "trespass",
        "affiliate"
    ]
    let meaningArray = [
        "〜を想像する",
        "〜を締めくくる",
        "〜を強調する",
        "杜撰な",
        "複写する",
        "保護主義",
        "〜を侵害する",
        "〜を連携させる"
    ]
    let exampleArray = [
        "Did you ever envisage that your book might be translated into different languages?",
        "The ceremony was culminated with the national anthem.",
        "This picture was taken in the evening to accentuate the shows of ancient remains.",
        "He was accused of the responsibility of sloppy accounting.",
        "She can transcribe melodic patterns from sound even if melody is adlib",
        "The country denounced Japan's protectionism to conceal its own lack of economic policy.",
        "He trespassed on neighbor's land without any allowance.",
        "The high school is affiliated with the college."
    ]
    let transArray = [
        "自分の本がいろいろな国の言葉に翻訳されると予想されましたか？",
        "その式典は国歌斉唱で締めくくられた。",
        "この写真は古代遺物の出現を強調するために夕方撮影された。",
        "彼は杜撰な会計処理の責任を責め立てられた",
        "たとえアドリブであっても、彼女は聴いた旋律パターンを楽譜に起こすことができる",
        "その国は自らの経済的な無策を隠すために日本の保護貿易主義を非難しました。",
        "彼は無断で隣人の土地に侵入した。",
        "その高校は大学と連携している。"
    ]
    // プリセット値：ダミー用回答（正解が2個以上ある際に使用する）
    var presetDummyAnswersArray = [
        "〜を明らかにする", "〜を横断する", "〜を乗り越える", "減少する", "分配する", "証明する", "を起訴する", "を回避する", "を蒸発させる",
        "〜に追従する", "〜を目撃する", "〜が落ちる", "干渉する", "救出する", "痛める", "を再生させる", "を飲む", "を破壊する",
        "形式上の", "個別の", "交互の", "神経症の〜", "時代遅れの〜", "揮発性の〜", "親切な", "綺麗に保たれている", "一過性の〜",
        "卓越", "支配権", "酵素", "信条", "領事", "吸収", "友愛", "花婿", "誘導", "完成", "詰め物", "襲撃", "事件", "建築物", "栽培", "（グラスなどの）容器"
    ]
    
    //　ダミーデータを生成する
    func make() -> [String] {
        //　上限値を取得
        let upperIndex = singleArray.count
        //　0〜上限値の範囲でindexを生成
        let index = Int.random(in: 0 ..< upperIndex)
        //　空のダミーデータを宣言
        var dummyData: [String] = []
        //　ダミーデータを登録
        dummyData.append(singleArray[index])
        dummyData.append(meaningArray[index])
        dummyData.append(exampleArray[index])
        dummyData.append(transArray[index])
        return dummyData
    }
    
    //　プリセット配列から1つ値を返す
    func returnOneMeaning() -> String {
        //　ダミーデータの中からランダムに1つindexを生成する
        let randomInt = Int.random(in: 0 ..< presetDummyAnswersArray.count)
        //　値を返す
        return presetDummyAnswersArray[randomInt]
    }
}
