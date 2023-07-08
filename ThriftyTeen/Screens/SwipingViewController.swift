//
//  SwipingViewController.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 3/5/23.
//

import UIKit

class SwipingViewController: UIViewController {
    enum Mode {
        case month
        case week
    }
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    }()
    
    var shouldScroll = true
    var isScrollingAnimated = false
    
    var allExpenses: [Expense]
    var expensesByWeek: [WeekExpenseRange]
    var expensesByMonth: [Int: [Expense]]
    var month: Int
    var week: Int
    let year: Int
    
    lazy var mode = Mode.month
    
    let yearsVCDelegate: YearsViewControllerDelegate
    
    init(allExpenses: [Expense], yearNumber: Int, monthNumber: Int, yearsVCDelegate: YearsViewControllerDelegate) {
        self.allExpenses = allExpenses
        self.month = monthNumber
        self.year = yearNumber
        self.yearsVCDelegate = yearsVCDelegate
        
        self.week = ExpensesHelper.firstWeekNumber(year: yearNumber, month: monthNumber)
        self.expensesByWeek = ExpensesHelper.getExpensesByWeek(allExpenses, year: yearNumber)
        self.expensesByMonth = ExpensesHelper.getExpensesByMonth(for: allExpenses)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var closeButton: UIButton = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 16.0, weight: .regular)
        let plusImage = UIImage(systemName: "xmark", withConfiguration: configuration)?
            .withTintColor(.label, renderingMode: .alwaysOriginal)
        
        var plusConfiguration = UIButton.Configuration.borderless()
        plusConfiguration.image = plusImage
        
        let actionButton = UIButton(configuration: plusConfiguration, primaryAction: UIAction(handler: {_ in
            self.dismiss(animated: true)
        }))
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        return actionButton
    }()
    
    lazy var calendarButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseBackgroundColor = .deepForestGreen
        configuration.baseForegroundColor = .white
        configuration.image = UIImage(systemName: "calendar", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .regular))
        
        let actionButton = UIButton(configuration: configuration)
        
        let add = UIAction(title: "Month") { (action) in
            self.mode = .month
            self.shouldScroll = true
            self.collectionView.reloadData()
        }
        
        let edit = UIAction(title: "Week") { (action) in
            guard self.mode != .week else { return }
            
            self.mode = .week
            self.shouldScroll = true
            self.collectionView.reloadData()
        }
        
        let menu = UIMenu(children: [add, edit])
        actionButton.menu = menu
        actionButton.showsMenuAsPrimaryAction = true
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        return actionButton
    }()
    
    lazy var rightArrow: UIButton = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 16.0, weight: .regular)
        let plusImage = UIImage(systemName: "arrow.right", withConfiguration: configuration)?
            .withTintColor(.label, renderingMode: .alwaysOriginal)
        
        var plusConfiguration = UIButton.Configuration.borderless()
        plusConfiguration.image = plusImage
        
        let actionButton = UIButton(configuration: plusConfiguration, primaryAction: UIAction(handler: {_ in
            switch self.mode {
            case .month:
                guard self.month < self.expensesByMonth.count else { return }
                self.month += 1
                self.week = ExpensesHelper.firstWeekNumber(year: self.year, month: self.month)
            case .week:
                guard self.week < self.expensesByWeek.count else { return }
                self.week += 1
                self.month = ExpensesHelper.monthNumber(year: self.year, weekNumber: self.week)
            }
            
            self.isScrollingAnimated = true
            self.shouldScroll = true
            self.view.layoutSubviews()
        }))
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        return actionButton
    }()
    
    lazy var leftArrow: UIButton = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 16.0, weight: .regular)
        let plusImage = UIImage(systemName: "arrow.left", withConfiguration: configuration)?
            .withTintColor(.label, renderingMode: .alwaysOriginal)
        
        var plusConfiguration = UIButton.Configuration.borderless()
        plusConfiguration.image = plusImage
        
        let actionButton = UIButton(configuration: plusConfiguration, primaryAction: UIAction(handler: {_ in
            switch self.mode {
            case .month:
                guard self.month > 1 else { return }
                self.month -= 1
                self.week = ExpensesHelper.firstWeekNumber(year: self.year, month: self.month)
            case .week:
                guard self.week > 1 else { return }
                self.week -= 1
                self.month = ExpensesHelper.monthNumber(year: self.year, weekNumber: self.week)
            }
            
            self.isScrollingAnimated = true
            self.shouldScroll = true
            self.view.layoutSubviews()
        }))
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        return actionButton
    }()
    
    let leftFloatingButton: UIButton = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 24.0, weight: .bold)
        let plusImage = UIImage(systemName: "pencil", withConfiguration: configuration)?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        
        var plusConfiguration = UIButton.Configuration.filled()
        plusConfiguration.baseBackgroundColor = .systemRed
        plusConfiguration.image = plusImage
        plusConfiguration.cornerStyle = .capsule
        
        let actionButton = UIButton(configuration: plusConfiguration, primaryAction: UIAction(handler: {_ in
            print("test")
        }))
        
        actionButton.translatesAutoresizingMaskIntoConstraints = false
         
        return actionButton
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard shouldScroll else { return }
        
        let indexPath: IndexPath
        
        switch mode {
        case .week:
            indexPath = IndexPath(row: week - 1, section: 0)
        case .month:
            indexPath = IndexPath(item: month - 1, section: 0)
        }
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: isScrollingAnimated)
        shouldScroll = false
        isScrollingAnimated = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        layoutUI()
    }
    
    func configureCollectionView() {
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: PageCell.reuseID)
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func layoutUI() {
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(calendarButton)
        view.addSubview(rightArrow)
        view.addSubview(leftArrow)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            calendarButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            calendarButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarButton.widthAnchor.constraint(equalToConstant: 50),
            calendarButton.heightAnchor.constraint(equalToConstant: 50),
            
            rightArrow.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            rightArrow.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            leftArrow.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            leftArrow.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
        ])
    }
    
    func dataUpdated(expenses: [Expense]) {
        self.allExpenses = expenses
        self.expensesByWeek = ExpensesHelper.getExpensesByWeek(allExpenses, year: year)
        self.expensesByMonth = ExpensesHelper.getExpensesByMonth(for: allExpenses)
        
        collectionView.reloadData()
        
    }
}

extension SwipingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch mode {
        case .week:
            return expensesByWeek.count
        case .month:
            return expensesByMonth.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let innerVC: UIViewController
        switch mode {
        case .week:
            let weekExpenseRange = expensesByWeek[indexPath.row]
            innerVC = WeekExpensesListViewController(weekExpenseRange: weekExpenseRange)
        case .month:
            let monthNumber = indexPath.row + 1
            let expensesForMonth = expensesByMonth[monthNumber]!
            innerVC = MonthExpensesListViewController(expenses: expensesForMonth, month: monthNumber, yearsVCDelegate: yearsVCDelegate)
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.reuseID, for: indexPath) as! PageCell
        
        cell.set(innerVC: innerVC)
        addChild(cell.innerVC)
        cell.innerVC.didMove(toParent: self)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let page = Int(x / view.frame.width)
        
        switch mode {
        case .month:
            month = page + 1
            week = ExpensesHelper.firstWeekNumber(year: year, month: month)
        case .week:
            week = page + 1
            month = ExpensesHelper.monthNumber(year: year, weekNumber: page + 1)
        }
    }
}
