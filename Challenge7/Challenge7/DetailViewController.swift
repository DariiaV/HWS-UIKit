//
//  DetailViewController.swift
//  Challenge7
//
//  Created by Дария Григорьева on 07.01.2023.
//

import UIKit

class DetailViewController: UIViewController {
    var image: UIImage?
    
    private lazy var  imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 3
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "Color")
        setupView()
        setupNavigationItem()
        imageView.image = image
    }
    
    private func setupView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
    
    private func setupNavigationItem() {
        let shared = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        shared.tintColor = UIColor(named: "textColor")
        navigationItem.rightBarButtonItems = [shared]
    }
    
    @objc private func shareTapped() {
        guard let image else {
            return
        }
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc,animated: true)
    }
}
