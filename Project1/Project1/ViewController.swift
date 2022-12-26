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
    private var pictureManager = PictureManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
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
  
}

extension ViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pictureManager.getPicturesCount()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = pictureManager.getImageName(index: indexPath.row)
        cell.textLabel?.font = .systemFont(ofSize: 20)
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
 
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailViewController()
        let pictureTitle = pictureManager.getImageName(index: indexPath.row)
        detailVC.imageName = pictureTitle
        detailVC.titleName = pictureManager.getPicktureTitle(indexPath.row)
        navigationController?.pushViewController(detailVC, animated: true)
        
        pictureManager.setImageTapCount(indexPath.row)
        print(pictureManager.getImageTapCount(index: indexPath.row))
    }
}
