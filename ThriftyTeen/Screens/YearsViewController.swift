//
//  YearsViewController.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/8/23.
//

import SwiftUI

class YearsViewController: UIViewController {
    lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionView.createTwoColumnFlowLayout(in: view))
    
    var expenses = [Expense]()
    var expenseYears = [Int]()
    var expensesByYear = [Int: [Expense]]()
    
    lazy var addButton: UIButton = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 36.0, weight: .regular)
        let plusImage = UIImage(systemName: "plus.circle.fill", withConfiguration: configuration)?
            .withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        
        var plusConfiguration = UIButton.Configuration.borderless()
        plusConfiguration.image = plusImage
        
        let actionButton = UIButton(configuration: plusConfiguration, primaryAction: UIAction(handler: {_ in
            let formVC = UIHostingController(rootView: AddExpenseForm() {
                self.dismiss(animated: true)
                self.getExpenses()
            })
            formVC.modalPresentationStyle = .overFullScreen
            self.present(formVC, animated: true)
        }))
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        return actionButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureViewController()
        
        getExpenses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getExpenses()
    }
    
    func configureViewController() {
        navigationItem.title = NSLocalizedString("years-view.navigation-item.title", comment: "")
        view.backgroundColor = .systemBackground
        
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(YearCell.self, forCellWithReuseIdentifier: YearCell.reuseID)
    }
    
    func getExpenses() {
        NetworkManager.shared.fetchExpenses { result in
            switch result {
            case .success(let expenses):
                self.expenses = expenses
                self.expenseYears = ExpensesHelper.getExpenseYears(expenses)
                self.expensesByYear = ExpensesHelper.getExpensesByYear(expenses)

                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(_):
                break
            }
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
        let year = expenseYears[indexPath.row]
        let filteredExpenses = expensesByYear[year]!
        
        let monthsVC = MonthsViewController(year: year, expenses: filteredExpenses)
        navigationController?.pushViewController(monthsVC, animated: true)
    }
}
