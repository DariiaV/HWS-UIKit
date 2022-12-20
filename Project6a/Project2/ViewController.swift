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
    private let rightBarItem = UIBarButtonItem()
    
    private var button1ConstraintsCommon = [NSLayoutConstraint]()
    private var button1ConstraintsLandscape = [NSLayoutConstraint]()
    private var button2ConstraintsCommon = [NSLayoutConstraint]()
    private var button2ConstraintsLandscape = [NSLayoutConstraint]()
    private var button3ConstraintsCommon = [NSLayoutConstraint]()
    private var button3ConstraintsLandscape = [NSLayoutConstraint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hexString: "F0DBDB")
        addButtonsToView()
        setupButton1Constraint()
        setupButton2Constraint()
        setupButton3Constraint()
        askQuestion()
        setupNavigationItem()
    }
    
    override func viewWillTransition(to: CGSize, with: UIViewControllerTransitionCoordinator){
        super.viewWillTransition(to: to, with: with)
        
        changeConstraintToLandscape()
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
        let ac = UIAlertController(title: "Your final score is \(score)",
                                   message: nil,
                                   preferredStyle: .alert)
        let restart = UIAlertAction(title: "Restart",
                                    style: .destructive) { [weak self] _ in
            self?.askQuestion()
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
}

extension ViewController {
    
    // MARK: - Setup Constraints
    
    private func addButtonsToView() {
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        
        button1.translatesAutoresizingMaskIntoConstraints = false
        button2.translatesAutoresizingMaskIntoConstraints = false
        button3.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupButton1Constraint() {
        let guide = view.safeAreaLayoutGuide
       
        button1ConstraintsCommon = [
            button1.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            button1.heightAnchor.constraint(equalTo: button1.widthAnchor, multiplier: 1/2),
            button1.widthAnchor.constraint(equalToConstant: 200),
            button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
        
        button1ConstraintsLandscape = [
            button1.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4),
            button1.heightAnchor.constraint(equalTo: button1.widthAnchor, multiplier: 1/2),
            button1.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            button1.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(button1ConstraintsCommon)
    }
    
    private func setupButton2Constraint() {
        button2ConstraintsCommon = [
            button2.topAnchor.constraint(equalTo: button1.topAnchor, constant: 150),
            button2.heightAnchor.constraint(equalToConstant: 100),
            button2.widthAnchor.constraint(equalToConstant: 200),
            button2.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        button2ConstraintsLandscape = [
            button2.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4),
            button2.heightAnchor.constraint(equalTo: button2.widthAnchor, multiplier: 1/2),
            button2.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button2.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate(button2ConstraintsCommon)
    }
    
    private func setupButton3Constraint() {
        let guide = view.safeAreaLayoutGuide
        
        button3ConstraintsCommon = [
            button3.topAnchor.constraint(equalTo: button2.topAnchor, constant: 150),
            button3.heightAnchor.constraint(equalToConstant: 100),
            button3.widthAnchor.constraint(equalToConstant: 200),
            button3.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        
        button3ConstraintsLandscape = [
            button3.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4),
            button3.heightAnchor.constraint(equalTo: button3.widthAnchor, multiplier: 1/2),
            button3.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            button3.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(button3ConstraintsCommon)
    }
    
    private func changeConstraintToLandscape() {
        if UIDevice.current.orientation.isLandscape {
            NSLayoutConstraint.activate(button1ConstraintsLandscape)
            NSLayoutConstraint.activate(button2ConstraintsLandscape)
            NSLayoutConstraint.activate(button3ConstraintsLandscape)
            NSLayoutConstraint.deactivate(button1ConstraintsCommon)
            NSLayoutConstraint.deactivate(button2ConstraintsCommon)
            NSLayoutConstraint.deactivate(button3ConstraintsCommon)
        } else {
            NSLayoutConstraint.deactivate(button1ConstraintsLandscape)
            NSLayoutConstraint.deactivate(button2ConstraintsLandscape)
            NSLayoutConstraint.deactivate(button3ConstraintsLandscape)
            NSLayoutConstraint.activate(button1ConstraintsCommon)
            NSLayoutConstraint.activate(button2ConstraintsCommon)
            NSLayoutConstraint.activate(button3ConstraintsCommon)
        }
    }
}
