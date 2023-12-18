//
//  SignInUpViewController.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 8/9/23.
//

import UIKit

class SignInUpViewController: UIViewController, UITextFieldDelegate {
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .smokyCharcoal.withAlphaComponent(0.2)
        textField.setLeftPaddingPoints(10)
        textField.tintColor = .label
        textField.keyboardType = .emailAddress
        textField.placeholder = "Email"
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.returnKeyType = .next
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .smokyCharcoal.withAlphaComponent(0.2)
        textField.setLeftPaddingPoints(10)
        textField.tintColor = .label
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.returnKeyType = .done
        return textField
    }()
    
    lazy var actionButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .medium
        configuration.baseBackgroundColor = .vibrantGreen
        
        var container = AttributeContainer()
        container.font = UIFont.preferredFont(forTextStyle: .headline)
        configuration.attributedTitle = AttributedString(selectedMode.description, attributes: container)
        
        let action = UIAction(handler: {_ in
            self.actionButtonTapped()
        })
        
        let button = UIButton(configuration: configuration, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return button
    }()
    
    let graphicImageView: UIImageView = {
        let graphicImageView = UIImageView(image: UIImage(named: "Illustration_SingIn"))
        graphicImageView.contentMode = .scaleAspectFit
        graphicImageView.translatesAutoresizingMaskIntoConstraints = false
        graphicImageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        graphicImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        return graphicImageView
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: Mode.allValues)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.setContentCompressionResistancePriority(.required, for: .vertical)
        segmentedControl.setContentHuggingPriority(.required, for: .vertical)
        return segmentedControl
    }()
    
    var selectedMode: Mode {
        return Mode.indexToMode(index: segmentedControl.selectedSegmentIndex)
    }
    
    enum Mode: CaseIterable {
        case signIn
        case signUp
        
        var description: String {
            switch self {
            case .signIn:
                return "Sign In"
            case .signUp:
                return "Sign Up"
            }
        }
        
        static var allValues: [String] {
            return Mode.allCases.map { $0.description }
        }
        
        static func indexToMode(index: Int) -> Mode {
            return Mode.allCases[index]
        }
    }
    
    var textFields: [UITextField] {
        return [emailTextField, passwordTextField]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @objc func keyboardDidShow() {
        let currentSize = graphicImageView.frame.size
        graphicImageView.translatesAutoresizingMaskIntoConstraints = true
        graphicImageView.frame.size = currentSize
        self.view.layoutIfNeeded()
    }

    @objc func keyboardWillDisappear() {
        graphicImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.layoutIfNeeded()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(segmentedControl)
        view.addSubview(graphicImageView)
        view.addSubview(actionButton)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            graphicImageView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            graphicImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            graphicImageView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.7),
            graphicImageView.heightAnchor.constraint(equalTo: graphicImageView.widthAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: graphicImageView.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            actionButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
            actionButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -20),
        ])
    }
    
    func actionButtonTapped() {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces), ValidationManager.isValidEmail(email) else {
            presentCustomAlert(message: SignInError.invalidEmail.description)
            return
        }
        
        guard let password = passwordTextField.text, ValidationManager.isValidPassword(password) else {
            presentCustomAlert(message: SignInError.invalidPassword.description)
            return
        }
        
        switch selectedMode {
        case .signIn:
            NetworkManager.shared.signIn(email: email, password: password, completed: authorizationRequestComplete)
        case .signUp:
            let loginRequest = LoginRequest(email: email, password: password)
            NetworkManager.shared.signUp(loginRequest: loginRequest, completed: authorizationRequestComplete)
        }
    }
    
    func authorizationRequestComplete(error: NetworkingError?) {
        DispatchQueue.main.async {
            let navigationController = UINavigationController(rootViewController: YearsViewController())
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.modalPresentationStyle = .overFullScreen
            
            self.present(navigationController, animated: false)
        }
    }
    
    @objc func segmentedControlValueChanged(_ segmentedControl: UISegmentedControl) {
        var updatedConfiguration = actionButton.configuration
        
        var updatedContainer = AttributeContainer()
        updatedContainer.font = UIFont.preferredFont(forTextStyle: .headline)
        updatedConfiguration?.attributedTitle = AttributedString(selectedMode.description, attributes: updatedContainer)
        
        actionButton.configuration = updatedConfiguration
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let selectedTextFieldIndex = textFields.firstIndex(of: textField), selectedTextFieldIndex < textFields.count - 1 {
            textFields[selectedTextFieldIndex + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            actionButtonTapped()
        }
        
        return true
    }
}
