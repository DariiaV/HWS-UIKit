//
//  ViewController.swift
//  Project15
//
//  Created by Дария Григорьева on 29.12.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private var imageView = UIImageView()
    private var currentAnimation = 0
    
    private lazy var tap: UIButton = {
        let button = UIButton()
        button.setTitle("Tap", for: .normal)
        button.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupView()
        setupImageView()
        
    }
    
    private func setupView() {
        view.addSubview(tap)
        tap.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tap.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            tap.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func setupImageView() {
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }
    
    @objc private func tapped(_ sender: UIButton) {
        sender.isHidden = true
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                break
            case 1:
                self.imageView.transform = .identity
            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
            case 3:
                self.imageView.transform = .identity
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
            case 5:
                self.imageView.transform = .identity
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = .blue
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = .clear
            default:
                break
            }
        }) { finished in
            sender.isHidden = false
        }
        
        currentAnimation += 1
        
        if currentAnimation > 7 {
            currentAnimation = 0
        }
        
    }
    
    
}

