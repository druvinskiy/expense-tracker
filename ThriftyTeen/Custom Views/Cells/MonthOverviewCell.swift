//
//  MonthOverviewCell.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 4/13/23.
//

import UIKit

class MonthOverviewCell: UICollectionViewCell {
    static let reuseID = "MonthOverviewCell"
    
    let monthLabel = DRTitleLabel(textAlignment: .center, fontSize: 18, weight: .regular)
    let amountLabel = DRTitleLabel(textAlignment: .center, fontSize: 18, weight: .bold)
    let imageView = UIImageView()
    
    private let shadowColor = UIColor.label.cgColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func set(viewModel: OverviewCellViewModel) {
        monthLabel.text = viewModel.title
        amountLabel.text = viewModel.subtitle
        
        guard let iconName = viewModel.iconName else {
            imageView.isHidden = true
            return
        }
        
        imageView.image = UIImage(named: iconName)
    }
    
    private func configure() {
        backgroundColor = .azureBlue
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = 10
        layer.masksToBounds = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(monthLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            monthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            monthLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            amountLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            amountLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 5),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
