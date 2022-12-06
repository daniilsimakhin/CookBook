//
//  RecipesModel.swift
//  CookBook
//
//  Created by SERGEY SHLYAKHIN on 30.11.2022.
//

import Foundation

struct RecipesModel {
    let recipes: [Recipe]
    
    struct Recipe {
        let id: Int
        let title: String
        let aggregateLikes: Int
        let readyInMinutes: Int
        let servings: Int
        let image: String
        let ingredients: [Ingredient]
        let instructions: [Instruction]
        let spoonacularSourceUrl: String
    }
    
    struct Ingredient {
        let id: Int
        let image: String
        let original: String
    }
    
    struct Instruction {
        let step: String
        let minutes: Int
    }
}
