//
//  ViewController.swift
//  Challenge8
//
//  Created by Дария Григорьева on 09.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private let buttonsView: UIView = {
        let buttonsView = UIView()
        buttonsView.backgroundColor = UIColor(named: "backgroundColor")
        return buttonsView
    }()
    
    private var imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor(named: "backgroundColor")
        image.tintColor = UIColor(named: "buttonColor")
        image.image = UIImage(systemName: "person.fill.questionmark")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var restartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "buttonColor")
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(getRestart(_:)), for: .touchUpInside)
        return button
    }()

    private var imagesName = [
        "sun.max",
        "sun.max",
        "moon.haze.circle.fill",
        "moon.haze.circle.fill",
        "moon.stars.circle.fill",
        "moon.stars.circle.fill",
        "cloud.snow.fill",
        "cloud.snow.fill",
        "house.fill",
        "house.fill",
        "alarm.waves.left.and.right.fill",
        "alarm.waves.left.and.right.fill",
        "heart.fill",
        "heart.fill",
        "lasso.and.sparkles",
        "lasso.and.sparkles",
    ]
    private var isGameStart = false
    private var imageButtons = [UIButton]()
    private var saveButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        setupView()
        setupNavigation()
    }
    
    private func setupView() {
        view.addSubview(buttonsView)
        view.addSubview(imageView)
        view.addSubview(restartButton)
        
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            buttonsView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            buttonsView.heightAnchor.constraint(equalTo: buttonsView.widthAnchor),
            
            restartButton.topAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: 20),
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restartButton.widthAnchor.constraint(equalToConstant: 100),
        
        ])
    }
    
    private func setupNavigation() {
        title = "Guess the picture"
    }

    private func setupButtonsView() {
        if isGameStart {
            return
        }
        imagesName.shuffle()
        let space: CGFloat = 1
        let width = buttonsView.bounds.width / 4 - space
        let height = buttonsView.bounds.height / 4 - space
        var index = -1
        for row in 0 ..< 4 {
            for column in 0 ..< 4 {
                index += 1
                let column = CGFloat(column)
                let row = CGFloat(row)
                let button = UIButton(type: .system)
                button.backgroundColor = UIColor(named: "buttonColor")
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                
                
                let frame = CGRect(x: column * width + (space * column+1),
                                   y: row * height + (space * row+1),
                                   width: width,
                                   height: height)
                
                button.frame = frame
                button.tag = index
                button.tintColor = UIColor(named: "buttonColor")
                button.imageView?.contentMode = .scaleAspectFit
                button.imageView?.isHidden = false
                    
                buttonsView.addSubview(button)
                imageButtons.append(button)
            }
        }
        isGameStart = true
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 100, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: imagesName[sender.tag], withConfiguration: largeConfig)
        if sender.currentImage == nil {
            sender.setImage(largeBoldDoc, for: .normal)
            sender.backgroundColor = UIColor(named: "tappedColor")
        } else {
            sender.backgroundColor = UIColor(named: "buttonColor")
            sender.setImage(nil, for: .normal)
        }
        
        if saveButton != nil {
            imageButtons.forEach { $0.isUserInteractionEnabled = false }
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                self.checkCurrentButton(button: sender)
            }
        } else {
            saveButton = sender
        }
    }
    
    private func checkCurrentButton(button: UIButton) {
        if saveButton?.currentImage == button.currentImage {
            saveButton?.isHidden = true
            button.isHidden = true
            button.setImage(nil, for: .normal)
            saveButton?.setImage(nil, for: .normal)
            imageView.image = UIImage(systemName: "checkmark.seal.fill")
        } else {
            button.backgroundColor = UIColor(named: "buttonColor")
            button.setImage(nil, for: .normal)
            saveButton?.backgroundColor = UIColor(named: "buttonColor")
            saveButton?.setImage(nil, for: .normal)
            imageView.image = UIImage(systemName: "multiply.circle.fill")
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
            self.imageView.image = UIImage(systemName: "person.fill.questionmark")
        }
        saveButton = nil
        imageButtons.forEach { $0.isUserInteractionEnabled = true }
    }
    
    @objc private func getRestart(_ sender: UIButton) {
        if !isGameStart {
            sender.setTitle("Restart", for: .normal)
            setupButtonsView()
        }
        
        imagesName.shuffle()
        imageButtons.forEach { button in
            button.isHidden = false
            button.backgroundColor = UIColor(named: "buttonColor")
            button.isUserInteractionEnabled = true
        }
    }

}

