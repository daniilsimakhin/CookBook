import Foundation

struct SearchResult: Decodable, Hashable {
    let id: Int
    let title: String
    let readyInMinutes: Int
    let image: String
    let aggregateLikes: Int
    let nutrition: Nutrition
    let servings: Int
    
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        return lhs.id == rhs.id
    }
    
    struct Nutrition: Decodable, Hashable {
        let nutrients: [Flavonoid]
        let ingredients: [Ingredient]
    }
    
    struct Flavonoid: Decodable, Hashable {
        let name: String
        let amount: Double
        let unit: String
        let percentOfDailyNeeds: Double?
    }
    
    struct Ingredient: Decodable, Hashable {
        let id: Int
        let name: String
        let amount: Double
        let unit: String
        let nutrients: [Flavonoid]
    }
}
