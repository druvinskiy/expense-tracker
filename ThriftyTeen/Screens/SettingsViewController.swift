//
//  SettingsViewController.swift
//  ThriftyTeen
//
//  Created by David Ruvinskiy on 10/11/23.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let signedOutAction: () -> ()
    
    init(signedOutAction: @escaping () -> ()) {
        self.signedOutAction = signedOutAction
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.reuseId, for: indexPath)
        
        var config = cell.defaultContentConfiguration()
        config.text = "Sign Out"
        config.textProperties.alignment = .center
        config.textProperties.color = .scarletRed
        
        cell.contentConfiguration = config
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        NetworkManager.shared.signOut { error in
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    self.signedOutAction()
                }
            }
        }
    }
}
