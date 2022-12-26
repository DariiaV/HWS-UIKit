//
//  ViewController.swift
//  Project5
//
//  Created by Дария Григорьева on 19.12.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private var allWords = [String]()
    private var usedWords = [String]()
    
    private let tableView = UITableView()
    private let cellReuseIdentifier = "cell"
    private var isNewGame = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationItem()
        searchStartWordsUrl()
        startGame()
        isNewGame = false
        
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = view.frame
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Restart game", style: .plain, target: self, action: #selector(startGame))
    }
    
    private func searchStartWordsUrl() {
        if let startWordsUrl = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsUrl) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
    }
    
    @objc private func startGame() {
        if let word = loadWord(),
           isNewGame {
            title = word
            usedWords = loadWords()
        } else {
            let newWord = allWords.randomElement()
            title = newWord
            saveNewWord(word: newWord)
            saveWords(words: [])
            usedWords.removeAll(keepingCapacity: true)
        }
        tableView.reloadData()
        
    }
    
    private func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        guard let title else {
            return
        }
        
        guard isPossible(word: lowerAnswer) else {
            showErrorMessage(errorTitle: "Word not possible",
                             errorMessage: "You can't spell that word from \(title.lowercased()).")
            return
        }
        
        guard isOriginal(word: lowerAnswer) else {
            showErrorMessage(errorTitle: "Word already used", errorMessage: "Be more original!")
            return
        }
            
        guard isReal(word: lowerAnswer) else {
            showErrorMessage(errorTitle: "Word not recognized", errorMessage: "You can't just make them up, you know!")
            return
        }
        
        usedWords.insert(lowerAnswer, at: 0)
        saveWords(words: usedWords)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    private func showErrorMessage(errorTitle: String, errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style: .default))
        present(ac, animated: true)
    }
    
    private func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    private func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    private func isReal(word: String) -> Bool {
        if let title,
           title == word || word.count < 3 {
            return false
        }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    @objc private func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let answer = ac?.textFields?.first?.text else {
                return
            }
            
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
        
    }
    
    private func saveNewWord(word: String?) {
        guard let word else {
            return
        }
        
        let defaults = UserDefaults.standard
        defaults.set(word, forKey: "newWord")
    }
    
    private func loadWord() -> String? {
        let defaults = UserDefaults.standard
        
        if let word = defaults.value(forKey: "newWord") as? String {
            return word
        } else {
            return nil
        }
    }
    
    private func saveWords(words: [String]) {
        let defaults = UserDefaults.standard
        defaults.set(words, forKey: "words")
    }
    
    private func loadWords() -> [String] {
        let defaults = UserDefaults.standard
        if let words = defaults.value(forKey: "words") as? [String] {
            return words
        } else {
            return []
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        cell.textLabel?.font = .systemFont(ofSize: 20)
        return cell
    }
}
