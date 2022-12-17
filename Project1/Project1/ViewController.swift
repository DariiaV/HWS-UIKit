//
//  ViewController.swift
//  Project1
//
//  Created by Дария Григорьева on 17.12.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let tableView = UITableView()
    private let cellReuseIdentifier = "cell"
    private var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getItemsFromFileManager()
        
        title = "Storm Viewer"
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
    
    private func getItemsFromFileManager() {
        let fm = FileManager.default
        guard let path = Bundle.main.resourcePath,
              let items = try? fm.contentsOfDirectory(atPath: path) else {
            return
        }
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
    }
  
}

extension ViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictures.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 20)
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
 
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailViewController()
        detailVC.imageName = pictures[indexPath.row]
        detailVC.titleName = "Picture \(indexPath.row + 1) of \(pictures.count)"
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
