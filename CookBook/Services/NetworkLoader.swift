import UIKit

struct NetworkLoader {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func fetchSearchRecipes<T: Decodable>(router: NetworkRouter, completionHandler: @escaping (Result<T, Error>) -> ()) {
        loadData(router.absoluteString) { (result: Result<T, Error>) in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func fetchRandomRecipes<T: Decodable>(completionHandler: @escaping (Result<T, Error>) -> ()) {
        let router: NetworkRouter = .randomRequest
        loadData(router.absoluteString) { (result: Result<T, Error>) in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func fetchVegetarianRecipes<T: Decodable>(completionHandler: @escaping (Result<T, Error>) -> ()) {
        let router: NetworkRouter = .randomVegetarianRequest
        loadData(router.absoluteString) { (result: Result<T, Error>) in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func fetchRecipeBy<T: Decodable>(id: Int, completionHandler: @escaping (Result<T, Error>) -> ()) {
        let stringUrl = "https://api.spoonacular.com/recipes/\(id)/information?apiKey=\(Secrets.apiKey)&includeNutrition=false"
        loadData(stringUrl) { (result: Result<T, Error>) in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getRecipeImage(stringUrl: String, completionHandler: @escaping (UIImage?) -> Void) {
        loadImage(stringUrl) { image in
            completionHandler(image)
        }
    }
    
    func getIngredientImage(name: String, completionHandler: @escaping (UIImage?) -> Void) {
        let stringUrl = "https://spoonacular.com/cdn/ingredients_100x100/\(name)"
        
        loadImage(stringUrl) { image in
            completionHandler(image)
        }
    }
    
    func getEquipmentImage(name: String, completionHandler: @escaping (UIImage?) -> Void) {
        let stringUrl = "https://spoonacular.com/cdn/equipment_100x100/\(name)"
        
        loadImage(stringUrl) { image in
            completionHandler(image)
        }
    }
}

private extension NetworkLoader {
    func loadImage(_ stringUrl: String, completionHandler: @escaping (UIImage?) -> Void) {
        if let image = ImageCache.shared.take(with: stringUrl) {
            completionHandler(image)
            return
        }
        
        guard let url = URL(string: stringUrl) else {
            completionHandler(nil)
            return
        }
        
        networkClient.fetch(url: url) { result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    completionHandler(nil)
                    return
                }
                completionHandler(image)
            case .failure(let error):
                print("Error with getting image from url: \(stringUrl) - \(error)")
            }
        }
    }
    
    
    func loadData<T: Decodable>(_ stringUrl: String, completionHandler: @escaping (Result<T, Error>) -> ()) {
        guard let url = URL(string: stringUrl) else {
            completionHandler(.failure(ServiceError.general(reason: "Wrong url")))
            return
        }
        networkClient.fetch(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(.success(result))
                } catch {
                    completionHandler(.failure(ServiceError.parsing))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

enum NetworkRouter {
    case randomRequest
    case randomVegetarianRequest
    case searchRequest(text: String, number: Int, offset: Int)
    
    var apiKey: String {
        return Secrets.apiKey
    }
    
    var scheme: String {
        switch self {
        case .randomRequest, .searchRequest, .randomVegetarianRequest:
            return "https"
        }
    }
    
    var host: String {
        switch self {
        case .randomRequest, .searchRequest, .randomVegetarianRequest:
            return "api.spoonacular.com"
        }
    }
    
    var path: String {
        switch self {
        case .randomRequest, .randomVegetarianRequest:
            return "/recipes/random"
        case .searchRequest:
            return "/recipes/complexSearch"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .randomVegetarianRequest:
            return [URLQueryItem(name: "apiKey", value: apiKey),
                    URLQueryItem(name: "number", value: String(10)),
                    URLQueryItem(name: "tags", value: "vegetarian")]
        case .searchRequest(let text, let number, let offset):
            return [URLQueryItem(name: "apiKey", value: apiKey),
                    URLQueryItem(name: "number", value: "\(number)"),
                    URLQueryItem(name: "addRecipeNutrition", value: String(true)),
                    URLQueryItem(name: "addRecipeInformation", value: String(true)),
                    URLQueryItem(name: "sort", value: "popularity"),
                    URLQueryItem(name: "query", value: text),
                    URLQueryItem(name: "offset", value: "\(offset)")]
        case .randomRequest:
            return [URLQueryItem(name: "apiKey", value: apiKey),
                    URLQueryItem(name: "number", value: String(10))]
        }
    }
    
    var absoluteString: String {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        return urlComponents.url?.absoluteString ?? ""
    }
}
