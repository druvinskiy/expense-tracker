//
//  AddExpenseContainerView.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 2/10/24.
//

import UIKit

// rename to make generic container view

struct FlowContainerViewModel {
    let topText: String
    let mainText: String?
    var isLeftArrowVisible = true
    var isRightArrowEnabled: Bool
    
    init(topText: String, mainText: String? = nil, isRightArrowEnabled: Bool = false) {
        self.topText = topText
        self.mainText = mainText
        self.isRightArrowEnabled = isRightArrowEnabled
    }
}

class FlowContainerView: UIView {
    let graphicImageView: UIImageView = {
        let graphicImageView = UIImageView()
        graphicImageView.contentMode = .scaleAspectFit
        graphicImageView.translatesAutoresizingMaskIntoConstraints = false
        return graphicImageView
    }()
    
    lazy var leftArrow: UIButton = {
        let imageConfiguration = UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .body))
        let arrowImage = UIImage(systemName: "arrow.left", withConfiguration: imageConfiguration)
        
        var buttonConfiguration = UIButton.Configuration.borderless()
        buttonConfiguration.image = arrowImage
        buttonConfiguration.baseForegroundColor = .white
        
        let actionButton = UIButton(configuration: buttonConfiguration, primaryAction: UIAction(handler: {_ in
            self.previousArrowAction()
        }))
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        return actionButton
    }()
    
    lazy var rightArrow: UIButton = {
        let imageConfiguration = UIImage.SymbolConfiguration(font: UIFont.preferredFont(forTextStyle: .body))
        let arrowImage = UIImage(systemName: "arrow.right", withConfiguration: imageConfiguration)
        
        var buttonConfiguration = UIButton.Configuration.borderless()
        buttonConfiguration.image = arrowImage
        buttonConfiguration.baseForegroundColor = .white
        
        let actionButton = UIButton(configuration: buttonConfiguration, primaryAction: UIAction(handler: {_ in
            self.nextArrowAction()
        }))
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        return actionButton
    }()
    
    lazy var mainLabel: UILabel = {
        let label = DRTitleLabel(textAlignment: .center, fontSize: 36, weight: .bold, textColor: .white)
        label.text = viewModel.mainText
        
        return label
    }()
    
    lazy var expenseNumberLabel: UILabel = {
//        let label = DRTitleLabel(textAlignment: .left, fontSize: 18, weight: .regular, textColor: .white)
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .white
//        label.backgroundColor = .red
        label.text = viewModel.topText
        
        return label
    }()
    
    let nextArrowAction: () -> ()
    let previousArrowAction: () -> ()
    
    var viewModel: FlowContainerViewModel {
        didSet {
            updateUsingViewModel()
        }
    }
    
    let horizontalPadding: CGFloat = 20
    let verticalPadding: CGFloat = 20
    let bottomPadding: CGFloat = 10
    
    init(viewModel: FlowContainerViewModel,
         nextArrowAction: @escaping () -> (),
         previousArrowAction: @escaping () -> (),
         imageName: String) {
        
        self.viewModel = viewModel
        self.nextArrowAction = nextArrowAction
        self.previousArrowAction = previousArrowAction
        self.graphicImageView.image = UIImage(named: imageName)
        
        super.init(frame: .zero)
        
        configure()
    }
    
    var blueView: UIView = {
        let blueView = UIView()
        
        blueView.backgroundColor = .azureBlue
        blueView.layer.borderWidth = 4
        blueView.layer.borderColor = UIColor.white.cgColor
        blueView.layer.cornerRadius = 16
        blueView.translatesAutoresizingMaskIntoConstraints = false
        blueView.clipsToBounds = true
        
        return blueView
    }()
    
    let testView: UIView = {
        let testView = UIView()
        testView.translatesAutoresizingMaskIntoConstraints = false
        testView.backgroundColor = .azureBlueDark
        return testView
    }()
    
    func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(graphicImageView)
        addSubview(blueView)
        
        
        testView.addSubview(expenseNumberLabel)
        
//        blueView.addSubview(expenseNumberLabel)
        blueView.addSubview(testView)
        blueView.addSubview(mainLabel)
        blueView.addSubview(rightArrow)
        blueView.addSubview(leftArrow)
        
        NSLayoutConstraint.activate([
            blueView.centerYAnchor.constraint(equalTo: centerYAnchor),
            blueView.centerXAnchor.constraint(equalTo: centerXAnchor),
            blueView.widthAnchor.constraint(equalTo: widthAnchor),
            
            testView.topAnchor.constraint(equalTo: blueView.topAnchor),
            testView.leadingAnchor.constraint(equalTo: blueView.leadingAnchor),
            testView.trailingAnchor.constraint(equalTo: blueView.trailingAnchor),
            testView.heightAnchor.constraint(equalTo: expenseNumberLabel.heightAnchor, constant: 42),
            
            expenseNumberLabel.centerYAnchor.constraint(equalTo: testView.centerYAnchor, constant: 2),
//            expenseNumberLabel.topAnchor.constraint(equalTo: testView.topAnchor, constant: 10),
            expenseNumberLabel.leadingAnchor.constraint(equalTo: blueView.leadingAnchor, constant: horizontalPadding),
            expenseNumberLabel.trailingAnchor.constraint(equalTo: blueView.trailingAnchor, constant: -horizontalPadding),
            
            rightArrow.bottomAnchor.constraint(equalTo: blueView.bottomAnchor, constant: -bottomPadding),
            rightArrow.trailingAnchor.constraint(equalTo: blueView.trailingAnchor, constant: -bottomPadding),
            
            leftArrow.bottomAnchor.constraint(equalTo: blueView.bottomAnchor, constant: -bottomPadding),
            leftArrow.leadingAnchor.constraint(equalTo: blueView.leadingAnchor, constant: bottomPadding),
            
            graphicImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            graphicImageView.bottomAnchor.constraint(equalTo: blueView.topAnchor, constant: 15),
            graphicImageView.heightAnchor.constraint(equalToConstant: 90),
            graphicImageView.widthAnchor.constraint(equalTo: graphicImageView.heightAnchor)
        ])
        
        updateUsingViewModel()
    }
    
    func updateUsingViewModel() {
        mainLabel.text = viewModel.mainText
        expenseNumberLabel.text = viewModel.topText
        leftArrow.isHidden = !viewModel.isLeftArrowVisible
        rightArrow.isEnabled = viewModel.isRightArrowEnabled
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func viewDidAppear() { }
    
    func viewDidDisappear() { }
}

class SignInUpContainerView: FlowContainerView, UITextFieldDelegate {
//    lazy var emailTextField: UITextField = {
//        let textField = BottomLineTextField()
//        textField.textColor = .white
//        textField.tintColor = .white
//        textField.keyboardType = .emailAddress
//        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightText])
//        textField.autocapitalizationType = .none
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.returnKeyType = .next
//        textField.font = .preferredFont(forTextStyle: .body)
//        textField.adjustsFontForContentSizeCategory = true
//        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//        return textField
//    }()
//
//    lazy var passwordTextField: UITextField = {
//        let textField = BottomLineTextField()
//        textField.textColor = .white
//        textField.tintColor = .white
//        textField.isSecureTextEntry = true
//        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightText])
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.returnKeyType = .done
//        textField.font = .preferredFont(forTextStyle: .body)
//        textField.adjustsFontForContentSizeCategory = true
//        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//        return textField
//    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .mistyBlue.withAlphaComponent(0.5)
        textField.setLeftPaddingPoints(10)
        textField.tintColor = .label
        textField.keyboardType = .emailAddress
        textField.placeholder = "Email"
        textField.layer.cornerRadius = 8
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.returnKeyType = .next
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .mistyBlue.withAlphaComponent(0.5)
        textField.setLeftPaddingPoints(10)
        textField.tintColor = .label
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
        textField.returnKeyType = .done
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }()
    
    var textFields: [UITextField] {
        return [emailTextField, passwordTextField]
    }
    
    override func configure() {
        super.configure()
        
        blueView.addSubview(emailTextField)
        blueView.addSubview(passwordTextField)
        
        mainLabel.removeFromSuperview()
        
        NSLayoutConstraint.activate([
            
            emailTextField.topAnchor.constraint(equalTo: testView.bottomAnchor, constant: verticalPadding),
            emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -verticalPadding),
            emailTextField.leadingAnchor.constraint(equalTo: blueView.leadingAnchor, constant: horizontalPadding),
            emailTextField.trailingAnchor.constraint(equalTo: blueView.trailingAnchor, constant: -horizontalPadding),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.bottomAnchor.constraint(equalTo: rightArrow.topAnchor, constant: -bottomPadding),
            passwordTextField.leadingAnchor.constraint(equalTo: blueView.leadingAnchor, constant: horizontalPadding),
            passwordTextField.trailingAnchor.constraint(equalTo: blueView.trailingAnchor, constant: -horizontalPadding),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
        ])
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let selectedTextFieldIndex = textFields.firstIndex(of: textField), selectedTextFieldIndex < textFields.count - 1 {
            textFields[selectedTextFieldIndex + 1].becomeFirstResponder()
        } else {
            nextArrowAction()
        }
        
        return true
    }
    
    var email = ""
    var password = ""
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces),
              let password = passwordTextField.text,
              ValidationManager.isValidEmail(email),
              ValidationManager.isValidPassword(password) else {
            
            viewModel.isRightArrowEnabled = false
            updateUsingViewModel()
            return
        }
        
        self.email = email
        self.password = password
        
        viewModel.isRightArrowEnabled = true
        updateUsingViewModel()
    }
    
    override func viewDidAppear() {
        emailTextField.becomeFirstResponder()
    }
    
    override func viewDidDisappear() {
        emailTextField.resignFirstResponder()
    }
}

class AddExpenseTextContainerView: FlowContainerView, UITextFieldDelegate {
    var mode: Mode
    
    enum Mode {
        case regular(value: String? = nil)
        case amount(value: String? = nil)
        
        var keyboardType: UIKeyboardType {
            switch self {
            case .regular(_):
                return .default
            case .amount(_):
                return .decimalPad
            }
        }
    }
    
    lazy var generalTextField: UITextField = {
        let textField = BottomLineTextField()
        textField.textAlignment = .center
        textField.textColor = .white
        textField.tintColor = .white
        textField.font = .preferredFont(forTextStyle: .title1)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .next
        textField.keyboardType = mode.keyboardType
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        return textField
    }()
    
    init(viewModel: FlowContainerViewModel,
         mode: Mode,
         nextArrowAction: @escaping () -> (),
         previousArrowAction: @escaping () -> (),
         imageName: String) {
        
        self.mode = mode
        
        super.init(viewModel: viewModel,
                   nextArrowAction: nextArrowAction,
                   previousArrowAction: previousArrowAction,
                   imageName: imageName)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        super.configure()
        
        blueView.addSubview(generalTextField)
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: testView.bottomAnchor, constant: verticalPadding),
            mainLabel.leadingAnchor.constraint(equalTo: blueView.leadingAnchor, constant: horizontalPadding),
            mainLabel.trailingAnchor.constraint(equalTo: blueView.trailingAnchor, constant: -horizontalPadding),
            mainLabel.bottomAnchor.constraint(equalTo: generalTextField.topAnchor, constant: -verticalPadding),
            
            generalTextField.bottomAnchor.constraint(equalTo: rightArrow.topAnchor, constant: -bottomPadding),
            generalTextField.leadingAnchor.constraint(equalTo: blueView.leadingAnchor, constant: horizontalPadding),
            generalTextField.trailingAnchor.constraint(equalTo: blueView.trailingAnchor, constant: -horizontalPadding)
        ])
        
        generalTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextArrowAction()
        
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            viewModel.isRightArrowEnabled = true
        } else {
            viewModel.isRightArrowEnabled = false
        }
        
        updateUsingViewModel()
        
        var amount = ""
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.minimumFractionDigits = 0
        
        if let decimal = Decimal(string: textField.text!), let formattedValue = formatter.string(from: NSDecimalNumber(decimal: decimal)) {
            amount = formattedValue
        } else {
            amount = textField.text!
        }
        
        textField.text = amount
        
        switch mode {
        case .amount(_):
            mode = .amount(value: amount)
        case .regular(_):
            mode = .regular(value: textField.text!)
        }
    }
    
    override func viewDidAppear() {
        generalTextField.becomeFirstResponder()
    }
    
    override func viewDidDisappear() {
        generalTextField.resignFirstResponder()
    }
    
//    func parentViewDidLayoutSubviews() {
//        let bottomLine = CALayer()
//        bottomLine.frame = CGRect(x: 0, y: generalTextField.frame.height, width: generalTextField.frame.width, height: 2)
//        bottomLine.backgroundColor = UIColor.white.cgColor
//
//        generalTextField.layer.addSublayer(bottomLine)
//    }
}

class AddExpenseDateContainerView: FlowContainerView {
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = .azureBlueDark.withAlphaComponent(0.4)
        datePicker.subviews[0].subviews[0].subviews[0].alpha = 0
        datePicker.tintColor = .azureBlue
        datePicker.overrideUserInterfaceStyle = .dark
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    override init(viewModel: FlowContainerViewModel,
                  nextArrowAction: @escaping () -> (),
                  previousArrowAction: @escaping () -> (),
                  imageName: String) {
        
        super.init(viewModel: viewModel,
                   nextArrowAction: nextArrowAction,
                   previousArrowAction: previousArrowAction,
                   imageName: imageName)
        
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutUI() {
        blueView.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: testView.bottomAnchor, constant: verticalPadding),
            mainLabel.leadingAnchor.constraint(equalTo: blueView.leadingAnchor, constant: horizontalPadding),
            mainLabel.trailingAnchor.constraint(equalTo: blueView.trailingAnchor, constant: -horizontalPadding),
            mainLabel.bottomAnchor.constraint(equalTo: datePicker.topAnchor, constant: -verticalPadding),
            
            datePicker.bottomAnchor.constraint(equalTo: rightArrow.topAnchor, constant: -verticalPadding),
            datePicker.centerXAnchor.constraint(equalTo: blueView.centerXAnchor),
            //            datePicker.leadingAnchor.constraint(equalTo: blueView.leadingAnchor, constant: horizontalPadding),
            //            datePicker.trailingAnchor.constraint(equalTo: blueView.trailingAnchor, constant: -horizontalPadding)
        ])
    }
}

class BottomLineTextField: UITextField {
    
    private let bottomLine = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBottomLine()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBottomLine()
    }
    
    private func setupBottomLine() {
        bottomLine.backgroundColor = UIColor.white.cgColor
        layer.addSublayer(bottomLine)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLine.frame = CGRect(x: 0, y: bounds.height - 2, width: bounds.width, height: 2)
    }
    
//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.insetBy(dx: 5, dy: 0)
//    }
//
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return bounds.insetBy(dx: 5, dy: 0)
//    }
}
