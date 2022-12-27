//
//  UserImageCell.swift
//  Challenge4
//
//  Created by Дария Григорьева on 27.12.2022.
//

import UIKit

class UserImageCell: UITableViewCell {
    
    private lazy var userImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor(named: "textColor")?.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 3
        return imageView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Label"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = UIColor(named: "textColor")
        label.font = UIFont(name: "Marker Felt", size: 30)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(name: String, image: UIImage?) {
        nameLabel.text = name
        userImage.image = image
    }
    
    private func configure() {
        addSubview(userImage)
        addSubview(nameLabel)
        userImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            userImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            userImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            userImage.widthAnchor.constraint(equalTo: userImage.heightAnchor),
            
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            nameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
