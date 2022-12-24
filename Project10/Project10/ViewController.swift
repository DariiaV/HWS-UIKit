//
//  ViewController.swift
//  Project10
//
//  Created by Дария Григорьева on 24.12.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let identifier = "cell"
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout() //настройка отступов и ячеек
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // отступы внутри контента
        layout.itemSize = CGSize(width: 140, height: 180) //размеры ячейки
        //layout.minimumLineSpacing // отступы между элементы снизу сверху
        //layout.minimumInteritemSpacing // отступы между элементами слева и справа
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PersonCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
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
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? PersonCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
    
}
