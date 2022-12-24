//
//  RecipesProvider.swift
//  CookBook
//
//  Created by SERGEY SHLYAKHIN on 30.11.2022.
//

import Foundation

protocol RecipesProvider {
    func loadRecipes(
        completion: ((Result<RecipesModel, RecipesLoadError>) -> Void)?
    )
    
    func loadRecipe(
        completion: ((Result<RecipesModel.Recipe, RecipesLoadError>) -> Void)?
    )
}

final class RecipesProviderImpl: RecipesProvider {
    func loadRecipes(
        completion: ((Result<RecipesModel, RecipesLoadError>) -> Void)?
    ) {
        guard let path = Bundle.main.path(forResource: "Example", ofType: "json") else {
            completion?(.failure(.noPathForLocalFile))
            return
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            completion?(.failure(.getDataCrashed))
            return
        }
        guard let result = try? JSONDecoder().decode(RecipesData.self, from: data) else {
            completion?(.failure(.decodingCrashed))
            return
        }
        let converter = RecipesModelFromDataConverter()
        let recipes = result.recipes?.compactMap({
            converter.convert(data: $0)
        }) ?? []
        guard !recipes.isEmpty else {
            completion?(.failure(.itemsIsEmpty))
            return
        }
        completion?(.success(RecipesModel(recipes: recipes)))
    }
    
    func loadRecipe(
        completion: ((Result<RecipesModel.Recipe, RecipesLoadError>) -> Void)?
    ) {
        guard let path = Bundle.main.path(forResource: "ExampleRecipe", ofType: "json") else {
            completion?(.failure(.noPathForLocalFile))
            return
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            completion?(.failure(.getDataCrashed))
            return
        }
        guard let result = try? JSONDecoder().decode(RecipesData.Recipe.self, from: data) else {
            completion?(.failure(.decodingCrashed))
            return
        }
        let converter = RecipesModelFromDataConverter()
        guard let recipe = converter.convert(data: result) else {
            completion?(.failure(.itemHasNoData))
            return
        }
        completion?(.success(recipe))
    }
}

enum RecipesLoadError: Error {
    case itemHasNoData
    case itemsIsEmpty
    case getDataCrashed
    case decodingCrashed
    case noPathForLocalFile
}
