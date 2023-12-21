//
//  SettingsViewController.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 10/11/23.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    enum RowContent: CaseIterable {
        case signOut
        case deleteAccount
        
        var text: String {
            switch self {
            case .signOut:
                return "Sign Out"
            case .deleteAccount:
                return "Delete Account"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Settings"
        
        let tableView = UITableView(frame: view.bounds)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: SettingsCell.reuseId)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RowContent.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseId, for: indexPath)
        let rowContent = RowContent.allCases[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = rowContent.text
        config.textProperties.alignment = .center
        config.textProperties.color = .scarletRed
        
        cell.contentConfiguration = config
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rowContent = RowContent.allCases[indexPath.row]
        
        switch rowContent {
        case .signOut:
            signOutRowTapped()
        case .deleteAccount:
            deleteAccountRowTapped()
        }
    }
    
    func signOutRowTapped() {
        NetworkManager.shared.signOut { error in
            DispatchQueue.main.async {
                let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
                sceneDelegate?.userSignedOut()
            }
        }
    }
    
    func deleteAccountRowTapped() {
        NetworkManager.shared.deleteAccount { error in
            DispatchQueue.main.async {
                let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
                sceneDelegate?.userSignedOut()
            }
        }
    }
}
