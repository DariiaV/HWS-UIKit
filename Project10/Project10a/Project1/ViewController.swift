//
//  ViewController.swift
//  Project1
//
//  Created by Дария Григорьева on 17.12.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 180, height: 180)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(StormCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    private let cellReuseIdentifier = "cell"
    private var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        getItemsFromFileManager()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.frame = view.frame
    }
    
    private func getItemsFromFileManager() {
        let fm = FileManager.default
        guard let path = Bundle.main.resourcePath,
              let items = try? fm.contentsOfDirectory(atPath: path) else {
            return
        }
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
    }
  
}

extension ViewController: UICollectionViewDataSource {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? StormCell else {
            return UICollectionViewCell()
        }
        
        cell.setupCell(image: UIImage(named: pictures[indexPath.item]))
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.imageName = pictures[indexPath.item]
        detailVC.titleName = "Picture \(indexPath.item + 1) of \(pictures.count)"
        navigationController?.pushViewController(detailVC, animated: true)
    }
   
}
