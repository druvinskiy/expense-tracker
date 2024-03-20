//
//  FlowViewController.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 2/10/24.
//

import UIKit

class FlowViewController: UIViewController {
    var containerViews = [FlowContainerView]()
    var currentContainerViewIndex = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        containerViews.first?.viewDidAppear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black.withAlphaComponent(0.75)
        
        if let firstContainerView = containerViews.first {
            addContainerView(firstContainerView)
        }
    }
    
    func nextArrowTapped() {
        let currentContainerView = containerViews[currentContainerViewIndex]
        currentContainerViewIndex += 1
        
        let width = view.frame.width
        
        UIView.animate(withDuration: 0.5) {
            currentContainerView.transform = CGAffineTransform(translationX: -width, y: 0)
        } completion: { _ in
            let nextContainerView = self.containerViews[self.currentContainerViewIndex]
            nextContainerView.transform = CGAffineTransform(translationX: width, y: 0)
            
            self.addContainerView(nextContainerView)
            nextContainerView.viewDidAppear()
            
            currentContainerView.viewDidDisappear()
            currentContainerView.removeFromSuperview()
            
            UIView.animate(withDuration: 0.5, delay: 0.2) {
                nextContainerView.transform = .identity
            }
        }
    }
    
    func previousArrowTapped() {
        guard currentContainerViewIndex > 0 else { return }
        
        let currentContainerView = containerViews[currentContainerViewIndex]
        currentContainerViewIndex -= 1
        
        let width = view.frame.width
        
        UIView.animate(withDuration: 0.5) {
            currentContainerView.transform = CGAffineTransform(translationX: width, y: 0)
        } completion: { _ in
            let previousContainerView = self.containerViews[self.currentContainerViewIndex]
            previousContainerView.transform = CGAffineTransform(translationX: -width, y: 0)
            
            self.addContainerView(previousContainerView)
            previousContainerView.viewDidAppear()
            
            currentContainerView.viewDidDisappear()
            currentContainerView.removeFromSuperview()
            
            UIView.animate(withDuration: 0.5, delay: 0.2) {
                previousContainerView.transform = .identity
            }
        }
    }
    
    func addContainerView(_ containerView: UIView) {
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
        ])
    }
}

class AddExpenseViewController: FlowViewController {
    
    enum ExpenseNumber: Int, CaseIterable {
        case first
        case second
        case third
        
        var textRepresentation: String {
            switch self {
            case .first:
                return "Let's add your first expense..."
            case .second:
                return "Let's add your second expense..."
            case .third:
                return "Let's add one more..."
            }
        }
        
        func next() -> ExpenseNumber? {
            let allCases = ExpenseNumber.allCases
            let currentIndex = allCases.firstIndex(of: self)!
            let nextIndex = allCases.index(after: currentIndex)
            
            if nextIndex < allCases.endIndex {
                return allCases[nextIndex]
            }
            
            return nil
        }
    }
    
    lazy var skipButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.baseBackgroundColor = .smokyCharcoal
        configuration.baseForegroundColor = .white
        configuration.title = "Skip"
        
        let button = UIButton(configuration: configuration, primaryAction: UIAction(handler: { _ in
            print("hello")
        }))
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let expenseNumber: ExpenseNumber
    let finishedHandler: (String, Int, Date) -> ()
    
    init(expenseNumber: ExpenseNumber,
         finishedHandler: @escaping (String, Int, Date) -> ()) {
        self.expenseNumber = expenseNumber
        self.finishedHandler = finishedHandler
        
        super.init()
        
        createContainerViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createContainerViews() {
        let nameViewModel = FlowContainerViewModel(topText: expenseNumber.textRepresentation,
                                                         mainText: "What did you spend on?")
        
        let amountViewModel = FlowContainerViewModel(topText: expenseNumber.textRepresentation,
                                                           mainText: "How much did it cost?")
        
        let dateViewModel = FlowContainerViewModel(topText: expenseNumber.textRepresentation,
                                                         mainText: "When was it?",
                                                         isRightArrowEnabled: true)
        
        let containerViews = [
            AddExpenseTextContainerView(viewModel: nameViewModel,
                                        mode: .regular(),
                                        nextArrowAction: nextArrowTapped,
                                        previousArrowAction: previousArrowTapped,
                                        imageName: "Illustration_Idle2"),
            
            AddExpenseTextContainerView(viewModel: amountViewModel,
                                        mode: .amount(),
                                        nextArrowAction: nextArrowTapped,
                                        previousArrowAction: previousArrowTapped,
                                        imageName: "Illustration_ArmsCrossed2"),
            
            AddExpenseDateContainerView(viewModel: dateViewModel,
                                        nextArrowAction: nextArrowTapped,
                                        previousArrowAction: previousArrowTapped,
                                        imageName: "Illustration_ThumbsUp2"),
        ]
        
        containerViews.first?.viewModel.isLeftArrowVisible = false
        
        super.containerViews = containerViews
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }
    
    override func addContainerView(_ containerView: UIView) {
        view.insertSubview(containerView, belowSubview: skipButton)
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
        ])
    }
    
    override func nextArrowTapped() {
        guard currentContainerViewIndex < containerViews.count - 1 else {
            
            dismiss(animated: true) {
                var name = ""
                var intAmount = 0
                var date = Date()
                
                for containerView in self.containerViews {
                    if let textContainerView = containerView as? AddExpenseTextContainerView {
                        switch textContainerView.mode {
                        case .regular(let value):
                            name = value!
                        case .amount(let value):
                            let formatter = NumberFormatter()
                            formatter.numberStyle = .currency
                            formatter.currencyCode = "USD"
                            formatter.minimumFractionDigits = 0
                            
                            guard let formattedAmount = formatter.number(from: value!)?.decimalValue.convertToInt(currencyCode: "USD") else {
                                return
                            }
                            
                            intAmount = formattedAmount
                        }
                    } else if let dateContainerView = containerView as? AddExpenseDateContainerView {
                        date = dateContainerView.datePicker.date
                    }
                }
                
                self.finishedHandler(name, intAmount, date)
            }
            
            return
        }
        
        super.nextArrowTapped()
    }
}

class SignInUpViewController: FlowViewController {
    let mode: AuthenticationMode
    let finishedHandler: (String, String) -> ()
    
    init(mode: AuthenticationMode, finishedHandler: @escaping (String, String) -> Void) {
        self.mode = mode
        self.finishedHandler = finishedHandler
        
        super.init()
        
        createContainerViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createContainerViews() {
        let viewModel = FlowContainerViewModel(topText: mode.textRepresentation)
        
        let containerViews = [
            SignInUpContainerView(viewModel: viewModel, nextArrowAction: nextArrowTapped,
                                  previousArrowAction: {
                                      
                                  }, imageName: "Illustration_SingIn2")
        ]
        
        containerViews.first?.viewModel.isLeftArrowVisible = false
        
        super.containerViews = containerViews
    }
    
    override func nextArrowTapped() {
        guard let signInUpContainerView = containerViews.first as? SignInUpContainerView else { return }
        
        dismiss(animated: true) {
            self.finishedHandler(signInUpContainerView.email, signInUpContainerView.password)
        }
    }
}
