//
//  ViewController.swift
//  Project19
//
//  Created by Дария Григорьева on 31.12.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let labelGreeting: UILabel = {
        let label = UILabel()
        label.text = "Hello, world!"
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont(name: "Noteworthy", size: 30)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupView()
    }
    
    private func setupView() {
        view.addSubview(labelGreeting)
        labelGreeting.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelGreeting.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelGreeting.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            labelGreeting.heightAnchor.constraint(equalToConstant: 200),
            labelGreeting.widthAnchor.constraint(equalToConstant: 200)
        ])
    }


}

