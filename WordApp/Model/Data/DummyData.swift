import Foundation

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
    
    func make() -> [String] {
        let upperIndex = singleArray.count - 1
        let index = Int.random(in: 0 ..< upperIndex)
        var dummyData: [String] = []
        dummyData.append(singleArray[index])
        dummyData.append(meaningArray[index])
        dummyData.append(exampleArray[index])
        dummyData.append(transArray[index])
        return dummyData
    }
    
}
