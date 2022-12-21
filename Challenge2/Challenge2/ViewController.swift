//
//  ViewController.swift
//  Challenge2
//
//  Created by Дария Григорьева on 20.12.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let tableView = UITableView()
    private let cellReuseIdentifier = "cell"
    private var shoppingList = ["Apple", "Milk", "Orange juice"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        title = "Shopping List"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
        rightItem.tintColor = .white
        navigationItem.rightBarButtonItem = rightItem
        let leftItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareShoppingList))
        leftItem.tintColor = .white
        navigationItem.leftBarButtonItem = leftItem
        
        
        
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = view.frame
        tableView.backgroundColor = UIColor(named: "backgroundColor")
    }
    
    @objc private func addNewItem() {
        let alertVC = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .alert)
        alertVC.addTextField { textField in
            textField.placeholder = "Create new item"
        }
        let action = UIAlertAction(title: "Add Item", style: .default) { [weak self] _ in
            guard let self else {
                return
            }
            
            if let text = alertVC.textFields?.first?.text, !text.isEmpty {
                self.shoppingList.append(text)
                self.tableView.insertRows(at: [IndexPath(row: self.shoppingList.count - 1, section: 0)], with: .automatic)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alertVC.addAction(action)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true)
    }
    
    @objc private func shareShoppingList() {
        let shoppingList = shoppingList.joined(separator: "\n")
        let vc = UIActivityViewController(activityItems: ["Shopping list:", shoppingList], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc,animated: true)
    }
    
}

extension ViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shoppingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        cell.backgroundColor = UIColor(named: "backgroundColor")
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
