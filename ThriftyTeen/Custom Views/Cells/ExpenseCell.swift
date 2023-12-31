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
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [.curveEaseOut, .autoreverse], animations: {
                    self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }) { _ in
                    self.transform = .identity
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func set(expense: Expense) {
        titleLabel.text = expense.title
        categoryLabel.text = expense.category.name.capitalized
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        
        amountLabel.text = formatter.string(from: NSDecimalNumber(decimal: expense.amount))!
    }
    
    private func configure() {
        backgroundColor = .smokyCharcoal.withAlphaComponent(0.2)
        
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
