//
//  YearsViewController.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/8/23.
//

import SwiftUI

protocol YearsViewControllerDelegate {
    func expenseUpdated(originalExpense: Expense, updatedExpense: Expense)
    func expenseAdded()
}

class YearsViewController: UIViewController {
    lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionView.createTwoColumnFlowLayout(in: view))
    lazy var networkingViewManager = NetworkingViewsManager(parentViewController: navigationController!)
    
    lazy var addButtonArrowImageView = AddButtonArrowImageView(primaryAction:  UIAction(handler: {_ in
        let formVC = UIHostingController(rootView: AddExpenseForm() {
            self.dismiss(animated: true)
        })
        formVC.modalPresentationStyle = .fullScreen
        self.present(formVC, animated: true)
    }))
    
    lazy var addButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        
        // Get the screen size
        let screenSize = UIScreen.main.bounds.size
        
        let imageHeightProportion: CGFloat = 0.1 // Adjust this proportion to fit your needs
        let imageHeight = screenSize.height * imageHeightProportion
        
        var image = UIImage(named: "Illustration_Idle2")!
        
        let aspectRatio = image.size.width / image.size.height
        let imageWidth = imageHeight * aspectRatio
        
        configuration.image = image
            .resized(to: CGSize(width: imageWidth, height: imageHeight))
            .withRenderingMode(.alwaysOriginal)
            .withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))
        
        configuration.imagePlacement = .leading
        configuration.imagePadding = 30
        configuration.background.cornerRadius = 10
        configuration.baseBackgroundColor = .vibrantGreen
        
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: 24)
        configuration.attributedTitle = AttributedString("Add Expense", attributes: container)
        
        let action = UIAction(handler: {_ in
            let formVC = UIHostingController(rootView: AddExpenseForm() {
                self.dismiss(animated: true)
            })
            formVC.modalPresentationStyle = .fullScreen
            self.present(formVC, animated: true)
        })
        
        let button = UIButton(configuration: configuration, primaryAction: action)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return button
    }()
    
    var monthsVC: MonthsViewController?
    
    var expenses = [Expense]()
    var expenseYears = [Int]()
    var expensesByYear = [Int: [Expense]]()
    var selectedYear: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getExpenses()
    }
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(YearCell.self, forCellWithReuseIdentifier: YearCell.reuseID)
    }
    
    func configureUI() {
        collectionView.backgroundColor = .systemBackground
        //        collectionView.addSubview(addButtonArrowImageView)
        //
        //        NSLayoutConstraint.activate([
        //            addButtonArrowImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
        //            addButtonArrowImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        //        ])
        
        collectionView.addSubview(addButton)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            //            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func getExpenses() {
        networkingViewManager.showLoadingView()
        
        NetworkManager.shared.fetchExpenses { result in
            DispatchQueue.main.async {
                self.networkingViewManager.dismissLoadingView()
                
                switch result {
                case .success(let expenses):
                    self.updateUI(with: expenses)
                case .failure(_):
                    break
                }
            }
        }
    }
    
    func updateUI(with expenses: [Expense]) {
        self.expenses = expenses
        expenseYears = ExpensesHelper.getExpenseYears(expenses)
        expensesByYear = ExpensesHelper.getExpensesByYear(expenses)
        collectionView.reloadData()
        
        if expenses.isEmpty { // move this to Array extension
            networkingViewManager.showEmptyStateView(emptyState: .noExpensesAtAll)
            addButtonArrowImageView.showTrainingAffordance()
            navigationItem.title = ""
        } else {
            networkingViewManager.dismissEmptyStateView()
            addButtonArrowImageView.hideTrainingAffordance()
            navigationItem.title = String(localized: "years-view.navigation-item.title") // change this to be more descriptive
        }
    }
}

extension YearsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return expensesByYear.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let year = expenseYears[indexPath.row]
        let filteredExpenses = expensesByYear[year]!
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YearCell.reuseID, for: indexPath) as! YearCell
        cell.set(expenses: filteredExpenses, yearNumber: year)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedYear = expenseYears[indexPath.row]
        let filteredExpenses = expensesByYear[selectedYear!]!
        
        monthsVC = MonthsViewController(year: selectedYear!, expenses: filteredExpenses, yearsVCDelegate: self)
        navigationController?.pushViewController(monthsVC!, animated: true)
    }
}

extension YearsViewController: YearsViewControllerDelegate {
    func expenseAdded() {
        fetchFilteredExpenses()
    }
    
    func expenseUpdated(originalExpense: Expense, updatedExpense: Expense) {
        fetchFilteredExpenses()
    }
    
    func fetchFilteredExpenses() {
        NetworkManager.shared.fetchExpenses { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let expenses):
                    let expensesByYear = ExpensesHelper.getExpensesByYear(expenses)
                    let filteredExpenses = expensesByYear[self.selectedYear!] ?? []
                    
                    self.monthsVC?.dataUpdated(expenses: filteredExpenses)
                case .failure(_):
                    break
                }
            }
        }
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
