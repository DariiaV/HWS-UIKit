//
//  PictureManager.swift
//  Project1
//
//  Created by Дария Григорьева on 26.12.2022.
//

import Foundation

struct PictureManager {
    private var pictures: [Picture] = []
    
    init() {
        self.pictures = getPictures()
    }
    
    private mutating func getPictures() -> [Picture] {
        let fm = FileManager.default
        guard let path = Bundle.main.resourcePath,
              let items = try? fm.contentsOfDirectory(atPath: path) else {
            return []
        }
        
        for item in items {
            if item.hasPrefix("nssl") {
                let picture = Picture(imageName: item)
                pictures.append(picture)
            }
        }
        
        pictures.sort { $0.imageName < $1.imageName }
        return pictures
    }
    
    func getPicktureTitle(_ row: Int) -> String {
        return "Picture \(row + 1) of \(pictures.count)"
    }
    
    func getImageName(index: Int) -> String {
        pictures[index].imageName
    }
    
    func getPicturesCount() -> Int {
        pictures.count
    }
    
    mutating func setImageTapCount(_ index: Int) {
        let picture = pictures[index]
        pictures[index].tapPictureCount = picture.tapPictureCount + 1
    }
    
    func getImageTapCount(index: Int) -> Int {
        pictures[index].tapPictureCount
    }
    
}
