import Foundation

// MARK: Notification
extension Notification.Name {
    // WordModelの配列に変更があった場合のNotificationName
    static let notifyName = Notification.Name("changeWordList")
}
