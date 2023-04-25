//
//  RealExpensesListVC.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/11/23.
//

import UIKit

class MonthExpensesListViewController: UIViewController {
    lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionView.createOneColumnFlowLayout(in: view))
    
    let expenses: [Expense]
    let month: Int
    
    init(expenses: [Expense], month: Int) {
        self.expenses = expenses
        self.month = month
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureCollectionView()
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ExpenseCell.self, forCellWithReuseIdentifier: ExpenseCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func layoutUI() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        
        let date = dateFormatter.date(from: "\(month)")!
        let monthName = date.formatted(Date.FormatStyle().month(.wide))
        
        let monthLabel = DRTitleLabel(textAlignment: .left, fontSize: 24, weight: .bold)
        monthLabel.text = String(format: NSLocalizedString("month-expenses-view.label.overview", comment: ""), monthName)
        
        let mostSpentCategory = ExpensesHelper.findMostSpentCategory(expenses)
        let totalMonthlySpent = ExpensesHelper.calculateTotalSpent(expenses)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "USD"
        let formattedAmount = numberFormatter.string(from: NSNumber(value: totalMonthlySpent))!
        
        let viewModels = [
            OverviewCellViewModel(title: NSLocalizedString("overview-view.label.spent-most-on", comment: ""),
                                  subtitle: mostSpentCategory.capitalized, hasIcon: true),
            
            OverviewCellViewModel(title: NSLocalizedString("overview-view.label.monthly-spend", comment: ""),
                                  subtitle: formattedAmount, hasIcon: false),
        ]
        
        let monthOverviewVC = MonthOverviewViewController(viewModels: viewModels)
        
        view.addSubview(monthLabel)
        view.addSubview(monthOverviewVC.view)
        view.addSubview(collectionView)
        
        addChild(monthOverviewVC)
        monthOverviewVC.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            monthLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
            monthOverviewVC.view.topAnchor.constraint(equalTo: monthLabel.bottomAnchor),
            monthOverviewVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            monthOverviewVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: monthOverviewVC.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MonthExpensesListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpenseCell.reuseID, for: indexPath) as! ExpenseCell
        let expense = expenses[indexPath.row]
        cell.set(expense: expense)
        return cell
    }
}
