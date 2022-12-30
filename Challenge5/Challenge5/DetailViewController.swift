//
//  DetailViewController.swift
//  Challenge5
//
//  Created by Дария Григорьева on 29.12.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let labelFlag: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(named: "Color")
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 300)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        return label
    }()
    
    private let labelCapital: UILabel = {
        let label = UILabel()
        label.text = "Capital"
        label.font = UIFont(name: "Arial Hebrew", size: 30)
        return label
    }()
    
    private let labelName: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont(name: "Arial Hebrew", size: 30)
        label.numberOfLines = 2
        return label
    }()
    
    private let labelPopulation: UILabel = {
        let label = UILabel()
        label.text = "Population"
        label.font = UIFont(name: "Arial Hebrew", size: 30)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = UIColor(named: "Color")
        navigationItem.largeTitleDisplayMode = .never
        setupView()
    }
    
    func configureView(config: ConfigureDetailVC) {
        labelFlag.text = config.flag
        labelName.text = "Official name: \(config.name)"
        labelCapital.text = "Capital: \(config.capital ?? "")"
        labelPopulation.text = "Population: \(String(config.population))"
        title = config.name
    }
    
    private func setupView() {
        view.addSubview(labelFlag)
        view.addSubview(labelName)
        view.addSubview(labelCapital)
        view.addSubview(labelPopulation)
        
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelFlag.translatesAutoresizingMaskIntoConstraints = false
        labelCapital.translatesAutoresizingMaskIntoConstraints = false
        labelPopulation.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelFlag.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            labelFlag.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            labelFlag.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            labelFlag.heightAnchor.constraint(equalToConstant: 200),
            
            labelName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            labelName.topAnchor.constraint(equalTo: labelFlag.bottomAnchor, constant: 30),
            labelName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            labelName.heightAnchor.constraint(equalToConstant: 80),
            
            labelCapital.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 30),
            labelCapital.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            labelCapital.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            labelCapital.heightAnchor.constraint(equalToConstant: 80),
            
            labelPopulation.topAnchor.constraint(equalTo: labelCapital.bottomAnchor, constant: 30),
            labelPopulation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            labelPopulation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            labelPopulation.heightAnchor.constraint(equalToConstant: 80)
    
        
        ])
    }
}
