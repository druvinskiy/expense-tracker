//
//  ExpenseCell.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/5/23.
//

import UIKit

class ExpenseCell: UICollectionViewCell {
    static let reuseID = "ExpenseCell"
    
    let titleLabel = DRTitleLabel(textAlignment: .left, fontSize: 18, weight: .bold, textColor: .label)
    let categoryLabel = DRTitleLabel(textAlignment: .left, fontSize: 14, weight: .regular, textColor: .label)
    let amountLabel = DRTitleLabel(textAlignment: .left, fontSize: 14, weight: .regular, textColor: .label)
    
    private let shadowColor = UIColor.label.cgColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func set(expense: Expense) {
        titleLabel.text = expense.title
        categoryLabel.text = expense.category.name!.capitalized
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        
        amountLabel.text = formatter.string(from: NSDecimalNumber(decimal: expense.amount))!
    }
    
    private func configure() {
        backgroundColor = .smokyCharcoal.withAlphaComponent(0.2)
//        #colorLiteral(red: 0.7034259439, green: 0.6529470086, blue: 0.9137045741, alpha: 1)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowRadius = 8.0
        layer.shadowColor = shadowColor
        layer.shadowOpacity = 0.10
        layer.shadowOffset = CGSize(width: 0, height: 5)
        
        let titleCategoryStackView = UIStackView(arrangedSubviews: [titleLabel, categoryLabel])
        titleCategoryStackView.spacing = 4
        titleCategoryStackView.axis = .vertical
        titleCategoryStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleCategoryStackView)
        addSubview(amountLabel)
        
        NSLayoutConstraint.activate([
            titleCategoryStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleCategoryStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
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
