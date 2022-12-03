//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by SERGEY SHLYAKHIN on 16.11.2022.
//

import UIKit

enum ServiceError: Error {
    case network(statusCode: Int)
    case parsing
    case general(reason: String)
}

struct NetworkClient {
    
    let apiKey = "cb257e86313842278ebccc9f3a2c5788"
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                handler(.failure(ServiceError.general(reason: error.localizedDescription)))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(ServiceError.network(statusCode: response.statusCode)))
                return
            }
            
            guard let data = data else { return }
            handler(.success(data))
        }
        
        task.resume()
    }
    
    func getImageFrom(stringUrl: String, completion: @escaping (UIImage) -> Void) {
        if let image = ImageCache.shared.take(with: stringUrl) {
            completion(image)
            return
        }
        
        guard let url = URL(string: stringUrl) else { return }
        let urlRequest = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                print("Error with download image from url - \(stringUrl)")
            }
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            
            ImageCache.shared.put(image: image, with: stringUrl)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }
    
    func searchRecipe(with title: String, completion: @escaping (SearchResults) -> Void) {
        let stringUrl = "https://api.spoonacular.com/recipes/complexSearch?apiKey="
        guard let url = URL(string: stringUrl + apiKey + "&addRecipeInformation=true&addRecipeNutrition=true&query=" + title + "&number=10") else { return }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else { return }
            guard let data = data else { return }
            do {
                let data = try JSONDecoder().decode(SearchResults.self, from: data)
                completion(data)
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
