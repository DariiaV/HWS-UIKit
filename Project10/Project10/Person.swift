//
//  Person.swift
//  Project10
//
//  Created by Дария Григорьева on 25.12.2022.
//

import UIKit

class Person: NSObject {
    var name: String
    var imagePath: String
    
    init(name: String, imagePath: String) {
        self.name = name
        self.imagePath = imagePath
    }
}
