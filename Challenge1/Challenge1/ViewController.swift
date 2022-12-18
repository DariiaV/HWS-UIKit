//
//  ViewController.swift
//  Challenge1
//
//  Created by Дария Григорьева on 18.12.2022.
//

import UIKit

class ViewController: UIViewController {
    private let tableView = UITableView()
    private let cellReuseIdentifier = "cell"
    private var countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
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
extension ViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let imageCountries = countries[indexPath.row]
        cell.textLabel?.text = countries[indexPath.row].uppercased()
        cell.textLabel?.font = .systemFont(ofSize: 20)
        cell.imageView?.image = UIImage(named: imageCountries)
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        return cell
    }
    
}
extension ViewController: UITableViewDelegate {
 
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailViewController()
        detailVC.imageName = countries[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

