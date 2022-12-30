//
//  Country.swift
//  Challenge5
//
//  Created by Дария Григорьева on 29.12.2022.
//

import Foundation

struct Country: Decodable {
    let name: Name
    let population: Int
    let capital: [String]?
    let flag: String
}

struct Name: Decodable {
    let common: String
}
