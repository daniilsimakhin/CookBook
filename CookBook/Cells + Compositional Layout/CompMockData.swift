//
//  CompMockData.swift
//  CookBook
//
//  Created by Alexander Altman on 01.12.2022.
//

import Foundation

struct CompMockData {
    
    static let shared = CompMockData()
    
    private let random: ListSection = {
        .random([.init(title: "Random 1", image: "Cookbook_logo_trans"),
                 .init(title: "Random 2", image: "Cookbook_logo_trans"),
                 .init(title: "Random 3", image: "Cookbook_logo_trans"),
                 .init(title: "Random 4", image: "Cookbook_logo_trans"),
                 .init(title: "Random 5", image: "Cookbook_logo_trans")])
    }()
    
    private let popular: ListSection = {
        .popular([.init(title: "Popular 1", image: "Cookbook_logo_trans"),
                  .init(title: "Popular 2", image: "Cookbook_logo_trans"),
                  .init(title: "Popular 3", image: "Cookbook_logo_trans"),
                  .init(title: "Popular 4", image: "Cookbook_logo_trans"),
                  .init(title: "Popular 5", image: "Cookbook_logo_trans"),
                  .init(title: "Popular 6", image: "Cookbook_logo_trans"),
                  .init(title: "Popular 7", image: "Cookbook_logo_trans"),
                  .init(title: "Popular 8", image: "Cookbook_logo_trans"),
                  .init(title: "Popular 9", image: "Cookbook_logo_trans")])
    }()
    
    var pageData: [ListSection] {
        [random, popular]
    }
    
}
