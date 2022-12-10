//
//  IngredientsDataSource.swift
//  CookBook
//
//  Created by Анастасия Бегинина on 06.12.2022.
//

import UIKit

final class IngredientsDataSource: NSObject {
    var ingredients: [IngredientModel]
    
    init(ingredients: [IngredientModel]) {
        self.ingredients = ingredients
    }
}

// MARK: - UITableViewDataSource
extension IngredientsDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.reuseID, for: indexPath) as! IngredientCell
        let ingredient = ingredients[indexPath.row]
        
        cell.configure(ingredient: ingredient)
        
        return cell
    }
}
