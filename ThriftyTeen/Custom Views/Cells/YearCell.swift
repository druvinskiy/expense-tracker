//
//  YearCell.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/8/23.
//

import SwiftUI

class YearCell: UICollectionViewCell {
    static let reuseID = "YearCell"
    
    let yearLabel = DRTitleLabel(textAlignment: .center, fontSize: 24, weight: .bold)
    let amountLabel = DRTitleLabel(textAlignment: .center, fontSize: 18, weight: .regular)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func set(expenses: [Expense], yearNumber: Int) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        
        amountLabel.text = formatter.string(from: NSNumber(value: ExpensesHelper.calculateTotalSpent(expenses)))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        let date = dateFormatter.date(from: "\(yearNumber)")!
        let yearText = date.formatted(Date.FormatStyle().year(.defaultDigits))
        
        yearLabel.text = yearText
    }
    
    private func configure() {
        backgroundColor = .systemBackground
        
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowRadius = 8.0
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOpacity = 0.10
        layer.shadowOffset = CGSize(width: 0, height: 5)
        
        let stackView = UIStackView(arrangedSubviews: [yearLabel, amountLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 5
        stackView.axis = .vertical
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13, *), self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.shadowColor = UIColor.label.cgColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
