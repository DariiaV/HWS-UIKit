//
//  PictureViewController.swift
//  Challenge7
//
//  Created by Дария Григорьева on 07.01.2023.
//

import UIKit

class PictureViewController: UIViewController {
    
    private var images = [UIImage]()
    private var textTop: String?
    private var textBottom: String?
    
    private let identifier = "cell"
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 180, height: 180)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PictureCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(named: "Color")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupNavigationItem()
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationItem() {
        title = "Create Memes"
        
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPicture))
        rightItem.tintColor = UIColor(named: "textColor")
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func addNewPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func createAlert(text: String, isFirstAlert: Bool, completion: @escaping ( ()-> Void) ) -> UIAlertController {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let okAction = UIAlertAction(title: "Add", style: .default) { [weak self, weak alert] _ in
            if let text = alert?.textFields?.first?.text,
               !text.isEmpty {
                if isFirstAlert {
                    self?.textTop = text
                } else {
                    self?.textBottom = text
                }
                completion()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion()
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        return alert
    }
    
}

extension PictureViewController: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PictureCell else {
            return UICollectionViewCell()
        }
        let image = images[indexPath.item]
        cell.setupCell(image: image)
        cell.layer.cornerRadius = 7
        return cell
    }
    
}

extension PictureViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     let vc = DetailViewController()
        vc.image = images[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        images.insert(image, at: 0)
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.insertItems(at: [indexPath])
        
        dismiss(animated: true)
        showFirstAlert()
    }
    
    private func showFirstAlert() {
        let firstAlert = createAlert(text: "You wants add text top?", isFirstAlert: true) { [weak self] in
            self?.showSecondAlert()
        }
        present(firstAlert, animated: true)
    }
    
    private func showSecondAlert() {
        let secondAlert = createAlert(text: "You wants add text bottom?", isFirstAlert: false) { [weak self] in
            self?.createGraphicsImage()
        }
        present(secondAlert, animated: true)
    }
    
    private func createGraphicsImage() {
        let image = images[0]
        let imageSize = image.size
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        let newImage = renderer.image { ctx in
            image.draw(at: CGPoint.zero)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: imageSize.height * 0.2),
                .paragraphStyle: paragraphStyle
            ]
            if let string = textTop {
                let attributedString = NSAttributedString(string: string, attributes: attrs)
                
                attributedString.draw(with: CGRect(x: imageSize.width*0.1,
                                                   y: imageSize.height*0.1,
                                                   width: imageSize.width*0.8,
                                                   height: imageSize.height*0.2), options: .usesLineFragmentOrigin, context: nil)
                
            }
            
            if let string = textBottom {
                let attributedString = NSAttributedString(string: string, attributes: attrs)
                attributedString.draw(with: CGRect(x: imageSize.width*0.1,
                                                   y: imageSize.height*0.7,
                                                   width: imageSize.width*0.8,
                                                   height: imageSize.height*0.2), options: .usesLineFragmentOrigin, context: nil)
                
            }
        }
        images[0] = newImage
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.reloadItems(at: [indexPath])
    }
}
