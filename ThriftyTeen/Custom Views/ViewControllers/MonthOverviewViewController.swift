//
//  MonthOverviewViewController.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 4/13/23.
//

import UIKit

class MonthOverviewViewController: UIViewController {
    lazy var collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionView.createTwoColumnFlowLayout(in: view))
    
    var viewModels: [OverviewCellViewModel]
    
    init(viewModels: [OverviewCellViewModel]) {
        self.viewModels = viewModels
        
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
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let collectionViewItemHeight = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.height
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: collectionViewItemHeight)
        ])
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MonthOverviewCell.self, forCellWithReuseIdentifier: MonthOverviewCell.reuseID)
    }
}

extension MonthOverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthOverviewCell.reuseID, for: indexPath) as! MonthOverviewCell
        let viewModel = viewModels[indexPath.item]
        cell.set(viewModel: viewModel)
        return cell
    }
}
