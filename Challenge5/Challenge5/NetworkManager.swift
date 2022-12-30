//
//  NetworkManager.swift
//  Challenge5
//
//  Created by Дария Григорьева on 29.12.2022.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let baseURL = "https://restcountries.com/v3.1/lang/eng"
    private init() {}
    
    func getCountries(completion: @escaping (Result<[Country], GFError>) -> Void) {
        
        guard let url = URL(string: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let user = try decoder.decode([Country].self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
        
    }
    
    // MARK: - Use async await
    
    func getCountries2() async throws ->  [Country] {
        guard let url = URL(string: baseURL) else {
            throw GFError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw GFError.invalidResponse
        }
        let decoder = JSONDecoder()
        return try decoder.decode([Country].self, from: data)
    }
}


enum GFError: String, Error {
    case invalidURL = "This url is broken"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToFavorite   = "There was an error favoriting this user. Please try again."
    case alreadyInFavorites = "You've already favorited this user. You must REALLY like them!"
}
