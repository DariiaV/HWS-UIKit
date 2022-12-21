//
//  ViewController.swift
//  Project7
//
//  Created by Дария Григорьева on 21.12.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let tableView = UITableView()
    private let cellReuseIdentifier = "cell"
    private var savedPetitions = [Petition]()
    private var filterPetitions = [Petition]()
    
    private var urlString: String {
        if navigationController?.tabBarItem.tag == 0 {
            return "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            return "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationItem()
        parseURLJSON()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = view.frame
    }
    
    private func setupNavigationItem() {
        let rightItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showCredits))
        navigationItem.rightBarButtonItem = rightItem
        
        let filterItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showFilter))
        let cancelFilterItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                               target: self,
                                               action: #selector(cancelFilterSearch))
        
        navigationItem.leftBarButtonItems = [filterItem, cancelFilterItem]
    }
    
    
    private func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading he feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    private func parseURLJSON() {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { [weak self] (data, response, error) in
                if error != nil {
                    self?.showError()
                    return
                }
                if let safeData = data {
                    self?.parse(json: safeData)
                }
            }
            task.resume()
        }
    }
    
    private func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            filterPetitions = jsonPetitions.results
            savedPetitions = filterPetitions
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc private func showCredits() {
        let vc = UIAlertController(title: "Credits", message: "We The People API of the Whitehouse", preferredStyle: .alert)
        vc.addAction(UIAlertAction(title: "OK", style: .default))
        present(vc, animated: true)
    }
    
    @objc private func showFilter() {
        let alert = UIAlertController(title: "Filter search", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter the word"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak alert, weak self] _ in
            guard let self else {
                return
            }
            
            if let text = alert?.textFields?.first?.text,
               !text.isEmpty {
                self.filterPetitions = self.savedPetitions.filter { $0.title.lowercased().contains(text.lowercased()) }
                self.tableView.reloadData()
            }
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    @objc private func cancelFilterSearch() {
        filterPetitions = savedPetitions
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filterPetitions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let petition = filterPetitions[indexPath.row]
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseIdentifier)
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        vc.detailItem = filterPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
