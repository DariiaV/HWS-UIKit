//
//  ViewController.swift
//  Project10
//
//  Created by Дария Григорьева on 24.12.2022.
//

import UIKit

enum Section {
    case first
}

class ViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Person>
    
    private var people = [Person]()
    
    private let identifier = "cell"
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 140, height: 180)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PersonCell.self, forCellWithReuseIdentifier: identifier)
//        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        return collectionView
    }()

    private lazy var dataSource: DataSource = {
        let dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as? PersonCell else {
                return UICollectionViewCell()
            }
            
            let person = self.people[indexPath.item]
            let path = self.getDocumentDirectory().appendingPathComponent(person.imagePath)
            let image = UIImage(contentsOfFile: path.path)
            
            cell.setupCell(name: person.name, image: image)
            cell.layer.cornerRadius = 7
            
            
            return cell
        }
        
        return dataSource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavigationItem()
    }
    
    private func updateUI() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Person>()
        snapshot.appendSections([.first])
        snapshot.appendItems(people)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setupNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                           target: self,
                                                           action: #selector(addNewPerson))
    }
    
    @objc private func addNewPerson() {
        let picker = UIImagePickerController()
        //picker.sourceType = .camera
        picker.allowsEditing = true //позволяет редактировать выбранное изображение
        picker.delegate = self
        present(picker, animated: true)
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

}
//extension ViewController: UICollectionViewDataSource {
//
//    // MARK: - UICollectionViewDataSource
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return people.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PersonCell else {
//            return UICollectionViewCell()
//        }
//
//        let person = people[indexPath.item]
//        let path = getDocumentDirectory().appendingPathComponent(person.imagePath)
//        let image = UIImage(contentsOfFile: path.path)
//
//        cell.setupCell(name: person.name, image: image)
//        cell.layer.cornerRadius = 7
//
//
//        return cell
//    }
//}

extension ViewController: UICollectionViewDelegate {
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "You wants rename person or delete person?", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let okAction = UIAlertAction(title: "Rename", style: .default)  { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?.first?.text,
            !newName.isEmpty else {
                return
            }
            self?.people[indexPath.item].name = newName
            self?.updateUI()
//            self?.collectionView.reloadData()

        }
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
            guard let self else {
                return
            }
            
            self.people.remove(at: indexPath.item)
            self.updateUI()
//            self.collectionView.deleteItems(at: [indexPath])
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        ac.addAction(okAction)
        ac.addAction(cancelAction)
        ac.addAction(deleteAction)
        present(ac, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate
    
    //сообщает когда пользователь выбирает изображение или отменяет выбор
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        let person = Person(name: "Unknown", imagePath: imageName)
        people.append(person)
//        collectionView.reloadData()
        updateUI()

        dismiss(animated: true)
    }
    
    func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension ViewController: UINavigationControllerDelegate {
    //помогает определить перемещаются ли они вперед назад внутри сборщика
    
}
