//
//  ViewController.swift
//  Project2
//
//  Created by Дария Григорьева on 17.12.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private var countries = ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    private var score = 0
    private var correctAnswer = 0
    private var answerCount = 10
    
    private lazy var button1: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        button.tag = 0
        return button
    }()
    
    private lazy var button2: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        button.tag = 1
        return button
    }()
    
    private lazy var button3: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(buttonDidTap(_:)), for: .touchUpInside)
        button.tag = 2
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hexString: "F0DBDB")
        setupButtons()
        askQuestion()
        setupRightNavigationItem()
    }
    
    private func setupRightNavigationItem() {
        let rightBarItem = UIBarButtonItem(title: "Show score",
                                           style: .plain,
                                           target: self,
                                           action: #selector(rightBarButtonDidTapped))
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    private func setupButtons() {
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        
        button1.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false
        button3.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button1.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            button1.heightAnchor.constraint(equalToConstant: 100),
            button1.widthAnchor.constraint(equalToConstant: 200),
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button2.topAnchor.constraint(equalTo: button1.topAnchor, constant: 150),
            button2.heightAnchor.constraint(equalToConstant: 100),
            button2.widthAnchor.constraint(equalToConstant: 200),
            button2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button3.topAnchor.constraint(equalTo: button2.topAnchor, constant: 150),
            button3.heightAnchor.constraint(equalToConstant: 100),
            button3.widthAnchor.constraint(equalToConstant: 200),
            button3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
        ])
    }
    
    private func askQuestion(action: UIAlertAction? = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
        
    }
    
    @objc private func buttonDidTap(_ sender: UIButton) {
        answerCount -= 1
        
        let title: String
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! That’s the flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        if answerCount == 0 {
            showFinalScore()
        } else {
            showQuestionAlert(with: title)
        }
    }
    
    private func showFinalScore() {
        let title = "Your final score is \(score)"
        let restart = UIAlertAction(title: "Restart",
                                    style: .destructive) { _ in
            self.askQuestion()
        }
        
        showAlert(title: title, message: nil, action: restart)
        score = 0
        answerCount = 10
    }
    
    private func showQuestionAlert(with title: String) {
        let message = "Your score is \(score)."
        let action = UIAlertAction(title: "Continue",
                                   style: .default,
                                   handler: askQuestion)
        showAlert(title: title, message: message, action: action)
    }
    
    @objc private func rightBarButtonDidTapped() {
        let title = "Your score is \(score)."
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        showAlert(title: title, message: nil, action: okAction)
    }
    
    private func showAlert(title: String, message: String?, action: UIAlertAction) {
        let ac = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: .alert)
        
        ac.addAction(action)
        present(ac, animated: true)
    }
}

