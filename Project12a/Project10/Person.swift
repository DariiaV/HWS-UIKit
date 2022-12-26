//
//  Person.swift
//  Project10
//
//  Created by Дария Григорьева on 25.12.2022.
//

import UIKit

class Person: NSObject, NSCoding {
    var name: String
    var imagePath: String
    
    init(name: String, imagePath: String) {
        self.name = name
        self.imagePath = imagePath
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        imagePath = aDecoder.decodeObject(forKey: "imagePath") as? String ?? ""
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(imagePath, forKey: "imagePath")
    }
}
