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
    private var finalScore = 0
    
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
    private let rightBarItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hexString: "F0DBDB")
        setupButtons()
        askQuestion()
        setupNavigationItem()
        loadFinalScore()
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
        
        rightBarItem.title = "Score: \(score)"
        
    }
    
    private func showFinalScore() {
        var message: String?
        if finalScore < score {
            finalScore = score
            saveFinalScore()
            message = "Your new high score is \(score) "
        }
        let ac = UIAlertController(title: "Your final score is \(score)",
                                   message: message,
                                   preferredStyle: .alert)
        let restart = UIAlertAction(title: "Restart",
                                    style: .destructive) { _ in
            self.askQuestion()
        }
        ac.addAction(restart)
        
        present(ac, animated: true)
        score = 0
        answerCount = 10
    }
    
    private func showQuestionAlert(with title: String) {
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue",
                                   style: .default,
                                   handler: askQuestion))
        
        present(ac, animated: true)
    }
    
    private func setupNavigationItem() {
        rightBarItem.title = "Score: \(score)"
        rightBarItem.tintColor = .black
        
        navigationItem.rightBarButtonItem = rightBarItem
        navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    
    private func saveFinalScore() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(finalScore) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "finalScore")
        } else {
            print("Failed to save score.")
        }
    }
    
    private func loadFinalScore() {
        let defaults = UserDefaults.standard
        if let savedFinalScore = defaults.object(forKey: "finalScore") as? Data {
            let jsonDecoder = JSONDecoder()

            do {
                finalScore = try jsonDecoder.decode(Int.self, from: savedFinalScore)
            } catch {
                print("Failed to load score")
            }
        }
    }
    
}

