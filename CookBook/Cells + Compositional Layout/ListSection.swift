//
//  ListSection.swift
//  CookBook
//
//  Created by Alexander Altman on 30.11.2022.
//

import Foundation

enum ListSection {
    case random([ListItem])
    case popular([ListItem])
    
    // Define sections
    var items: [ListItem] {
        switch self {
        case .random(let items),
                .popular(let items):
            return items
        }
    }
    // Count of items in Sections
    var count: Int {
        items.count
    }
    
    // Sections Headers
    var title: String {
        switch self {
        case .random(_):
            return "Random Recipes"
        case .popular(_):
            return "Popular Recipes"
        }
    }
}
