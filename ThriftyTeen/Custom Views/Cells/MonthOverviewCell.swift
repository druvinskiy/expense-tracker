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
        
        imageView.isHidden = !viewModel.hasIcon
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowRadius = 8.0
        layer.shadowColor = shadowColor
        layer.shadowOpacity = 0.10
        layer.shadowOffset = CGSize(width: 0, height: 5)
        
        imageView.image = UIImage(named: "Shopping")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        let stackView1 = UIStackView(arrangedSubviews: [amountLabel, imageView])
        stackView1.axis = .vertical
        stackView1.alignment = .center
//        stackView1.distribution = .equalSpacing
        stackView1.spacing = 3
        stackView1.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(monthLabel)
        addSubview(stackView1)
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            monthLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
//            monthLabel.widthAnchor.constraint(equalToConstant: 150),
            
            stackView1.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 30),
            stackView1.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13, *), self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.shadowColor = shadowColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
