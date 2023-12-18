//
//  AddExpenseCell.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 10/3/23.
//

import UIKit

class AddExpenseCell: UICollectionViewCell {
    static let reuseID = "AddExpenseCell"
    
    private let shadowColor = UIColor.label.cgColor
    
    let messageLabel = DRTitleLabel(textAlignment: .center, fontSize: 20, weight: .bold)
    
    let graphicImageView: UIImageView = {
        let graphicImageView = UIImageView(image: UIImage(named: "Illustration_Idle"))
        graphicImageView.contentMode = .scaleAspectFit
        graphicImageView.translatesAutoresizingMaskIntoConstraints = false
        return graphicImageView
    }()
    
//    var addButton: UIButton = {
//        var configuration = UIButton.Configuration.filled()
//        configuration.cornerStyle = .capsule
//        configuration.baseBackgroundColor = .deepForestGreen
//        configuration.baseForegroundColor = .white
//        configuration.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular))
//
//        let button = UIButton(configuration: configuration)
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        return button
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowRadius = 8.0
        layer.shadowColor = shadowColor
        layer.shadowOpacity = 0.10
        layer.shadowOffset = CGSize(width: 0, height: 5)
        
        backgroundColor = .vibrantGreen
        addSubview(messageLabel)
        addSubview(graphicImageView)
        
        let customView = CustomView()
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(customView)
        
        NSLayoutConstraint.activate([
            graphicImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            graphicImageView.heightAnchor.constraint(equalTo: graphicImageView.widthAnchor),
            graphicImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            graphicImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            messageLabel.topAnchor.constraint(equalTo: graphicImageView.bottomAnchor, constant: 5),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            customView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 15),
            customView.topAnchor.constraint(equalTo: topAnchor, constant: -15),
            customView.widthAnchor.constraint(equalToConstant: 50),
            customView.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        messageLabel.text = "Add Expense"
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

class CustomView: UIView {
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .deepForestGreen
        
        let plusImageView = UIImageView(image: UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)))
        plusImageView.tintColor = .white
        plusImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(plusImageView)
        
        NSLayoutConstraint.activate([
            plusImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            plusImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.width / 2
    }
}
