//
//  DetailViewController.swift
//  Project1
//
//  Created by Дария Григорьева on 17.12.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    var imageName: String?
    var titleName: String?
    
    private lazy var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        imageView.image = UIImage(named: imageName ?? "")
        
        title = titleName
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        
        ])
    }
}
