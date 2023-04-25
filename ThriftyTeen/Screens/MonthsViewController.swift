//
//  MonthVC.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/6/23.
//

import UIKit

class MonthsViewController: UIViewController {
    lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionView.createTwoColumnFlowLayout(in: view))
    
    let year: Int
    let expenses: [Expense]
    
    init(year: Int, expenses: [Expense]) {
        self.year = year
        self.expenses = expenses
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureCollectionView()
    }
    
    func configureViewController() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        let date = dateFormatter.date(from: "\(year)")!
        let yearText = date.formatted(Date.FormatStyle().year(.defaultDigits))
        
        navigationItem.title = yearText
        
        view.backgroundColor = .systemBackground
    }
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MonthCell.self, forCellWithReuseIdentifier: MonthCell.reuseID)
    }
}

extension MonthsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let monthRange = Calendar.current.range(of: .month, in: .year, for: Date())!
        return monthRange.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let month = indexPath.row + 1
        let filteredExpenses = ExpensesHelper.getExpensesByMonth(for: expenses)[month]!
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthCell.reuseID, for: indexPath) as! MonthCell
        cell.set(expenses: filteredExpenses, monthNumber: month)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let month = indexPath.row + 1
        let swipingVC = SwipingViewController(allExpenses: expenses, yearNumber: year, monthNumber: month)
        
        swipingVC.modalPresentationStyle = .overFullScreen
        present(swipingVC, animated: true)
    }
}
