//
//  CountryImageCell.swift
//  Challenge5
//
//  Created by Дария Григорьева on 29.12.2022.
//

import UIKit

class CountryImageCell: UITableViewCell {
    
    private lazy var flagImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 3
        return imageView
    }()
    
    private lazy var flagLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 100)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        return label
    }()
    
    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.text = "Country"
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = UIFont(name: "Arial Hebrew", size: 20)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(flag: String, countryName: String) {
        
        flagLabel.text = flag
        countryLabel.text = countryName
    }
    
    private func configure() {
        addSubview(flagLabel)
        addSubview(countryLabel)
        flagLabel.translatesAutoresizingMaskIntoConstraints = false
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            flagLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            flagLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            flagLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            flagLabel.widthAnchor.constraint(equalTo: flagLabel.heightAnchor),
            
            countryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            countryLabel.leadingAnchor.constraint(equalTo: flagLabel.trailingAnchor, constant: 12),
            countryLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
