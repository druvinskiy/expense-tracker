//
//  RealExpensesListVC.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/11/23.
//

import UIKit
import SwiftUI

class MonthExpensesListViewController: UIViewController {
    let monthLabel = DRTitleLabel(textAlignment: .left, fontSize: 24, weight: .bold, textColor: .label)
    
    lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionView.createOneColumnFlowLayout(in: view))
    lazy var networkingViewManager = NetworkingViewsManager(parentViewController: self)
    
    let expenses: [Expense]
    let month: Int
    
    let yearsVCDelegate: YearsViewControllerDelegate
    
    init(expenses: [Expense], month: Int, yearsVCDelegate: YearsViewControllerDelegate) {
        self.expenses = expenses
        self.month = month
        self.yearsVCDelegate = yearsVCDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        
        guard !expenses.isEmpty else {
            networkingViewManager.showEmptyStateView(emptyState: .noMonthlyExpenses)
            showMonthLabel()
            return
        }
        
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
        showMonthLabel()
        
        let mostSpentCategory = ExpensesHelper.findMostSpentCategory(expenses)
        let totalMonthlySpent = ExpensesHelper.calculateTotalSpent(expenses)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = "USD"
        let formattedAmount = numberFormatter.string(from: NSDecimalNumber(decimal: totalMonthlySpent))!
        
        let viewModels = [
            OverviewCellViewModel(title: String(localized: "overview-view.label.spent-most-on"),
                                  subtitle: mostSpentCategory.name!.localizedCapitalized, iconName: mostSpentCategory.iconName),
            
            OverviewCellViewModel(title: String(localized: "overview-view.label.monthly-spend"),
                                  subtitle: formattedAmount, iconName: nil),
        ]
        
        let monthOverviewVC = MonthOverviewViewController(viewModels: viewModels)
        
        view.addSubview(monthOverviewVC.view)
        view.addSubview(collectionView)
        
        addChild(monthOverviewVC)
        monthOverviewVC.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            monthOverviewVC.view.topAnchor.constraint(equalTo: monthLabel.bottomAnchor),
            monthOverviewVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            monthOverviewVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: monthOverviewVC.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func showMonthLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        
        let date = dateFormatter.date(from: "\(month)")!
        let monthName = date.formatted(Date.FormatStyle().month(.wide))
        
        monthLabel.text = String(localized: "month-expenses-view.label.overview \(monthName)")
        
        view.addSubview(monthLabel)
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            monthLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let expense = expenses[indexPath.row]
        let updateExpenseForm = UpdateExpenseForm(expense: expense) { updatedExpense in
            guard let updatedExpense = updatedExpense else {
                self.dismiss(animated: true)
                return
            }
            
            self.yearsVCDelegate.updateData(originalExpense: expense, updatedExpense: updatedExpense)
            self.dismiss(animated: true)
        }
        
        let formVC = UIHostingController(rootView: updateExpenseForm)
        
        self.present(formVC, animated: true)
    }
}
