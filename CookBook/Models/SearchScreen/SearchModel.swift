import UIKit

struct SearchModel: Hashable {
    let id: Int
    let title: String
    let readyInMinutes: Int
    let image: String
    let aggregateLikes: Int
    let calories: Int
    let ingredients: Int
    
    var recipeString: NSAttributedString {
        let recipeString = title + " \n"
        let ingidientsString = "\(ingredients) Ingrediens\n"
        let caloriesString = "\(calories) Calories\n"
        let timeString = "\(readyInMinutes) Minutes"
        
        let attributedString = NSMutableAttributedString(string: recipeString + ingidientsString + caloriesString + timeString)
        attributedString.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .headline), range: NSMakeRange(0, recipeString.count))
        attributedString.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .footnote), range: NSMakeRange(recipeString.count + ingidientsString.count - 11, 10))
        attributedString.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .footnote), range: NSMakeRange(recipeString.count + ingidientsString.count + caloriesString.count - 9, 8))
        attributedString.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: .footnote), range: NSMakeRange(recipeString.count + ingidientsString.count + caloriesString.count + timeString.count - 7, 7))
        return attributedString
    }
    
    init(searchResult: SearchResult) {
        self.id = searchResult.id
        self.title = searchResult.title
        self.readyInMinutes = searchResult.readyInMinutes
        self.image = searchResult.image
        self.aggregateLikes = searchResult.aggregateLikes
        self.calories = Int(searchResult.nutrition.nutrients[0].amount)
        self.ingredients = searchResult.nutrition.ingredients.count
    }
    
    static func == (lhs: SearchModel, rhs: SearchModel) -> Bool {
        return lhs.id == rhs.id
    }
}
