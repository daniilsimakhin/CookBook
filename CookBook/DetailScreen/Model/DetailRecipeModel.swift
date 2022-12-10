//
//  DetailRecipeModel.swift
//  CookBook
//
//  Created by Анастасия Бегинина on 07.12.2022.
//

import Foundation

struct DetailRecipeModel{
    let id: Int
    let title: String
    let aggregateLikes: Int
    let readyInMinutes: Int
    let servings: Int
    let image: String
    let calories: Int
    
    let ingredients: [IngredientModel]
    var steps: [InstructionModel]
}

struct IngredientModel {
    let image: String
    let original: String
}

struct InstructionModel {
    let step: String
    let minutes: Int
    var isChecked = false
}
