//
//  ViewController.swift
//  Challenge3
//
//  Created by Дария Григорьева on 23.12.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let alphabetArray = Array("абвгдеёжзийклмнопрстуфхцчшщъыьэюя")
    private let hiddenWords = ["ребус", "салют", "семья", "вагон", "альфа", "ветер", "бальзам"]
    private var hiddenWord = ""
    private var promptWord = ""
    
    private var score = 0 {
        didSet {
            scoreLabel.text = "Счёт: \(score)"
        }
    }
    private var attempt = 7 {
        didSet {
            attempts.text = "Попытки: \(attempt)"
        }
    }
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.text = "Счёт: 0"
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    private let attempts: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Попытки: 7"
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    private let wordLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "?????"
        label.font = .systemFont(ofSize: 40, weight: .heavy)
        label.textColor = UIColor(named: "textColor")
        return label
    }()
    
    private let buttonsView: UIView = {
        let buttonsView = UIView()
//        buttonsView.backgroundColor = UIColor(named: "buttonsviewcolor")
        return buttonsView
    }()
    private var alphabetButtons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "background")
        title = "Угадай слово"
        
        setupView()
        setupButtonsView()
        setLetterButtons()
        loadLevel()
    }
    
    private func setupView() {
        view.addSubview(scoreLabel)
        view.addSubview(attempts)
        view.addSubview(wordLabel)
        view.addSubview(buttonsView)
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        attempts.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            attempts.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            attempts.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            
            wordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            wordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            wordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            wordLabel.heightAnchor.constraint(equalToConstant: 50),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 350),
            buttonsView.heightAnchor.constraint(equalToConstant: 450),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 20),
            
        ])
    }
    
    private func setupButtonsView() {
        let width = 70
        let height = 64
        
        for row in 0 ..< 7 {
            for column in 0 ..< 5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
                letterButton.setTitleColor(UIColor(named: "textColor"), for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                letterButton.isHidden = true
                
                buttonsView.addSubview(letterButton)
                alphabetButtons.append(letterButton)
            }
        }
    }
    
    @objc private func letterTapped(_ sender: UIButton) {
        guard let letter = sender.titleLabel?.text?.lowercased() else {
            return
        }
        
        if hiddenWord.contains(letter) {
            sender.isHidden = true
            updatePromptWord(letter: letter)
        } else {
            sender.setTitleColor(.red, for: .normal)
            sender.isUserInteractionEnabled = false
            
            attempt -= 1
            
            if attempt == 0 {
               showAlert(with: "Вы проиграли!", isWon: false)
            }
           
        }
    }
    
    private func updatePromptWord(letter: String) {
        var characterArray = Array(promptWord)
        for (index, character) in hiddenWord.enumerated() {
            if String(character) == letter {
                characterArray[index] = Character(letter)
            }
        }
        promptWord = String(characterArray)
        wordLabel.text = promptWord
        
        if promptWord == hiddenWord {
            showAlert(with: "Вы угадали!", isWon: true)
        }
    }
    
    private func setLetterButtons() {
        for i in 0 ..< alphabetArray.count {
            let letter = alphabetArray[i].uppercased()
            let button = alphabetButtons[i]
            button.setTitle(String(letter), for: .normal)
            button.isHidden = false
        }
    }
    
    private func loadLevel() {
        guard let randomWord = hiddenWords.randomElement() else {
            return
        }
        
        hiddenWord = randomWord.lowercased()
        promptWord = String(repeating: "?", count: hiddenWord.count)
        wordLabel.text = promptWord
        attempt = 7
        for alphabetButton in alphabetButtons {
            alphabetButton.isUserInteractionEnabled = true
            alphabetButton.setTitleColor(UIColor(named: "textColor"), for: .normal)
            alphabetButton.isHidden = false
        }
    }
    
    
    private func showAlert(with title: String, isWon: Bool) {
        let vc = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {[weak self] _ in
            self?.loadLevel()
            self?.score += isWon ? 1 : -1
        }
        vc.addAction(okAction)
        present(vc, animated: true)
    }
    
}
