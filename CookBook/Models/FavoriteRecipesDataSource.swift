//
//  FavoriteRecipesDataSource.swift
//  CookBook
//
//  Created by SERGEY SHLYAKHIN on 06.12.2022.
//

import UIKit

final class FavoriteRecipesDataSource: NSObject {
    var favoriteRecipes: [SearchModel]
    
    init(favoriteRecipes: [SearchModel]) {
        self.favoriteRecipes = favoriteRecipes
    }
}

// MARK: - UITableViewDataSource
extension FavoriteRecipesDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewMiniCell.reuseID, for: indexPath) as! SearchTableViewMiniCell
        let recipe = favoriteRecipes[indexPath.row]
        
        cell.configure(recipe: recipe)
        
        return cell
    }
}
