//
//  MonthCell.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/6/23.
//

import SwiftUI

class MonthCell: UICollectionViewCell {
    static let reuseID = "MonthCell"
    
    let monthLabel = DRTitleLabel(textAlignment: .center, fontSize: 24, weight: .bold)
    let amountLabel = DRTitleLabel(textAlignment: .center, fontSize: 18, weight: .regular)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func set(expenses: [Expense], monthNumber: Int) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        
        amountLabel.text = formatter.string(from: NSNumber(value: ExpensesHelper.calculateTotalSpent(expenses)))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        
        let date = dateFormatter.date(from: "\(monthNumber)")!
        let monthName = date.formatted(Date.FormatStyle().month(.wide))
        
        monthLabel.text = monthName
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
        
        let stackView = UIStackView(arrangedSubviews: [monthLabel, amountLabel])
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
