//
//  StorageManager.swift
//  Challenge4
//
//  Created by Дария Григорьева on 27.12.2022.
//

import Foundation

// MARK: - Manager UserDefaults
class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let key = "image"
    
    private init() {}
    
    func setNewImages(images: [UserImage]) {
        guard let data = try? JSONEncoder().encode(images) else {
            return
        }
        
        userDefaults.set(data, forKey: key)
    }
    
    func fetchImages() -> [UserImage] {
        guard let data = userDefaults.object(forKey: key) as? Data else {
            return []
        }
        
        guard let items = try? JSONDecoder().decode([UserImage].self, from: data) else {
            return []
        }
        
        return items
    }
    
    func deleteImage(at index: Int) {
        var image = fetchImages()
        image.remove(at: index)
        
        guard let data = try? JSONEncoder().encode(image) else {
            return
        }
        
        userDefaults.set(data, forKey: key)
    }
}
