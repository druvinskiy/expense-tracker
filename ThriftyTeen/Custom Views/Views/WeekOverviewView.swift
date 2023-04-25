//
//  WeekOverviewView.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/5/23.
//

import UIKit

class WeekOverviewView: UIView {
    let weekRangeLabel = DRTitleLabel(textAlignment: .center, fontSize: 22, weight: .bold)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(weekRangeLabel)
        
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 70),
            weekRangeLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            weekRangeLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func set(weekExpenseRange: WeekExpenseRange) {
        let formatter = DateIntervalFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        weekRangeLabel.text = formatter.string(from: weekExpenseRange.weekStart, to: weekExpenseRange.weekEnd)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "USD"
    }
}
