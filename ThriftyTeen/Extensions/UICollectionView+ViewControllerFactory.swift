//
//  UICollectionView+Ext.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/6/23.
//

import UIKit

extension UICollectionView {
    static func createOneColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 8
        let availableWidth = width - (padding * 2)
        let itemWidth = availableWidth
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: 75)
        flowLayout.minimumLineSpacing = 16
        
        return flowLayout
    }
    
    static func createTwoColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 2
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        print("Foo: \(flowLayout.itemSize.height)")
        
        return flowLayout
    }
}
