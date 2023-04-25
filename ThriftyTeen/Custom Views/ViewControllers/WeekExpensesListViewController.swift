//
//  WeekExpensesListVC.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/5/23.
//

import UIKit

class WeekExpensesListViewController: UIViewController {
    lazy var collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionView.createOneColumnFlowLayout(in: view))
    let overviewView = WeekOverviewView()
    
    let weekExpenseRange: WeekExpenseRange
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureCollectionView()
        layoutUI()
        overviewView.set(weekExpenseRange: weekExpenseRange)
    }
    
    init(weekExpenseRange: WeekExpenseRange) {
        self.weekExpenseRange = weekExpenseRange
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
    }
    
    func configureCollectionView() {
        collectionView.backgroundColor = .zircon
        collectionView.register(ExpenseCell.self, forCellWithReuseIdentifier: ExpenseCell.reuseID)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func layoutUI() {
        view.addSubview(overviewView)
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            overviewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            overviewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overviewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: overviewView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension WeekExpensesListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekExpenseRange.expenses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpenseCell.reuseID, for: indexPath) as! ExpenseCell
        let expense = weekExpenseRange.expenses[indexPath.row]
        cell.set(expense: expense)
        return cell
    }
}
