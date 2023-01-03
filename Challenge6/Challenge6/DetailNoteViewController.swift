//
//  DetailNoteViewController.swift
//  Challenge6
//
//  Created by Дария Григорьева on 02.01.2023.
//

import UIKit

protocol DetailNoteViewControllerDelegate: AnyObject {
    func saveNote(_ note: String)
    func changeNote(_ note: String, index: Int)
}

class DetailNoteViewController: UIViewController {
    
    weak var delegate: DetailNoteViewControllerDelegate?
    var note: String?
    var index: Int?
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.tintColor = UIColor(named: "textColor")
        textView.autocorrectionType = .no
        textView.delegate = self
        textView.backgroundColor = UIColor(named: "backgroundColor")
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont(name: "Noteworthy", size: 30)
        textView.textColor = UIColor(named: "textColor")
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        navigationController?.navigationBar.tintColor = UIColor(named: "textColor")
        textView.text = note
        textView.becomeFirstResponder()
        
        setupTextView()
        setupNavigationView()
        setRightBarButtonItemState()
        addNotificationCenter()
    }
    
    private func setupTextView() {
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])
    }
    
    private func setupNavigationView() {
        let rightItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonItemTapped))
        rightItem.tintColor = UIColor(named: "textColor")
        let shared = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        shared.tintColor = UIColor(named: "textColor")
        navigationItem.rightBarButtonItems = [rightItem, shared]
        
    }
    
    @objc private func saveButtonItemTapped() {
        guard let text = textView.text,
              !text.isEmpty else {
            return
        }
        
        if let index {
            delegate?.changeNote(text, index: index)
        } else {
            delegate?.saveNote(text)
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func shareTapped() {
        guard let text = textView.text,
              !text.isEmpty else {
            return
        }
        
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc,animated: true)
    }
    
    private func setRightBarButtonItemState() {
        if let text = textView.text,
           text.isEmpty {
            navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = false }
        } else {
            navigationItem.rightBarButtonItems?.forEach { $0.isEnabled = true }
        }
    }
    
    // MARK: - Notification(Observer) keyboard for textView
    private func addNotificationCenter() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0,
                                                 bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom,
                                                 right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
}

extension DetailNoteViewController: UITextViewDelegate {
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        setRightBarButtonItemState()
    }
}
