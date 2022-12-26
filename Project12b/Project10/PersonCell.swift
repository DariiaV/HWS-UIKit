//
//  PersonCell.swift
//  Project10
//
//  Created by Дария Григорьева on 24.12.2022.
//

import UIKit

class PersonCell: UICollectionViewCell {
    
    private lazy var  imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 3
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Label"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .black
        label.font = UIFont(name: "Marker Felt", size: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(name: String, image: UIImage?) {
        nameLabel.text = name
        imageView.image = image
    }
    
    private func configure() {
        addSubview(imageView)
        addSubview(nameLabel)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
