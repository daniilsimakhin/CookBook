//
//  RecipesData.swift
//  CookBook
//
//  Created by SERGEY SHLYAKHIN on 30.11.2022.
//

import Foundation

struct RecipesData: Decodable {
    let recipes: [Recipe]?
    
    struct Recipe: Decodable {
        let aggregateLikes: Int?
        let extendedIngredients: [Ingredient]?
        let id: Int?
        let title: String?
        let readyInMinutes: Int?
        let servings: Int?
        let image: String?
        let analyzedInstructions: [Instruction]?
        let spoonacularSourceUrl: String?
    }
    
    struct Instruction: Decodable {
        let name: String?
        let steps: [Step]?
    }
    
    struct Step: Decodable {
        let number: Int?
        let step: String?
        let length: Length?
    }
    
    struct Length: Decodable {
        let number: Int?
        let unit: String?
    }
    
    struct Ingredient: Decodable {
        let id: Int?
        let image: String?
        let original: String?
    }
}
