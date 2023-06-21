//
//  EmptyStateView.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 5/28/23.
//

import UIKit

class EmptyStateView: UIView {
    
    enum EmptyState {
        case noExpensesAtAll
        case noMonthlyExpenses
        
        var message: String {
            switch self {
            case .noExpensesAtAll:
                return "No expenses. Add one by tapping the plus button."
            case .noMonthlyExpenses:
                return "No expenses for this month."
            }
        }
        
        var graphicName: String {
            switch self {
            case .noExpensesAtAll:
                return "Illustration_NoExpensesAtAll_v3"
            case .noMonthlyExpenses:
                return "Illustration_NoMonthlyExpenses_v3"
            }
        }
    }
    
    let messageLabel = DRTitleLabel(textAlignment: .center, fontSize: 28, weight: .regular)
    let graphicImageView = UIImageView()
    
    init(emptyState: EmptyState) {
        messageLabel.text = emptyState.message
        graphicImageView.image = UIImage(named: emptyState.graphicName)
        
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
//        backgroundColor = .red
        
        addSubview(graphicImageView)
        addSubview(messageLabel)
        configureGraphicImageView()
        configureMessageLabel()
    }
    
    private func configureMessageLabel() {
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .secondaryLabel

        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: graphicImageView.bottomAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureGraphicImageView() {
        graphicImageView.translatesAutoresizingMaskIntoConstraints = false
        graphicImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            graphicImageView.topAnchor.constraint(equalTo: topAnchor),
            graphicImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            graphicImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            graphicImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
//            graphicImageView.widthAnchor.constraint(equalToConstant: 300),
//            graphicImageView.heightAnchor.constraint(equalToConstant: 303)
        ])
    }
}
