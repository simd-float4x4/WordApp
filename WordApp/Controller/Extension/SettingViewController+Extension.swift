import UIKit
import Foundation

// MARK: SettingViewControllerのCollecctionViewDelegate
extension SettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let view = self.view as! SettingView
        let width: CGFloat = view.collectionThemeCollectionView.frame.width / 2  - 16
        let height = width / 3.2
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ud = UserDefaults.standard
        ud.set(indexPath.row, forKey: "selectedThemeColorId")
        collectionView.reloadData()
        viewDidLoad()
    }
}

// MARK: WordListViewControllerのNavigationBarDelegate
extension SettingViewController: UINavigationBarDelegate {
    //　ステータスバーとナビゲーションバーの隙間を自動的に埋める
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
