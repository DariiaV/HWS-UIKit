//
//  Photo.swift
//  Project25
//
//  Created by Дария Григорьева on 05.01.2023.
//

import UIKit

struct Photo: Hashable {
    var image: UIImage
    
    private let uuid = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
