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
        
        let plusIconView = PlusIconView()
        plusIconView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(plusIconView)
        
        NSLayoutConstraint.activate([
            graphicImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
            graphicImageView.heightAnchor.constraint(equalTo: graphicImageView.widthAnchor),
            graphicImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            graphicImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            messageLabel.topAnchor.constraint(equalTo: graphicImageView.bottomAnchor, constant: 5),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            plusIconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 15),
            plusIconView.topAnchor.constraint(equalTo: topAnchor, constant: -15),
            plusIconView.widthAnchor.constraint(equalToConstant: 50),
            plusIconView.heightAnchor.constraint(equalToConstant: 50),
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
    
    func rotateImage() {
        UIView.animate(withDuration: 0.5) {
            self.graphicImageView.transform = CGAffineTransform(rotationAngle: .pi)
        }
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.25,
            options: UIView.AnimationOptions.curveEaseOut
        ) {
            self.graphicImageView.transform = CGAffineTransform(rotationAngle: 2 * .pi)
        }
    }
}
