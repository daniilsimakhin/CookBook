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
            .init(title: "Vegan 1", image: "rmeal1"),
            .init(title: "Vegan 2", image: "rmeal2"),
            .init(title: "Vegan 3", image: "rmeal3"),
            .init(title: "Vegan 4", image: "rmeal4"),
            .init(title: "Vegan 3", image: "rmeal5"),
            .init(title: "Vegan 4", image: "rmeal6")
        ])
    }()
    
    private let random: ListSection = {
        .random([
            .init(title: "Popular 1", image: "meal1"),
            .init(title: "Popular 2", image: "meal2"),
            .init(title: "Popular 3", image: "meal3"),
            .init(title: "Popular 4", image: "meal4"),
            .init(title: "Popular 5", image: "meal5"),
            .init(title: "Popular 6", image: "meal6")
        ])
    }()
    
    var pageData: [ListSection] {
        [random, vegan]
    }
}
