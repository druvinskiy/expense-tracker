//
//  DRTitleLabel.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/5/23.
//

import UIKit

class DRTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat, weight: UIFont.Weight) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
    }
    
    private func configure() {
        textColor = .black
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
}
