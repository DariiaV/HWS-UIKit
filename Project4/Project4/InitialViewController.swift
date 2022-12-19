//
//  InitialViewController.swift
//  Project4
//
//  Created by Дария Григорьева on 19.12.2022.
//

import UIKit
class InitialViewController: UIViewController {
    
    private let tableView = UITableView()
    private let cellReuseIdentifier = "cell"
    private var resources = ["apple.com", "hackingwithswift.com", "github.com", "colorhunt.co", "freebiesupply.com", "www.sketchappsources.com", "www.reverso.net"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        title = "Resources"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = view.frame
        
    }
}
extension InitialViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resources.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = resources[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 20)
        return cell
    }
    
}
extension InitialViewController: UITableViewDelegate {
 
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ViewController()
        vc.webSite = resources[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

