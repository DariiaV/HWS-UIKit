//
//  PictureListViewController.swift
//  Challenge4
//
//  Created by Дария Григорьева on 27.12.2022.
//

import UIKit

class PictureListViewController: UIViewController {
    
    private let tableView = UITableView()
    private let cellReuseIdentifier = "cell"
    
    private var userImages = [UserImage]()
    private let storeManager = StorageManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupNavigationItem()
        
        userImages = storeManager.fetchImages()
        
        
    }
    
    private func setupTableView() {
        tableView.register(UserImageCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.frame = view.frame
        tableView.backgroundColor = UIColor(named: "backgroundColor")
        
    }
    
    private func setupNavigationItem() {
        title = "Picture"
        let rightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPicture))
        rightItem.tintColor = UIColor(named: "textColor")
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func addNewPicture() {
        let picker = UIImagePickerController()
        //picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
}
extension PictureListViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? UserImageCell  else {
            return UITableViewCell()
        }
        
        cell.backgroundColor = UIColor(named: "backgroundColor")
        let userImage = userImages[indexPath.row]
        let path = getDocumentDirectory().appendingPathComponent(userImage.imageName)
        let image = UIImage(contentsOfFile: path.path)
        
        cell.setupCell(name: userImage.name, image: image)
        return cell
    }
    
}

extension PictureListViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showDetailVC(index: indexPath.row)
    }
    
    private func showDetailVC(index: Int) {
        let detailVC = DetailViewController()
        let userImage = userImages[index]
        let path = getDocumentDirectory().appendingPathComponent(userImage.imageName)
        let image = UIImage(contentsOfFile: path.path)
        
        detailVC.titleName = userImages[index].name
        detailVC.image = image
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.userImages.remove(at: indexPath.row)
            self.storeManager.setNewImages(images: self.userImages)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, isDone in
            self.showRenameAlert(index: indexPath.row)
        }
        editAction.backgroundColor = UIColor(named: "editColor")
        deleteAction.backgroundColor = UIColor(named: "deleteColor")
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    private func showRenameAlert(index: Int) {
        let ac = UIAlertController(title: "What do you want?", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let okAction = UIAlertAction(title: "Rename", style: .default) { [weak self, weak ac] _ in
            guard let self,
                  let newName = ac?.textFields?.first?.text,
                  !newName.isEmpty else {
                return
            }
            
            self.userImages[index].name = newName
            self.storeManager.setNewImages(images: self.userImages)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
}

extension PictureListViewController: UIImagePickerControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let userImage = UserImage(name: "Unknown", imageName: imageName)
        userImages.append(userImage)
        storeManager.setNewImages(images: userImages)
        
        let indexPath = IndexPath(row: userImages.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        dismiss(animated: true)
    }
    
    private  func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension PictureListViewController: UINavigationControllerDelegate {
    
}

