//
//  CompMockData.swift
//  CookBook
//
//  Created by Alexander Altman on 01.12.2022.
//

import Foundation

struct CompMockData {
    
    static let shared = CompMockData()
    
    private let vegan: ListSection = {
        .vegan([
            .init(title: "Vegan 1 Vegan 1 Vegan 1 Vegan 1 Vegan 1", image: "https://spoonacular.com/recipeImages/715521-312x231.jpg", id: 1),
            .init(title: "Vegan 2", image: "https://spoonacular.com/recipeImages/715521-312x231.jpg", id: 1),
            .init(title: "Vegan 3", image: "https://spoonacular.com/recipeImages/715521-312x231.jpg", id: 1),
            .init(title: "Vegan 4", image: "https://spoonacular.com/recipeImages/715521-312x231.jpg", id: 1),
            .init(title: "Vegan 3", image: "https://spoonacular.com/recipeImages/715521-312x231.jpg", id: 1),
            .init(title: "Vegan 4", image: "https://spoonacular.com/recipeImages/715521-312x231.jpg", id: 1)
        ])
    }()
    
    private let random: ListSection = {
        .random([
            .init(title: "Popular 1 Popular 1 Popular 1 Popular 1 Popular 1", image: "https://spoonacular.com/recipeImages/715415-312x231.jpg", id: 1),
            .init(title: "Popular 2", image: "https://spoonacular.com/recipeImages/715415-312x231.jpg", id: 1),
            .init(title: "Popular 3", image: "https://spoonacular.com/recipeImages/715415-312x231.jpg", id: 1),
            .init(title: "Popular 4", image: "https://spoonacular.com/recipeImages/715415-312x231.jpg", id: 1),
            .init(title: "Popular 5", image: "https://spoonacular.com/recipeImages/715415-312x231.jpg", id: 1),
            .init(title: "Popular 6", image: "https://spoonacular.com/recipeImages/715415-312x231.jpg", id: 1)
        ])
    }()
    
    var pageData: [ListSection] {
        [random, vegan]
    }
}
