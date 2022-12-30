//
//  CountryViewController.swift
//  Challenge5
//
//  Created by Дария Григорьева on 29.12.2022.
//

import UIKit

class CountryViewController: UIViewController {
    
    private let tableView = UITableView()
    private let cellReuseIdentifier = "cell"
    private var countries = [Country]()
    private let manager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Country"
        setupTableView()
        
        // MARK: - Use async await
//        Task {
//            do {
//                countries = try await manager.getCountries2()
//                tableView.reloadData()
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
        manager.getCountries { result in
            switch result {
            case .success(let countries):
                DispatchQueue.main.async { [weak self] in
                    self?.countries = countries
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    private func setupTableView() {
        tableView.register(CountryImageCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.frame = view.frame
    }
    
    
}

extension CountryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? CountryImageCell else {
            return UITableViewCell()
        }
        
        let country = countries[indexPath.row]
        cell.setupCell(flag: country.flag, countryName: country.name.common)
        cell.backgroundColor = UIColor(named: "Color")
        return cell
    }
}

extension CountryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let country = countries[indexPath.row]
        let detailVC = DetailViewController()
        let config = ConfigureDetailVC(flag: country.flag,
                                       name: country.name.common,
                                       capital: country.capital?.first,
                                       population: country.population)
        detailVC.configureView(config: config)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
