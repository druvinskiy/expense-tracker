//
//  YearsViewController.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/8/23.
//

import SwiftUI

protocol YearsViewControllerDelegate {
    func expenseUpdated()
    func expenseAdded()
}

class YearsViewController: UIViewController {
    lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionView.createTwoColumnFlowLayout(in: view))
    lazy var networkingViewManager = NetworkingViewsManager(parentViewController: navigationController!)
    
    enum CellType {
        case addExpense
        case expenseYear(Int)
    }
    
    var cellTypes = [CellType]()
    
    var monthsVC: MonthsViewController?
    
    var expenses = [Expense]()
    var expensesByYear = [Int: [Expense]]()
    var selectedYear: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureUI()
    }
    
    @objc func settingsButtonTapped() {
        let settingsViewController = SettingsViewController {
            self.dismiss(animated: false)
        }
        
        let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
        settingsNavigationController.navigationBar.prefersLargeTitles = true
        
        present(settingsNavigationController, animated: true)
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
        collectionView.register(AddExpenseCell.self, forCellWithReuseIdentifier: AddExpenseCell.reuseID)
    }
    
    func configureUI() {
        collectionView.backgroundColor = .systemBackground
        navigationItem.title = String(localized: "years-view.navigation-item.title") // change this to be more descriptive
        
        let settingsItem = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"),
                                           style: .plain, target: self, action: #selector(settingsButtonTapped))
        settingsItem.tintColor = .label
        navigationItem.rightBarButtonItem = settingsItem
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
        let expenseYears = ExpensesHelper.getExpenseYears(expenses)
        
        cellTypes = [CellType.addExpense]
        
        cellTypes.append(contentsOf: expenseYears.map { year in
            CellType.expenseYear(year)
        })
        
        expensesByYear = ExpensesHelper.getExpensesByYear(expenses)
        collectionView.reloadData()
    }
    
    func addExpenseCellTapped() {
        let formVC = UIHostingController(rootView: AddExpenseForm() { expenseAdded in
            self.dismiss(animated: true)
            
            if expenseAdded {
                self.rotateAddExpenseCellImage()
            }
        })
        formVC.modalPresentationStyle = .fullScreen
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.present(formVC, animated: true)
        }
    }
    
    func rotateAddExpenseCellImage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let cell = self.collectionView.visibleCells.compactMap({ $0 as? AddExpenseCell }).first
            cell?.rotateImage()
        }
    }
    
    func yearCellTapped(year: Int) {
        let filteredExpenses = expensesByYear[year]!
        selectedYear = year
        
        monthsVC = MonthsViewController(year: year, expenses: filteredExpenses, yearsVCDelegate: self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.navigationController?.pushViewController(self.monthsVC!, animated: true)
        }
    }
}

extension YearsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = cellTypes[indexPath.item]
        
        switch cellType {
        case .addExpense:
            return collectionView.dequeueReusableCell(withReuseIdentifier: AddExpenseCell.reuseID, for: indexPath)
        case .expenseYear(let year):
            let filteredExpenses = expensesByYear[year]!
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YearCell.reuseID, for: indexPath) as! YearCell
            cell.set(expenses: filteredExpenses, yearNumber: year)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellType = cellTypes[indexPath.item]
        
        switch cellType {
        case .addExpense:
            addExpenseCellTapped()
        case .expenseYear(let year):
            yearCellTapped(year: year)
        }
    }
}

extension YearsViewController: YearsViewControllerDelegate {
    func expenseAdded() {
        fetchFilteredExpenses()
    }
    
    func expenseUpdated() {
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
