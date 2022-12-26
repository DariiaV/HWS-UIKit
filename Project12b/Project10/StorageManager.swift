//
//  StorageManager.swift
//  Project10
//
//  Created by Дария Григорьева on 26.12.2022.
//

import Foundation

// MARK: - Manager UserDefaults
class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let key = "people"
    
    private init() {}
    
    func save(person: Person) {
        var people = fetchPeople()
        people.append(person)
        
        setNewPeople(people: people)
    }
    
    func setNewPeople(people: [Person]) {
        guard let data = try? JSONEncoder().encode(people) else {
            return
        }
        
        userDefaults.set(data, forKey: key)
    }
    
    func fetchPeople() -> [Person] {
        guard let data = userDefaults.object(forKey: key) as? Data else {
            return []
        }
        
        guard let items = try? JSONDecoder().decode([Person].self, from: data) else {
            return []
        }
        
        return items
    }
    
    func deletePerson(at index: Int) {
        var people = fetchPeople()
        people.remove(at: index)
        
        guard let data = try? JSONEncoder().encode(people) else {
            return
        }
        
        userDefaults.set(data, forKey: key)
    }
}
