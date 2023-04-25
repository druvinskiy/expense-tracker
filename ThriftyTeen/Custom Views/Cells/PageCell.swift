//
//  PageCell.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/5/23.
//

import UIKit

class PageCell: UICollectionViewCell {
    static let reuseID = "PageCell"
    
    var innerVC = UIViewController()
    
    func set(innerVC: UIViewController) {
        self.innerVC = innerVC
        addSubview(innerVC.view)
        innerVC.view.frame = bounds
    }
}
