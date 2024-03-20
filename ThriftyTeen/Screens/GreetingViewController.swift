//
//  TestIconAnimatedViewController.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 1/4/24.
//

import SwiftUI

class GreetingViewController: UIViewController {
    
    let scrollView = IconScrollView()
    
    let greetingLabel: UILabel = {
        let label = DRTitleLabel(textAlignment: .center, fontSize: 28, weight: .bold, textColor: .label)
        label.text = "Thanks for downloading the expense tracker!"
        
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        return label
    }()
    
    lazy var signUpButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .large
        configuration.cornerStyle = .large
        configuration.baseBackgroundColor = .vibrantGreen
        configuration.attributedTitle = "Create an account"
        configuration.attributedTitle?.font = UIFont.preferredFont(forTextStyle: .headline)
        
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return button
    }()
    
    lazy var signInButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Already have an account?"
        configuration.baseForegroundColor = .secondaryLabel
        
        let button = UIButton(configuration: configuration)
        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return button
    }()
    
    @objc func signUpButtonTapped() {
        scrollView.animateBorders(completion: {
            self.presentSignUpViewController()
        })
    }
    
    func presentSignUpViewController() {
        let signInUpViewController = SignInUpViewController(mode: .signUp) { email, password in
            self.scrollView.startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                let loginRequest = LoginRequest(email: email, password: password)
                NetworkManager.shared.signUp(loginRequest: loginRequest) { error in
                    self.authorizationRequestComplete(authenticationMode: .signUp, error: error)
                }
            }
        }
        
        self.present(signInUpViewController, animated: true)
    }
    
    @objc func signInButtonTapped() {
        scrollView.animateBorders(completion: {
            self.presentSignInViewController()
        })
    }
    
    func presentSignInViewController() {
        let signInUpViewController = SignInUpViewController(mode: .signIn) { email, password in
            self.scrollView.startAnimating()
            
            NetworkManager.shared.signIn(email: email, password: password) { error in
                self.authorizationRequestComplete(authenticationMode: .signIn, error: error)
            }
        }
        
        self.present(signInUpViewController, animated: true)
    }
    
    var uncategorizedCategory: Category?
    
    func authorizationRequestComplete(authenticationMode: AuthenticationMode, error: NetworkingError?) {
        DispatchQueue.main.async {
            switch authenticationMode {
            case .signIn:
                self.scrollView.stopAnimating()
                self.presentYearsViewController()
            case .signUp:
                self.scrollView.stopAnimating()
                
                NetworkManager.shared.postCategory(iconName: "Icon38", name: "Uncategorized") { result in
                    switch result {
                    case .success(let category):
                        self.uncategorizedCategory = category
                        
                        DispatchQueue.main.async {
                            self.presentAddExpenseViewController()
                        }
                    case .failure(_):
                        break
                    }
                }
            }
        }
    }
    
    func presentYearsViewController() {
        let navigationController = UINavigationController(rootViewController: YearsViewController())
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.navigationBar.tintColor = .label
        
        self.present(navigationController, animated: false)
    }
    
    func presentAddExpenseViewController(expenseNumber: AddExpenseViewController.ExpenseNumber = .first) {
        guard let uncategorizedCategory else {
            return
        }
        
        let numbers = AddExpenseViewController.ExpenseNumber.allCases
        
        let addExpenseViewController = AddExpenseViewController(expenseNumber: numbers[expenseNumber.rawValue]) { name, intAmount, date in
            NetworkManager.shared.postExpense(category: uncategorizedCategory, title: name, amount: intAmount, currencyCode: "USD", dateCreated: date) { error in
                let nextExpenseNumber = expenseNumber.next()
                
                DispatchQueue.main.async {
                    if let nextExpenseNumber {
                        self.presentAddExpenseViewController(expenseNumber: nextExpenseNumber)
                    } else {
                        self.presentYearsViewController()
                    }
                }
            }
        }
        
        present(addExpenseViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(greetingLabel)
        view.addSubview(signUpButton)
        view.addSubview(signInButton)
        
        configureScrollView()
        scrollView.animateScrollView()
        
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20),
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            greetingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            greetingLabel.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -20),
            
            signUpButton.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: -10),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        scrollView.configure(maxHeight: view.frame.height * 0.6)
    }
}

enum AuthenticationMode {
    case signIn
    case signUp
    
    var textRepresentation: String {
        switch self {
        case .signIn:
            return "Sign in to continue..."
        case .signUp:
            return "Let's create an account for you..."
        }
    }
}
