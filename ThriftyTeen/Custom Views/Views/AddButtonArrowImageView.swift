//
//  AddButtonArrowImageView.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 6/14/23.
//

import UIKit

class AddButtonArrowImageView: UIView {
    
    let actionButton = UIButton()
    var arrowImageView: UIImageView?
    
    init(primaryAction: UIAction) {
        super.init(frame: .zero)
        
        configure(primaryAction: primaryAction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(primaryAction: UIAction) {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .vibrantGreen
        configuration.baseForegroundColor = .white
        configuration.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular))
        
        actionButton.configuration = configuration
        actionButton.addAction(primaryAction, for: .primaryActionTriggered)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 50),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 100),
            heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    func showTrainingAffordance() {
        guard arrowImageView == nil else { return }
        
        arrowImageView = UIImageView(image: UIImage(systemName: "arrow.down"))
        
        let arrowImageView = arrowImageView!
        
        arrowImageView.tintColor = .vibrantGreen
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            arrowImageView.centerXAnchor.constraint(equalTo: actionButton.centerXAnchor),
            arrowImageView.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -10),
            arrowImageView.heightAnchor.constraint(equalToConstant: 50),
            arrowImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func hideTrainingAffordance() {
        arrowImageView?.removeFromSuperview()
        arrowImageView = nil
    }
}
