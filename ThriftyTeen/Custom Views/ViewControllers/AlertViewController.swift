//
//  AlertViewController.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 9/16/23.
//

import UIKit

class AlertViewController: UIViewController {
    
    let containerView = AlertContainerView()
    let messageLabel = DRTitleLabel(textAlignment: .center, fontSize: 20, weight: .bold)
    
    let graphicImageView: UIImageView = {
        let graphicImageView = UIImageView(image: UIImage(named: "Illustration_Surprised"))
        graphicImageView.contentMode = .scaleAspectFit
        graphicImageView.translatesAutoresizingMaskIntoConstraints = false
        return graphicImageView
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var message: String
    
    let padding: CGFloat = 20
    
    init(message: String) {
        self.message = message
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubview(containerView)
        
        containerView.addSubview(messageLabel)
        containerView.addSubview(graphicImageView)
        containerView.addSubview(actionButton)
        
        configureContainerView()
        configureGraphicImageView()
        configureMessageLabel()
        configureActionButton()
    }
    
    func configureContainerView() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    func configureGraphicImageView() {
        NSLayoutConstraint.activate([
            graphicImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.4),
            graphicImageView.heightAnchor.constraint(equalTo: graphicImageView.widthAnchor),
            graphicImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            graphicImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding)
        ])
    }
    
    func configureMessageLabel() {
        messageLabel.text = message
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: graphicImageView.bottomAnchor, constant: padding),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
        ])
    }
    
    func configureActionButton() {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .medium
        configuration.baseBackgroundColor = .vibrantGreen
        
        var container = AttributeContainer()
        container.font = UIFont.preferredFont(forTextStyle: .headline)
        configuration.attributedTitle = AttributedString("Ok", attributes: container)
        
        let action = UIAction(handler: {_ in
            self.dismiss(animated: true)
        })
        
        actionButton.configuration = configuration
        actionButton.addAction(action, for: .primaryActionTriggered)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
