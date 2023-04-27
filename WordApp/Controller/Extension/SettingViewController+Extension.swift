import UIKit
import Foundation

// MARK: SettingViewControllerのCollecctionViewDelegate
extension SettingViewController: UICollectionViewDelegateFlowLayout {
    //　セルのレイアウトを決定する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //　設定画面を取得
        let view = self.view as! SettingView
        //　セルの幅を設定（collectionViewの幅から余白分を差し引いた値）
        let width: CGFloat = view.collectionThemeCollectionView.frame.width / 2  - 16
        //　セルの高さを設定（幅に対して黄金比になるように）
        let height = width / 3.2
        return CGSize(width: width, height: height)
    }
    
    //　セルが選択された時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //　テーマカラーを設定し、UserDefaultsに保存
        ud.selectedThemeColorId = indexPath.row
        //　CollectionViewを更新
        collectionView.reloadData()
        //　画面全体を更新
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
