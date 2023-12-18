//
//  UIViewController+Ext.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 9/18/23.
//

import UIKit

extension UIViewController {
    
    func presentCustomAlert(message: String) {
        let alertVC = AlertViewController(message: message)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        self.present(alertVC, animated: true)
    }
}
