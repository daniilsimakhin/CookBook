//
//  RecipesModelFromDataConverter.swift
//  CookBook
//
//  Created by SERGEY SHLYAKHIN on 30.11.2022.
//

import Foundation

struct RecipesModelFromDataConverter {
    func convert(data: RecipesData.Recipe?) -> RecipesModel.Recipe? {
        guard
            let aggregateLikes = data?.aggregateLikes,
            let ingredients = convertIngredients(data: data?.extendedIngredients),
            let id = data?.id,
            let title = data?.title,
            let readyInMinutes = data?.readyInMinutes,
            let servings = data?.servings,
            let image = data?.image,
            let instructions = convertInstructions(data: data?.analyzedInstructions),
            let spoonacularSourceUrl = data?.spoonacularSourceUrl
        else {
            return nil
        }
        return .init(
            id: id,
            title: title,
            aggregateLikes: aggregateLikes,
            readyInMinutes: readyInMinutes,
            servings: servings,
            image: image,
            ingredients: ingredients,
            instructions: instructions,
            spoonacularSourceUrl: spoonacularSourceUrl
        )
    }
    
    private func convertIngredients(data: [RecipesData.Ingredient]?) -> [RecipesModel.Ingredient]? {
        guard
            let data = data,
            !data.isEmpty
        else {
            return nil
        }
        
        var ingredients: [RecipesModel.Ingredient] = []
        
        for item in data {
            if let id = item.id,
               let image = item.image,
               let original = item.original {
                ingredients.append(.init(id: id, image: image, original: original))
            }
        }
        
        guard !ingredients.isEmpty else { return nil }
        return ingredients
    }
    
    private func convertInstructions(data: [RecipesData.Instruction]?) -> [RecipesModel.Instruction]? {
        guard
            let data = data,
            !data.isEmpty
        else {
            return nil
        }
        
        var instructions: [RecipesModel.Instruction] = []
        
        for item in data {
            if let name = item.name,
               !name.isEmpty {
                instructions.append(.init(step: name, minutes: 0))
            }
            if let steps = item.steps,
               !steps.isEmpty {
                for step in steps {
                    if let name = step.step,
                       !name.isEmpty {
                        if let length = step.length,
                           let number = length.number {
                            instructions.append(.init(step: name, minutes: number))
                        } else {
                            instructions.append(.init(step: name, minutes: 0))
                        }
                    }
                }
            }
        }
        
        guard !instructions.isEmpty else { return nil }
        return instructions
    }
}
