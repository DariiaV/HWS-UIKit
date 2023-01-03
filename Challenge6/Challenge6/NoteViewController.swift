//
//  NoteViewController.swift
//  Challenge6
//
//  Created by Дария Григорьева on 02.01.2023.
//

import UIKit

class NoteViewController: UIViewController {
    
    private let tableView = UITableView()
    private let cellReuseIdentifier = "cell"
    private var notesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationView()
        notesArray = loadNotes()
        tableView.reloadData()
    }
    
    private func setupNavigationView() {
        title = "Notes"
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightButtonItemTapped))
        rightItem.tintColor = UIColor(named: "textColor")
        navigationItem.rightBarButtonItem = rightItem
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func rightButtonItemTapped() {
        let detailVC = DetailNoteViewController()
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    // MARK: - UserDefaults
    
    private func saveNotes(_ notes: [String]) {
        let defaults = UserDefaults.standard
        defaults.set(notes, forKey: "saveNote")
    }
    
    private func loadNotes() -> [String] {
        let defaults = UserDefaults.standard
        if let notes = defaults.value(forKey: "saveNote") as? [String] {
            return notes
        } else {
            return []
        }
    }
    
}

extension NoteViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor(named: "backgroundColor")
        cell.textLabel?.text = notesArray[indexPath.row]
        cell.textLabel?.textColor = UIColor(named: "textColor")
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(named: "selection")
        cell.selectedBackgroundView = backgroundView
        return cell
    }
}

extension NoteViewController: UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailNoteViewController()
        detailVC.delegate = self
        detailVC.note = notesArray[indexPath.row]
        detailVC.index = indexPath.row
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.notesArray.remove(at: indexPath.row)
            self.saveNotes(self.notesArray)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
       
        deleteAction.backgroundColor = UIColor(named: "textColor")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}

extension NoteViewController: DetailNoteViewControllerDelegate {
    
    // MARK: - DetailNoteViewControllerDelegate
    
    func saveNote(_ note: String) {
        notesArray.append(note)
        let indexPath = IndexPath(row: notesArray.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        saveNotes(notesArray)
    }
    
    func changeNote(_ note: String, index: Int) {
        notesArray[index] = note
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        saveNotes(notesArray)
    }
    
}

