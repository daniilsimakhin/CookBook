//
//  FavoriteRecipesStorage.swift
//  CookBook
//
//  Created by SERGEY SHLYAKHIN on 06.12.2022.
//

import Foundation

class FavoriteRecipesStorage {
    static let shared = FavoriteRecipesStorage()
    private init() {}
    
    private var favoriteRecipes: [SearchModel] = []
    private var favoriteRecipesVisible: [Int: Bool] = [:]
    
    func addToFavorite(_ recipe: SearchModel?, with flag: Bool) {
        guard let recipe = recipe else { return }

        let id = recipe.id
        if favoriteRecipesVisible[id] == nil {
            favoriteRecipes.append(recipe)
        }
        favoriteRecipesVisible[id] = flag
    }
    
    func getFavoriteRecipes() -> [SearchModel] {
        favoriteRecipes.filter { favoriteRecipesVisible[$0.id, default: false] }
    }
    
    func checkIsFavoriteRecipe(_ id: Int) -> Bool {
        favoriteRecipesVisible[id] ?? false
    }
}

// MARK: - NSCopying
extension FavoriteRecipesStorage: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
